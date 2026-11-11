model nvidia/nemotron-3.5-super-vl:free, up to 4 attempts per case

| task | PDK | canvas | icl | raw |
|---|---|---|---|---|
| cdac6 | gf180mcuD | **solved** (attempt 3) | - | built; fails DRC2, LVS, pins, area (440 DRC) |
| cdac6 | sky130A | built; fails DRC, DRC2, LVS, pins (768 DRC) | - | built; fails LVS, pins, area |
| dec4to16 | freepdk45 | built; fails DRC, DRC2, LVS, pins (427 DRC) | - | no build |
| dec4to16 | gf180mcuD | no build | - | built; fails DRC, DRC2, LVS, pins (3373 DRC) |
| dec4to16 | sky130A | no build | no build | built; fails DRC, DRC2, LVS, pins, area (3594 DRC) |
| ota_miller | freepdk45 | built; fails DRC, DRC2, LVS, pins (37858 DRC) | - | built; fails DRC, DRC2, LVS, pins, area (493 DRC) |
| ota_miller | gf180mcuD | no build | - | built; fails DRC, DRC2, LVS, pins (1132 DRC) |
| ota_miller | sky130A | built; fails DRC, DRC2, LVS, pins (3305 DRC) | - | built; fails DRC, DRC2, LVS, pins, area (10602 DRC) |
| r2r8 | gf180mcuD | built; fails DRC, DRC2, LVS, pins (82 DRC) | - | built; fails DRC, DRC2, LVS, pins, area (1845 DRC) |
| r2r8 | sky130A | built; fails DRC, DRC2, LVS, pins (271 DRC) | - | built; fails DRC, DRC2, LVS, pins (2144 DRC) |
| rca8 | freepdk45 | built; fails DRC, DRC2, LVS, pins, area (257 DRC) | - | built; fails DRC, DRC2, LVS, pins (1240 DRC) |
| rca8 | gf180mcuD | built; fails DRC, DRC2, LVS, pins (4279 DRC) | - | built; fails DRC, DRC2, LVS, pins, area (12961 DRC) |
| rca8 | sky130A | built; fails DRC, DRC2, LVS, pins, area (15416 DRC) | **solved** (attempt 1) | built; fails DRC, DRC2, LVS, pins, area (12425 DRC) |
| shreg16 | freepdk45 | built; fails DRC, DRC2, LVS, pins, area (144 DRC) | - | built; fails DRC, DRC2, LVS, pins (4826 DRC) |
| shreg16 | gf180mcuD | no build | - | built; fails DRC, DRC2, LVS, pins (11852 DRC) |
| shreg16 | sky130A | built; fails DRC, DRC2, LVS, pins, area (1133 DRC) | **solved** (attempt 4) | built; fails DRC, DRC2, LVS, pins, area (18656 DRC) |
| spiral | freepdk45 | built; fails DRC, DRC2, one coil, no closed loop, at least 3 turns around the centre (17 DRC) | - | built; fails DRC, DRC2, edges Manhattan or 45 degrees, some at 45, trace width >= 4.0 um (7 DRC) |
| spiral | gf180mcuD | built; fails trace width >= 4.0 um, area | - | built; fails DRC, DRC2, edges Manhattan or 45 degrees, some at 45, at least 3 turns around the centre, underpass from the inner end to outside the coil, area (4 DRC) |
| spiral | sky130A | built; fails trace width >= 4.0 um | - | built; fails DRC, DRC2, one coil, no closed loop, trace width >= 4.0 um, area (120 DRC) |
| sram16x8 | freepdk45 | built; fails DRC, DRC2, LVS, pins (1768 DRC) | - | built; fails DRC, DRC2, LVS, pins, area |
| sram16x8 | gf180mcuD | built; fails DRC, DRC2, LVS, pins (26880 DRC) | - | built; fails DRC, DRC2, LVS, pins (39760 DRC) |
| sram16x8 | sky130A | built; fails DRC, DRC2, LVS, pins, area (61157 DRC) | no build | built; fails DRC, DRC2, LVS, pins (15838 DRC) |

canvas: solved 1/22, built 18/22, model calls 87
icl: solved 2/4, built 2/4, model calls 13
raw: solved 0/22, built 21/22, model calls 88
