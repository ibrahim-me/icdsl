pdk sky130A
param W=1.0 L=0.15

cell comp_latch
  port CLK   in  side=left
  port INP   in  side=left
  port INN   in  side=left
  port QP    out side=right
  port QN    out side=right
  port VPWR power side=top
  port VGND ground side=bottom

  # ---------- Comparator tail switch (centered on axis) ----------
  nmos M0 w=W l=L nf=4 d=tail g=CLK s=VGND

  # ---------- Input differential pair M1/M2 (mirror) ----------
  nmos M1 w=W l=L nf=2 d=P  g=INP s=tail
  nmos M2 w=W l=L nf=2 d=Q  g=INN s=tail

  # ---------- Cross-coupled latch M3/M4 (mirror) ----------
  nmos M3 w=W l=L nf=1 d=OUTN g=OUTP s=P
  nmos M4 w=W l=L nf=1 d=OUTP g=OUTN s=Q

  # ---------- PMOS loads M5/M6 (mirror) ----------
  pmos M5 w=W l=L nf=1 d=OUTN g=OUTP s=VPWR
  pmos M6 w=W l=L nf=1 d=OUTP g=OUTN s=VPWR

  # ---------- PMOS precharge M7/M8 (mirror) ----------
  pmos M7 w=W l=L nf=1 d=OUTN g=CLK s=VPWR
  pmos M8 w=W l=L nf=1 d=OUTP g=CLK s=VPWR

  # ---------- PMOS precharge M9/M10 (mirror) ----------
  pmos M9 w=W l=L nf=1 d=P  g=CLK s=VPWR
  pmos M10 w=W l=L nf=1 d=Q g=CLK s=VPWR

  # ---------- SR latch left side ----------
  nmos MN11 w=W l=L nf=1 d=QP g=OUTN s=m1
  nmos MN12 w=W l=L nf=1 d=m1 g=QN s=VGND
  pmos MP11 w=W l=L nf=1 d=QP g=OUTN s=VPWR
  pmos MP12 w=W l=L nf=1 d=QP g=QN s=VPWR

  # ---------- SR latch right side ----------
  nmos MN21 w=W l=L nf=1 d=QN g=OUTP s=m2
  nmos MN22 w=W l=L nf=1 d=m2 g=QP s=VGND
  pmos MP21 w=W l=L nf=1 d=QN g=OUTP s=VPWR
  pmos MP22 w=W l=L nf=1 d=QN g=QP s=VPWR

  # ---------- Substrate taps ----------
  tap TP kind=ptap net=VGND
  tap TN kind=ntap net=VPWR

  # ---------- Placement: mirror axis at x=0 ----------
  # Tail transistor centered on the axis
  place M0 at=(0, 0) align=center
  place TP below=M0 gap=0.6 align=center
  place TN above=M9 gap=0.6 align=center

  # Input pair: M1 left, M2 right, mirrored about x=0
  pair M1 M2 axis=0 below=M0 gap=0.6
  pair M3 M4 axis=0 below=M1 gap=0.6
  pair M5 M6 axis=0 above=M0 gap=0.6
  pair M7 M8 axis=0 above=M5 gap=0.6
  pair M9 M10 axis=0 above=M7 gap=0.6
  pair MN11 MN21 axis=0 below=M3 gap=0.6
  pair MN12 MN22 axis=0 below=MN11 gap=0.6
  pair MP11 MP21 axis=0 above=M9 gap=0.6
  pair MP12 MP22 axis=0 above=MP11 gap=0.6

  # ---------- Routing ----------
  route * width=0.25

  # Tail: M0 drain -> M1/M2 sources
  route tail width=0.4
  route CLK width=0.3
  route INP width=0.25
  route INN width=0.25
  route P width=0.25
  route Q width=0.25
  route OUTN width=0.25
  route OUTP width=0.25
  route VPWR width=0.4
  route VGND width=0.4
  route QP width=0.25
  route QN width=0.25
  route m1 width=0.25
  route m2 width=0.25

end