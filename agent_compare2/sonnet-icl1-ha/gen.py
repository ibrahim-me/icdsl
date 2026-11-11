# generator for ha.icl
gaps=[("c","max(0.28, 0.54 - L)"),("b","0.80"),("b","0.80"),("b","0.80"),("b","0.80"),("s","max(0.21, 0.54 - L)")]
gnet=["A","B","n3","n1","n1","B","A"]
o=[]
o.append("pdk sky130A\nparam L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42\n\nstdcell ha width=16 height=H")
devs="""  device M0 nmos w=WN2 l=L d=n1 g=B s=n2
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
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1"""
o.append(devs)
o.append("  ny0 = ptap.top + 0.27\n  py1 = ntap.bottom - 0.27")
span="0.53 + 7*L + "+" + ".join(g for _,g in gaps)
o.append("  span = "+span+"\n  x0 = cell.cx - span/2")
o.append("  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)")
for i in range(2,8):
    o.append(f"  g{i} = rect poly w=L left=(g{i-1}.right + {gaps[i-2][1]}) yspan=(ny0 - 0.13, py1 + 0.13)")
# islands: name, kind, width, first gate, last gate
ni=[("Na","WN2",1,2),("Nb","WN",3,3),("Nc","WN2",4,4),("Nd","WN",5,5),("Ne","WN2",6,7)]
pi=[("Pa","WP2",1,2),("Pb","WP",3,4),("Pc","WP2",5,7)]
for n,w,a,b in ni:
    o.append(f"  {n} = rect diff xspan=(g{a}.left - 0.265, g{b}.right + 0.265) yspan=(ny0, ny0 + {w})")
for n,w,a,b in pi:
    o.append(f"  {n} = rect diff xspan=(g{a}.left - 0.265, g{b}.right + 0.265) yspan=(py1 - {w}, py1)")
o.append("  nim = enclose ["+", ".join(n for n,*_ in ni)+"] nsdm")
o.append("  pim = enclose ["+", ".join(n for n,*_ in pi)+"] psdm")
# contacts: (island, side, gate-or-pair, net)
cols=[
 ("Na","left_of=g1","VGND"),("Na","between=[g1, g2]","n4"),("Na","right_of=g2","VGND"),
 ("Nb","left_of=g3","VGND"),("Nb","right_of=g3","SUM"),
 ("Nc","left_of=g4","n3"),("Nc","right_of=g4","n4"),
 ("Nd","left_of=g5","VGND"),("Nd","right_of=g5","COUT"),
 ("Ne","left_of=g6","n1"),("Ne","right_of=g7","VGND"),
 ("Pa","left_of=g1","n1"),("Pa","between=[g1, g2]","VPWR"),("Pa","right_of=g2","n1"),
 ("Pb","left_of=g3","SUM"),("Pb","between=[g3, g4]","VPWR"),("Pb","right_of=g4","COUT"),
 ("Pc","left_of=g5","VPWR"),("Pc","between=[g5, g6]","n3"),("Pc","right_of=g7","VPWR"),
]
nl=[]
for k,(isl,pos,net) in enumerate(cols,1):
    o.append(f"  c{k} = array licon in={isl} {pos}")
    o.append(f"  c{k}l = enclose c{k} li net={net}")
    if net=="VGND": o.append(f"  c{k}s = strap li from=c{k}l to=vgnd_li")
    if net=="VPWR": o.append(f"  c{k}s = strap li from=c{k}l to=vpwr_li")
    if isl[0]=="N": nl.append(f"c{k}l")
cb="max("+", ".join(["Nb.top + 0.19"]+[f"{x}.top + 0.25" for x in nl])+")"
o.append("  cb = "+cb)
sh={}
for i in range(1,8):
    o.append(f"  gc{i} = contact licon cx=(g{i}.cx + {sh.get(i,0)}) bottom=cb")
    o.append(f"  gp{i} = enclose gc{i} poly by=minx")
    o.append(f"  gl{i} = enclose gc{i} li"+("" if i==4 else f" net={gnet[i-1]}"))
o.append("  gs45 = strap li from=gl4 to=gl5")
o.append("  gn = enclose ["+", ".join(f"gc{i}" for i in range(1,8))+"] npc")
o.append("  well y=((Nb.top + 0.34 + Pb.bottom - 0.18) / 2)")
o.append("  am = contact mcon in=gl1\n  ap = enclose am m1 by=0.06 net=A\n  port A in on=ap")
o.append("  bm = contact mcon in=gl2\n  bp = enclose bm m1 by=0.06 net=B\n  port B in on=bp")
o.append("  sm = contact mcon in=c5l\n  sp = enclose sm m1 by=0.06 net=SUM\n  port SUM out on=sp\n  om = contact mcon in=c9l\n  op = enclose om m1 by=0.06 net=COUT\n  port COUT out on=op")
for n in ["A","B","SUM","COUT","n1","n3","n4"]:
    o.append(f"  route {n} layers=m1,m2 prefer=m2")
o.append("end")
open("ha.icl","w").write("\n".join(o)+"\n")
