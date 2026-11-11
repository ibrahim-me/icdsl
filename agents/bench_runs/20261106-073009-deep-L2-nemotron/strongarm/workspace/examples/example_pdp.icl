# Worked example: PMOS differential pair with a PMOS tail (not part of the benchmark)
pdk sky130A
param W=1.0 L=0.5

cell pdp
  port INP  in  side=left
  port INN  in  side=right
  port VBP  in  side=top
  port OUTP out side=bottom
  port OUTN out side=bottom
  port VPWR power

  pmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail       # w is PER FINGER, nf = number of fingers
  pmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  pmos MT w=W l=L nf=4 d=tail g=VBP s=VPWR

  # matching: 2x2 common centroid (rows separated by '/'), one dummy finger at each row end
  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  place MT at=(0, 0)
  place DP below=MT align=center gap=0.6          # gap=min (default) = closest legal spacing
  guardring GN around=[MT, DP] kind=ntap net=VPWR  # pmos bodies: n-well tied to VPWR by an n-tap ring

  route tail width=0.4                             # wide tail
  route OUTP width=0.2 avoid=INP:0.5,INN:0.5       # outputs kept 0.5 um away from the inputs
  route OUTN width=0.2 avoid=INP:0.5,INN:0.5
end
