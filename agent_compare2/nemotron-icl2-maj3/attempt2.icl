pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=14 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4
  device M3 nmos w=WN l=L d=VGND g=n3 s=X
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3

  # Gate order (same on both rows): A B C n3 | A B C n3
  # NMOS islands:
  #   nd1: g1(A)-g2(B) = M4-M1: VGND-[A]-n2-[B]-n3
  #   nd2: g3(C) = M9: n4-[C]-VGND
  #   nd3: g5(A)-g6(B) = M5-M2: VGND-[A]-n5-[B]-n4? No, M2 d=n3 s=n4
  #   Let me re-think...
  #
  # NMOS with gate order A B C n3 | A B C n3:
  #   g1(A): M4 (d=VGND, s=n2)
  #   g2(B): M1 (d=n2, s=n3) -> shares n2 with M4
  #   g3(C): M9 (d=n4, s=VGND) -> M1's source=n3, M9's drain=n4. No match. Break.
  #   g4(n3): M3 (d=VGND, s=X)
  #   g5(A): M5 (d=n5, s=VGND)
  #   g6(B): M2 (d=n3, s=n4) -> M5's source=VGND, M2's drain=n3. No match. Break.
  #   g7(C): M10 (d=n3, s=n5) -> M2's source=n4, M10's drain=n3. No match. Break.
  #   g8(n3): (nothing left)
  #
  # This doesn't work well. Let me try a different gate order.
  #
  # Try: A B C n3 | A C B n3
  # NMOS:
  #   g1(A): M4 (d=VGND, s=n2)
  #   g2(B): M1 (d=n2, s=n3) -> shares n2
  #   g3(C): M2? No, M2 has gate B.
  #   g3(C): M9 (d=n4, s=VGND) -> M1's source=n3, M9's drain=n4. No match. Break.
  #   g4(n3): M3 (d=VGND, s=X)
  #   g5(A): M5 (d=n5, s=VGND)
  #   g6(C): M10 (d=n3, s=n5) -> M5's source=VGND, M10's drain=n3. No match. Break.
  #   g7(B): M2 (d=n3, s=n4) -> M10's source=n5, M2's drain=n3. No match. Break.
  #   g8(n3): (nothing)
  #
  # Still not great. Let me try: A B C n3 | A B C n3 but with different island assignments.
  #
  # Actually, the simplest approach: each transistor gets its own diffusion island.
  # That's 7 NMOS islands + 7 PMOS islands = 14 islands. With 8 gates, that's fine.
  #
  # But sharing diffusion reduces area. Let me try to maximize sharing.
  #
  # NMOS sharing:
  #   M4(A)-M1(B): VGND-n2-n3 (share n2)
  #   M5(A)-M10(C): VGND-n5-n3 (share n5) -- wait, M5 s=VGND, M10 d=n3. M5's source=VGND, M10's drain=n3. No shared node.
  #   Actually M5: d=n5, s=VGND. M10: d=n3, s=n5. M5's drain=n5, M10's source=n5. Share n5!
  #   So M5-M10: VGND-[A]-n5-[C]-n3
  #
  #   M2(B)-M9(C): n3-[B]-n4-[C]-VGND (share n4)
  #
  #   M3(n3): VGND-[n3]-X (standalone)
  #
  # NMOS gate order needed: A B | A C | B C | n3
  #
  # PMOS sharing:
  #   M0(A)-M11(C): VPWR-n1-n3 (share n1)
  #   M7(C)-M6(B): VPWR-n6-n3 (share n6)
  #   M12(A)-M13(B): VPWR-n7-n3 (share n7)
  #   M8(n3): VPWR-[n3]-X (standalone)
  #
  # PMOS gate order needed: A C | C B | A B | n3
  #
  # Common order: A B C n3 | A C B n3
  # NMOS: A B | A C | B C | n3 -> g1(A) g2(B) | g5(A) g6(C) | g7(B) g8(C) | ... n3?
  #   But n3 is at g4 and g8. M3 needs gate n3.
  #   With order A B C n3 | A C B n3:
  #   g1(A) g2(B) g3(C) g4(n3) g5(A) g6(C) g7(B) g8(n3)
  #   NMOS islands:
  #     nd1: g1(A)-g2(B) = M4-M1: VGND-[A]-n2-[B]-n3
  #     nd2: g5(A)-g6(C) = M5-M10: VGND-[A]-n5-[C]-n3
  #     nd3: g7(B)-g3(C)? No, g3 is before g4. Can't go back.
  #     
  #   Hmm, the islands need to be in gate order. Let me try:
  #   nd1: g1(A)-g2(B) = M4-M1
  #   nd2: g3(C) = M9 (standalone: n4-[C]-VGND)
  #   nd3: g5(A)-g6(C) = M5-M10: VGND-[A]-n5-[C]-n3
  #   nd4: g7(B) = M2 (standalone: n3-[B]-n4)
  #   nd5: g4(n3) or g8(n3) = M3 (standalone: VGND-[n3]-X)
  #
  #   But M2 needs to connect to n3 and n4. As standalone: left=n3, right=n4.
  #   M9 needs left=n4, right=VGND. As standalone.
  #   
  #   These are separate islands, so no connection between them needed.
  #
  # PMOS with order A B C n3 | A C B n3:
  #   g1(A) g2(B) g3(C) g4(n3) g5(A) g6(C) g7(B) g8(n3)
  #   PMOS islands:
  #     pd1: g1(A)-g3(C)? Not adjacent. 
  #     pd1: g1(A) = M0 (standalone: VPWR-[A]-n1)
  #     pd2: g3(C)-g2(B)? Not in order.
  #     
  #   This is getting complicated because the sharing patterns don't align with a single gate order.

  # Let me just use a simple approach: each transistor is its own island.
  # Gate order: A B C n3 A B C n3 (each net appears twice)
  #
  # NMOS:
  #   g1(A): M4 standalone (d=VGND, s=n2): left=VGND, right=n2
  #   g2(B): M1 standalone (d=n2, s=n3): left=n2, right=n3
  #   g3(C): M9 standalone (d=n4, s=VGND): left=n4, right=VGND
  #   g4(n3): M3 standalone (d=VGND, s=X): left=VGND, right=X
  #   g5(A): M5 standalone (d=n5, s=VGND): left=VGND, right=n5
  #   g6(B): M2 standalone (d=n3, s=n4): left=n3, right=n4
  #   g7(C): M10 standalone (d=n3, s=n5): left=n3, right=n5
  #   g8(n3): (nothing, or M3 again? No, each transistor once)
  #
  # PMOS:
  #   g1(A): M0 standalone (d=n1, s=VPWR): left=VPWR, right=n1
  #   g2(B): M6 standalone (d=n3, s=n6): left=n6, right=n3
  #   g3(C): M7 standalone (d=n6, s=VPWR): left=VPWR, right=n6
  #   g4(n3): M8 standalone (d=VPWR, s=X): left=VPWR, right=X
  #   g5(A): M12 standalone (d=VPWR, s=n7): left=n7, right=VPWR
  #   g6(B): M13 standalone (d=n7, s=n3): left=n3, right=n7
  #   g7(C): M11 standalone (d=n3, s=n1): left=n1, right=n3
  #   g8(n3): (nothing)
  #
  # This works! Each transistor is its own island. The routing will connect everything.
  # But it's a lot of area. Let me try to share where possible.
  #
  # Actually, let me try sharing adjacent transistors that share a net:
  # NMOS: M4(A)-M1(B) share n2. M5(A)-M10(C) share n5. M2(B)-M9(C) share n4.
  # PMOS: M0(A)-M11(C) share n1. M7(C)-M6(B) share n6. M12(A)-M13(B) share n7.
  #
  # Gate order: A B | A C | B C | n3 | A C | C B | A B | n3
  # That's 14 gates. Too many.
  #
  # Let me try: A B C n3 | A B C n3 with selective sharing:
  # NMOS:
  #   nd1: g1(A)-g2(B) = M4-M1: VGND-[A]-n2-[B]-n3
  #   nd2: g3(C) = M9: n4-[C]-VGND (standalone)
  #   nd3: g5(A)-g6(C) = M5-M10: VGND-[A]-n5-[C]-n3
  #   nd4: g7(B) = M2: n3-[B]-n4 (standalone)
  #   nd5: g8(n3) = M3: VGND-[n3]-X (standalone)
  #   g4(n3) unused? Or use g4 for M3 and g8 for nothing.
  #
  # PMOS:
  #   pd1: g1(A)-g3(C) = M0-M11: VPWR-[A]-n1-[C]-n3 (but g2 is between them!)
  #   Can't skip g2. So M0 and M11 can't share if there's a gate between them.
  #
  # OK, I think the cleanest approach is to use the gate order from the verified examples
  # pattern. Let me try: A B C n3 A B C n3 and accept some standalone transistors.

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  # Gate positions (same order on both rows): A B C n3 | A B C n3
  g1 = rect poly w=L left=(cell.left + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C
  g4 = rect poly w=L left=(g3.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3 (break)
  g5 = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g6 = rect poly w=L left=(g5.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g7 = rect poly w=L left=(g6.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C
  g8 = rect poly w=L left=(g7.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3 (break)

  # NMOS diffusion islands (each transistor separate for simplicity)
  nd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(ny0, ny0 + WN2)   # M4
  nd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)   # M1
  nd3 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN2)   # M9
  nd4 = rect diff xspan=(g4.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)    # M3
  nd5 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN2)   # M5
  nd6 = rect diff xspan=(g6.left - 0.265, g6.right + 0.265) yspan=(ny0, ny0 + WN2)   # M2
  nd7 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN2)   # M10

  # PMOS diffusion islands (each transistor separate)
  pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP2, py1)   # M0
  pd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(py1 - WP2, py1)   # M6
  pd3 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP2, py1)   # M7
  pd4 = rect diff xspan=(g4.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)    # M8
  pd5 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(py1 - WP2, py1)   # M12
  pd6 = rect diff xspan=(g6.left - 0.265, g6.right + 0.265) yspan=(py1 - WP2, py1)   # M13
  pd7 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(py1 - WP2, py1)   # M11

  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6, nd7] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7] psdm

  # NMOS contacts
  # nd1: M4 (d=VGND, g=A, s=n2)
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2

  # nd2: M1 (d=n2, g=B, s=n3)
  c3 = array licon in=nd2 left_of=g2
  c3l = enclose c3 li net=n2
  c4 = array licon in=nd2 right_of=g2
  c4l = enclose c4 li net=n3

  # nd3: M9 (d=n4, g=C, s=VGND)
  c5 = array licon in=nd3 left_of=g3
  c5l = enclose c5 li net=n4
  c6 = array licon in=nd3 right_of=g3
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li

  # nd4: M3 (d=VGND, g=n3, s=X)
  c7 = array licon in=nd4 left_of=g4
  c7l = enclose c7 li net=VGND
  c7s = strap li from=c7l to=vgnd_li
  c8 = array licon in=nd4 right_of=g4
  c8l = enclose c8 li net=X

  # nd5: M5 (d=n5, g=A, s=VGND)
  c9 = array licon in=nd5 left_of=g5
  c9l = enclose c9 li net=VGND
  c9s = strap li from=c9l to=vgnd_li
  c10 = array licon in=nd5 right_of=g5
  c10l = enclose c10 li net=n5

  # nd6: M2 (d=n3, g=B, s=n4)
  c11 = array licon in=nd6 left_of=g6
  c11l = enclose c11 li net=n3
  c12 = array licon in=nd6 right_of=g6
  c12l = enclose c12 li net=n4

  # nd7: M10 (d=n3, g=C, s=n5)
  c13 = array licon in=nd7 left_of=g7
  c13l = enclose c13 li net=n3
  c14 = array licon in=nd7 right_of=g7
  c14l = enclose c14 li net=n5

  # PMOS contacts
  # pd1: M0 (d=n1, g=A, s=VPWR)
  c15 = array licon in=pd1 left_of=g1
  c15l = enclose c15 li net=VPWR
  c15s = strap li from=c15l to=vpwr_li
  c16 = array licon in=pd1 right_of=g1
  c16l = enclose c16 li net=n1

  # pd2: M6 (d=n3, g=B, s=n6)
  c17 = array licon in=pd2 left_of=g2
  c17l = enclose c17 li net=n6
  c18 = array licon in=pd2 right_of=g2
  c18l = enclose c18 li net=n3

  # pd3: M7 (d=n6, g=C, s=VPWR)
  c19 = array licon in=pd3 left_of=g3
  c19l = enclose c19 li net=VPWR
  c19s = strap li from=c19l to=vpwr_li
  c20 = array licon in=pd3 right_of=g3
  c20l = enclose c20 li net=n6

  # pd4: M8 (d=VPWR, g=n3, s=X)
  c21 = array licon in=pd4 left_of=g4
  c21l = enclose c21 li net=VPWR
  c21s = strap li from=c21l to=vpwr_li
  c22 = array licon in=pd4 right_of=g4
  c22l = enclose c22 li net=X

  # pd5: M12 (d=VPWR, g=A, s=n7)
  c23 = array licon in=pd5 left_of=g5
  c23l = enclose c23 li net=VPWR
  c23s = strap li from=c23l to=vpwr_li
  c24 = array licon in=pd5 right_of=g5
  c24l = enclose c24 li net=n7

  # pd6: M13 (d=n7, g=B, s=n3)
  c25 = array licon in=pd6 left_of=g6
  c25l = enclose c25 li net=n3
  c26 = array licon in=pd6 right_of=g6
  c26l = enclose c26 li net=n7

  # pd7: M11 (d=n3, g=C, s=n1)
  c27 = array licon in=pd7 left_of=g7
  c27l = enclose c27 li net=n1
  c28 = array licon in=pd7 right_of=g7
  c28l = enclose c28 li net=n3

  # Gate contacts (cb from n-row items only)
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, nd4.top + 0.19,
           nd5.top + 0.19, nd6.top + 0.19, nd7.top + 0.19,
           c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25,
           c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25,
           c9l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25, c12l.top + 0.25,
           c13l.top + 0.25, c14l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=C
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=n3
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=A
  gc6 = contact licon cx=g6.cx bottom=cb
  gp6 = enclose gc6 poly by=minx
  gl6 = enclose gc6 li net=B
  gc7 = contact licon cx=g7.cx bottom=cb
  gp7 = enclose gc7 poly by=minx
  gl7 = enclose gc7 li net=C
  gc8 = contact licon cx=g8.cx bottom=cb
  gp8 = enclose gc8 poly by=minx
  gl8 = enclose gc8 li net=n3
  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7, gc8] npc

  well y=((max(nd1.top, nd2.top, nd3.top, nd4.top, nd5.top, nd6.top, nd7.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom, pd4.bottom, pd5.bottom, pd6.bottom, pd7.bottom) - 0.18) / 2)

  # Ports
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
  port X out

  # Routes
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route n6 layers=m1,m2 prefer=m2
  route n7 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
  route C layers=m1,m2 prefer=m2
end
