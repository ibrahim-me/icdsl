model nvidia/nemotron-3.5-super-vl:free, up to 4 attempts per case

| task | PDK | canvas |
|---|---|---|
| cdac6 | gf180mcuD | **solved** (attempt 3) |
| cdac6 | sky130A | **solved** (attempt 2) |
| dec4to16 | freepdk45 | **solved** (attempt 1) |
| dec4to16 | gf180mcuD | **solved** (attempt 1) |
| dec4to16 | sky130A | **solved** (attempt 1) |
| ota_miller | freepdk45 | **solved** (attempt 1) |
| ota_miller | gf180mcuD | **solved** (attempt 1) |
| ota_miller | sky130A | **solved** (attempt 1) |
| r2r8 | gf180mcuD | no build |
| r2r8 | sky130A | no build |
| rca8 | freepdk45 | **solved** (attempt 1) |
| rca8 | gf180mcuD | **solved** (attempt 1) |
| rca8 | sky130A | **solved** (attempt 1) |
| shreg16 | freepdk45 | **solved** (attempt 1) |
| shreg16 | gf180mcuD | **solved** (attempt 1) |
| shreg16 | sky130A | **solved** (attempt 1) |
| spiral | freepdk45 | built; fails edges Manhattan or 45 degrees, some at 45, area |
| spiral | gf180mcuD | built; fails trace width >= 4.0 um |
| spiral | sky130A | built; fails area |
| sram16x8 | freepdk45 | built; fails DRC, DRC2, LVS, pins, area (35016 DRC) |
| sram16x8 | gf180mcuD | **solved** (attempt 1) |
| sram16x8 | sky130A | no build |

canvas: solved 15/22, built 19/22, model calls 46
