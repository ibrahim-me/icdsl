model nvidia/nemotron-3.5-super-vl:free, up to 4 attempts per case

| task | PDK | canvas |
|---|---|---|
| cdac6 | gf180mcuD | **solved** (attempt 1) |
| cdac6 | sky130A | built; fails DRC, LVS, pins (517 DRC) |
| dec4to16 | freepdk45 | **solved** (attempt 1) |
| dec4to16 | gf180mcuD | **solved** (attempt 1) |
| dec4to16 | sky130A | **solved** (attempt 1) |
| ota_miller | freepdk45 | **solved** (attempt 1) |
| ota_miller | gf180mcuD | **solved** (attempt 1) |
| ota_miller | sky130A | **solved** (attempt 1) |
| r2r8 | gf180mcuD | built; fails DRC, DRC2, LVS, pins (690 DRC) |
| r2r8 | sky130A | built; fails LVS, pins |
| rca8 | freepdk45 | **solved** (attempt 1) |
| rca8 | gf180mcuD | **solved** (attempt 1) |
| rca8 | sky130A | **solved** (attempt 1) |
| shreg16 | freepdk45 | **solved** (attempt 1) |
| shreg16 | gf180mcuD | **solved** (attempt 1) |
| shreg16 | sky130A | **solved** (attempt 1) |
| spiral | freepdk45 | built; fails edges Manhattan or 45 degrees, some at 45, trace width >= 4.0 um, underpass from the inner end to outside the coil |
| spiral | gf180mcuD | built; fails DRC2, edges Manhattan or 45 degrees, some at 45 (6 DRC) |
| spiral | sky130A | **solved** (attempt 4) |
| sram16x8 | freepdk45 | **solved** (attempt 1) |
| sram16x8 | gf180mcuD | **solved** (attempt 2) |
| sram16x8 | sky130A | no build |

canvas: solved 16/22, built 21/22, model calls 44
