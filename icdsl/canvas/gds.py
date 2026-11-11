"""GDS in / out for canvas cells (klayout.db), hierarchical, any layer, rectangles and polygons."""
from __future__ import annotations

import os
import re

import klayout.db as kdb

from .core import Cell, Rect, CanvasError, _ORIENT, _src
from . import tech as T

_src_cache = {}


def _source(path):
    if path not in _src_cache:
        ly = kdb.Layout()
        ly.read(path)
        _src_cache[path] = ly
    return _src_cache[path]


def write_gds(top, path):
    t = top.tech
    ly = kdb.Layout()
    # GDS database unit: 1 nm unless the PDK data says otherwise (gds_dbu, um). A deck that checks a
    # manufacturing grid finer than 1 nm (FreePDK45: 2.5 nm) can only be evaluated on a finer unit.
    dbu = t.d.get("gds_dbu", 0.001)
    F = int(round(0.001 / dbu))                 # database units per nm
    if F < 1 or abs(F * dbu - 0.001) > 1e-12:
        raise CanvasError(f"gds_dbu={dbu} of {t.name} must divide 1 nm")
    ly.dbu = dbu
    made = {}
    lidx = {}

    def L(ld):
        if ld not in lidx:
            lidx[ld] = ly.layer(*ld)
        return lidx[ld]

    def make(c):
        if c.name in made:
            return made[c.name]
        if c.foreign:
            src = _source(c.foreign[0])
            sc = src.cell(c.foreign[1])
            k = ly.create_cell(c.name)
            k.copy_tree(sc)
            made[c.name] = k
            return k
        k = ly.create_cell(c.name)
        for s in c.shapes:
            li = L(t.layer(s.layer))
            if isinstance(s, Rect):
                k.shapes(li).insert(kdb.Box(F * s.x0, F * s.y0, F * s.x1, F * s.y1))
            else:
                k.shapes(li).insert(kdb.Polygon([kdb.Point(F * x, F * y) for x, y in s.pts]))
        for name, rects in c.ports.items():
            for r in rects:
                txt = kdb.Text(name, kdb.Trans(F * ((r.x0 + r.x1) // 2), F * ((r.y0 + r.y1) // 2)))
                if r.layer in t.pin_layer:
                    pl = L(t.pin_layer[r.layer])
                    k.shapes(pl).insert(kdb.Box(F * r.x0, F * r.y0, F * r.x1, F * r.y1))
                    k.shapes(pl).insert(txt)
                if r.layer in t.label_layer:
                    k.shapes(L(t.label_layer[r.layer])).insert(txt)
                elif r.layer not in t.pin_layer:
                    raise CanvasError(f"port {name!r} of {c.name} is on {r.layer!r}, which has no label layer in "
                                      f"{t.name}", f"put ports on one of: {', '.join(t.label_layer)}")
        for (text, layer, x, y) in c.labels:
            if layer not in t.label_layer:
                raise CanvasError(f"label {text!r}: layer {layer!r} has no label layer in {t.name}",
                                  f"label one of: {', '.join(t.label_layer)}")
            k.shapes(L(t.label_layer[layer])).insert(kdb.Text(text, kdb.Trans(F * x, F * y)))
        for r in c.refs:
            cc = make(r.cell)
            rot, mir = _ORIENT[r.orient]
            tr = kdb.Trans(rot, mir, F * r.x, F * r.y)
            if r.nx * r.ny > 1:
                k.insert(kdb.CellInstArray(cc.cell_index(), tr, kdb.Vector(F * r.dx, 0), kdb.Vector(0, F * r.dy), r.nx, r.ny))
            else:
                k.insert(kdb.CellInstArray(cc.cell_index(), tr))
        made[c.name] = k
        return k

    make(top)
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    ly.write(path)
    return path


def _subckt(spice_path, name):
    txt = open(spice_path, errors="replace").read()
    m = re.search(rf"^\.subckt\s+{re.escape(name)}\s.*?^\.ends[^\n]*", txt, re.S | re.M | re.I)
    if not m:
        return None, []
    body = m.group(0)
    head = re.sub(r"\n\+", " ", body.split("\n.", 1)[0] if False else body)
    first = re.match(r"\.subckt\s+\S+\s+([^\n]*(?:\n\+[^\n]*)*)", body, re.I).group(1)
    pins = [p for p in re.sub(r"\n\+", " ", first).split() if "=" not in p]
    return body, pins


def import_gds(path, cellname, spice=None, name=None, tech=None, boundary_layer=None):
    """Bring a finished layout cell in from any GDS file (PDK cells, IP blocks, another tool's output).
    Ports are discovered from the text labels on the conductor label / pin layers; with spice= (a file
    holding `.subckt <cellname>`) the cell also has a reference netlist, so the parent can be LVS'd."""
    t = tech or T.current()
    if not os.path.exists(path):
        raise CanvasError(f"GDS file not found: {path}")
    src = _source(path)
    sc = src.cell(cellname)
    if sc is None:
        names = [c.name for c in src.each_cell()]
        import difflib
        raise CanvasError(f"no cell {cellname!r} in {os.path.basename(path)}",
                          "close names: " + ", ".join(difflib.get_close_matches(cellname, names, 6, 0.3)))
    c = Cell(name or cellname, t)
    c.foreign = (path, cellname)
    k = 1000.0 * src.dbu          # source dbu -> nm
    bb = sc.bbox()
    bl = boundary_layer or t.roles.get("boundary")
    if bl:
        li = src.find_layer(*t.layer(bl))
        if li is not None and not sc.bbox_per_layer(li).empty():
            bb = sc.bbox_per_layer(li)
    c.boundary = tuple(int(round(v * k)) for v in (bb.left, bb.bottom, bb.right, bb.top))
    # ports: texts on pin / label layers of each conductor
    found = {}
    for cond in t.stack:
        for kind, table in (("pin", t.pin_layer), ("label", t.label_layer)):
            if cond not in table:
                continue
            li = src.find_layer(*table[cond])
            if li is None:
                continue
            reg = kdb.Region(sc.begin_shapes_rec(li)) if kind == "pin" else None
            draw = None
            it = sc.begin_shapes_rec(li)
            while not it.at_end():
                sh = it.shape()
                if sh.is_text():
                    tx = sh.text.transformed(it.trans())
                    pos = kdb.Point(tx.x, tx.y)
                    box = None
                    if reg is not None:
                        for p in reg.each():
                            if p.bbox().contains(pos):
                                box = p.bbox()
                                break
                    if box is None:
                        if draw is None:
                            dl = src.find_layer(*t.layer(cond))
                            draw = kdb.Region(sc.begin_shapes_rec(dl)).merged() if dl is not None else kdb.Region()
                        for p in draw.each():
                            if p.bbox().contains(pos) and p.inside(pos):
                                h = int(t.width(cond) * 500 / k) or 1
                                box = kdb.Box(pos.x - h, pos.y - h, pos.x + h, pos.y + h) & p.bbox()
                                break
                    if box is not None:
                        key = (sh.text.string, cond, box.left, box.bottom, box.right, box.top)
                        found.setdefault(sh.text.string, {})[key] = Rect(
                            cond, *(int(round(v * k)) for v in (box.left, box.bottom, box.right, box.top)),
                            net=sh.text.string)
                it.next()
    pins = []
    if spice:
        body, pins = _subckt(spice, cellname)
        if body is None:
            raise CanvasError(f"no .subckt {cellname} in {spice}")
        if c.name != cellname:
            body = re.sub(rf"(\.subckt\s+){re.escape(cellname)}\b", rf"\g<1>{c.name}", body, flags=re.I)
        c.spice_text = body
    for nm_ in (pins or sorted(found)):
        c.port_order.append(nm_)
        c.ports[nm_] = list(found.get(nm_, {}).values())
        c.port_dir[nm_] = "inout"
    return c


def pdk_cell(name, tech=None):
    """A cell of one of the PDK's own libraries (standard cells, fixed-layout devices such as BJTs),
    with its real GDS and SPICE. Libraries are listed in the PDK data under 'libs'."""
    t = tech or T.current()
    for lib in t.d.get("libs", []):
        if name.startswith(lib["prefix"]):
            gds = os.path.join(t.root, lib["gds"].format(cell=name))
            sp = os.path.join(t.root, lib["spice"].format(cell=name)) if lib.get("spice") else None
            if name in Cell.registry and Cell.registry[name].foreign:
                return Cell.registry[name]
            return import_gds(gds, name, spice=sp, tech=t)
    raise CanvasError(f"no PDK library for cell {name!r} in {t.name}",
                      "known prefixes: " + ", ".join(l["prefix"] for l in t.d.get("libs", [])))
