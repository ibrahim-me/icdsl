"""Row template mode for `cell` blocks: automatic rails, taps, wells, implants.

Rows are listed bottom to top; nmos rows below pmos rows; a single n-well band at the top.
"""
from __future__ import annotations

from . import tech as T
from .devices import DeviceError, build_array, single, tap_strip
from .geom import Rect, Shape, rect_c
from .lib_assembly import WALL, Obj, ceil_grid, required_offset
from .router import NetRoute, NetSpec, PinGroup, Router
from .syntax import ICLError, did_you_mean

G = T.GRID


class RowTemplate:
    def __init__(self, b):
        self.b, self.L = b, b.L

    def err(self, msg, line=None, hint=""):
        return self.b.err(msg, line, hint)

    def run(self):
        L = self.L
        if not L.power or not L.ground:
            raise self.err("needs exactly one 'power' port and one 'ground' port", None,
                           "e.g.  port VPWR power   /   port VGND ground")
        rows = self._rows()
        self._place_x(rows)
        self._place_y(rows)
        self._wells_taps_rails(rows)
        self._route()
        self._ports()
        L.shapes.append(Shape("boundary", Rect(0, 0, L.width, L.height), None, "boundary"))
        L.info["rows"] = [{"kind": r["kind"], "strap": r["strap"], "gate_row": r.get("y", 0) // G,
                           "items": [(o.name, o.x // G) for o in r["placed"]]} for r in rows]

    # ------------------------------------------------------------- rows
    def _rows(self):
        b = self.b
        seen = {}
        rows = []
        for st in b.rows:
            items, kinds = [], set()
            for it in st.args:
                if it in seen:
                    raise ICLError(f"'{it}' placed in two rows (lines {seen[it]} and {st.line})", st.line)
                seen[it] = st.line
                if it in b.devs:
                    items.append(("dev", b.devs[it]))
                    kinds.add(b.devs[it].kind)
                elif it in b.objs and b.objs[it].inst is not None:
                    items.append(("inst", b.objs[it]))
                    kinds.add("inst")
                else:
                    raise ICLError(f"row item '{it}' is not a device or instance", st.line,
                                   did_you_mean(it, list(b.devs) + list(b.objs)))
            if len(kinds) != 1:
                raise ICLError(f"row mixes {sorted(kinds)}; each row holds only nmos, only pmos, or only instances",
                               st.line, "split it into separate rows")
            kind = kinds.pop()
            strap = st.kw.get("strap", "top" if kind == "nmos" else "bottom")
            if strap not in ("top", "bottom"):
                raise ICLError(f"strap must be top|bottom, got '{strap}'", st.line)
            def cols(key):
                v = str(st.kw.get(key, "0")).strip()
                if v in ("min", "0"):
                    return 0
                try:
                    n = int(v)
                except ValueError:
                    raise ICLError(f"row {key}= counts extra routing columns (an integer, or min); got '{v}'",
                                   st.line, f"use {key}=min (abut / tightest legal), or e.g. {key}=1 for one free "
                                            "column between items")
                if n < 0:
                    raise ICLError(f"row {key}= must be >= 0", st.line)
                return n
            rows.append({"kind": kind, "items": items, "strap": strap, "gap": cols("gap"),
                         "space": cols("space"), "line": st.line, "placed": []})
        missing = [n for n in list(b.devs) + [o for o in b.objs if b.objs[o].inst is not None] if n not in seen]
        if missing:
            raise self.err(f"not placed in any row: {', '.join(missing)}", None,
                           "add e.g. 'row " + " ".join(missing) + "'")
        kinds = [r["kind"] for r in rows]
        if "inst" in kinds and len(set(kinds)) > 1:
            raise self.err("a row-template cell contains either device rows or instance rows, not both")
        if "inst" not in kinds:
            seen_p = False
            for r in rows:
                if r["kind"] == "pmos":
                    seen_p = True
                elif seen_p:
                    raise ICLError("an nmos row is listed above a pmos row", r["line"],
                                   "rows are listed bottom-to-top; nmos rows first, then pmos rows "
                                   "(the n-well sits at the top of the cell under the power rail)")
        self.inst_mode = "inst" in kinds
        return rows

    def _place_x(self, rows):
        b = self.b
        width = 0
        for ri, row in enumerate(rows):
            placed = []
            prev_end = None
            for kind, it in row["items"]:
                if kind == "dev":
                    arr = single(it, row["strap"], it.line)
                    arr.dummy_gate = self.L.ground if it.kind == "nmos" else self.L.power
                    try:
                        build_array(arr)
                    except DeviceError as e:
                        raise ICLError(str(e), it.line)
                    o = Obj(it.name, "array", arr.shapes, arr.pins, it.line, array=arr)
                    b.objs[it.name] = o
                    b.dev_obj[it.name] = it.name
                    shp = arr.shapes
                    need = max(WALL.get(s.layer, 0) - s.rect.x0 for s in shp)
                    if placed:
                        d = required_offset(placed, shp, "x", T.SPACE_H)
                        if d is not None:
                            need = max(need, d)
                    x = ceil_grid(need)
                    if prev_end is not None and row["gap"]:
                        x = max(x, prev_end + (row["gap"] + 1) * G)
                    o.x = x
                    placed += [s.moved(x, 0) for s in shp]
                    prev_end = x + arr.span
                else:
                    o = it
                    x = (0 if prev_end is None else prev_end) + row["gap"] * G
                    o.x = o.inst.x = x
                    prev_end = x + o.inst.cell.width
                    placed.append(Shape("boundary", Rect(x, 0, prev_end, o.inst.cell.height)))
                o.placed = True
                row["placed"].append(o)
            right = prev_end if row["kind"] == "inst" else max(s.rect.x1 + WALL.get(s.layer, 0) for s in placed)
            width = max(width, ceil_grid(right))
        if "width" in b.params:
            wreq = int(b.params["width"]) * G
            if wreq < width:
                raise self.err(f"width={b.params['width']} columns is too small; needs {width // G}")
            width = wreq
        self.L.width = width

    def _row_bands(self, row, dy):
        W = self.L.width
        ds = [s.rect.moved(o.x, o.y + dy) for o in row["placed"] for s in o.shapes if s.layer == "diff"]
        y0, y1 = min(r.y0 for r in ds), max(r.y1 for r in ds)
        e = T.R["sdm.enc_diff"]
        if row["kind"] == "nmos":
            return [Shape("nsdm", Rect(0, y0 - e, W, y1 + e), None, "implant")]
        en = T.R["nwell.enc_pdiff"]
        return [Shape("psdm", Rect(0, y0 - e, W, y1 + e), None, "implant"),
                Shape("nwell", Rect(0, y0 - en, W, y1 + en), None, "nwell")]

    def _taps(self, kind, y):
        W, L = self.L.width, self.L
        net = L.ground if kind == "ptap" else L.power
        S = tap_strip(kind, net, W, y, kind)
        th = T.R["licon.size"] + 2 * T.R["licon.diff_enc1"]
        e = T.R["sdm.enc_diff"]
        if kind == "ptap":
            S.append(Shape("psdm", Rect(0, y - th // 2 - e, W, y + th // 2 + e), None, "implant"))
        else:
            S.append(Shape("nsdm", Rect(0, y - th // 2 - e, W, y + th // 2 + e), None, "implant"))
            en = T.R["nwell.enc_ntap"]
            S.append(Shape("nwell", Rect(0, y - th // 2 - en, W, y + th // 2 + en), None, "nwell"))
        return S

    def _place_y(self, rows):
        L, b = self.L, self.b
        if self.inst_mode:
            hs = {o.inst.cell.height for row in rows for o in row["placed"]}
            if len(hs) != 1 or len(rows) != 1:
                raise self.err("row-template instance cells hold a single row of equal-height cells "
                               "(use free placement for anything else)", rows[0]["line"])
            L.height = hs.pop()
            return
        below = self._taps("ptap", 0)
        prev_y = 0
        for row in rows:
            shp = [s.moved(o.x, 0) for o in row["placed"] for s in o.shapes]
            shp_b = shp + self._row_bands(row, 0)
            d = required_offset(below, shp_b, "y", T.SPACE_V)
            y = ceil_grid(max(d if d is not None else 0, prev_y + G)) + row["space"] * G
            row["y"] = y
            for o in row["placed"]:
                o.y = y
            below = below + [s.moved(0, y) for s in shp_b]
            prev_y = y
        top = self._taps("ntap", 0)
        d = required_offset(below, top, "y", T.SPACE_V)
        H = ceil_grid(max(d or 0, prev_y + 2 * G))
        if "height" in b.params:
            hreq = int(b.params["height"]) * G
            if hreq < H:
                raise self.err(f"height={b.params['height']} rows is too small; the rows need {H // G}",
                               None, f"use height={H // G} or more")
            H = hreq
        L.height = H

    def _wells_taps_rails(self, rows):
        L = self.L
        W, H = L.width, L.height
        S = L.shapes
        if not self.inst_mode:
            S += self._taps("ptap", 0)
            S += self._taps("ntap", H)
            bands = []
            for row in rows:
                for o in row["placed"]:
                    S += o.gshapes()
                bands += self._row_bands(row, 0)
            for lay, smin in (("nsdm", T.R["sdm.space"]), ("psdm", T.R["sdm.space"]), ("nwell", T.R["nwell.space"])):
                rs = sorted([x.rect for x in bands if x.layer == lay] + [s.rect for s in S if s.layer == lay],
                            key=lambda r: r.y0)
                S[:] = [s for s in S if s.layer != lay]
                merged = []
                for r in rs:
                    if merged and (lay == "nwell" or (r.y0 - merged[-1].y1 < smin and
                                                      not self._between(lay, merged[-1].y1, r.y0, bands, S))):
                        merged[-1] = merged[-1].union(r)
                    else:
                        merged.append(r)
                for r in merged:
                    S.append(Shape(lay, r, None, "implant" if lay != "nwell" else "nwell"))
        rw = T.RAIL_W
        self.rails = {L.ground: Shape("m1", Rect(0, -rw // 2, W, rw // 2), L.ground, f"rail:{L.ground}"),
                      L.power: Shape("m1", Rect(0, H - rw // 2, W, H + rw // 2), L.power, f"rail:{L.power}")}
        S += list(self.rails.values())
        if self.inst_mode:
            for row in rows:
                for o in row["placed"]:
                    L.insts.append(o.inst)
        self.rows = rows

    def _between(self, lay, y0, y1, bands, S):
        other = {"nsdm": "psdm", "psdm": "nsdm", "nwell": None}[lay]
        if other is None:
            return False
        return any(s.layer == other and s.rect.y1 > y0 and s.rect.y0 < y1 for s in list(bands) + list(S))

    # ------------------------------------------------------------- routing
    def _route(self):
        L, b = self.L, self.b
        nc, nr = L.width // G, L.height // G
        L.grid = (nc, nr)
        rt = Router(Rect(G, 0, L.width - G, L.height), G, layers=T.ROUTE_LAYERS)
        for s in L.all_shapes(True):
            rt.add_shape(s)
        pins = {}
        labelled = {p[0] for p in b.ports}
        for row in self.rows:
            for o in row["placed"]:
                for p in o.gpins():
                    if p.net is None:
                        continue
                    if o.inst is not None and p.net in (L.power, L.ground):
                        continue
                    pins.setdefault(p.net, []).append(PinGroup(p.net, p.name, [], [p.shape]))
                    if o.inst is None and p.net not in labelled and p.net not in (L.power, L.ground):
                        labelled.add(p.net)
                        L.labels.append((p.net, "li", p.shape.rect.cx, p.shape.rect.cy))
        for net, gs in pins.items():
            for g in gs:
                for s in g.shapes:
                    for a in rt.access_for(net, s, ["m1"]):
                        if a.stack:
                            rt.penalty[(a.c, a.r)].add(net)
        supplies = {n: PinGroup(n, f"rail:{n}", [], [s]) for n, s in self.rails.items()}
        self.pins = pins
        b.plan.execute(rt, pins, b.scope, supplies=supplies, default_layers=("m1", "m2"),
                       err=lambda m, line, hint="": self.err(m, line, hint))
        L.routes = rt.routes
        for n, r in rt.routes.items():
            L.shapes += r.shapes
        self.router = rt
        b.pins = pins

    def _ports(self):
        L, b = self.L, self.b
        rt = self.router
        for (net, d, line) in b.ports:
            if net in (L.power, L.ground):
                y = 0 if net == L.ground else L.height
                r = Rect(G - 145, y - T.RAIL_W // 2, G + 145, y + T.RAIL_W // 2)
                L.ports.append((net, d, Shape("m1", r, net, f"port:{net}")))
                continue
            if net not in self.pins:
                raise ICLError(f"port '{net}' is not connected to any device", line, did_you_mean(net, self.pins))
            nrt = L.routes.get(net)
            m1 = sorted([(c, r) for (c, r, l) in (nrt.nodes if nrt else ()) if l == "m1"])
            if m1:
                node = m1[len(m1) // 2]
                pr = rect_c(node[0] * G, node[1] * G, T.PAD_VIA, T.PAD_VIA)
                if not rt.clear(net, "m1", pr):
                    pr = rect_c(node[0] * G, node[1] * G, T.WIRE_W["m1"], T.WIRE_W["m1"])
                s = Shape("m1", pr, net, f"port:{net}")
                L.shapes.append(s)
                L.ports.append((net, d, s))
                continue
            sp = NetSpec(net, layers=["m1"])
            done = False
            for g in self.pins[net]:
                for s in g.shapes:
                    for a in rt.access_for(net, s, ["m1"]):
                        if rt.stack_ok(net, a, sp):
                            nr2 = rt.routes.setdefault(net, NetRoute(net))
                            new = rt._commit(nr2, sp, [(a.c, a.r, "m1")], a, None)
                            L.shapes += new
                            pad = [x for x in new if x.layer == "m1"][0]
                            L.ports.append((net, d, Shape("m1", pad.rect, net, f"port:{net}")))
                            done = True
                            break
                    if done:
                        break
                if done:
                    break
            if not done:
                raise ICLError(f"port '{net}': no free met1 location above its pin", line)
