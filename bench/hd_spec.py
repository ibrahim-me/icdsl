#!/usr/bin/env python3
"""Benchmark-style task specs for ANY sky130_fd_sc_hd cell (same conventions as make_bench.py).

PDK transistor topology kept exactly, internal nodes renamed n1, n2, ..., bodies tied to the rails,
pfet_01v8_hvt -> pfet_01v8, widths x0.75 (our cells carry their own taps) and one width parameter per
distinct (kind, width). Pin directions come from the LEF.

    python bench/hd_spec.py                     # writes library/hd_specs.json (every supported cell)
"""
from __future__ import annotations

import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIB = os.path.join(ROOT, "pdk", "sky130A", "libs.ref", "sky130_fd_sc_hd")
SPICE = os.path.join(LIB, "spice", "sky130_fd_sc_hd.spice")
LEF = os.path.join(LIB, "lef", "sky130_fd_sc_hd.lef")
PREFIX = "sky130_fd_sc_hd__"
SCALE = 0.75
MODELS = {"sky130_fd_pr__nfet_01v8": "nmos", "sky130_fd_pr__pfet_01v8_hvt": "pmos"}
SWEEP = [(0.15, 1.0, 2.72), (0.18, 1.0, 2.72), (0.25, 1.0, 2.72), (0.15, 0.85, 2.72),
         (0.15, 1.35, 3.26), (0.15, 1.9, 4.08)]
SUPPLIES = ("VNB", "VPB", "VGND", "VPWR")
# library conventions: tapless cells (the row's tap cells tie the bodies), PDK widths, a sweep that only grows
SWEEP_LIB = [(0.15, 1.0, 2.72), (0.18, 1.0, 2.72), (0.25, 1.0, 2.72), (0.15, 1.25, 3.26), (0.15, 1.5, 3.8)]
TAPLESS_WAIVE = "LU.2,LU.3,nwell.4"

_cache = {}


def subckts():
    if "subs" not in _cache:
        txt = open(SPICE).read()
        _cache["subs"] = {m.group(1): m.group(0) for m in
                          re.finditer(r"^\.subckt\s+(\S+)(.*?)^\.ends", txt, re.S | re.M | re.I)}
    return _cache["subs"]


def lef():
    """macro -> {"size": (w, h), "pins": {name: direction}}"""
    if "lef" not in _cache:
        out, cur, pin = {}, None, None
        for line in open(LEF):
            m = re.match(r"\s*MACRO\s+(\S+)", line)
            if m:
                cur = m.group(1)
                out[cur] = {"size": (0, 0), "pins": {}}
                continue
            if cur is None:
                continue
            m = re.match(r"\s*SIZE\s+([\d.]+)\s+BY\s+([\d.]+)", line)
            if m:
                out[cur]["size"] = (float(m.group(1)), float(m.group(2)))
            m = re.match(r"\s*PIN\s+(\S+)", line)
            if m:
                pin = m.group(1)
            m = re.match(r"\s*DIRECTION\s+(\S+)", line)
            if m and pin:
                out[cur]["pins"][pin] = m.group(1).upper()
        _cache["lef"] = out
    return _cache["lef"]


def snap(w, scale=SCALE):
    return max(0.42, round(w * scale * 100) / 100) if scale != 1.0 else round(w, 3)


def family(short):
    """Function family used to keep near-copies out of a retrieval library: drive strength and
    inverted-input ('b'/'bb') variants of one function share a family (nand4_1, nand4b_2 -> nand4)."""
    core = re.sub(r"_\d+$", "", short)
    core = re.sub(r"^(nand|nor|and|or)(\d)b+$", r"\1\2", core)
    core = re.sub(r"^([ao]\d+)b(o|a|oi|ai)$", r"\1\2", core)
    return core


