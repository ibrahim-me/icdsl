#!/usr/bin/env python3
"""Build the level-1 standard-cell benchmark from the SKY130 hd library.

For every cell we keep the PDK transistor topology exactly (from libs.ref/.../sky130_fd_sc_hd.spice),
rename internal nodes to n1, n2, ..., tie bodies to the rails (VNB->VGND, VPB->VPWR: our cells
carry their own taps), map pfet_01v8_hvt -> pfet_01v8 (no hvtp in the template) and scale widths by
0.75 (the hd cells are tapless; with in-cell taps a 2.72 um cell holds about WN+WP <= 1.3 um single
finger). Widths become parameters so the harness can sweep them.

Output: bench/cells.json
"""
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SPICE = os.path.join(ROOT, "pdk", "sky130A", "libs.ref", "sky130_fd_sc_hd", "spice", "sky130_fd_sc_hd.spice")
GDS_LEF = os.path.join(ROOT, "pdk", "sky130A", "libs.ref", "sky130_fd_sc_hd", "lef", "sky130_fd_sc_hd.lef")
SCALE = 0.75

TIERS = {
    1: ["inv_1", "buf_1", "nand2_1", "nor2_1"],
    2: ["nand3_1", "nor3_1", "and2_1", "or2_1"],
    3: ["a21oi_1", "o21ai_1", "a22oi_1", "o22ai_1"],
    4: ["xor2_1", "mux2i_1"],
    5: ["maj3_1", "ha_1", "dlxtp_1", "fa_1"],
}
FUNC = {
    "inv_1": "Y = !A", "buf_1": "X = A (two inverters)", "nand2_1": "Y = !(A & B)", "nor2_1": "Y = !(A | B)",
    "nand3_1": "Y = !(A & B & C)", "nor3_1": "Y = !(A | B | C)", "and2_1": "X = A & B (NAND2 + inverter)",
    "or2_1": "X = A | B (NOR2 + inverter)", "a21oi_1": "Y = !((A1 & A2) | B1)", "o21ai_1": "Y = !((A1 | A2) & B1)",
    "a22oi_1": "Y = !((A1 & A2) | (B1 & B2))", "o22ai_1": "Y = !((A1 | A2) & (B1 | B2))",
    "xor2_1": "X = A ^ B", "mux2i_1": "Y = !(S ? A1 : A0)",
    "maj3_1": "X = majority(A, B, C) = AB + BC + CA", "ha_1": "half adder: SUM = A ^ B, COUT = A & B",
    "dlxtp_1": "D latch, transparent while GATE is high: Q follows D", "fa_1": "full adder: SUM = A^B^CIN, COUT = maj(A,B,CIN)",
}
# sweep: (gate length, width scale, cell height)
SWEEP = [(0.15, 1.0, 2.72), (0.18, 1.0, 2.72), (0.25, 1.0, 2.72), (0.15, 0.85, 2.72),
         (0.15, 1.35, 3.26), (0.15, 1.9, 4.08)]


def hd_sizes():
    out = {}
    cur = None
    for line in open(GDS_LEF):
        m = re.match(r"\s*MACRO\s+(\S+)", line)
        if m:
            cur = m.group(1)
        m = re.match(r"\s*SIZE\s+([\d.]+)\s+BY\s+([\d.]+)", line)
        if m and cur:
            out[cur] = (float(m.group(1)), float(m.group(2)))
    return out


def snap(w):
    return max(0.42, round(w * 100) / 100)


def main():
    txt = open(SPICE).read()
    subs = {m.group(1): m.group(0) for m in re.finditer(r"^\.subckt\s+(\S+)(.*?)^\.ends", txt, re.S | re.M | re.I)}
    sizes = hd_sizes()
    cells = []
    for tier, names in TIERS.items():
        for short in names:
            full = "sky130_fd_sc_hd__" + short
            body = subs[full]
            head = body.splitlines()[0].split()
            ports = [p for p in head[2:] if p not in ("VNB", "VPB", "VGND", "VPWR")]
            ren, devs = {}, []

            def net(n):
                if n == "VNB":
                    return "VGND"
                if n == "VPB":
                    return "VPWR"
                if n.startswith("a_"):
                    if n not in ren:
                        ren[n] = f"n{len(ren) + 1}"
                    return ren[n]
                return n
            for line in body.splitlines():
                if not line.startswith("X"):
                    continue
                t = line.split()
                kind = "nmos" if "nfet" in t[5] else "pmos"
                w = float(re.search(r"w=([\d.e+]+)u", line).group(1)) / 1e6
                l = float(re.search(r"l=([\d.e+]+)u", line).group(1)) / 1e6
                devs.append({"name": "M" + t[0][1:], "kind": kind, "d": net(t[1]), "g": net(t[2]),
                             "s": net(t[3]), "w_hd": w, "w": snap(w * SCALE), "l": l})
            # one width parameter per distinct (kind, width)
            params = {}
            for kind, base in (("nmos", "WN"), ("pmos", "WP")):
                ws = sorted({d["w"] for d in devs if d["kind"] == kind}, reverse=True)
                for i, w in enumerate(ws):
                    params[base if i == 0 else f"{base}{i + 1}"] = w
            for d in devs:
                d["wparam"] = next(k for k, v in params.items() if k.startswith("WN" if d["kind"] == "nmos" else "WP")
                                   and v == d["w"])
            outs = [p for p in ports if p in ("Y", "X", "Q", "Q_N", "COUT", "SUM")]
            hw, hh = sizes.get(full, (0, 0))
            cells.append({"name": short.replace("_1", ""), "hd_cell": full, "tier": tier, "function": FUNC[short],
                          "inputs": [p for p in ports if p not in outs], "outputs": outs, "devices": devs,
                          "params": params, "hd_size_um": [hw, hh], "internal_nets": sorted(ren.values())})
    spec = {"source": "sky130_fd_sc_hd (open_pdks, ciel 792ef67)", "width_scale": SCALE,
            "notes": "bodies tied to rails, pfet_01v8_hvt -> pfet_01v8, widths x0.75 (cells carry their own taps)",
            "sweep": [{"L": l, "wscale": s, "H": h} for (l, s, h) in SWEEP], "cells": cells}
    out = os.path.join(ROOT, "bench", "cells.json")
    json.dump(spec, open(out, "w"), indent=1)
    for c in cells:
        print(f"T{c['tier']} {c['name']:7s} {len(c['devices'])} dev  params={c['params']}  hd {c['hd_size_um']}")
    print("wrote", out)


if __name__ == "__main__":
    main()
