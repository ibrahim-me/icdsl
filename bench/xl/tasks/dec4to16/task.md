# dec4to16 - 4-to-16 decoder

A 4-to-16 line decoder: four input inverters, sixteen 4-input NAND gates and sixteen output
inverters. Inputs A0..A3, outputs Y0..Y15 (Yk is high when the inputs spell k), supplies VDD and VSS.
Each of the eight true / complemented address lines fans out to eight NAND gates.

**Top cell name:** `dec4to16`
**Pins:** VSS VDD Y0 Y1 Y10 Y11 Y12 Y13 Y14 Y15 Y2 Y3 Y4 Y5 Y6 Y7 Y8 Y9 A0 A1 A2 A3
**PDKs:** sky130A, gf180mcuD, freepdk45. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 816 um2 | 21.76 x 18.73 um |
| gf180mcuD | `gf180mcuD.spice` | 1398 um2 | 31.24 x 22.36 um |
| freepdk45 | `freepdk45.spice` | 127 um2 | 9.6 x 6.58 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py dec4to16 <pdk> <submission.gds | script.py | file.icl>
