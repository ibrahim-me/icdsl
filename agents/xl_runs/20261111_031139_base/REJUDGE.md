Replies with more than one code block where the run judged the longest block and the model's last
whole file is a different one. The last file was judged afterwards (same sandbox, same judge).

| interface | task | PDK | attempt | judged in the run (longest block) | the reply's last whole file | case as run |
|---|---|---|---|---|---|---|
| canvas | cdac6 | gf180mcuD | 1 | 88 lines: no build | 70 lines: no build | solved |
| canvas | dec4to16 | freepdk45 | 1 | 82 lines: no build | 76 lines: no build | not solved |
| canvas | ota_miller | freepdk45 | 1 | 205 lines: no build | 117 lines: no build | not solved |
| canvas | ota_miller | sky130A | 2 | 130 lines: no build | 24 lines: fails DRC, DRC2, LVS, pins | not solved |
| canvas | r2r8 | sky130A | 1 | 101 lines: no build | 79 lines: no build | not solved |
| canvas | rca8 | gf180mcuD | 1 | 177 lines: no build | 153 lines: no build | not solved |
| canvas | rca8 | sky130A | 1 | 205 lines: no build | 184 lines: no build | not solved |
| canvas | shreg16 | freepdk45 | 1 | 223 lines: no build | 177 lines: no build | not solved |
| canvas | shreg16 | sky130A | 1 | 177 lines: no build | 162 lines: no build | not solved |
| canvas | spiral | gf180mcuD | 1 | 103 lines: no build | 81 lines: no build | not solved |
| canvas | spiral | sky130A | 1 | 34 lines: fails DRC, DRC2, one coil, no closed loop, at least 3 turns around the centre | 33 lines: fails DRC, DRC2, one coil, no closed loop, at least 3 turns around the centre | not solved |
| raw | dec4to16 | gf180mcuD | 1 | 247 lines: no build | 207 lines: fails DRC, DRC2, LVS, pins, area | not solved |
| raw | rca8 | sky130A | 1 | 353 lines: no build | 346 lines: fails DRC, DRC2, LVS, pins, area | not solved |
| raw | shreg16 | freepdk45 | 1 | 307 lines: fails DRC, DRC2, LVS, pins, area | 307 lines: fails DRC, DRC2, LVS, pins, area | not solved |
| raw | sram16x8 | freepdk45 | 1 | 67 lines: no build | 51 lines: no build | not solved |

15 replies. Cases not solved in the run whose last file is judged solved: 0
