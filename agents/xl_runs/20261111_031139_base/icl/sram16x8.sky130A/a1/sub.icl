pdk sky130A

# ------------------------------------------------------------------
# 6T SRAM cell (sky130A, 1.8V devices)
#   nmos access : w=0.42 l=0.15
#   nmos pull-down : w=0.42 l=0.15
#   pmos pull-up   : w=0.84 l=0.15
# ------------------------------------------------------------------
cell sram6t
  port VSS ground side=bottom layer=m1
  port VDD power  side=top    layer=m1
  port BL  inout  side=right  layer=m1
  port BLB inout  side=right  layer=m1
  port WL  in     side=left   layer=m2

  # access transistors
  nmos M_acc_Q  w=0.42 l=0.15 d=Q  g=WL s=BL
  nmos M_acc_QB w=0.42 l=0.15 d=QB g=WL s=BLB

  # pull-down devices (cross-coupled inverters)
  nmos M_pd_Q  w=0.42 l=0.15 d=VSS g=QB s=Q
  nmos M_pd_QB w=0.42 l=0.15 d=QB  g=Q  s=VSS

  # pull-up devices
  pmos M_pu_Q  w=0.84 l=0.15 d=Q  g=QB s=VDD
  pmos M_pu_QB w=0.84 l=0.15 d=QB g=Q  s=VDD

  # compact placement: access devices at bottom, pull-downs above,
  # pull-ups at top.  All devices in a column share the same gate
  # diffusion where legal; the router will metal the internal nodes.
  place M_acc_Q  at=(0,0)
  place M_acc_QB right_of=M_acc_Q gap=min
  place M_pd_Q   above=M_acc_Q  gap=min
  place M_pd_QB  above=M_acc_QB gap=min
  place M_pu_Q   above=M_pd_Q   gap=min
  place M_pu_QB  above=M_pd_QB  gap=min
end

