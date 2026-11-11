# sram16x8 - 16 x 8 array of 6T SRAM cells

The core cell array of a small SRAM: 16 words of 8 bits, 128 six-transistor cells (subcircuit
`sram6t`: two cross-coupled inverters and two NMOS access transistors). Word lines WL0..WL15 run along the
rows, bit-line pairs BL0..BL7 / BLB0..BLB7 down the columns; supplies VDD and VSS. No decoder and no
sense amplifiers.

**Top cell name:** `sram16x8`
**Pins:** VSS VDD BL0 BL1 BL2 BL3 BL4 BL5 BL6 BL7 BLB0 BLB1 BLB2 BLB3 BLB4 BLB5 BLB6 BLB7 WL0 WL1 WL10 WL11 WL12 WL13 WL14 WL15 WL2 WL3 WL4 WL5 WL6 WL7 WL8 WL9
**PDKs:** sky130A, gf180mcuD, freepdk45. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 4210 um2 | 28.56 x 73.69 um |
| gf180mcuD | `gf180mcuD.spice` | 7253 um2 | 41.04 x 88.36 um |
| freepdk45 | `freepdk45.spice` | 592 um2 | 12.4 x 23.855 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py sram16x8 <pdk> <submission.gds | script.py | file.icl>
