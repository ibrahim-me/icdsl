model nvidia/nemotron-3.5-super-vl:free, up to 4 attempts per case

| task | PDK | canvas |
|---|---|---|
| cdac6 | gf180mcuD | built; fails DRC, DRC2, LVS, pins (36 DRC) |
| cdac6 | sky130A | built; fails DRC (942 DRC) |
| dec4to16 | freepdk45 | **solved** (attempt 1) |
| dec4to16 | gf180mcuD | **solved** (attempt 1) |
| dec4to16 | sky130A | **solved** (attempt 1) |
| ota_miller | freepdk45 | built; fails DRC, DRC2, LVS, pins, area (324 DRC) |
| ota_miller | gf180mcuD | no build |
| ota_miller | sky130A | built; fails DRC, DRC2, LVS, pins (744 DRC) |
| r2r8 | gf180mcuD | built; fails DRC2, LVS, pins (22 DRC) |
| r2r8 | sky130A | built; fails DRC, DRC2, LVS, pins (54 DRC) |
| rca8 | freepdk45 | **solved** (attempt 1) |
| rca8 | gf180mcuD | **solved** (attempt 1) |
| rca8 | sky130A | **solved** (attempt 1) |
| shreg16 | freepdk45 | **solved** (attempt 1) |
| shreg16 | gf180mcuD | **solved** (attempt 1) |
| shreg16 | sky130A | **solved** (attempt 1) |
| spiral | freepdk45 | built; fails underpass from the inner end to outside the coil, area |
| spiral | gf180mcuD | built; fails area |
| spiral | sky130A | **solved** (attempt 3) |
| sram16x8 | freepdk45 | **solved** (attempt 1) |
| sram16x8 | gf180mcuD | built; fails DRC, DRC2, LVS, pins, area (21152 DRC) |
| sram16x8 | sky130A | **solved** (attempt 1) |

canvas: solved 12/22, built 21/22, model calls 54
