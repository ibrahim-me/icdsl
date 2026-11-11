#!/usr/bin/env python
"""Build the XL benchmark from the reference designs: for every task and PDK run the reference script,
require it to be clean (magic DRC + the foundry KLayout deck + netgen LVS), and write

    tasks/<task>/task.md        what to build (interface-neutral: any tool may produce the GDS)
    tasks/<task>/task.json      top cell, pins, per-PDK area budget and reference numbers
    tasks/<task>/<pdk>.spice    the netlist the layout must match on that PDK
    REFERENCE.md                the table of reference results

    .venv/bin/python bench/xl/make_tasks.py [task ...]
"""
import json
import math
import os
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, ROOT)
from icdsl.canvas.check import run_script          # noqa: E402
from icdsl.canvas.tech import load                 # noqa: E402

PDKS = ["sky130A", "gf180mcuD", "freepdk45"]       # a task is left out on a PDK that lacks a device it needs
BUDGET = 2.0                                        # area budget = BUDGET x the reference area

TASKS = {
    "rca8": dict(
        title="8-bit ripple-carry adder", kind="lvs", probes="regular datapath, cell reuse, 2 rows",
        text="""An 8-bit ripple-carry adder made of eight identical 28-transistor mirror full adders.
Inputs A0..A7, B0..B7 and CIN; outputs S0..S7 and COUT; supplies VDD and VSS.
The netlist gives the full adder as a subcircuit `fa` and the top level `rca8` with eight instances
whose carries are chained (internal nets k1..k7). You may keep that hierarchy or flatten it."""),
    "dec4to16": dict(
        title="4-to-16 decoder", kind="lvs", probes="random logic, high fan-out nets, routing congestion",
        text="""A 4-to-16 line decoder: four input inverters, sixteen 4-input NAND gates and sixteen output
inverters. Inputs A0..A3, outputs Y0..Y15 (Yk is high when the inputs spell k), supplies VDD and VSS.
Each of the eight true / complemented address lines fans out to eight NAND gates."""),
    "shreg16": dict(
        title="16-bit shift register", kind="lvs", probes="sequential cells, clock distribution, serpentine chain",
        text="""Sixteen positive-edge D flip-flops in a chain. Each flip-flop (subcircuit `dff`, 22 transistors) is a
master-slave pair of clocked-inverter latches with a local clock buffer. Input D, clock CK, outputs
Q0..Q15 (Qi feeds the next stage), supplies VDD and VSS."""),
    "sram16x8": dict(
        title="16 x 8 array of 6T SRAM cells", kind="lvs", probes="dense array, shared word / bit lines, 768 transistors",
        text="""The core cell array of a small SRAM: 16 words of 8 bits, 128 six-transistor cells (subcircuit
`sram6t`: two cross-coupled inverters and two NMOS access transistors). Word lines WL0..WL15 run along the
rows, bit-line pairs BL0..BL7 / BLB0..BLB7 down the columns; supplies VDD and VSS. No decoder and no
sense amplifiers."""),
    "r2r8": dict(
        title="8-bit R-2R ladder", kind="lvs", needs=["res_poly"], probes="non-MOS devices (poly resistors), matching, guard ring",
        text="""An 8-bit R-2R resistor ladder built from 25 identical unit poly resistors (R = one unit, 2R = two
units in series). Bit inputs B0 (LSB)..B7 (MSB), output OUT, and VSS for the terminating 2R leg.
All unit resistors have the drawn W and L given in the netlist. Good practice, not judged: identical
orientation, one substrate guard ring tied to VSS around the array."""),
    "cdac6": dict(
        title="6-bit binary-weighted capacitor array", kind="lvs", needs=["cap_mim"], probes="MIM capacitors on the upper metals, unit-cell array",
        text="""The capacitor array of a 6-bit charge-redistribution DAC: 64 identical unit MIM capacitors that share
one top plate TOP. The bottom plates are grouped 32 / 16 / 8 / 4 / 2 / 1 units onto B5 (MSB)..B0 (LSB), and
the remaining unit goes to VSS. Good practice, not judged: the units of one bit are spread over the
array (interleaved), not clustered."""),
    "ota_miller": dict(
        title="two-stage Miller OTA", kind="lvs", probes="analog: mixed W/L, multi-finger devices, guard rings, R + C",
        text="""A two-stage Miller-compensated operational transconductance amplifier:
NMOS differential pair M1/M2 (inputs INN, INP), PMOS mirror load M3/M4, tail source M5, second stage
M6 (PMOS) with sink M7, bias diode M8 (pin IB), nulling resistor RZ (poly) in series with the Miller
capacitor CC (MIM) between the first-stage output and OUT. Supplies VDD and VSS.
Device sizes and finger counts are in the netlist (each finger is one line); NMOS bodies are VSS,
PMOS bodies (n-well) are VDD. Good practice, not judged: a p-tap guard ring around the NMOS devices
and an n-tap ring around the PMOS devices.
On a PDK that has no resistor and no MIM capacitor (freepdk45: MOS devices only) the compensation
network is made of transistors, as that PDK's netlist shows: RZ becomes M9, an NMOS in triode with its
gate at VDD, and CC becomes MC, an NMOS capacitor (gate OUT, source and drain joined)."""),
    "spiral": dict(
        title="octagonal spiral inductor", kind="spiral", probes="non-Manhattan geometry, top metal, underpass",
        spiral=dict(turns=3, width_um=4.0),
        text="""A planar octagonal spiral inductor on the top metal of the stack.
* at least 3 full turns, every edge horizontal, vertical or at 45 degrees (and some at 45 degrees);
* trace width at least 4.0 um everywhere (only a dead end of at most 4 um2 that sticks out of the
  trace, such as the pad of the via at the inner end, may be narrower);
* the inner end is brought out underneath the turns on the metal below the top metal (via + underpass)
  to outside the coil;
* all the metal is one net; label it `L`.
There is no netlist: the judge checks DRC and the geometry (one open coil without closed loops, the
number of turns counted from the centre, the width, the underpass)."""),
}

