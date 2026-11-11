# rca8 - 8-bit ripple-carry adder

An 8-bit ripple-carry adder made of eight identical 28-transistor mirror full adders.
Inputs A0..A7, B0..B7 and CIN; outputs S0..S7 and COUT; supplies VDD and VSS.
The netlist gives the full adder as a subcircuit `fa` and the top level `rca8` with eight instances
whose carries are chained (internal nets k1..k7). You may keep that hierarchy or flatten it.

**Top cell name:** `rca8`
**Pins:** VSS VDD A0 A1 A2 A3 A4 A5 A6 A7 B0 B1 B2 B3 B4 B5 B6 B7 CIN COUT S0 S1 S2 S3 S4 S5 S6 S7
**PDKs:** sky130A, gf180mcuD, freepdk45. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 1147 um2 | 44.88 x 12.77 um |
| gf180mcuD | `gf180mcuD.spice` | 2046 um2 | 64.56 x 15.84 um |
| freepdk45 | `freepdk45.spice` | 161 um2 | 19.12 x 4.185 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py rca8 <pdk> <submission.gds | script.py | file.icl>
