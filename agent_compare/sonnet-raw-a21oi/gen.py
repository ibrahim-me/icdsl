import klayout.db as db
ly=db.Layout(); ly.dbu=0.001
top=ly.create_cell("a21oi")
L={n:ly.layer(a,b) for n,(a,b) in dict(nwell=(64,20),diff=(65,20),tap=(65,44),poly=(66,20),licon=(66,44),npc=(95,20),nsdm=(93,44),psdm=(94,20),li=(67,20),mcon=(67,44),met1=(68,20),via=(68,44),met2=(69,20)).items()}
def R(l,x0,y0,x1,y1): top.shapes(L[l]).insert(db.Box(round(x0*1000),round(y0*1000),round(x1*1000),round(y1*1000)))
def T(l,t,x,y): top.shapes(ly.layer(*l)).insert(db.Text(t,round(x*1000),round(y*1000)))
# wells/implants
R('nwell',-.03,1.31,1.87,3.045)
R('diff',.15,.42,1.69,.91)      # nmos
R('diff',.15,1.555,1.69,2.305)  # pmos
R('tap',.07,-.145,1.77,.145)
R('tap',.15,2.575,1.69,2.865)
R('nsdm',.025,.295,1.815,1.035)
R('psdm',-.055,-.27,1.895,.27)
R('psdm',.025,1.43,1.815,2.43)
R('nsdm',.025,2.45,1.815,2.99)
# poly gates
for x in (.415,.845,1.275): R('poly',x,.29,x+.15,2.435)
R('poly',.305,1.07,.575,1.40); R('poly',.785,1.07,1.055,1.40); R('poly',1.275,1.07,1.545,1.40)
R('npc',.255,1.05,1.595,1.42)
def licon(x0,y0,mc=True,li=None):
    R('licon',x0,y0,x0+.17,y0+.17)
# diff contacts
cols=[.19,.62,1.05,1.48]
# nmos
for x in (.19,1.48): licon(x,.58)
licon(.62,.58)
# ptap
for x in (.19,1.48):
    licon(x,-.085); R('mcon',x,-.085,x+.17,.085); R('li',x,-.165,x+.17,.83)
R('li',.62,.50,.79,.83); R('mcon',.62,.58,.79,.75)
# pmos
licon(.19,1.615); R('li',.11,1.615,.44,1.785); R('mcon',.19,1.615,.36,1.785)
for x in (.62,1.48):
    licon(x,2.075); R('li',x,1.995,x+.17,2.325); R('mcon',x,2.075,x+.17,2.245)
licon(1.05,2.075); R('li',1.05,1.995,1.22,2.885)
licon(1.05,2.635); R('mcon',1.05,2.635,1.22,2.805)
R('met1',.56,2.045,1.71,2.275)
# poly contacts
for x in (.355,.835,1.325):
    licon(x,1.15); R('li',x,1.07,x+.17,1.40); R('mcon',x,1.15,x+.17,1.32)
    R('met1',x-.06,1.09,x+.23,1.38)
# Y
R('met1',.545,.52,.865,.81); R('via',.63,.59,.78,.74); R('met2',.575,.505,.835,1.40)
R('met1',.115,1.57,.435,1.83); R('via',.20,1.625,.35,1.775); R('met2',.145,1.14,.405,1.86)
R('met2',.145,1.14,.835,1.40)
# rails
R('met1',0,-.24,1.84,.24); R('met1',0,2.48,1.84,2.96)
T((68,5),"VGND",.92,0); T((68,5),"VPWR",.92,2.72)
T((68,5),"B1",.44,1.235); T((68,5),"A1",.92,1.235); T((68,5),"A2",1.41,1.235); T((68,5),"Y",.275,1.68)
def P(t,x0,y0,x1,y1):
    R('met1',x0,y0,x1,y1) if False else None
    top.shapes(ly.layer(68,16)).insert(db.Box(round(x0*1000),round(y0*1000),round(x1*1000),round(y1*1000)))
    T((68,16),t,(x0+x1)/2,(y0+y1)/2)
P("VGND",.3,-.1,.6,.1); P("VPWR",.3,2.62,.6,2.82)
P("B1",.295,1.09,.585,1.38); P("A1",.775,1.09,1.065,1.38); P("A2",1.265,1.09,1.555,1.38); P("Y",.115,1.57,.435,1.83)
ly.write("/home/ibrahim/claude-workspace/icdsl/agent_compare/sonnet-raw-a21oi/a21oi.gds")
