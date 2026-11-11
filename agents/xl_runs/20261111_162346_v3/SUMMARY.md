model nvidia/nemotron-3.5-super-vl:free, up to 4 attempts per case

| task | PDK | canvas |
|---|---|---|
| cdac6 | gf180mcuD | built; fails LVS, pins |
| cdac6 | sky130A | built; fails LVS, pins |
| ota_miller | freepdk45 | **solved** (attempt 1) |
| ota_miller | gf180mcuD | **solved** (attempt 1) |
| ota_miller | sky130A | **solved** (attempt 1) |
| r2r8 | gf180mcuD | no build |
| r2r8 | sky130A | built; fails DRC, DRC2, LVS, pins (604 DRC) |
| sram16x8 | freepdk45 | built; fails DRC, DRC2, LVS, pins (3313 DRC) |
| sram16x8 | gf180mcuD | **solved** (attempt 1) |
| sram16x8 | sky130A | no build |

canvas: solved 4/10, built 8/10, model calls 28
