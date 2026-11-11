# Positive-edge master-slave D flip-flop (transmission-gate, 20 transistors)
pdk sky130A

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

  # master: TG1 (D -> m1, transparent while CLK low), inverter m1 -> m2, feedback m2 -> m3 -> TG2 -> m1
  nmos NT1 w=0.5 l=0.15 d=m1 g=CKB s=D
  pmos PT1 w=0.5 l=0.15 d=m1 g=CKI s=D
  nmos NI1 w=0.5 l=0.15 d=m2 g=m1 s=VGND
  pmos PI1 w=0.8 l=0.15 d=m2 g=m1 s=VPWR
  nmos NI2 w=0.42 l=0.15 d=m3 g=m2 s=VGND
  pmos PI2 w=0.42 l=0.15 d=m3 g=m2 s=VPWR
  nmos NT2 w=0.42 l=0.15 d=m1 g=CKI s=m3
  pmos PT2 w=0.42 l=0.15 d=m1 g=CKB s=m3

  # slave: TG3 (m2 -> s1, transparent while CLK high), inverter s1 -> Q, feedback Q -> s3 -> TG4 -> s1
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
