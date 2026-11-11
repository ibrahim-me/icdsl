pdk sky130A

# ------------------------------------------------------------------
# D flip-flop (master-slave, transmission-gate, 22 transistors)
# Matches reference netlist: sky130A.spice dff subckt
# ------------------------------------------------------------------
cell dff
  port D    in
  port CLK  in
  port Q    out
  port VPWR power
  port VGND ground

  # CKB = !CLK (inverter formed by n0_0/p0_0)
  nmos n0_0 w=0.42 l=0.15 d=VGND g=CLK s=CKB
  pmos p0_0 w=0.84 l=0.15 d=VPWR g=CLK s=CKB

  # Master section
  nmos n0_1 w=0.42 l=0.15 d=n1 g=D s=VGND
  pmos p0_1 w=0.84 l=0.15 d=p1 g=D s=VPWR
  nmos n0_2 w=0.42 l=0.15 d=m g=CKB s=n1
  pmos p0_2 w=0.84 l=0.15 d=m g=CLK s=p1
  nmos n0_3 w=0.42 l=0.15 d=n2 g=CLK s=m
  pmos p0_3 w=0.84 l=0.15 d=p2 g=CKB s=m
  nmos n0_4 w=0.42 l=0.15 d=VGND g=mb s=n2
  pmos p0_4 w=0.84 l=0.15 d=VPWR g=mb s=p2
  nmos n0_5 w=0.42 l=0.15 d=mb g=m s=VGND
  pmos p0_5 w=0.84 l=0.15 d=mb g=m s=VPWR

  # Slave section
  nmos n7_0 w=0.42 l=0.15 d=n3 g=Q s=VGND
  pmos p7_0 w=0.84 l=0.15 d=p3 g=Q s=VPWR
  nmos n7_1 w=0.42 l=0.15 d=s g=CKB s=n3
  pmos p7_1 w=0.84 l=0.15 d=s g=CLK s=p3
  nmos n7_2 w=0.42 l=0.15 d=n4 g=CLK s=s
  pmos p7_2 w=0.84 l=0.15 d=p4 g=CKB s=s
  nmos n7_3 w=0.42 l=0.15 d=VGND g=mb s=n4
  pmos p7_3 w=0.84 l=0.15 d=VPWR g=mb s=p4
  nmos n7_4 w=0.42 l=0.15 d=Q g=s s=VGND
  pmos p7_4 w=0.84 l=0.15 d=Q g=s s=VPWR

  row n0_0 n0_1 n0_2 n0_3 n0_4 n0_5 n7_0 n7_1 n7_2 n7_3 n7_4
  row p0_0 p0_1 p0_2 p0_3 p0_4 p0_5 p7_0 p7_1 p7_2 p7_3 p7_4
end

# ------------------------------------------------------------------
# 16-bit shift register: sixteen dff stages chained Q(n) -> D(n+1)
# ------------------------------------------------------------------
cell shreg16
  port VSS ground
  port VDD power
  port D    in
  port CK   in
  port Q0   out
  port Q1   out
  port Q2   out
  port Q3   out
  port Q4   out
  port Q5   out
  port Q6   out
  port Q7   out
  port Q8   out
  port Q9   out
  port Q10  out
  port Q11  out
  port Q12  out
  port Q13  out
  port Q14  out
  port Q15  out

  inst FF0  dff VGND=VSS VPWR=VDD Q=Q0  CLK=CK D=D
  inst FF1  dff VGND=VSS VPWR=VDD Q=Q1  CLK=CK D=Q0
  inst FF2  dff VGND=VSS VPWR=VDD Q=Q2  CLK=CK D=Q1
  inst FF3  dff VGND=VSS VPWR=VDD Q=Q3  CLK=CK D=Q2
  inst FF4  dff VGND=VSS VPWR=VDD Q=Q4  CLK=CK D=Q3
  inst FF5  dff VGND=VSS VPWR=VDD Q=Q5  CLK=CK D=Q4
  inst FF6  dff VGND=VSS VPWR=VDD Q=Q6  CLK=CK D=Q5
  inst FF7  dff VGND=VSS VPWR=VDD Q=Q7  CLK=CK D=Q6
  inst FF8  dff VGND=VSS VPWR=VDD Q=Q8  CLK=CK D=Q7
  inst FF9  dff VGND=VSS VPWR=VDD Q=Q9  CLK=CK D=Q8
  inst FF10 dff VGND=VSS VPWR=VDD Q=Q10 CLK=CK D=Q9
  inst FF11 dff VGND=VSS VPWR=VDD Q=Q11 CLK=CK D=Q10
  inst FF12 dff VGND=VSS VPWR=VDD Q=Q12 CLK=CK D=Q11
  inst FF13 dff VGND=VSS VPWR=VDD Q=Q13 CLK=CK D=Q12
  inst FF14 dff VGND=VSS VPWR=VDD Q=Q14 CLK=CK D=Q13
  inst FF15 dff VGND=VSS VPWR=VDD Q=Q15 CLK=CK D=Q14

  # placement: two rows of eight, left-aligned
  place FF0  at=(0,0)
  place FF1  right_of=FF0  gap=min
  place FF2  right_of=FF1  gap=min
  place FF3  right_of=FF2  gap=min
  place FF4  right_of=FF3  gap=min
  place FF5  right_of=FF4  gap=min
  place FF6  right_of=FF5  gap=min
  place FF7  right_of=FF6  gap=min

  place FF8  below=FF0  gap=min align=left
  place FF9  right_of=FF8  gap=min
  place FF10 right_of=FF9  gap=min
  place FF11 right_of=FF10 gap=min
  place FF12 right_of=FF11 gap=min
  place FF13 right_of=FF12 gap=min
  place FF14 right_of=FF13 gap=min
  place FF15 right_of=FF14 gap=min
end



