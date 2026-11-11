import klayout.db as db
ly=db.Layout(); ly.dbu=0.001
top=ly.create_cell("ota5t_small")
L={'nwell':(64,20),'diff':(65,20),'tap':(65,44),'poly':(66,20),'licon':(66,44),'npc':(95,20),
'nsdm':(93,44),'psdm':(94,20),'li':(67,20),'mcon':(67,44),'met1':(68,20)}
def R(l,x1,y1,x2,y2):
    top.shapes(ly.layer(*L[l])).insert(db.Box(round(x1*1000),round(y1*1000),round(x2*1000),round(y2*1000)))
def T(layer,t,x,y):
    for lay in (layer,(layer[0],16)):
        top.shapes(ly.layer(*lay)).insert(db.Text(t,round(x*1000),round(y*1000)))
W=3.41
cx=[0.06+0.78*i for i in range(5)]
gx=[0.285+0.78*i for i in range(4)]
def row(yb,gates_up=0,gates_dn=0):
    R('diff',0,yb,W,yb+1.0)
    for i in range(4): R('poly',gx[i],yb-0.13,gx[i]+0.5,yb+1.13)
    for c in cx:
        for k in range(3):
            y=yb+0.08+0.34*k; R('licon',c,y,c+0.17,y+0.17)
def strip(i,y1,y2): R('li',cx[i],y1,cx[i]+0.17,y2)
def pad(x,yl,yh_poly=None):  # poly licon at x (left), licon y yl
    R('licon',x,yl,x+0.17,yl+0.17)
    R('npc',x-0.1,yl-0.1,x+0.27,yl+0.27)
    R('li',x,yl-0.085,x+0.17,yl+0.255)
yMT,yP,yQ=0.95,2.75,4.55
# ptap
R('tap',0,0,W,0.33)
for k in range(9): R('licon',0.12+0.34*k,0.08,0.29+0.34*k,0.25)
R('li',0,0,W,0.33); R('psdm',-0.125,-0.125,W+0.125,0.455)
# rows
row(yMT); row(yP); row(yQ)
R('nsdm',-0.125,yMT-0.125,W+0.125,yP+1.125)
R('psdm',-0.125,yQ-0.125,W+0.125,yQ+1.125)
# MT
R('poly',gx[0],0.50,gx[3]+0.5,0.82)
pad(1.205,0.585); T(L['li'],'VBN',1.29,0.67)
for i in (0,2,4): strip(i,0,yMT+1.01)
for i in (1,3): strip(i,yMT,yP+1.01)
# pair
for i in (1,3): R('mcon',cx[i],2.16,cx[i]+0.17,2.33)
R('met1',cx[1]-0.03,2.10,cx[3]+0.2,2.39)
R('poly',gx[1],2.30,gx[2]+0.5,2.62)
pad(1.205,2.39); T(L['li'],'INN',1.29,2.47)
for g in (0,3):
    R('poly',gx[g],yP+1.0,gx[g]+0.5,4.195)
    px=gx[g]+0.165; pad(px,3.94)
    R('mcon',px,3.94,px+0.17,4.11)
R('met1',0.42,3.88,2.99,4.17)
T((68,5),'INP',1.0,4.025)
for i in (0,4): strip(i,yP,6.045)
strip(2,yP,yQ+1.01)
# pmos
R('poly',gx[0],5.68,gx[3]+0.5,6.05)
pad(0.34,5.79); R('li',0.06,5.705,0.51,6.045)
pad(2.90,5.79); R('li',2.90,5.705,3.35,6.045)
for i in (1,3): strip(i,yQ,6.68)
T(L['li'],'OUT',1.705,4.0)
# ntap
R('tap',0,6.35,W,6.68)
for k in range(9): R('licon',0.12+0.34*k,6.43,0.29+0.34*k,6.60)
R('li',0,6.35,W,6.68); R('nsdm',-0.125,6.225,W+0.125,6.805)
R('nwell',-0.18,4.35,W+0.18,6.86)
T(L['li'],'VPWR',0.5,6.5); T(L['li'],'VGND',0.5,0.15)
ly.write("ota5t_small.gds")
