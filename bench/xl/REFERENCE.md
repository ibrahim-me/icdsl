# XL benchmark - reference results

Every reference is one PDK-neutral canvas script (`ref/<task>.py`) run unchanged on each PDK;
all are clean under magic `drc(full)`, the PDK's KLayout DRC deck and netgen LVS. `-`: the PDK has
no such device (freepdk45 has MOS devices only). Regenerate with `make_tasks.py`.

| task | what it probes | devices | sky130A area (um2) / time | gf180mcuD area (um2) / time | freepdk45 area (um2) / time |
|---|---|---|---|---|---|
| `rca8` 8-bit ripple-carry adder | regular datapath, cell reuse, 2 rows | 224 | 573.12 / 6.4 s | 1022.63 / 8.9 s | 80.02 / 4.7 s |
| `dec4to16` 4-to-16 decoder | random logic, high fan-out nets, routing congestion | 168 | 407.56 / 7.2 s | 698.53 / 8.2 s | 63.17 / 4.5 s |
| `shreg16` 16-bit shift register | sequential cells, clock distribution, serpentine chain | 352 | 928.02 / 5.7 s | 1649.42 / 8.8 s | 130.23 / 4.3 s |
| `sram16x8` 16 x 8 array of 6T SRAM cells | dense array, shared word / bit lines, 768 transistors | 768 | 2104.59 / 7.3 s | 3626.29 / 16.1 s | 295.8 / 5.5 s |
| `r2r8` 8-bit R-2R ladder | non-MOS devices (poly resistors), matching, guard ring | 25 | 814.74 / 4.9 s | 852.06 / 6.9 s | - |
| `cdac6` 6-bit binary-weighted capacitor array | MIM capacitors on the upper metals, unit-cell array | 64 | 4255.26 / 5.6 s | 5288.9 / 8.3 s | - |
| `ota_miller` two-stage Miller OTA | analog: mixed W/L, multi-finger devices, guard rings, R + C | 32 | 1323.89 / 5.2 s | 1450.07 / 7.2 s | 379.92 / 4.5 s |
| `spiral` octagonal spiral inductor | non-Manhattan geometry, top metal, underpass | 0 | 5232.32 / 5.5 s | 5232.32 / 8.2 s | 5232.32 / 3.4 s |
