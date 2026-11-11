# r2r8 - 8-bit R-2R ladder

An 8-bit R-2R resistor ladder built from 25 identical unit poly resistors (R = one unit, 2R = two
units in series). Bit inputs B0 (LSB)..B7 (MSB), output OUT, and VSS for the terminating 2R leg.
All unit resistors have the drawn W and L given in the netlist. Good practice, not judged: identical
orientation, one substrate guard ring tied to VSS around the array.

**Top cell name:** `r2r8`
**Pins:** B0 B1 B2 B3 B4 B5 B6 B7 OUT VSS
**PDKs:** sky130A, gf180mcuD. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 1630 um2 | 77.08 x 10.57 um |
| gf180mcuD | `gf180mcuD.spice` | 1705 um2 | 77.04 x 11.06 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py r2r8 <pdk> <submission.gds | script.py | file.icl>
