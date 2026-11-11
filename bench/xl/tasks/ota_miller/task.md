# ota_miller - two-stage Miller OTA

A two-stage Miller-compensated operational transconductance amplifier:
NMOS differential pair M1/M2 (inputs INN, INP), PMOS mirror load M3/M4, tail source M5, second stage
M6 (PMOS) with sink M7, bias diode M8 (pin IB), nulling resistor RZ (poly) in series with the Miller
capacitor CC (MIM) between the first-stage output and OUT. Supplies VDD and VSS.
Device sizes and finger counts are in the netlist (each finger is one line); NMOS bodies are VSS,
PMOS bodies (n-well) are VDD. Good practice, not judged: a p-tap guard ring around the NMOS devices
and an n-tap ring around the PMOS devices.
On a PDK that has no resistor and no MIM capacitor (freepdk45: MOS devices only) the compensation
network is made of transistors, as that PDK's netlist shows: RZ becomes M9, an NMOS in triode with its
gate at VDD, and CC becomes MC, an NMOS capacitor (gate OUT, source and drain joined).

**Top cell name:** `ota_miller`
**Pins:** INP INN OUT IB VDD VSS
**PDKs:** sky130A, gf180mcuD, freepdk45. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | `sky130A.spice` | 2648 um2 | 60.715 x 21.805 um |
| gf180mcuD | `gf180mcuD.spice` | 2901 um2 | 64.88 x 22.35 um |
| freepdk45 | `freepdk45.spice` | 760 um2 | 21.095 x 18.01 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. netgen LVS of the extracted layout against the task netlist matches: same devices, same W / L, same connectivity, same pin names (hierarchy is free, internal net names are free).
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py ota_miller <pdk> <submission.gds | script.py | file.icl>
