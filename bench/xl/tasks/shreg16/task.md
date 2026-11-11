# shreg16 - 16-bit shift register

Sixteen positive-edge D flip-flops in a chain. Each flip-flop (subcircuit `dff`, 22 transistors) is a
master-slave pair of clocked-inverter latches with a local clock buffer. Input D, clock CK, outputs
Q0..Q15 (Qi feeds the next stage), supplies VDD and VSS.

**Top cell name:** `shreg16`
**Pins:** VSS VDD D Q11 Q15 Q3 Q7 Q0 Q1 Q10 Q12 Q13 Q14 Q2 Q4 Q5 Q6 Q8 Q9 CK
**PDKs:** sky130A, gf180mcuD, freepdk45. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 1857 um2 | 39.44 x 23.53 um |
| gf180mcuD | `gf180mcuD.spice` | 3299 um2 | 56.72 x 29.08 um |
| freepdk45 | `freepdk45.spice` | 261 um2 | 16.88 x 7.715 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py shreg16 <pdk> <submission.gds | script.py | file.icl>
