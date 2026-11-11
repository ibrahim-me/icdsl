# Task: analog cell `folded_cascode`

Function: folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current sinks, NMOS cascodes, PMOS cascoded mirror load
Write the layout to `/folded_cascode.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell folded_cascode`):
```icl
pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP in side=left
  port INN in side=right
  port VBP in side=top
  port VBN in side=bottom
  port VCN in side=left
  port VCP in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  pmos MT w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1 w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2 w=W l=L nf=2 d=f2 g=INN s=tail
  nmos M3 w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4 w=W l=L nf=2 d=f2 g=VBN s=VGND
  nmos M5 w=W l=L nf=2 d=x g=VCN s=f1
  nmos M6 w=W l=L nf=2 d=OUT g=VCN s=f2
  pmos M7 w=W l=L nf=2 d=y g=x s=VPWR
  pmos M8 w=W l=L nf=2 d=z g=x s=VPWR
  pmos M9 w=W l=L nf=2 d=x g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. M1, M2 on a common centroid: the centroids of their fingers coincide
  2. M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  3. M5 and M6 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  4. M7 and M8 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  5. M9 and M10 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  6. routed wires of OUT and INP at least 0.5 um apart
  7. routed wires of OUT and INN at least 0.5 um apart
Checked at the nominal parameters, then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.
