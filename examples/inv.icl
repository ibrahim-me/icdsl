# CMOS inverter
pdk sky130A

cell inv
  port A    in
  port Y    out
  port VPWR power
  port VGND ground

  nmos MN w=0.65 l=0.15 d=Y g=A s=VGND
  pmos MP w=1.00 l=0.15 d=Y g=A s=VPWR

  row MN          # rows are listed bottom -> top
  row MP
end
