pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=10 height=H
  device M0 nmos w=WN2 l=L d=n1 g=B s=n2
  device M1 nmos w=WN2 l=L d=n3 g=n1 s=n4
  device M2 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M3 pmos w=WP l=L d=VPWR g=n1 s=COUT
  device M4 nmos w=WN2 l=L d=VGND g=A s=n4
  device M5 pmos w=WP2 l=L d=n3 g=B s=n5
  device M6 pmos w=WP2 l=L d=n5 g=A s=VPWR
  device M7 nmos w=WN l=L d=SUM g=n3 s=VGND
  device M8 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M9 pmos w=WP l=L d=SUM g=n3 s=VPWR
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3
  device M11 nmos w=WN2 l=L d=n4 g=B s=VGND
  device M12 nmos w=WN l=L d=VGND g=n1 s=COUT
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1

  # Gate order: A B A B n1 n1 n3  (7 columns)
  # n-row: g1=A(M8:VGND/n2) g2=B(M0:n2/n1) | g3=A(M4:n4/VGND) g4=B(M11:VGND/n4) g5=n1(M1:n4/n3) | g6=n1(M12:COUT/VGND) g7=n3(M7:VGND/SUM)
  #   breaks: g2-g3 (n1 vs n4), g5-g6 (n3 vs COUT)
  # p-row: g1=A(M2:VPWR/n1) g2=B(M13:n1/VPWR) g3=A(M6:VPWR/n5) g4=B(M5:n5/n3) g5=n1(M10:n3/VPWR) | g6=n1(M3:COUT/VPWR) g7=n3(M9:VPWR/SUM)
  #   break: g5-g6 (VPWR vs COUT)
  #
  # n-row islands: [g1-g2] [g3-g5] [g6-g7]
  # p-row islands: [g1-g5] [g6-g7]

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  # 7 gates with breaks at g2-g3 (0.80) and g5-g6 (0.80)
  g1  = rect poly w=L left=(cell.cx - (0.53 + 7*L + 0.28*4 + 0.80*2)/2 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2  = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3  = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A (n-row break)
  g4  = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g5  = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g6  = rect poly w=L left=(g5.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1 (break both rows)
  g7  = rect poly w</think>Let me look at how the verified examples handle the supply straps more carefully, and check the template behavior:
<tool_call>
<function=read_file>