MD = """# {name} - {title}

{text}

**Top cell name:** `{name}`{pins}
**PDKs:** {pdks}. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
{rows}

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. {lvs}
3. The bounding box of the top cell is within the area budget ({budget:g} x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py {name} <pdk> <submission.gds | script.py | file.icl>
"""


def main():
    names = sys.argv[1:] or list(TASKS)
    summary = json.load(open(os.path.join(HERE, "reference.json"))) if os.path.exists(os.path.join(HERE, "reference.json")) else {}
    for name in names:
        spec = TASKS[name]
        tdir = os.path.join(HERE, "tasks", name)
        os.makedirs(tdir, exist_ok=True)
        meta = dict(name=name, top=name, title=spec["title"], kind=spec["kind"], probes=spec["probes"], pdks={})
        if "spiral" in spec:
            meta["spiral"] = spec["spiral"]
        rows = []
        pdks = [p for p in PDKS if all(d in load(p).d["devices"] for d in spec.get("needs", []))]
        for pdk in pdks:
            out = os.path.join(ROOT, "build", f"{name}.{pdk}")
            cell, rep = run_script(os.path.join(HERE, "ref", name + ".py"), pdk=pdk, out=out)
            if rep["status"] != "CLEAN":
                sys.exit(f"reference {name} is not clean on {pdk}: see {out}")
            lvs = rep.get("lvs") or {}
            entry = dict(ref_area_um2=rep["area_um2"], ref_size_um=rep["size_um"],
                         area_budget_um2=float(math.ceil(BUDGET * rep["area_um2"])),
                         devices=rep["devices_declared"], shapes=rep["shapes"], ref_seconds=rep["seconds"])
            if spec["kind"] == "lvs":
                shutil.copy(lvs["reference_spice"], os.path.join(tdir, pdk + ".spice"))
                entry["netlist"] = pdk + ".spice"
            meta["pdks"][pdk] = entry
            meta["pins"] = list(cell.port_order)
            rows.append(f"| {pdk} | {('`' + pdk + '.spice`') if spec['kind'] == 'lvs' else '-'} | "
                        f"{entry['area_budget_um2']:g} um2 | {rep['size_um'][0]:g} x {rep['size_um'][1]:g} um |")
            print(f"{name:11s} {pdk:10s} CLEAN  {rep['devices_declared']:4d} devices  {rep['area_um2']:9.1f} um2  {rep['seconds']} s")
        json.dump(meta, open(os.path.join(tdir, "task.json"), "w"), indent=1)
        open(os.path.join(tdir, "task.md"), "w").write(MD.format(
            name=name, title=spec["title"], text=spec["text"].strip(), pdks=", ".join(pdks), rows="\n".join(rows),
            pins=("\n**Pins:** " + " ".join(meta["pins"])) if spec["kind"] == "lvs" else "",
            budget=BUDGET,
            lvs=("netgen LVS of the extracted layout against the task netlist matches: same devices, same "
                 "W / L, same connectivity, same pin names (hierarchy is free, internal net names are free)."
                 if spec["kind"] == "lvs" else "The geometry checks listed above pass.")))
        summary[name] = meta
    json.dump(summary, open(os.path.join(HERE, "reference.json"), "w"), indent=1)
    o = ["# XL benchmark - reference results", "",
         "Every reference is one PDK-neutral canvas script (`ref/<task>.py`) run unchanged on each PDK;",
         "all are clean under magic `drc(full)`, the PDK's KLayout DRC deck and netgen LVS. `-`: the PDK has",
         "no such device (freepdk45 has MOS devices only). Regenerate with `make_tasks.py`.", "",
         "| task | what it probes | devices | " + " | ".join(f"{p} area (um2) / time" for p in PDKS) + " |",
         "|---|---|---|" + "---|" * len(PDKS)]
    for name in TASKS:
        if name in summary:
            m = summary[name]
            o.append(f"| `{name}` {m['title']} | {m['probes']} | {m['pdks'][PDKS[0]]['devices']} | "
                     + " | ".join(f"{m['pdks'][p]['ref_area_um2']:g} / {m['pdks'][p]['ref_seconds']} s"
                                  if p in m["pdks"] else "-" for p in PDKS) + " |")
    open(os.path.join(HERE, "REFERENCE.md"), "w").write("\n".join(o) + "\n")


if __name__ == "__main__":
    main()
