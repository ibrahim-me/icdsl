# 5-stage ring oscillator built hierarchically from an inverter cell
pdk sky130A

cell inv_m1
  port A    in
  port Y    out
  port VPWR power
  port VGND ground
  nmos MN w=0.65 l=0.15 d=Y g=A s=VGND
  pmos MP w=1.00 l=0.15 d=Y g=A s=VPWR
  row MN
  row MP
  route * layers=m1        # keep met2 free so the parent can route over this cell
end

cell ring5
  port OUT  out
  port VPWR power
  port VGND ground
  inst X1 inv_m1 A=OUT Y=n1
  inst X2 inv_m1 A=n1  Y=n2
  inst X3 inv_m1 A=n2  Y=n3
  inst X4 inv_m1 A=n3  Y=n4
  inst X5 inv_m1 A=n4  Y=OUT
  row X1 X2 X3 X4 X5       # abutted, shared rails
end
