# cdac6 - 6-bit binary-weighted capacitor array

The capacitor array of a 6-bit charge-redistribution DAC: 64 identical unit MIM capacitors that share
one top plate TOP. The bottom plates are grouped 32 / 16 / 8 / 4 / 2 / 1 units onto B5 (MSB)..B0 (LSB), and
the remaining unit goes to VSS. Good practice, not judged: the units of one bit are spread over the
array (interleaved), not clustered.

**Top cell name:** `cdac6`
**Pins:** TOP B0 B1 B2 B3 VSS B4 B5
**PDKs:** sky130A, gf180mcuD. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 8511 um2 | 66.24 x 64.24 um |
| gf180mcuD | `gf180mcuD.spice` | 10578 um2 | 73.6 x 71.86 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py cdac6 <pdk> <submission.gds | script.py | file.icl>
