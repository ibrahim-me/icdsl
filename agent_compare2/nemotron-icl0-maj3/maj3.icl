pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=28 height=H
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

  # ===== NMOS row (bottom) =====
  # M4: g=A, d=VGND, s=n2
  nd4 = rect diff w=(L+0.53) h=WN2 left=0.23 above=ptap space=0.6
  g4  = cross nd4 poly w=L ext=0.25
  c4s = array licon in=nd4 right_of=g4 space=min
  c4d = array licon in=nd4 left_of=g4 space=min
  c4sl = enclose c4s li
  c4dl = enclose c4d li

  # M1: g=B, d=n2, s=n3
  nd1 = rect diff w=(L+0.53) h=WN2 right_of=nd4 space=0.6
  g1  = cross nd1 poly w=L ext=0.25
  c1s = array licon in=nd1 right_of=g1 space=min
  c1d = array licon in=nd1 left_of=g1 space=min
  c1sl = enclose c1s li
  c1dl = enclose c1d li

  # M2: g=B, d=n3, s=n4
  nd2 = rect diff w=(L+0.53) h=WN2 right_of=nd1 space=0.6
  g2  = cross nd2 poly w=L ext=0.25
  c2s = array licon in=nd2 right_of=g2 space=min
  c2d = array licon in=nd2 left_of=g2 space=min
  c2sl = enclose c2s li
  c2dl = enclose c2d li

  # M9: g=C, d=n4, s=VGND
  nd9 = rect diff w=(L+0.53) h=WN2 right_of=nd2 space=0.6
  g9  = cross nd9 poly w=L ext=0.25
  c9s = array licon in=nd9 right_of=g9 space=min
  c9d = array licon in=nd9 left_of=g9 space=min
  c9sl = enclose c9s li
  c9dl = enclose c9d li

  # M5: g=A, d=n5, s=VGND
  nd5 = rect diff w=(L+0.53) h=WN2 right_of=nd9 space=0.6
  g5  = cross nd5 poly w=L ext=0.25
  c5s = array licon in=nd5 right_of=g5 space=min
  c5d = array licon in=nd5 left_of=g5 space=min
  c5sl = enclose c5s li
  c5dl = enclose c5d li

  # M10: g=C, d=n3, s=n5
  nd10 = rect diff w=(L+0.53) h=WN2 right_of=nd5 space=0.6
  g10 = cross nd10 poly w=L ext=0.25
  c10s = array licon in=nd10 right_of=g10 space=min
  c10d = array licon in=nd10 left_of=g10 space=min
  c10sl = enclose c10s li
  c10dl = enclose c10d li

  # M3: g=n3, d=VGND, s=X (W=WN=0.49)
  nd3 = rect diff w=(L+0.53) h=WN right_of=nd10 space=0.6
  g3  = cross nd3 poly w=L ext=0.25
  c3s = array licon in=nd3 right_of=g3 space=min
  c3d = array licon in=nd3 left_of=g3 space=min
  c3sl = enclose c3s li
  c3dl = enclose c3d li

  nim = enclose [nd4, nd1, nd2, nd9, nd5, nd10, nd3] nsdm

  # ===== PMOS row (top) =====
  # M12: g=A, d=VPWR, s=n7
  pd12 = rect diff w=(L+0.53) h=WP2 left=0.23 below=ntap space=0.6
  g12  = cross pd12 poly w=L ext=0.25
  c12s = array licon in=pd12 right_of=g12 space=min
  c12d = array licon in=pd12 left_of=g12 space=min
  c12sl = enclose c12s li
  c12dl = enclose c12d li

  # M13: g=B, d=n7, s=n3
  pd13 = rect diff w=(L+0.53) h=WP2 right_of=pd12 space=0.6
  g13  = cross pd13 poly w=L ext=0.25
  c13s = array licon in=pd13 right_of=g13 space=min
  c13d = array licon in=pd13 left_of=g13 space=min
  c13sl = enclose c13s li
  c13dl = enclose c13d li

  # M0: g=A, d=n1, s=VPWR
  pd0 = rect diff w=(L+0.53) h=WP2 right_of=pd13 space=0.6
  g0  = cross pd0 poly w=L ext=0.25
  c0s = array licon in=pd0 right_of=g0 space=min
  c0d = array licon in=pd0 left_of=g0 space=min
  c0sl = enclose c0s li
  c0dl = enclose c0d li

  # M11: g=C, d=n3, s=n1
  pd11 = rect diff w=(L+0.53) h=WP2 right_of=pd0 space=0.6
  g11 = cross pd11 poly w=L ext=0.25
  c11s = array licon in=pd11 right_of=g11 space=min
  c11d = array licon in=pd11 left_of=g11 space=min
  c11sl = enclose c11s li
  c11dl = enclose c11d li

  # M7: g=C, d=n6, s=VPWR
  pd7 = rect diff w=(L+0.53) h=WP2 right_of=pd11 space=0.6
  g7  = cross pd7 poly w=L ext=0.25
  c7s = array licon in=pd7 right_of=g7 space=min
  c7d = array licon in=pd7 left_of=g7 space=min
  c7sl = enclose c7s li
  c7dl = enclose c7d li

  # M6: g=B, d=n3, s=n6
  pd6 = rect diff w=(L+0.53) h=WP2 right_of=pd7 space=0.6
  g6  = cross pd6 poly w=L ext=0.25
  c6s = array licon in=pd6 right_of=g6 space=min
  c6d = array licon in=pd6 left_of=g6 space=min
  c6sl = enclose c6s li
  c6dl = enclose c6d li

  # M8: g=n3, d=VPWR, s=X (W=WP=0.75)
  pd8 = rect diff w=(L+0.53) h=WP right_of=pd6 space=0.6
  g8  = cross pd8 poly w=L ext=0.25
  c8s = array licon in=pd8 right_of=g8 space=min
  c8d = array licon in=pd8 left_of=g8 space=min
  c8sl = enclose c8s li
  c8dl = enclose c8d li

  pim = enclose [pd12, pd13, pd0, pd11, pd7, pd6, pd8] psdm

  well y=((nd4.top + 0.34 + pd12.bottom - 0.18) / 2)

end