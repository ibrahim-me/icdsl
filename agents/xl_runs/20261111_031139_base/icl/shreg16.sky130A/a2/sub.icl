pdk sky130A

# ------------------------------------------------------------------
# D flip-flop (master-slave, transmission-gate, 22 transistors)
# ------------------------------------------------------------------
cell dff
  port D    in
  port CLK  in
  port Q    out
  port VPWR power
  port VGND ground

  # local clock buffers: CKB = !CLK, CKI = CLK (buffered)
  nmos NC1 w=0.5 l=0.15 d=CKB g=CLK s=VGND
  pmos PC1 w=0.8 l=0.15 d=CKB g=CLK s=VPWR
  nmos NC2 w=0.5 l=0.15 d=CKI g=CKB s=VGND
  pmos PC2 w=0.8 l=0.15 d=CKI g=CKB s=VPWR

  # master: TG1 (D -> m1, transparent while CLK low), inverter m1 -> m2,
  # feedback m2 -> m3 -> TG2 -> m1
  nmos NT1 w=0.5 l=0.15 d=m1 g=CKB s=D
  pmos PT1 w=0.5 l=0.15 d=m1 g=CKI s=D
  nmos NI1 w=0.5 l=0.15 d=m2 g=m1 s=VGND
  pmos PI1 w=0.8 l=0.15 d=m2 g=m1 s=VPWR
  nmos NI2 w=0.42 l=0.15 d=m3 g=m2 s=VGND
  pmos PI2 w=0.42 l=0.15 d=m3 g=m2 s=VPWR
  nmos NT2 w=0.42 l=0.15 d=m1 g=CKI s=m3
  pmos PT2 w=0.42 l=0.15 d=m1 g=CKB s=m3

  # slave: TG3 (m2 -> s1, transparent while CLK high), inverter s1 -> Q,
  # feedback Q -> s3 -> TG4 -> s1
  nmos NT3 w=0.5 l=0.15 d=s1 g=CKI s=m2
  pmos PT3 w=0.5 l=0.15 d=s1 g=CKB s=m2
  nmos NI3 w=0.65 l=0.15 d=Q g=s1 s=VGND
  pmos PI3 w=1.0 l=0.15 d=Q g=s1 s=VPWR
  nmos NI4 w=0.42 l=0.15 d=s3 g=Q s=VGND
  pmos PI4 w=0.42 l=0.15 d=s3 g=Q s=VPWR
  nmos NT4 w=0.42 l=0.15 d=s1 g=CKB s=s3
  pmos PT4 w=0.42 l=0.15 d=s1 g=CKI s=s3

  row NC1 NC2 NT1 NI1 NI2 NT2 NT3 NI3 NI4 NT4
  row PC1 PC2 PT1 PI1 PI2 PT2 PT3 PI3 PI4 PT4
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

  inst FF0  dff VGND=VSS VPWR=VDD Q=Q0  CK=CK D=D
  inst FF1  dff VGND=VSS VPWR=VDD Q=Q1  CK=CK D=Q0
  inst FF2  dff VGND=VSS VPWR=VDD Q=Q2  CK=CK D=Q1
  inst FF3  dff VGND=VSS VPWR=VDD Q=Q3  CK=CK D=Q2
  inst FF4  dff VGND=VSS VPWR=VDD Q=Q4  CK=CK D=Q3
  inst FF5  dff VGND=VSS VPWR=VDD Q=Q5  CK=CK D=Q4
  inst FF6  dff VGND=VSS VPWR=VDD Q=Q6  CK=CK D=Q5
  inst FF7  dff VGND=VSS VPWR=VDD Q=Q7  CK=CK D=Q6
  inst FF8  dff VGND=VSS VPWR=VDD Q=Q8  CK=CK D=Q7
  inst FF9  dff VGND=VSS VPWR=VDD Q=Q9  CK=CK D=Q8
  inst FF10 dff VGND=VSS VPWR=VDD Q=Q10 CK=CK D=Q9
  inst FF11 dff VGND=VSS VPWR=VDD Q=Q11 CK=CK D=Q10
  inst FF12 dff VGND=VSS VPWR=VDD Q=Q12 CK=CK D=Q11
  inst FF13 dff VGND=VSS VPWR=VDD Q=Q13 CK=CK D=Q12
  inst FF14 dff VGND=VSS VPWR=VDD Q=Q14 CK=CK D=Q13
  inst FF15 dff VGND=VSS VPWR=VDD Q=Q15 CK=CK D=Q14

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

