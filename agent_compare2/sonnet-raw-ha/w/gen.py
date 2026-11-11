import klayout.db as db
L=db.Layout(); L.dbu=0.001
top=L.create_cell("ha")
SH=0.12; W=7.36
ly={n:L.layer(a,b) for n,(a,b) in dict(nwell=(64,20),diff=(65,20),tap=(65,44),poly=(66,20),licon=(66,44),npc=(95,20),nsdm=(93,44),psdm=(94,20),li=(67,20),mcon=(67,44),met1=(68,20),via=(68,44),met2=(69,20),
 lil=(67,5),m1l=(68,5),m1p=(68,16)).items()}
def R(n,x1,y1,x2,y2,sh=True):
    if sh: x1+=SH; x2+=SH
    top.shapes(ly[n]).insert(db.Box(round(x1*1000),round(y1*1000),round(x2*1000),round(y2*1000)))
def Rc(n,cx,cy,w,h,sh=True): R(n,cx-w/2,cy-h/2,cx+w/2,cy+h/2,sh)
def T(n,s,x,y): top.shapes(ly[n]).insert(db.Text(s,round((x+SH)*1000),round(y*1000)))
def licon(x,y): Rc('licon',x,y,.17,.17)
def mcon(x,y): Rc('mcon',x,y,.17,.17)
# frame (no shift)
R('nwell',0,1.30,W,3.10,False)
R('psdm',0,-.275,W,.275,False); R('nsdm',0,.275,W,1.015,False)
R('psdm',0,1.445,W,2.47,False); R('nsdm',0,2.47,W,2.97,False)
R('tap',.2,-.125,W-.2,.125,False); R('tap',.2,2.595,W-.2,2.845,False)
R('met1',0,-.24,W,.24,False); R('met1',0,2.48,W,2.96,False)
R('li',0,-.085,W,.085,False); R('li',0,2.635,W,2.805,False)
for x in (.6,1.8,3.0,4.2,5.4,6.6):
    for y in (0,2.72):
        Rc('licon',x,y,.17,.17,False); Rc('mcon',x,y,.17,.17,False)
# diffusions
ND=[(.40,1.76,.42),(2.28,3.64,.42),(4.16,4.84,.42),(5.36,6.72,.49)]
for a,b,w in ND: R('diff',a-.125,.40,b+.125,.40+w)
PD=[(.40,4.84,.42),(5.36,6.72,.75)]
for a,b,w in PD: R('diff',a-.125,2.32-w,b+.125,2.32)
# gates
G={1:.74,2:1.42,3:2.62,4:3.30,5:4.50,6:5.70,7:6.38}
GL={1:1.2,2:1.37,3:1.2,4:1.37,5:1.2,6:1.2,7:1.2}
for i,x in G.items():
    R('poly',x-.075,.27,x+.075,2.45)
    Rc('poly',x,GL[i],.27,.33); licon(x,GL[i]); Rc('npc',x,GL[i],.37,.37)
# tracks y
T1,T2,T3,T4=1.00,1.37,1.74,2.11
def pad(x,y): Rc('met1',x,y,.29,.23); mcon(x,y)
def track(x1,x2,y):
    R('met1',x1-.145,y-.115,x2+.145,y+.115)
def li(x,y1,y2): R('li',x-.085,y1,x+.085,y2)
# gate strips
gt={1:T4,2:T2,3:T4,4:T2,5:T3,6:T3,7:T2}
for i,x in G.items():
    y=gt[i]; li(x,min(GL[i],y)-.165,max(GL[i],y)+.165); pad(x,y)
track(G[1],G[3],T4); track(G[2],G[4],T2)
# contacts
def N(x,yc=.61): licon(x,yc)
for x in (.40,2.28,3.64): N(x)
N(6.04,.645)
for x in (1.76,2.96,4.16,4.84): N(x)
N(5.36,.645); N(6.72,.645)
def P(x,yc=2.11): licon(x,yc)
for x in (.40,2.10,4.84,1.08,3.80): P(x)
for x in (5.36,6.04,6.72): P(x,1.945)
# GND stubs
for x,yc in ((.40,.61),(2.28,.61),(3.64,.61),(6.04,.645)): li(x,0,yc+.165)
# VPWR stubs
for x,yc in ((.40,2.11),(2.10,2.11),(4.84,2.11),(6.04,1.945)): li(x,yc-.165,2.72)
# n1
li(1.76,.445,T3+.165); pad(1.76,T3); li(1.08,T3-.165,2.275); pad(1.08,T3); track(1.08,5.70,T3)
# n4
li(2.96,.445,T1+.165); pad(2.96,T1); li(4.84,.445,T1+.165); pad(4.84,T1); track(2.96,4.84,T1)
# n3
li(4.16,.445,T2+.165); pad(4.16,T2); li(3.80,T2-.165,2.275); pad(3.80,T2); track(3.80,6.38,T2)
# COUT SUM
for x,nm in ((5.36,'COUT'),(6.72,'SUM')):
    li(x,.48,2.11); mcon(x,.85)
    Rc('met1',x,.85,.23,.37)
    R('m1p',x-.115,.85-.185,x+.115,.85+.185); T('m1p',nm,x,.85); T('m1l',nm,x,.85)
# pins A B
for nm,x,y in (('A',G[1],T4),('B',G[2],T2)):
    R('m1p',x-.145,y-.115,x+.145,y+.115); T('m1p',nm,x,y); T('m1l',nm,x,y)
R('m1p',.1,-.24,.7,.24,False); T('m1p','VGND',.4,0); T('m1l','VGND',.4,0)
R('m1p',.1,2.48,.7,2.96,False); T('m1p','VPWR',.4,2.72); T('m1l','VPWR',.4,2.72)
for t in (top,): pass
L.write("../ha.gds")
