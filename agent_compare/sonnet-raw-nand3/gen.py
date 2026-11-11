import klayout.db as db
ly=db.Layout(); ly.dbu=0.001
top=ly.create_cell("nand3")
L={n:ly.layer(*a) for n,a in dict(nwell=(64,20),diff=(65,20),tap=(65,44),poly=(66,20),licon=(66,44),npc=(95,20),nsdm=(93,44),psdm=(94,20),li=(67,20),mcon=(67,44),met1=(68,20),lil=(67,5),pin=(68,16),m1l=(68,5)).items()}
def R(l,x0,y0,x1,y1): top.shapes(L[l]).insert(db.Box(round(x0*1000),round(y0*1000),round(x1*1000),round(y1*1000)))
def P(s,x,y):
    top.shapes(L['pin']).insert(db.Box(round(x*1000)-70,round(y*1000)-70,round(x*1000)+70,round(y*1000)+70)); top.shapes(L['pin']).insert(db.Text(s,round(x*1000),round(y*1000)))
def T(l,s,x,y): top.shapes(L[l]).insert(db.Text(s,round(x*1000),round(y*1000)))
def sq(l,cx,cy,s=0.17): R(l,cx-s/2,cy-s/2,cx+s/2,cy+s/2)
W=2.3
R('nwell',0,1.30,W,3.03)
R('diff',0.265,0.40,2.035,0.89)
R('diff',0.265,1.52,2.035,2.27)
R('tap',0.18,-0.125,2.12,0.125)
R('tap',0.18,2.595,2.12,2.845)
R('psdm',0.055,-0.25,2.245,0.25); R('nsdm',0.14,0.275,2.16,1.015)
R('psdm',0.14,1.395,2.16,2.395); R('nsdm',0.055,2.47,2.245,2.97)
gates={'C':0.605,'B':1.085,'A':1.565}
for n,gx in gates.items():
    R('poly',gx-0.075,0.27,gx+0.075,2.40)
    R('poly',gx-0.135,1.0,gx+0.135,1.33)
    sq('licon',gx,1.165); R('li',gx-0.085,1.0,gx+0.085,1.33)
    sq('mcon',gx,1.165); R('met1',gx-0.145,1.02,gx+0.145,1.31)
    T('m1l',n,gx,1.165); P(n,gx,1.165)
R('npc',0.42,0.98,1.75,1.35)
# tap strips
for y in (0,2.72):
    R('li',0.305,y-0.165,1.995,y+0.165)
    for x in (0.39,1.15,1.91): sq('licon',x,y); sq('mcon',x,y)
R('met1',0,-0.24,W,0.24); R('met1',0,2.48,W,2.96)
T('m1l','VGND',0.2,0); T('m1l','VPWR',0.2,2.72); P('VGND',0.2,0); P('VPWR',0.2,2.72)
# nmos contacts: left VGND, right Y
sq('licon',0.39,0.645); R('li',0.305,-0.165,0.475,0.815)
sq('licon',1.91,0.645)
# pmos
for x in (0.39,0.845,1.325,1.91):
    sq('licon',x,1.665); sq('licon',x,2.005)
    R('li',x-0.085,1.50,x+0.085,2.17)
R('li',0.305,2.17,0.475,2.72); R('li',1.24,2.17,1.41,2.72)
R('li',1.825,0.48,1.995,2.17)
# Y bridge
sq('mcon',0.845,1.835); sq('mcon',1.91,1.835)
R('met1',0.70,1.72,2.055,1.95)
T('m1l','Y',1.91,1.835); P('Y',1.91,1.835)
top.shapes(ly.layer(235,4)) if False else None
ly.write("/home/ibrahim/claude-workspace/icdsl/agent_compare/sonnet-raw-nand3/nand3.gds")
