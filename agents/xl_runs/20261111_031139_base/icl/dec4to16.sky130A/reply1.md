```icl
pdk sky130A

# ------------------------------------------------------------------
# Level-1 standard cells: inverter and 4-input NAND
# ------------------------------------------------------------------

stdcell inv width=4 height=2.72
  # n-well for the pmos
  nwell = rect nwell w=1.40 h=2.00 x=0.60 y=0.36

  # pmos active (inside n-well)
  pa = rect active w=0.80 h=0.55 x=0.60 y=0.60 net=VDD
  psel = rect pselect enclose=pa by=0.10

  # nmos active
  na = rect active w=0.42 h=0.55 x=0.40 y=0.60 net=VSS
  nsel = rect nselect enclose=na by=0.10

  # shared poly gate
  g = cross [pa, na] poly w=0.15 x=1.00

  # gate contact
  gc = contact li in=g x=1.00 y=0.90

  # pmos source/drain contacts
  ps = contact mcon in=pa x=0.60 y=0.85
  pd = contact mcon in=pa x=1.40 y=0.85

  # nmos source/drain contacts
  ns = contact mcon in=na x=0.40 y=0.85
  nd = contact mcon in=na x=0.82 y=0.85

  # metal1 rails
  vss_rail = rect m1 w=1.84 h=0.20 x=0 y=0.10 net=VSS
  vdd_rail = rect m1 w=1.84 h=0.20 x=0 y=2.42 net=VDD

  # output metal1 segment
  out_m1 = rect m1 w=0.30 h=0.20 x=1.10 y=1.30 net=Y

  # vias to metal2 for pin access
  via_a = contact via in=gc x=1.00 y=0.90
  via_y = contact via in=out_m1 x=1.25 y=1.40

  # devices for LVS
  device Mn0 nmos w=0.42 l=0.15 d=Y g=A s=VSS
  device Mp0 pmos w=0.84 l=0.15 d=Y g=A s=VDD

  # nets
  net VSS vss_rail ns nd
  net VDD vdd_rail ps pd
  net A   gc
  net Y   out_m1 via_y

  # ports
  port VSS in on=vss_rail layer=m1 side=bottom
  port VDD in on=vdd_rail layer=m1 side=top
  port A   in on=via_a layer=m2 side=left
  port Y   out on=via_y layer=m2 side=right
end

stdcell nand4 width=8 height=2.72
  # n-well for the pmos array
  nwell = rect nwell w=5.60 h=2.00 x=1.20 y=0.36

  # nmos series chain (4 devices)
  na0 = rect active w=0.42 h=0.55 x=0.40 y=0.60 net=VSS
  na1 = rect active w=0.42 h=0.55 x=0.90 y=0.60 net=x1
  na2 = rect active w=0.42 h=0.55 x=1.40 y=0.60 net=x2
  na3 = rect active w=0.42 h=0.55 x=1.90 y=0.60 net=x3
  nsel = rect nselect enclose=[na0,na1,na2,na3] by=0.10

  # pmos parallel array (4 devices, shared VDD and Y rails)
  pa0 = rect active w=0.84 h=0.55 x=2.60 y=0.60 net=VDD
  pa1 = rect active w=0.84 h=0.55 x=3.60 y=0.60 net=VDD
  pa2 = rect active w=0.84 h=0.55 x=4.60 y=0.60 net=VDD
  pa3 = rect active w=0.84 h=0.55 x=5.60 y=0.60 net=VDD
  psel = rect pselect enclose=[pa0,pa1,pa2,pa3] by=0.10

  # poly gates for the four inputs
  g0 = cross [na0, pa0] poly w=0.15 x=0.61
  g1 = cross [na1, pa1] poly w=0.15 x=1.11
  g2 = cross [na2, pa2] poly w=0.15 x=1.61
  g3 = cross [na3, pa3] poly w=0.15 x=2.11

  # gate contacts
  gc0 = contact li in=g0 x=0.61 y=0.90
  gc1 = contact li in=g1 x=1.11 y=0.90
  gc2 = contact li in=g2 x=1.61 y=0.90
  gc3 = contact li in=g3 x=2.11 y=0.90

  # nmos source/drain contacts
  ns0 = contact mcon in=na0 x=0.40 y=0.85
  nd0 = contact mcon in=na0 x=0.82 y=0.85
  ns1 = contact mcon in=na1 x=0.90 y=0.85
  nd1 = contact mcon in=na1 x=1.32 y=0.85
  ns2 = contact mcon in=na2 x=1.40 y=0.85
  nd2 = contact mcon in=na2 x=1.82 y=0.85
  ns3 = contact mcon in=na3 x=1.90 y=0.85
  nd3 = contact mcon in=na3 x=2.32 y=0.85

  # pmos source/drain contacts (all sources to VDD, drains to Y)
  ps0 = contact mcon in=pa0 x=2.60 y=0.85
  pd0 = contact mcon in=pa0 x=3.44 y=0.85
  ps1 = contact mcon in=pa1 x=3.60 y=0.85
  pd1 = contact mcon in=pa1 x=4.44 y=0.85
  ps2 = contact mcon in=pa2 x=4.60 y=0.85
  pd2 = contact mcon in=pa2 x=5.44 y=0.85
  ps3 = contact mcon in=pa3 x=5.60 y=0.85
  pd3 = contact mcon in=pa3 x=6.44 y=0.85

  # metal1 rails
  vss_rail = rect m1 w=3.68 h=0.20 x=0 y=0.10 net=VSS
  vdd_rail = rect m1 w=5.60 h=0.20 x=1.20 y=2.42 net=VDD

  # output metal1 segment
  out_m1 = rect m1 w=0.60 h=0.20 x=6.20 y=1.30 net=Y

  # vias to metal2 for pin access
  via_a0 = contact via in=gc0 x=0.61 y=0.90
  via_a1 = contact via in=gc1 x=1.11 y=0.90
  via_a2 = contact via in=gc2 x=1.61 y=0.90
  via_a3 = contact via in=gc3 x=2.11 y=0.90
  via_y  = contact via in=out_m1 x=6.50 y=1.40

  # devices for LVS
  device Mn0_0 nmos w=0.42 l=0.15 d=x1 g=A s=VSS
  device Mn0_1 nmos w=0.42 l=0.15 d=x2 g=B s=x1
  device Mn0_2 nmos w=0.42 l=0.15 d=x3 g=C s=x2
  device Mn0_3 nmos w=0.42 l=0.15 d=Y g=D s=x3
  device Mp0_0 pmos w=0.84 l=0.15 d=Y g=A s=VDD
  device Mp0_1 pmos w=0.84 l=0.15 d=Y g=B s=VDD
  device Mp0_2 pmos w=0.84 l=0.15 d=Y g=C s=VDD
  device Mp0_3 pmos w=0.84 l=0.15 d=Y g=D s=VDD

  # nets
  net VSS vss_rail ns0 nd0 ns1 nd1 ns2 nd2 ns3 nd3
  net VDD vdd_rail ps0 pd0 ps1 pd1 ps2 pd2 ps3 pd3
  net A   via_a0
  net B   via_a1
  net C   via_a2
  net D   via_a3
  net Y   out_m1 via_y

  # ports
  port VSS in on=vss_rail layer=m1 side=bottom
  port VDD in on=vdd_rail layer=m1 side=top
  port A   in on=via_a0 layer=m2 side=left
  port B   in on=via_a1 layer=m2 side=left
  port C   in on=via_a2 layer=m2 side=left
  port D   in on=via_a3 layer=m2 side=left
  port Y   out on=via_y layer=m2 side=right
end

# ------------------------------------------------------------------
# Top cell: 4-to-16 decoder
# ------------------------------------------------------------------

cell dec4to16
  port VSS ground
  port VDD power
  port A0 in
  port A1 in
  port A2 in
  port A3 in
  port Y0  out
  port Y1  out
  port Y2  out
  port Y3  out
  port Y4  out
  port Y5  out
  port Y6  out
  port Y7  out
  port Y8  out
  port Y9  out
  port Y10 out
  port Y11 out
  port Y12 out
  port Y13 out
  port Y14 out
  port Y15 out

  # --------------------------------------------------------------
  # Input inverters: produce complemented address lines AB0..AB3
  # --------------------------------------------------------------
  inst IA0 inv VSS=VSS VDD=VDD A=A0 Y=AB0
  inst IA1 inv VSS=VSS VDD=VDD A=A1 Y=AB1
  inst IA2 inv VSS=VSS VDD=VDD A=A2 Y=AB2
  inst IA3 inv VSS=VSS VDD=VDD A=A3 Y=AB3

  # --------------------------------------------------------------
  # 16 four-input NAND gates
  # --------------------------------------------------------------
  inst N0  nand4 VSS=VSS VDD=VDD A=AB0 B=AB1 C=AB2 D=AB3 Y=YB0
  inst N1  nand4 VSS=VSS VDD=VDD A=A0  B=AB1 C=AB2 D=AB3 Y=YB1
  inst N2  nand4 VSS=VSS VDD=VDD A=AB0 B=A1  C=AB2 D=AB3 Y=YB2
  inst N3  nand4 VSS=VSS VDD=VDD A=A0  B=A1  C=AB2 D=AB3 Y=YB3
  inst N4  nand4 VSS=VSS VDD=VDD A=AB0 B=AB1 C=A2  D=AB3 Y=YB4
  inst N5  nand4 VSS=VSS VDD=VDD A=A0  B=AB1 C=A2  D=AB3 Y=YB5
  inst N6  nand4 VSS=VSS VDD=VDD A=AB0 B=A1  C=A2  D=AB3 Y=YB6
  inst N7  nand4 VSS=VSS VDD=VDD A=A0  B=A1  C=A2  D=AB3 Y=YB7
  inst N8  nand4 VSS=VSS VDD=VDD A=AB0 B=AB1 C=AB2 D=A3  Y=YB8
  inst N9  nand4 VSS=VSS VDD=VDD A=A0  B=AB1 C=AB2 D=A3  Y=YB9
  inst N10 nand4 VSS=VSS VDD=VDD A=AB0 B=A1  C=AB2 D=A3  Y=YB10
  inst N11 nand4 VSS=VSS VDD=VDD A=A0  B=A1  C=AB2 D=A3  Y=YB11
  inst N12 nand4 VSS=VSS VDD=VDD A=AB0 B=AB1 C=A2  D=A3  Y=YB12
  inst N13 nand4 VSS=VSS VDD=VDD A=A0  B=AB1 C=A2  D=A3  Y=YB13
  inst N14 nand4 VSS=VSS VDD=VDD A=AB0 B=A1  C=A2  D=A3  Y=YB14
  inst N15 nand4 VSS=VSS VDD=VDD A=A0  B=A1  C=A2  D=A3  Y=YB15

  # --------------------------------------------------------------
  # Output inverters: produce Y0..Y15
  # --------------------------------------------------------------
  inst I0  inv VSS=VSS VDD=VDD A=YB0 Y=Y0
  inst I1  inv VSS=VSS VDD=VDD A=YB1 Y=Y1
  inst I2  inv VSS=VSS VDD=VDD A=YB2 Y=Y2
  inst I3  inv VSS=VSS VDD=VDD A=YB3 Y=Y3
  inst I4  inv VSS=VSS VDD=VDD A=YB4 Y=Y4
  inst I5  inv VSS=VSS VDD=VDD A=YB5 Y=Y5
  inst I6  inv VSS=VSS VDD=VDD A=YB6 Y=Y6
  inst I7  inv VSS=VSS VDD=VDD A=YB7 Y=Y7
  inst I8  inv VSS=VSS VDD=VDD A=YB8 Y=Y8
  inst I9  inv VSS=VSS VDD=VDD A=YB9 Y=Y9
  inst I10 inv VSS=VSS VDD=VDD A=YB10 Y=Y10
  inst I11 inv VSS=VSS VDD=VDD A=YB11 Y=Y11
  inst I12 inv VSS=VSS VDD=VDD A=YB12 Y=Y12
  inst I13 inv VSS=VSS VDD=VDD A=YB13 Y=Y13
  inst I14 inv VSS=VSS VDD=VDD A=YB14 Y=Y14
  inst I15 inv VSS=VSS VDD=VDD A=YB15 Y=Y15

  # --------------------------------------------------------------
  # Placement: three vertical columns
  # --------------------------------------------------------------
  place IA0 at=(0.0, 0.0)
  place IA1 right_of=IA0 gap=0.2
  place IA2 right_of=IA1 gap=0.2
  place IA3 right_of=IA2 gap=0.2

  place N0  right_of=IA3 gap=0.6 align=bottom
  place N1  right_of=N0  gap=0.2 align=bottom
  place N2  right_of=N1  gap=0.2 align=bottom
  place N3  right_of=N2  gap=0.2 align=bottom
  place N4  right_of=N3  gap=0.2 align=bottom
  place N5  right_of=N4  gap=0.2 align=bottom
  place N6  right_of=N5  gap=0.2 align=bottom
  place N7  right_of=N6  gap=0.2 align=bottom
  place N8  right_of=N7  gap=0.2 align=bottom
  place N9  right_of=N8  gap=0.2 align=bottom
  place N10 right_of=N9  gap=0.2 align=bottom
  place N11 right_of=N10 gap=0.2 align=bottom
  place N12 right_of=N11 gap=0.2 align=bottom
  place N13 right_of=N12 gap=0.2 align=bottom
  place N14 right_of=N13 gap=0.2 align=bottom
  place N15 right_of=N14 gap=0.2 align=bottom

  place I0  right_of=N15 gap=0.6 align=bottom
  place I1  right_of=I0  gap=0.2 align=bottom
  place I2  right_of=I1  gap=0.2 align=bottom
  place I3  right_of=I2  gap=0.2 align=bottom
  place I4  right_of=I3  gap=0.2 align=bottom
  place I5  right_of=I4  gap=0.2 align=bottom
  place I6  right_of=I5  gap=0.2 align=bottom
  place I7  right_of=I6  gap=0.2 align=bottom
  place I8  right_of=I7  gap=0.2 align=bottom
  place I9  right_of=I8  gap=0.2 align=bottom
  place I10 right_of=I9  gap=0.2 align=bottom
  place I11 right_of=I10 gap=0.2 align=bottom
  place I12 right_of=I11 gap=0.2 align=bottom
  place I13 right_of=I12 gap=0.2 align=bottom
  place I14 right_of=I13 gap=0.2 align=bottom
  place I15 right_of=I14 gap=0.2 align=bottom

  # --------------------------------------------------------------
  # Routing constraints
  # --------------------------------------------------------------
  route VSS VDD layers=m1 width=0.30
  route A0 A1 A2 A3 AB0 AB1 AB2 AB3 layers=m2 width=0.20
  route Y0 Y1 Y2 Y3 Y4 Y5 Y6 Y7 Y8 Y9 Y10 Y11 Y12 Y13 Y14 Y15 layers=m2 width=0.20
end
```