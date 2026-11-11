# 2-input NAND: series nmos stack, parallel pmos
pdk sky130A

cell nand2
  port A    in
  port B    in
  port Y    out
  port VPWR power
  port VGND ground

  nmos MNA w=0.65 l=0.15 d=Y  g=A s=n1     # n1 = internal stack node
  nmos MNB w=0.65 l=0.15 d=n1 g=B s=VGND
  pmos MPA w=1.00 l=0.15 d=Y  g=A s=VPWR
  pmos MPB w=1.00 l=0.15 d=Y  g=B s=VPWR

  row MNA MNB
  row MPA MPB
end
