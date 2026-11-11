Lay out the analog cell `diff_stage`: fully differential stage: NMOS pair, PMOS current-source loads, NMOS tail - drawn mirror-symmetric with guard rings.
```icl
pdk sky130A
param W=1.0 L=0.3

cell diff_stage
  port INP in side=left
  port INN in side=right
  port VBN in side=bottom
  port VBP in side=top
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  pmos M3 w=W l=L nf=2 d=OUTN g=VBP s=VPWR
  pmos M4 w=W l=L nf=2 d=OUTP g=VBP s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry):
  1. mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4
  2. the routing of OUTP is the mirror image of the routing of OUTN
  3. a closed ptap guard ring around M1, M2, MT
  4. a closed ntap guard ring around M3, M4
It is checked at the nominal parameters and then at: W=1.0, L=0.6; W=1.0, L=0.15; W=2.0, L=0.3.

Verified example `mirror4` (4-way NMOS mirror bank (reference + 3 outputs) on one 2-D common centroid inside a ptap guard ring; constraints: M0, M1, M2, M3 on a common centroid: the centroids of their fingers coincide; a closed ptap guard ring around M0, M1, M2, M3) - clean over the whole sweep:
```icl
# 4-way NMOS mirror bank: 2-D common centroid ABCD/DCBA in a ptap guard ring
pdk sky130A
param W=1.0 L=1.0

cell mirror4
  port IREF in  side=left
  port I1   out side=right
  port I2   out side=right
  port I3   out side=right
  port VGND ground

  nmos M0 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M1 w=W l=L nf=2 d=I1   g=IREF s=VGND
  nmos M2 w=W l=L nf=2 d=I2   g=IREF s=VGND
  nmos M3 w=W l=L nf=2 d=I3   g=IREF s=VGND

  common_centroid M0 M1 M2 M3 pattern=ABCD/DCBA dummies=1 name=CM
  place CM at=(0, 0)
  guardring GR around=[CM] kind=ptap net=VGND
end
```

Verified example `cascode_n` (NMOS cascode current mirror (M1/M2 bottom pair, M3/M4 cascodes); constraints: M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)) - clean over the whole sweep:
```icl
# NMOS cascode current mirror: both pairs interdigitated ABBA, cascodes stacked above
pdk sky130A
param W=1.0 L=0.5

cell cascode_n
  port IREF in  side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=n1   g=n1   s=VGND
  nmos M2 w=W l=L nf=2 d=n2   g=n1   s=VGND
  nmos M3 w=W l=L nf=2 d=IREF g=IREF s=n1
  nmos M4 w=W l=L nf=2 d=IOUT g=IREF s=n2

  interdigitate M1 M2 pattern=ABBA dummies=1 name=BOT
  interdigitate M3 M4 pattern=ABBA dummies=1 name=TOP
  tap TP kind=ptap net=VGND cols=6
  place TP at=(0, 0)
  place BOT above=TP align=center
  place TOP above=BOT align=center gap=0.6
end
```