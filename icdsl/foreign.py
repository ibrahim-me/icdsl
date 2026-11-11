"""Import pre-built blocks from GDS (e.g. SKY130 standard cells) as ICL layouts.

Shapes are read for proximity analysis and as routing obstacles; nets come from the
text labels on li/met1 (pin purpose); the reference subcircuit is taken from the PDK
SPICE library.
"""
from __future__ import annotations

import os
import re

import klayout.db as kdb

from . import tech as T
from .build import Layout
from .geom import Rect, Shape
from .signoff import PDK_ROOT
from .syntax import ICLError, did_you_mean

LIB = os.path.join(PDK_ROOT, "sky130A", "libs.ref", "sky130_fd_sc_hd")
_cache = {}


def _lib():
    if "ly" not in _cache:
        ly = kdb.Layout()
        ly.read(os.path.join(LIB, "gds", "sky130_fd_sc_hd.gds"))
        _cache["ly"] = ly
        txt = open(os.path.join(LIB, "spice", "sky130_fd_sc_hd.spice")).read()
        subs = {}
        for m in re.finditer(r"^\.subckt\s+(\S+)(.*?)^\.ends", txt, re.S | re.M | re.I):
            subs[m.group(1)] = m.group(0)
        _cache["spice"] = subs
    return _cache["ly"], _cache["spice"]


def pdk_cell(name, line=0):
    ly, subs = _lib()
    if not name.startswith("sky130_"):
        name = "sky130_fd_sc_hd__" + name
    c = ly.cell(name)
    if c is None:
        names = [ly.cell(i).name for i in range(ly.cells())]
        raise ICLError(f"PDK cell '{name}' not found", line, did_you_mean(name, names))
    rev = {v: k for k, v in T.GDS.items()}
    L = Layout(name, kind="pdk")
    L.gds_path = os.path.join(LIB, "gds", "sky130_fd_sc_hd.gds")
    L.gds_cell = name
    # placement boundary = the cell's site area (prBoundary / bbox without overhangs)
    bnd = None
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        if (info.layer, info.datatype) in ((235, 4), (236, 0), (81, 4)):
            for s in c.begin_shapes_rec(li):
                b = s.shape().bbox().transformed(s.trans())
                bnd = b if bnd is None else bnd + b
    if bnd is None:
        bnd = c.bbox()
    if bnd.left != 0 or bnd.bottom != 0:
        raise ICLError(f"{name}: unexpected origin {bnd}", line)
    L.width, L.height = bnd.width(), bnd.height()
    labels = {}
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        key = (info.layer, info.datatype)
        for lay, ld in list(T.GDS_LABEL.items()) + list(T.GDS_PIN.items()):
            if key == ld:
                for s in c.begin_shapes_rec(li):
                    if s.shape().is_text():
                        p = s.trans() * s.shape().text.trans.disp
                        labels.setdefault(lay, []).append((s.shape().text.string, p.x, p.y))
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        lay = rev.get((info.layer, info.datatype))
        if lay is None or lay == "boundary":
            continue
        reg = kdb.Region(c.begin_shapes_rec(li))
        reg.merge()
        for poly in reg.each():
            net = None
            for (txt, x, y) in labels.get(lay, []):
                if poly.inside(kdb.Point(x, y)) or poly.bbox().contains(kdb.Point(x, y)) and poly.is_box():
                    net = txt
                    break
            for tr in poly.decompose_trapezoids(0):
                b = tr.bbox()
                L.shapes.append(Shape(lay, Rect(b.left, b.bottom, b.right, b.top), net, name))
    _propagate_nets(L.shapes)
    sub = subs.get(name)
    if sub is None:
        raise ICLError(f"{name}: no SPICE subcircuit in the PDK library", line)
    head = sub.split("\n", 1)[0].split()
    L.port_order = head[2:]
    L.power, L.ground = "VPWR", "VGND"
    L.info["bulk"] = {"VPB": "power", "VNB": "ground"}
    L.spice = sub.strip() + "\n"
    for s in L.shapes:
        if s.net and s.layer in ("li", "m1") and s.net in L.port_order:
            L.ports.append((s.net, "inout", s))
    return L


_CUT_LINKS = {"licon": ("tap", "li"), "mcon": ("li", "m1"), "via": ("m1", "m2"),
              "via2": ("m2", "m3"), "via3": ("m3", "m4")}


def _propagate_nets(shapes):
    """Give unlabelled conductors the net of the labelled shape they connect to."""
    # diffusion / poly are excluded: a diffusion rectangle spans source and drain
    cond = [s for s in shapes if s.layer in ("tap", "li", "m1", "m2", "m3", "m4")]
    cuts = [s for s in shapes if s.layer in _CUT_LINKS]
    idx = {id(s): i for i, s in enumerate(cond)}
    par = list(range(len(cond)))

    def find(i):
        while par[i] != i:
            par[i] = par[par[i]]
            i = par[i]
        return i
    for i, a in enumerate(cond):
        for b in cond[i + 1:]:
            if a.layer == b.layer and a.rect.touches(b.rect):
                par[find(i)] = find(idx[id(b)])
    for c in cuts:
        hit = [idx[id(s)] for s in cond if s.layer in _CUT_LINKS[c.layer] and s.rect.overlaps(c.rect)]
        for h in hit[1:]:
            par[find(h)] = find(hit[0])
    net = {}
    for i, s in enumerate(cond):
        if s.net:
            net.setdefault(find(i), s.net)
    for i, s in enumerate(cond):
        if s.net is None and find(i) in net:
            s.net = net[find(i)]