# ------------------------------------------------------------------
# 16 x 8 SRAM array
#   16 rows (WL0..WL15), 8 columns (BL0..BL7 / BLB0..BLB7)
#   cell pitch derived from the reference area:
#     width  = 28.56 um / 8 = 3.57 um
#     height = 73.69 um / 16 = 4.605625 um
# ------------------------------------------------------------------
cell sram16x8
  port VSS ground
  port VDD power
  port BL0  inout
  port BL1  inout
  port BL2  inout
  port BL3  inout
  port BL4  inout
  port BL5  inout
  port BL6  inout
  port BL7  inout
  port BLB0 inout
  port BLB1 inout
  port BLB2 inout
  port BLB3 inout
  port BLB4 inout
  port BLB5 inout
  port BLB6 inout
  port BLB7 inout
  port WL0  in
  port WL1  in
  port WL2  in
  port WL3  in
  port WL4  in
  port WL5  in
  port WL6  in
  port WL7  in
  port WL8  in
  port WL9  in
  port WL10 in
  port WL11 in
  port WL12 in
  port WL13 in
  port WL14 in
  port WL15 in

  param CELL_W=3.57
  param CELL_H=4.605625

  # ------------------------------------------------------------------
  # Row 0  (WL0)
  # ------------------------------------------------------------------
  inst C0_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL0
  place C0_0 at=(0,0)
  inst C0_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL0
  place C0_1 right_of=C0_0 gap=min
  inst C0_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL0
  place C0_2 right_of=C0_1 gap=min
  inst C0_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL0
  place C0_3 right_of=C0_2 gap=min
  inst C0_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL0
  place C0_4 right_of=C0_3 gap=min
  inst C0_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL0
  place C0_5 right_of=C0_4 gap=min
  inst C0_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL0
  place C0_6 right_of=C0_5 gap=min
  inst C0_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL0
  place C0_7 right_of=C0_6 gap=min

  # ------------------------------------------------------------------
  # Row 1  (WL1)
  # ------------------------------------------------------------------
  inst C1_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL1
  place C1_0 above=C0_0 gap=min
  inst C1_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL1
  place C1_1 right_of=C1_0 gap=min
  inst C1_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL1
  place C1_2 right_of=C1_1 gap=min
  inst C1_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL1
  place C1_3 right_of=C1_2 gap=min
  inst C1_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL1
  place C1_4 right_of=C1_3 gap=min
  inst C1_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL1
  place C1_5 right_of=C1_4 gap=min
  inst C1_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL1
  place C1_6 right_of=C1_5 gap=min
  inst C1_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL1
  place C1_7 right_of=C1_6 gap=min

  # ------------------------------------------------------------------
  # Row 2  (WL2)
  # ------------------------------------------------------------------
  inst C2_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL2
  place C2_0 above=C1_0 gap=min
  inst C2_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL2
  place C2_1 right_of=C2_0 gap=min
  inst C2_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL2
  place C2_2 right_of=C2_1 gap=min
  inst C2_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL2
  place C2_3 right_of=C2_2 gap=min
  inst C2_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL2
  place C2_4 right_of=C2_3 gap=min
  inst C2_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL2
  place C2_5 right_of=C2_4 gap=min
  inst C2_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL2
  place C2_6 right_of=C2_5 gap=min
  inst C2_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL2
  place C2_7 right_of=C2_6 gap=min

  # ------------------------------------------------------------------
  # Row 3  (WL3)
  # ------------------------------------------------------------------
  inst C3_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL3
  place C3_0 above=C2_0 gap=min
  inst C3_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL3
  place C3_1 right_of=C3_0 gap=min
  inst C3_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL3
  place C3_2 right_of=C3_1 gap=min
  inst C3_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL3
  place C3_3 right_of=C3_2 gap=min
  inst C3_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL3
  place C3_4 right_of=C3_3 gap=min
  inst C3_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL3
  place C3_5 right_of=C3_4 gap=min
  inst C3_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL3
  place C3_6 right_of=C3_5 gap=min
  inst C3_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL3
  place C3_7 right_of=C3_6 gap=min

  # ------------------------------------------------------------------
  # Row 4  (WL4)
  # ------------------------------------------------------------------
  inst C4_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL4
  place C4_0 above=C3_0 gap=min
  inst C4_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL4
  place C4_1 right_of=C4_0 gap=min
  inst C4_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL4
  place C4_2 right_of=C4_1 gap=min
  inst C4_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL4
  place C4_3 right_of=C4_2 gap=min
  inst C4_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL4
  place C4_4 right_of=C4_3 gap=min
  inst C4_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL4
  place C4_5 right_of=C4_4 gap=min
  inst C4_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL4
  place C4_6 right_of=C4_5 gap=min
  inst C4_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL4
  place C4_7 right_of=C4_6 gap=min

  # ------------------------------------------------------------------
  # Row 5  (WL5)
  # ------------------------------------------------------------------
  inst C5_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL5
  place C5_0 above=C4_0 gap=min
  inst C5_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL5
  place C5_1 right_of=C5_0 gap=min
  inst C5_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL5
  place C5_2 right_of=C5_1 gap=min
  inst C5_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL5
  place C5_3 right_of=C5_2 gap=min
  inst C5_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL5
  place C5_4 right_of=C5_3 gap=min
  inst C5_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL5
  place C5_5 right_of=C5_4 gap=min
  inst C5_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL5
  place C5_6 right_of=C5_5 gap=min
  inst C5_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL5
  place C5_7 right_of=C5_6 gap=min

  # ------------------------------------------------------------------
  # Row 6  (WL6)
  # ------------------------------------------------------------------
  inst C6_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL6
  place C6_0 above=C5_0 gap=min
  inst C6_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL6
  place C6_1 right_of=C6_0 gap=min
  inst C6_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL6
  place C6_2 right_of=C6_1 gap=min
  inst C6_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL6
  place C6_3 right_of=C6_2 gap=min
  inst C6_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL6
  place C6_4 right_of=C6_3 gap=min
  inst C6_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL6
  place C6_5 right_of=C6_4 gap=min
  inst C6_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL6
  place C6_6 right_of=C6_5 gap=min
  inst C6_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL6
  place C6_7 right_of=C6_6 gap=min

  # ------------------------------------------------------------------
  # Row 7  (WL7)
  # ------------------------------------------------------------------
  inst C7_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL7
  place C7_0 above=C6_0 gap=min
  inst C7_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL7
  place C7_1 right_of=C7_0 gap=min
  inst C7_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL7
  place C7_2 right_of=C7_1 gap=min
  inst C7_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL7
  place C7_3 right_of=C7_2 gap=min
  inst C7_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL7
  place C7_4 right_of=C7_3 gap=min
  inst C7_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL7
  place C7_5 right_of=C7_4 gap=min
  inst C7_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL7
  place C7_6 right_of=C7_5 gap=min
  inst C7_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL7
  place C7_7 right_of=C7_6 gap=min

  # ------------------------------------------------------------------
  # Row 8  (WL8)
  # ------------------------------------------------------------------
  inst C8_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL8
  place C8_0 above=C7_0 gap=min
  inst C8_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL8
  place C8_1 right_of=C8_0 gap=min
  inst C8_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL8
  place C8_2 right_of=C8_1 gap=min
  inst C8_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL8
  place C8_3 right_of=C8_2 gap=min
  inst C8_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL8
  place C8_4 right_of=C8_3 gap=min
  inst C8_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL8
  place C8_5 right_of=C8_4 gap=min
  inst C8_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL8
  place C8_6 right_of=C8_5 gap=min
  inst C8_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL8
  place C8_7 right_of=C8_6 gap=min

  # ------------------------------------------------------------------
  # Row 9  (WL9)
  # ------------------------------------------------------------------
  inst C9_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL9
  place C9_0 above=C8_0 gap=min
  inst C9_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL9
  place C9_1 right_of=C9_0 gap=min
  inst C9_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL9
  place C9_2 right_of=C9_1 gap=min
  inst C9_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL9
  place C9_3 right_of=C9_2 gap=min
  inst C9_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL9
  place C9_4 right_of=C9_3 gap=min
  inst C9_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL9
  place C9_5 right_of=C9_4 gap=min
  inst C9_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL9
  place C9_6 right_of=C9_5 gap=min
  inst C9_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL9
  place C9_7 right_of=C9_6 gap=min

  # ------------------------------------------------------------------
  # Row 10 (WL10)
  # ------------------------------------------------------------------
  inst C10_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL10
  place C10_0 above=C9_0 gap=min
  inst C10_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL10
  place C10_1 right_of=C10_0 gap=min
  inst C10_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL10
  place C10_2 right_of=C10_1 gap=min
  inst C10_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL10
  place C10_3 right_of=C10_2 gap=min
  inst C10_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL10
  place C10_4 right_of=C10_3 gap=min
  inst C10_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL10
  place C10_5 right_of=C10_4 gap=min
  inst C10_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL10
  place C10_6 right_of=C10_5 gap=min
  inst C10_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL10
  place C10_7 right_of=C10_6 gap=min

  # ------------------------------------------------------------------
  # Row 11 (WL11)
  # ------------------------------------------------------------------
  inst C11_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL11
  place C11_0 above=C10_0 gap=min
  inst C11_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL11
  place C11_1 right_of=C11_0 gap=min
  inst C11_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL11
  place C11_2 right_of=C11_1 gap=min
  inst C11_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL11
  place C11_3 right_of=C11_2 gap=min
  inst C11_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL11
  place C11_4 right_of=C11_3 gap=min
  inst C11_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL11
  place C11_5 right_of=C11_4 gap=min
  inst C11_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL11
  place C11_6 right_of=C11_5 gap=min
  inst C11_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL11
  place C11_7 right_of=C11_6 gap=min

  # ------------------------------------------------------------------
  # Row 12 (WL12)
  # ------------------------------------------------------------------
  inst C12_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL12
  place C12_0 above=C11_0 gap=min
  inst C12_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL12
  place C12_1 right_of=C12_0 gap=min
  inst C12_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL12
  place C12_2 right_of=C12_1 gap=min
  inst C12_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL12
  place C12_3 right_of=C12_2 gap=min
  inst C12_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL12
  place C12_4 right_of=C12_3 gap=min
  inst C12_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL12
  place C12_5 right_of=C12_4 gap=min
  inst C12_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL12
  place C12_6 right_of=C12_5 gap=min
  inst C12_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL12
  place C12_7 right_of=C12_6 gap=min

  # ------------------------------------------------------------------
  # Row 13 (WL13)
  # ------------------------------------------------------------------
  inst C13_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL13
  place C13_0 above=C12_0 gap=min
  inst C13_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL13
  place C13_1 right_of=C13_0 gap=min
  inst C13_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL13
  place C13_2 right_of=C13_1 gap=min
  inst C13_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL13
  place C13_3 right_of=C13_2 gap=min
  inst C13_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL13
  place C13_4 right_of=C13_3 gap=min
  inst C13_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL13
  place C13_5 right_of=C13_4 gap=min
  inst C13_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL13
  place C13_6 right_of=C13_5 gap=min
  inst C13_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL13
  place C13_7 right_of=C13_6 gap=min

  # ------------------------------------------------------------------
  # Row 14 (WL14)
  # ------------------------------------------------------------------
  inst C14_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL14
  place C14_0 above=C13_0 gap=min
  inst C14_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL14
  place C14_1 right_of=C14_0 gap=min
  inst C14_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL14
  place C14_2 right_of=C14_1 gap=min
  inst C14_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL14
  place C14_3 right_of=C14_2 gap=min
  inst C14_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL14
  place C14_4 right_of=C14_3 gap=min
  inst C14_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL14
  place C14_5 right_of=C14_4 gap=min
  inst C14_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL14
  place C14_6 right_of=C14_5 gap=min
  inst C14_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL14
  place C14_7 right_of=C14_6 gap=min

  # ------------------------------------------------------------------
  # Row 15 (WL15)
  # ------------------------------------------------------------------
  inst C15_0  sram6t VSS=VSS VDD=VDD BL=BL0  BLB=BLB0 WL=WL15
  place C15_0 above=C14_0 gap=min
  inst C15_1  sram6t VSS=VSS VDD=VDD BL=BL1  BLB=BLB1 WL=WL15
  place C15_1 right_of=C15_0 gap=min
  inst C15_2  sram6t VSS=VSS VDD=VDD BL=BL2  BLB=BLB2 WL=WL15
  place C15_2 right_of=C15_1 gap=min
  inst C15_3  sram6t VSS=VSS VDD=VDD BL=BL3  BLB=BLB3 WL=WL15
  place C15_3 right_of=C15_2 gap=min
  inst C15_4  sram6t VSS=VSS VDD=VDD BL=BL4  BLB=BLB4 WL=WL15
  place C15_4 right_of=C15_3 gap=min
  inst C15_5  sram6t VSS=VSS VDD=VDD BL=BL5  BLB=BLB5 WL=WL15
  place C15_5 right_of=C15_4 gap=min
  inst C15_6  sram6t VSS=VSS VDD=VDD BL=BL6  BLB=BLB6 WL=WL15
  place C15_6 right_of=C15_5 gap=min
  inst C15_7  sram6t VSS=VSS VDD=VDD BL=BL7  BLB=BLB7 WL=WL15
  place C15_7 right_of=C15_6 gap=min

  # ------------------------------------------------------------------
  # Word-line routing (horizontal, metal2)
  # ------------------------------------------------------------------
  route WL0  layers=m2 width=0.2 from=C0_0.WL  to=C0_7.WL
  route WL1  layers=m2 width=0.2 from=C1_0.WL  to=C1_7.WL
  route WL2  layers=m2 width=0.2 from=C2_0.WL  to=C2_7.WL
  route WL3  layers=m2 width=0.2 from=C3_0.WL  to=C3_7.WL
  route WL4  layers=m2 width=0.2 from=C4_0.WL  to=C4_7.WL
  route WL5  layers=m2 width=0.2 from=C5_0.WL  to=C5_7.WL
  route WL6  layers=m2 width=0.2 from=C6_0.WL  to=C6_7.WL
  route WL7  layers=m2 width=0.2 from=C7_0.WL  to=C7_7.WL
  route WL8  layers=m2 width=0.2 from=C8_0.WL  to=C8_7.WL
  route WL9  layers=m2 width=0.2 from=C9_0.WL  to=C9_7.WL
  route WL10 layers=m2 width=0.2 from=C10_0.WL to=C10_7.WL
  route WL11 layers=m2 width=0.2 from=C11_0.WL to=C11_7.WL
  route WL12 layers=m2 width=0.2 from=C12_0.WL to=C12_7.WL
  route WL13 layers=m2 width=0.2 from=C13_0.WL to=C13_7.WL
  route WL14 layers=m2 width=0.2 from=C14_0.WL to=C14_7.WL
  route WL15 layers=m2 width=0.2 from=C15_0.WL to=C15_7.WL

  # ------------------------------------------------------------------
  # Bit-line routing (vertical, metal1)
  # ------------------------------------------------------------------
  route BL0  layers=m1 width=0.2 from=C0_0.BL  to=C15_0.BL
  route BL1  layers=m1 width=0.2 from=C0_1.BL  to=C15_1.BL
  route BL2  layers=m1 width=0.2 from=C0_2.BL  to=C15_2.BL
  route BL3  layers=m1 width=0.2 from=C0_3.BL  to=C15_3.BL
  route BL4  layers=m1 width=0.2 from=C0_4.BL  to=C15_4.BL
  route BL5  layers=m1 width=0.2 from=C0_5.BL  to=C15_5.BL
  route BL6  layers=m1 width=0.2 from=C0_6.BL  to=C15_6.BL
  route BL7  layers=m1 width=0.2 from=C0_7.BL  to=C15_7.BL

  route BLB0 layers=m1 width=0.2 from=C0_0.BLB to=C15_0.BLB
  route BLB1 layers=m1 width=0.2 from=C0_1.BLB to=C15_1.BLB
  route BLB2 layers=m1 width=0.2 from=C0_2.BLB to=C15_2.BLB
  route BLB3 layers=m1 width=0.2 from=C0_3.BLB to=C15_3.BLB
  route BLB4 layers=m1 width=0.2 from=C0_4.BLB to=C15_4.BLB
  route BLB5 layers=m1 width=0.2 from=C0_5.BLB to=C15_5.BLB
  route BLB6 layers=m1 width=0.2 from=C0_6.BLB to=C15_6.BLB
  route BLB7 layers=m1 width=0.2 from=C0_7.BLB to=C15_7.BLB

  # ------------------------------------------------------------------
  # Supply rails (metal1, wide)
  # ------------------------------------------------------------------
  route VDD layers=m1 width=0.5 from=C0_0.VDD to=C15_7.VDD
  route VSS layers=m1 width=0.5 from=C0_0.VSS to=C15_7.VSS
end
