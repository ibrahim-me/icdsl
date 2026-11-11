# generator for maj3_1.icl: one diffusion island per device, one poly column per gate (n3, A, B, B, C, A, C)
cols = [
 (1, 'n3', ('VGND', 'X'), ('VPWR', 'X'), 'WN', 'WP'),
 (2, 'A',  ('VGND', 'n2'), ('VPWR', 'n7'), 'WN2', 'WP2'),
 (3, 'B',  ('n2', 'n3'), ('n7', 'n3'), 'WN2', 'WP2'),
 (4, 'B',  ('n3', 'n4'), ('n3', 'n6'), 'WN2', 'WP2'),
 (5, 'C',  ('n4', 'VGND'), ('n6', 'VPWR'), 'WN2', 'WP2'),
 (6, 'A',  ('n5', 'VGND'), ('n1', 'VPWR'), 'WN2', 'WP2'),
 (7, 'C',  ('n3', 'n5'), ('n3', 'n1'), 'WN2', 'WP2'),
]
out = []
w = out.append
w("""# maj3_1: one diffusion island per device (no shared nodes). Each island end has its own licon and
# li pad; internal nets get an explicit mcon + met1 pad (clear of the rails) and are joined with route.
# Gate columns: n3, A, B, B, C, A, C (the n and p device of a column share one poly stripe).
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=18 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3 b=VNB
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5 b=VNB
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3 b=VPB

  pz = L + 0.83
  x1 = 0.42
""")
for j in range(2, 8):
    w(f"  x{j} = x{j-1} + pz")
w("""  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  yg1 = nb + WN + 0.277              # gate contact of col 1 (n3): between the big n and p devices
  ya = pt - WP2 - 0.37               # gate contacts of the A columns (high, near the p row)
  yb = nb + WN2 + 0.345              # gate contacts of the B and C columns (low, near the n row)
  cn1 = nb + WN / 2                  # node contact heights
  cn = nb + WN2 / 2 + 0.045
  cm1 = cn1 + 0.07                   # met1 pad heights (clear of the VGND rail)
  cm = cn + 0.07
  cp1 = pt - WP / 2
  cp = pt - WP2 / 2 - 0.045
  cq1 = cp1 - 0.09                   # met1 pad heights (clear of the VPWR rail)
  cq = cp - 0.09
""")
nd, pd = [], []
for (j, g, n, p, wn, wp) in cols:
    yg = 'yg1' if j == 1 else ('ya' if g == 'A' else 'yb')
    cn = 'cn1' if j == 1 else 'cn'
    cm = 'cm1' if j == 1 else 'cm'
    cp = 'cp1' if j == 1 else 'cp'
    cq = 'cq1' if j == 1 else 'cq'
    nd.append(f"nd{j}"); pd.append(f"pd{j}")
    w(f"  # column {j}: gate {g}; n device {n[0]}-{n[1]} ({wn}), p device {p[0]}-{p[1]} ({wp})")
    w(f"  nd{j} = rect diff xspan=(x{j} - 0.265, x{j} + L + 0.265) yspan=(nb, nb + {wn})")
    w(f"  pd{j} = rect diff xspan=(x{j} - 0.265, x{j} + L + 0.265) yspan=(pt - {wp}, pt)")
    w(f"  pg{j} = rect poly xspan=(x{j}, x{j} + L) yspan=(0.105, H - 0.105)")
    w(f"  gp{j} = rect poly xspan=(x{j} - 0.06, x{j} + L + 0.06) yspan=({yg} - 0.17, {yg} + 0.17)")
    w(f"  gc{j} = contact licon cx=(x{j} + L / 2) cy={yg}")
    w(f"  gl{j} = rect li xspan=(x{j} + L / 2 - 0.165, x{j} + L / 2 + 0.165) yspan=({yg} - 0.165, {yg} + 0.165) net={g}")
    w(f"  gm{j} = contact mcon in=gl{j}")
    w(f"  gmp{j} = enclose gm{j} m1 by=0.06 net={g}")
    w(f"  gn{j} = rect npc xspan=(x{j} - 0.1, x{j} + L + 0.1) yspan=({yg} - 0.17, {yg} + 0.17)")
    for side, net, cx, xs in (('a', n[0], f"(x{j} - 0.14)", f"(x{j} - 0.305, x{j} - 0.025)"),
                              ('b', n[1], f"(x{j} + L + 0.14)", f"(x{j} + L + 0.025, x{j} + L + 0.305)")):
        w(f"  nc{j}{side} = contact licon cx={cx} cy={cn}")
        if net == 'VGND':
            w(f"  nl{j}{side} = rect li xspan={xs} yspan=(-0.085, {cn} + 0.165) net=VGND")
            w(f"  nm{j}{side} = contact mcon cx={cx} cy=0")
        else:
            w(f"  nl{j}{side} = rect li xspan={xs} yspan=({cn} - 0.165, {cm} + 0.1) net={net}")
            w(f"  nm{j}{side} = contact mcon cx={cx} cy={cm}")
            w(f"  nmp{j}{side} = enclose nm{j}{side} m1 by=0.06 net={net}")
    for side, net, cx, xs in (('a', p[0], f"(x{j} - 0.14)", f"(x{j} - 0.305, x{j} - 0.025)"),
                              ('b', p[1], f"(x{j} + L + 0.14)", f"(x{j} + L + 0.025, x{j} + L + 0.305)")):
        w(f"  pc{j}{side} = contact licon cx={cx} cy={cp}")
        if net == 'VPWR':
            w(f"  pl{j}{side} = rect li xspan={xs} yspan=({cp} - 0.165, H + 0.085) net=VPWR")
            w(f"  pm{j}{side} = contact mcon cx={cx} cy=H")
        else:
            w(f"  pl{j}{side} = rect li xspan={xs} yspan=({cq} - 0.1, {cp} + 0.165) net={net}")
            w(f"  pm{j}{side} = contact mcon cx={cx} cy={cq}")
            w(f"  pmp{j}{side} = enclose pm{j}{side} m1 by=0.06 net={net}")
w("  nim = enclose [" + ", ".join(nd) + "] nsdm")
w("  pim = enclose [" + ", ".join(pd) + "] psdm")
w("  well y=((nb + WN + 0.34 + pt - WP - 0.18) / 2)")
w("  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells")
w("  # routing of the internal nets (their met1 pads carry the net labels)")
for net in ["A", "B", "C", "n3", "X", "n1", "n2", "n4", "n5", "n6", "n7"]:
    w(f"  route {net} layers=m1,m2")
w("  port A in on=gmp2")
w("  port B in on=gmp3")
w("  port C in on=gmp5")
w("  port X out on=nmp1b")
w("end")
open('/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-maj3_1/maj3_1.icl', 'w').write("\n".join(out) + "\n")
