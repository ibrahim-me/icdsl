# Analysis of a2bb2oi_1 netlist
# Y = (A1_N&!B1) | (A1_N&!B2) | (A2_N&!B1) | (A2_N&!B2)
# = (A1_N|A2_N) & (!B1|!B2)
#
# Devices:
# M0 pmos d=n1 g=A2_N s=n2
# M1 nmos d=n3 g=B1 s=VGND
# M2 nmos d=Y g=B2 s=n3
# M3 pmos d=Y g=n2 s=n4
# M4 pmos d=VPWR g=B1 s=n4
# M5 pmos d=n4 g=B2 s=VPWR
# M6 nmos d=n2 g=A2_N s=VGND
# M7 nmos d=VGND g=A1_N s=n2
# M8 pmos d=VPWR g=A1_N s=n1
# M9 nmos d=VGND g=n2 s=Y
#
# NMOS diffusion chain: VGND-[A1_N]-n2-[A2_N]-VGND | VGND-[B1]-n3-[B2]-Y-[n2]-VGND
#   Island A: VGND, n2 (gates A1_N, A2_N) - M7, M6
#   Island B: VGND, n3, Y (gates B1, B2) - M1, M2
#   Island C: VGND, Y (gate n2) - M9
#   Break between A2_N and B1 (0.80 gap), between B2 and n2 (0.80 gap)
#
# PMOS diffusion chain: VPWR-[A1_N]-n1-[A2_N]-n2 | VPWR-[B1]-n4-[B2]-n4 | Y-[n2]-n4
#   Island A: VPWR, n1, n2 (gates A1_N, A2_N) - M8, M0, M3(side)
#   Island B: VPWR, n4 (gates B1, B2) - M4, M5
#   Island C: Y, n4 (gate n2) - M3
#   Break between A2_N and B1 (0.80 gap), between B2 and n2 (0.80 gap)
#
# Gate order: A1_N, A2_N, B1, B2, n2 (same for both rows)
