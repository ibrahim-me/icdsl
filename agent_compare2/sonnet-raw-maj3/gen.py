import klayout.db as db
ly=db.Layout(); ly.dbu=0.001
top=ly.create_cell("maj3")
L={n:ly.layer(a,b) for n,(a,b) in dict(nwell=(64,20),diff=(65,20),tap=(65,44),poly=(66,20),licon=(66,44),npc=(95,20),
 nsdm=(93,44),psdm=(94,20),li=(67,20),mcon=(67,44),met1=(68,20),via=(68,44),met2=(69,20),
 lil=(67,5),lip=(67,16),m1l=(68,5),m1p=(68,16)).items()}
def R(l,x1,y1,x2,y2): top.shapes(L[l]).insert(db.Box(round(x1/.001),round(y1/.001),round(x2/.001),round(y2/.001)))
def C(l,x,y,w=0.17,h=0.17): R(l,x-w/2,y-h/2,x+w/2,y+h/2)
def T(l,x,y,s): top.shapes(L[l]).insert(db.Text(s,db.Trans(round(x/.001),round(y/.001))))
W=7.82
gx=[0.92+0.92*i for i in range(6)]
cx=[0.46+0.92*i for i in range(7)]
# rails, taps
R('met1',0,-0.24,W,0.24); R('met1',0,2.48,W,2.96)
R('tap',0.18,-0.125,W-0.18,0.125); R('psdm',0,-0.25,W,0.25)
R('tap',0.18,2.595,W-0.18,2.845); R('nsdm',0,2.45,W,2.97)
R('li',0.375,-0.165,W-0.375,0.165); R('li',0.375,2.555,W-0.375,2.885)
x=0.46
while x<W-0.4:
    for y in (0,2.72):
        C('licon',x,y); C('mcon',x,y)
    x+=0.46
R('nwell',0,1.3,W,3.03)
# diffusion strips
R('diff',0.335,0.4,6.105,0.82); R('diff',0.335,1.905,6.105,2.325)
R('diff',6.395,0.4,7.565,0.89); R('diff',6.395,1.575,7.565,2.325)
R('nsdm',0.21,0.25,7.69,1.015); R('psdm',0.21,1.45,7.69,2.45)
# gate polys
for g in gx+[6.98]: R('poly',g-0.075,0.27,g+0.075,2.455)
# strip contacts
def col(x,y): C('licon',x,y)
VG=[0,4]; N3=[2,6]
for i in VG:
    col(cx[i],0.61); R('li',cx[i]-0.085,0.0,cx[i]+0.085,0.775)
    col(cx[i],2.115); R('li',cx[i]-0.085,1.95,cx[i]+0.085,2.72)
for i in N3:
    col(cx[i],0.61); col(cx[i],2.115); R('li',cx[i]-0.085,0.445,cx[i]+0.085,2.28)
# M3/M8
col(6.52,0.61); R('li',6.435,0,6.605,0.775)
col(6.52,2.115); R('li',6.435,1.95,6.605,2.72)
col(7.44,0.61); col(7.44,2.115); R('li',7.355,0.445,7.525,2.28)
C('mcon',7.44,1.46); R('met1',7.31,1.29,7.57,1.63)
# n3 link
R('li',2.215,0.945,7.065,1.115)
C('licon',6.98,1.19); R('li',6.895,0.945,7.065,1.355)
R('poly',6.815,1.055,7.145,1.325); R('npc',6.795,0.955,7.165,1.425)
# A/B/C pads
trk={'A':1.46,'B':1.86,'C':1.06}
pads=[('A',0),('C',1),('B',2),('C',3),('A',4),('B',5)]
ext={}
for n,i in pads:
    x=gx[i]; y=1.46
    C('licon',x,y); R('poly',x-0.165,y-0.135,x+0.165,y+0.135); R('npc',x-0.185,y-0.185,x+0.185,y+0.185)
    R('li',x-0.085,y-0.17,x+0.085,y+0.17); C('mcon',x,y)
    ty=trk[n]
    R('met1',x-0.13,min(y,ty)-0.17,x+0.13,max(y,ty)+0.17)
    C('via',x,ty,0.15,0.15)
    ext.setdefault(n,[]).append(x)
for n,xs in ext.items():
    R('met2',min(xs)-0.16,trk[n]-0.13,max(xs)+0.16,trk[n]+0.13)
# pins/labels
for n in ('A','B','C'):
    x=ext[n][0]
    T('m1l',x,1.46,n); T('m1p',x,1.46,n); R('m1p',x-0.13,1.29,x+0.13,1.63)
T('m1l',7.44,1.46,'X'); T('m1p',7.44,1.46,'X'); R('m1p',7.31,1.29,7.57,1.63)
for n,y in (('VGND',0),('VPWR',2.72)):
    T('m1l',3.9,y,n); T('m1p',3.9,y,n); R('m1p',0,y-0.24,W,y+0.24)
ly.write("maj3.gds")
