#!/usr/bin/env bash
# gallery/ = GDS and PNG of the 22 reference layouts, copied from build/ (bash tests/run_canvas.sh builds them).
cd "$(dirname "${BASH_SOURCE[0]}")/../.." && mkdir -p bench/xl/gallery
for t in rca8 dec4to16 shreg16 sram16x8 r2r8 cdac6 ota_miller spiral; do
  for p in sky130A gf180mcuD freepdk45; do
    [ -f "build/$t.$p/$t.gds" ] && cp "build/$t.$p/$t.gds" "bench/xl/gallery/$t.$p.gds" && cp "build/$t.$p/$t.png" "bench/xl/gallery/$t.$p.png"
  done
done
ls bench/xl/gallery/*.gds | wc -l