def spec_for(short, name=None, scale=SCALE):
    """Task spec for one hd cell (short = name without the library prefix, e.g. 'a21oi_1').
    Returns None for cells the level-1 language cannot express (special devices, other gate lengths)."""
    full = PREFIX + short
    body = subckts().get(full)
    if body is None:
        return None
    head = body.splitlines()[0].split()
    ports = [p for p in head[2:] if p not in SUPPLIES]
    ren, devs = {}, []

    def net(n):
        if n == "VNB":
            return "VGND"
        if n == "VPB":
            return "VPWR"
        if n.startswith("a_") or n.startswith("sky130"):
            if n not in ren:
                ren[n] = f"n{len(ren) + 1}"
            return ren[n]
        return n
    for line in body.splitlines():
        if not line.startswith("X"):
            continue
        t = line.split()
        if len(t) != 8 or t[5] not in MODELS:
            return None
        w = float(re.search(r"w=([\d.e+]+)u", line).group(1)) / 1e6
        l = float(re.search(r"l=([\d.e+]+)u", line).group(1)) / 1e6
        if abs(l - 0.15) > 1e-6:
            return None
        devs.append({"name": "M" + t[0][1:], "kind": MODELS[t[5]], "d": net(t[1]), "g": net(t[2]),
                     "s": net(t[3]), "w_hd": round(w, 3), "w": snap(w, scale), "l": l})
    if not devs:
        return None
    params = {}
    for kind, base in (("nmos", "WN"), ("pmos", "WP")):
        ws = sorted({d["w"] for d in devs if d["kind"] == kind}, reverse=True)
        for i, w in enumerate(ws):
            params[base if i == 0 else f"{base}{i + 1}"] = w
    for d in devs:
        d["wparam"] = next(k for k, v in params.items() if k.startswith("WN" if d["kind"] == "nmos" else "WP")
                           and v == d["w"])
    info = lef().get(full, {"size": (0, 0), "pins": {}})
    dirs = info["pins"]
    outs = [p for p in ports if dirs.get(p) == "OUTPUT"] or [p for p in ports if p in ("Y", "X", "Q", "Q_N")]
    return {"name": name or short, "hd_cell": full, "tier": 0, "function": "", "family": family(short),
            "inputs": [p for p in ports if p not in outs], "outputs": outs, "devices": devs,
            "params": params, "hd_size_um": list(info["size"]), "internal_nets": sorted(ren.values())}


def all_specs(scale=SCALE):
    cells = []
    for full in sorted(subckts()):
        if not full.startswith(PREFIX):
            continue
        s = spec_for(full[len(PREFIX):], scale=scale)
        if s:
            cells.append(s)
    return cells


def bench_doc(cells):
    return {"source": "sky130_fd_sc_hd (open_pdks, ciel 792ef67)", "width_scale": SCALE,
            "notes": "bodies tied to rails, pfet_01v8_hvt -> pfet_01v8, widths x0.75 (cells carry their own taps)",
            "sweep": [{"L": l, "wscale": s, "H": h} for (l, s, h) in SWEEP], "cells": cells}


def lib_doc(cells):
    return {"source": "sky130_fd_sc_hd (open_pdks, ciel 792ef67)", "width_scale": 1.0, "taps": False,
            "waive": TAPLESS_WAIVE,
            "notes": "library conventions: tapless cells (bodies VNB/VPB, tied by the row's tap cells; the tap rules "
                     "LU.2/LU.3/nwell.4 are waived), PDK widths, pfet_01v8_hvt -> pfet_01v8",
            "sweep": [{"L": l, "wscale": s, "H": h} for (l, s, h) in SWEEP_LIB], "cells": cells}


if __name__ == "__main__":
    os.makedirs(os.path.join(ROOT, "library"), exist_ok=True)
    cells = all_specs()
    out = os.path.join(ROOT, "library", "hd_specs.json")
    json.dump(bench_doc(cells), open(out, "w"), indent=1)
    print(f"{len(cells)} cells -> {out}  (benchmark conventions: in-cell taps, widths x0.75)")
    cells = all_specs(scale=1.0)
    out = os.path.join(ROOT, "library", "lib_specs.json")
    json.dump(lib_doc(cells), open(out, "w"), indent=1)
    print(f"{len(cells)} cells -> {out}  (library conventions: tapless, PDK widths)")
