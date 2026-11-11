pdk sky130A

# -----------------------------------------------------------------------------
# 28-transistor mirror full adder (fa)
# -----------------------------------------------------------------------------
cell fa
  port VSS ground
  port VDD power
  port COUT out
  port SUM  out
  port A    in
  port B    in
  port CIN  in

  # ---- nFET network (14 devices, w=0.42 l=0.15) ---------------------------
  nmos Mn0_0  w=0.42 l=0.15 d=VSS  g=A    s=n1
  nmos Mn0_1  w=0.42 l=0.15 d=n1   g=B    s=VSS
  nmos Mn0_2  w=0.42 l=0.15 d=CB   g=CIN  s=n1
  nmos Mn0_3  w=0.42 l=0.15 d=n2   g=B    s=CB
  nmos Mn0_4  w=0.42 l=0.15 d=VSS  g=A    s=n2
  nmos Mn0_5  w=0.42 l=0.15 d=n3   g=A    s=VSS
  nmos Mn0_6  w=0.42 l=0.15 d=VSS  g=B    s=n3
  nmos Mn0_7  w=0.42 l=0.15 d=n3   g=CIN  s=VSS
  nmos Mn0_8  w=0.42 l=0.15 d=SB   g=CB   s=n3
  nmos Mn0_9  w=0.42 l=0.15 d=n5   g=CIN  s=SB
  nmos Mn0_10 w=0.42 l=0.15 d=n4   g=B    s=n5
  nmos Mn0_11 w=0.42 l=0.15 d=VSS  g=A    s=n4
  nmos Mn0_12 w=0.42 l=0.15 d=COUT g=CB   s=VSS
  nmos Mn14   w=0.42 l=0.15 d=VSS  g=SB   s=SUM

  # ---- pFET network (14 devices, w=0.84 l=0.15) ---------------------------
  pmos Mp0_0  w=0.84 l=0.15 d=VDD  g=A    s=p1
  pmos Mp0_1  w=0.84 l=0.15 d=p1   g=B    s=VDD
  pmos Mp0_2  w=0.84 l=0.15 d=CB   g=CIN  s=p1
  pmos Mp0_3  w=0.84 l=0.15 d=p2   g=B    s=CB
  pmos Mp0_4  w=0.84 l=0.15 d=VDD  g=A    s=p2
  pmos Mp0_5  w=0.84 l=0.15 d=p3   g=A    s=VDD
  pmos Mp0_6  w=0.84 l=0.15 d=VDD  g=B    s=p3
  pmos Mp0_7  w=0.84 l=0.15 d=p3   g=CIN  s=VDD
  pmos Mp0_8  w=0.84 l=0.15 d=SB   g=CB   s=p3
  pmos Mp0_9  w=0.84 l=0.15 d=p5   g=CIN  s=SB
  pmos Mp0_10 w=0.84 l=0.15 d=p4   g=B    s=p5
  pmos Mp0_11 w=0.84 l=0.15 d=VDD  g=A    s=p4
  pmos Mp0_12 w=0.84 l=0.15 d=COUT g=CB   s=VDD
  pmos Mp14   w=0.84 l=0.15 d=VDD  g=SB   s=SUM

  # ---- automatic rows: nFETs below, pFETs above ---------------------------
  row Mn0_0 Mn0_1 Mn0_2 Mn0_3 Mn0_4 Mn0_5 Mn0_6 Mn0_7 Mn0_8 Mn0_9 Mn0_10 Mn0_11 Mn0_12 Mn14
  row Mp0_0 Mp0_1 Mp0_2 Mp0_3 Mp0_4 Mp0_5 Mp0_6 Mp0_7 Mp0_8 Mp0_9 Mp0_10 Mp0_11 Mp0_12 Mp14
end

# -----------------------------------------------------------------------------
# 8-bit ripple-carry adder (rca8) – eight fa instances, carries chained
# -----------------------------------------------------------------------------
cell rca8
  port VSS ground
  port VDD power
  port A0  in
  port A1  in
  port A2  in
  port A3  in
  port A4  in
  port A5  in
  port A6  in
  port A7  in
  port B0  in
  port B1  in
  port B2  in
  port B3  in
  port B4  in
  port B5  in
  port B6  in
  port B7  in
  port CIN in
  port COUT out
  port S0  out
  port S1  out
  port S2  out
  port S3  out
  port S4  out
  port S5  out
  port S6  out
  port S7  out

  # ---- full-adder instances ------------------------------------------------
  inst FA0 fa VSS=VSS VDD=VDD COUT=k1  SUM=S0  A=A0  B=B0  CIN=CIN
  inst FA1 fa VSS=VSS VDD=VDD COUT=k2  SUM=S1  A=A1  B=B1  CIN=k1
  inst FA2 fa VSS=VSS VDD=VDD COUT=k3  SUM=S2  A=A2  B=B2  CIN=k2
  inst FA3 fa VSS=VSS VDD=VDD COUT=k4  SUM=S3  A=A3  B=B3  CIN=k3
  inst FA4 fa VSS=VSS VDD=VDD COUT=k5  SUM=S4  A=A4  B=B4  CIN=k4
  inst FA5 fa VSS=VSS VDD=VDD COUT=k6  SUM=S5  A=A5  B=B5  CIN=k5
  inst FA6 fa VSS=VSS VDD=VDD COUT=k7  SUM=S6  A=A6  B=B6  CIN=k6
  inst FA7 fa VSS=VSS VDD=VDD COUT=COUT SUM=S7  A=A7  B=B7  CIN=k7

  # ---- place the eight cells in a single row, abutting with min gap -------
  place FA0 at=(0,0)
  place FA1 right_of=FA0 gap=min
  place FA2 right_of=FA1 gap=min
  place FA3 right_of=FA2 gap=min
  place FA4 right_of=FA3 gap=min
  place FA5 right_of=FA4 gap=min
  place FA6 right_of=FA5 gap=min
  place FA7 right_of=FA6 gap=min
end
