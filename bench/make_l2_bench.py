#!/usr/bin/env python3
"""Level-2 (PCell assembly) benchmark: textbook analog blocks with layout constraints.

Each cell fixes the transistors (kind, per-finger width, length, fingers, connections) and a list
of layout constraints that bench/l2_judge.py checks on the drawn geometry:

  interdigitated  [A, B]      all fingers in one row, alternating, centroids equal (ABBA-like)
  common_centroid [A, B, ..]  centroids of all devices coincide (1-D or 2-D arrays)
  mirror_symmetric [[A,B],..] one vertical axis: every pair is a mirror image about it
  guard_ring      devices, kind   a closed ptap/ntap ring around those devices
  route_width     net, min    every routed segment of the net at least min wide
  spacing         nets, min   routed wires of the two nets at least min apart (same layer)
  maxres          net, max    worst pin-to-pin resistance of the routed net
  route_symmetric nets        the second net's wires are the mirror image of the first's

Output: bench/l2_cells.json
"""
import json
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def dev(name, kind, d, g, s, nf=1, w="W", l="L"):
    return {"name": name, "kind": kind, "d": d, "g": g, "s": s, "nf": nf, "w": w, "l": l}


def port(name, d, side=None):
    return {"name": name, "dir": d, "side": side}


CELLS = [
    {"name": "cm_n", "tier": 1, "function": "1:1 NMOS current mirror (M1 diode-connected reference, M2 output)",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("IREF", "in", "left"), port("IOUT", "out", "right"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "IREF", "IREF", "VGND", 2), dev("M2", "nmos", "IOUT", "IREF", "VGND", 2)],
     "constraints": [{"type": "interdigitated", "devices": ["M1", "M2"]}]},
    {"name": "cm_p12", "tier": 1, "function": "1:2 PMOS current mirror (M1 reference, M2 = 2x output)",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("IREF", "in", "left"), port("IOUT", "out", "right"), port("VPWR", "power")],
     "devices": [dev("M1", "pmos", "IREF", "IREF", "VPWR", 2), dev("M2", "pmos", "IOUT", "IREF", "VPWR", 4)],
     "constraints": [{"type": "common_centroid", "devices": ["M1", "M2"]}]},
    {"name": "diffpair", "tier": 1, "function": "NMOS differential pair with tail current source",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("INP", "in", "left"), port("INN", "in", "right"), port("VBN", "in", "bottom"),
               port("OUTP", "out", "top"), port("OUTN", "out", "top"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "OUTN", "INP", "tail", 2), dev("M2", "nmos", "OUTP", "INN", "tail", 2),
                 dev("MT", "nmos", "tail", "VBN", "VGND", 4)],
     "constraints": [{"type": "common_centroid", "devices": ["M1", "M2"]},
                     {"type": "route_width", "net": "tail", "min": 0.3}]},
    {"name": "cascode_n", "tier": 2, "function": "NMOS cascode current mirror (M1/M2 bottom pair, M3/M4 cascodes)",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("IREF", "in", "left"), port("IOUT", "out", "right"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "n1", "n1", "VGND", 2), dev("M2", "nmos", "n2", "n1", "VGND", 2),
                 dev("M3", "nmos", "IREF", "IREF", "n1", 2), dev("M4", "nmos", "IOUT", "IREF", "n2", 2)],
     "constraints": [{"type": "interdigitated", "devices": ["M1", "M2"]},
                     {"type": "interdigitated", "devices": ["M3", "M4"]}]},
    {"name": "ota5t", "tier": 2, "function": "5-transistor OTA: NMOS input pair, PMOS mirror load, NMOS tail",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("INP", "in", "left"), port("INN", "in", "right"), port("VBN", "in", "left"),
               port("OUT", "out", "right"), port("VPWR", "power"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "x", "INP", "tail", 2), dev("M2", "nmos", "OUT", "INN", "tail", 2),
                 dev("M3", "pmos", "x", "x", "VPWR", 2), dev("M4", "pmos", "OUT", "x", "VPWR", 2),
                 dev("MT", "nmos", "tail", "VBN", "VGND", 4)],
     "constraints": [{"type": "interdigitated", "devices": ["M1", "M2"]},
                     {"type": "common_centroid", "devices": ["M3", "M4"]},
                     {"type": "spacing", "nets": ["OUT", "INN"], "min": 0.5},
                     {"type": "route_width", "net": "tail", "min": 0.4}]},
    {"name": "diff_stage", "tier": 2, "function": "fully differential stage: NMOS pair, PMOS current-source "
                                                   "loads, NMOS tail - drawn mirror-symmetric with guard rings",
     "params": {"W": 1.0, "L": 0.3},
     "ports": [port("INP", "in", "left"), port("INN", "in", "right"), port("VBN", "in", "bottom"),
               port("VBP", "in", "top"), port("OUTP", "out"), port("OUTN", "out"),
               port("VPWR", "power"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "OUTN", "INP", "tail", 2), dev("M2", "nmos", "OUTP", "INN", "tail", 2),
                 dev("M3", "pmos", "OUTN", "VBP", "VPWR", 2), dev("M4", "pmos", "OUTP", "VBP", "VPWR", 2),
                 dev("MT", "nmos", "tail", "VBN", "VGND", 4)],
     "constraints": [{"type": "mirror_symmetric", "pairs": [["M1", "M2"], ["M3", "M4"]]},
                     {"type": "route_symmetric", "nets": ["OUTN", "OUTP"]},
                     {"type": "guard_ring", "devices": ["M1", "M2", "MT"], "kind": "ptap"},
                     {"type": "guard_ring", "devices": ["M3", "M4"], "kind": "ntap"}]},
    {"name": "bias3", "tier": 3, "function": "NMOS bias mirror: reference M0, outputs M1 (1x) and M2 (2x), "
                                              "all three on one common centroid",
     "params": {"W": 1.0, "L": 1.0},
     "ports": [port("IREF", "in", "left"), port("I1", "out", "right"), port("I2", "out", "right"),
               port("VGND", "ground")],
     "devices": [dev("M0", "nmos", "IREF", "IREF", "VGND", 2), dev("M1", "nmos", "I1", "IREF", "VGND", 2),
                 dev("M2", "nmos", "I2", "IREF", "VGND", 4)],
     "constraints": [{"type": "common_centroid", "devices": ["M0", "M1", "M2"]}]},
    {"name": "ota2s", "tier": 3, "function": "two-stage OTA (no compensation cap): 5T first stage + PMOS "
                                              "common-source second stage with NMOS current-source load",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("INP", "in", "left"), port("INN", "in", "left"), port("VBN", "in", "left"),
               port("OUT", "out", "right"), port("VPWR", "power"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "x", "INP", "tail", 2), dev("M2", "nmos", "o1", "INN", "tail", 2),
                 dev("M3", "pmos", "x", "x", "VPWR", 2), dev("M4", "pmos", "o1", "x", "VPWR", 2),
                 dev("MT", "nmos", "tail", "VBN", "VGND", 4), dev("M6", "pmos", "OUT", "o1", "VPWR", 4),
                 dev("M7", "nmos", "OUT", "VBN", "VGND", 4)],
     "constraints": [{"type": "common_centroid", "devices": ["M1", "M2"]},
                     {"type": "common_centroid", "devices": ["M3", "M4"]},
                     {"type": "route_width", "net": "OUT", "min": 0.3},
                     {"type": "spacing", "nets": ["OUT", "INP"], "min": 0.6},
                     {"type": "spacing", "nets": ["OUT", "INN"], "min": 0.6}]},
    {"name": "strongarm", "tier": 3, "function": "StrongARM latch comparator, drawn mirror-symmetric",
     "params": {"W": 1.0, "L": 0.15},
     "ports": [port("CLK", "in", "bottom"), port("INP", "in", "left"), port("INN", "in", "right"),
               port("OUTP", "out", "top"), port("OUTN", "out", "top"), port("VPWR", "power"),
               port("VGND", "ground")],
     "devices": [dev("M0", "nmos", "tail", "CLK", "VGND", 4),
                 dev("M1", "nmos", "P", "INP", "tail", 2), dev("M2", "nmos", "Q", "INN", "tail", 2),
                 dev("M3", "nmos", "OUTN", "OUTP", "P"), dev("M4", "nmos", "OUTP", "OUTN", "Q"),
                 dev("M5", "pmos", "OUTN", "OUTP", "VPWR"), dev("M6", "pmos", "OUTP", "OUTN", "VPWR"),
                 dev("M7", "pmos", "OUTN", "CLK", "VPWR"), dev("M8", "pmos", "OUTP", "CLK", "VPWR"),
                 dev("M9", "pmos", "P", "CLK", "VPWR"), dev("M10", "pmos", "Q", "CLK", "VPWR")],
     "constraints": [{"type": "mirror_symmetric",
                      "pairs": [["M1", "M2"], ["M3", "M4"], ["M5", "M6"], ["M7", "M8"], ["M9", "M10"]]}]},
    {"name": "mirror4", "tier": 4, "function": "4-way NMOS mirror bank (reference + 3 outputs) on one 2-D common "
                                                "centroid inside a ptap guard ring",
     "params": {"W": 1.0, "L": 1.0},
     "ports": [port("IREF", "in", "left"), port("I1", "out", "right"), port("I2", "out", "right"),
               port("I3", "out", "right"), port("VGND", "ground")],
     "devices": [dev("M0", "nmos", "IREF", "IREF", "VGND", 2), dev("M1", "nmos", "I1", "IREF", "VGND", 2),
                 dev("M2", "nmos", "I2", "IREF", "VGND", 2), dev("M3", "nmos", "I3", "IREF", "VGND", 2)],
     "constraints": [{"type": "common_centroid", "devices": ["M0", "M1", "M2", "M3"]},
                     {"type": "guard_ring", "devices": ["M0", "M1", "M2", "M3"], "kind": "ptap"}]},
    {"name": "ota5t_small", "tier": 4, "function": "5-transistor OTA as ota5t, but inside an area budget",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("INP", "in", "left"), port("INN", "in", "right"), port("VBN", "in", "left"),
               port("OUT", "out", "right"), port("VPWR", "power"), port("VGND", "ground")],
     "devices": [dev("M1", "nmos", "x", "INP", "tail", 2), dev("M2", "nmos", "OUT", "INN", "tail", 2),
                 dev("M3", "pmos", "x", "x", "VPWR", 2), dev("M4", "pmos", "OUT", "x", "VPWR", 2),
                 dev("MT", "nmos", "tail", "VBN", "VGND", 4)],
     "constraints": [{"type": "interdigitated", "devices": ["M1", "M2"]},
                     {"type": "interdigitated", "devices": ["M3", "M4"]},
                     {"type": "area", "max": {"W=1.0,L=0.5": 86.0, "W=1.0,L=1.0": 117.0, "W=1.0,L=0.15": 55.0,
                                              "W=2.0,L=0.5": 113.0}}]},
    {"name": "folded_cascode", "tier": 4, "function": "folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current "
                                                       "sinks, NMOS cascodes, PMOS cascoded mirror load",
     "params": {"W": 1.0, "L": 0.5},
     "ports": [port("INP", "in", "left"), port("INN", "in", "right"), port("VBP", "in", "top"),
               port("VBN", "in", "bottom"), port("VCN", "in", "left"), port("VCP", "in", "left"),
               port("OUT", "out", "right"), port("VPWR", "power"), port("VGND", "ground")],
     "devices": [dev("MT", "pmos", "tail", "VBP", "VPWR", 4),
                 dev("M1", "pmos", "f1", "INP", "tail", 2), dev("M2", "pmos", "f2", "INN", "tail", 2),
                 dev("M3", "nmos", "f1", "VBN", "VGND", 2), dev("M4", "nmos", "f2", "VBN", "VGND", 2),
                 dev("M5", "nmos", "x", "VCN", "f1", 2), dev("M6", "nmos", "OUT", "VCN", "f2", 2),
                 dev("M7", "pmos", "y", "x", "VPWR", 2), dev("M8", "pmos", "z", "x", "VPWR", 2),
                 dev("M9", "pmos", "x", "VCP", "y", 2), dev("M10", "pmos", "OUT", "VCP", "z", 2)],
     "constraints": [{"type": "common_centroid", "devices": ["M1", "M2"]},
                     {"type": "interdigitated", "devices": ["M3", "M4"]},
                     {"type": "interdigitated", "devices": ["M5", "M6"]},
                     {"type": "interdigitated", "devices": ["M7", "M8"]},
                     {"type": "interdigitated", "devices": ["M9", "M10"]},
                     {"type": "spacing", "nets": ["OUT", "INP"], "min": 0.5},
                     {"type": "spacing", "nets": ["OUT", "INN"], "min": 0.5}]},
    {"name": "comp_latch", "tier": 5, "function": "StrongARM comparator with an SR (NAND2) output latch, drawn "
                                                  "mirror-symmetric",
     "params": {"W": 1.0, "L": 0.15},
     "ports": [port("CLK", "in", "bottom"), port("INP", "in", "left"), port("INN", "in", "right"),
               port("QP", "out", "top"), port("QN", "out", "top"), port("VPWR", "power"), port("VGND", "ground")],
     "devices": [dev("M0", "nmos", "tail", "CLK", "VGND", 4),
                 dev("M1", "nmos", "P", "INP", "tail", 2), dev("M2", "nmos", "Q", "INN", "tail", 2),
                 dev("M3", "nmos", "OUTN", "OUTP", "P"), dev("M4", "nmos", "OUTP", "OUTN", "Q"),
                 dev("M5", "pmos", "OUTN", "OUTP", "VPWR"), dev("M6", "pmos", "OUTP", "OUTN", "VPWR"),
                 dev("M7", "pmos", "OUTN", "CLK", "VPWR"), dev("M8", "pmos", "OUTP", "CLK", "VPWR"),
                 dev("M9", "pmos", "P", "CLK", "VPWR"), dev("M10", "pmos", "Q", "CLK", "VPWR"),
                 dev("MN11", "nmos", "QP", "OUTN", "m1"), dev("MN12", "nmos", "m1", "QN", "VGND"),
                 dev("MP11", "pmos", "QP", "OUTN", "VPWR"), dev("MP12", "pmos", "QP", "QN", "VPWR"),
                 dev("MN21", "nmos", "QN", "OUTP", "m2"), dev("MN22", "nmos", "m2", "QP", "VGND"),
                 dev("MP21", "pmos", "QN", "OUTP", "VPWR"), dev("MP22", "pmos", "QN", "QP", "VPWR")],
     "constraints": [{"type": "mirror_symmetric",
                      "pairs": [["M1", "M2"], ["M3", "M4"], ["M5", "M6"], ["M7", "M8"], ["M9", "M10"],
                                ["MN11", "MN21"], ["MN12", "MN22"], ["MP11", "MP21"], ["MP12", "MP22"]]}]},
]

SWEEP = [{"Lscale": 1.0, "wscale": 1.0}, {"Lscale": 2.0, "wscale": 1.0}, {"Lmin": True, "wscale": 1.0},
         {"Lscale": 1.0, "wscale": 2.0}]


def main():
    spec = {"source": "textbook analog blocks (current mirrors, differential pairs, OTAs, StrongARM latch); "
                      "constraints checked on the drawn geometry by bench/l2_judge.py",
            "sweep": SWEEP, "cells": CELLS}
    out = os.path.join(ROOT, "bench", "l2_cells.json")
    json.dump(spec, open(out, "w"), indent=1)
    for c in CELLS:
        print(f"T{c['tier']} {c['name']:10s} {len(c['devices'])} dev  " +
              ", ".join(x["type"] for x in c["constraints"]))
    print("wrote", out)


if __name__ == "__main__":
    main()
