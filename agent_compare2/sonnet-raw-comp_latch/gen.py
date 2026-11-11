import klayout.db as db, random, heapq, sys
D='/home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-raw-comp_latch/'
ly=db.Layout(); ly.dbu=0.001
top=ly.create_cell("comp_latch")
NW=(64,20);DIFF=(65,20);TAP=(65,44);POLY=(66,20);LICON=(66,44);NPC=(95,20)
NSDM=(93,44);PSDM=(94,20);LI=(67,20);MCON=(67,44);M1=(68,20);VIA=(68,44);M2=(69,20)
def R(l,x1,y1,x2,y2):
    top.shapes(ly.layer(*l)).insert(db.Box(x1,y1,x2,y2))
def RC(l,cx,cy,w,h):
    R(l,cx-w//2,cy-h//2,cx+w//2,cy+h//2)
def T(l,s,x,y):
    top.shapes(ly.layer(*l)).insert(db.Text(s,db.Trans(x,y)))
P=460
X=lambda i:P*i
Jp=14
Y=lambda j:P*j
YP=Y(Jp)
swap={'OUTN':'OUTP','OUTP':'OUTN','P':'Q','Q':'P','INP':'INN','INN':'INP','QP':'QN','QN':'QP'}
sw=lambda n: None if n is None else swap.get(n,n)
def mirror(s):
    n=len(s['cols'])
    return dict(kind=s['kind'],cols=[-c for c in reversed(s['cols'])],
        nets=[sw(x) for x in reversed(s['nets'])],
        gates=[(sw(g),[n-2-k for k in ks],-cc) for g,ks,cc in s['gates']])
nspecs=[
 dict(kind='n',cols=[-6,-5,-4],nets=['tail','P','tail'],gates=[('INP',[0,1],-5)]),
 dict(kind='n',cols=[-9,-8],nets=['OUTN','P'],gates=[('OUTP',[0],-9)]),
 dict(kind='n',cols=[-13,-12,-11],nets=['QP',None,'VGND'],gates=[('OUTN',[0],-13),('QN',[1],-11)]),
]
m0=dict(kind='n',cols=[-2,-1,0,1,2],nets=['VGND','tail','VGND','tail','VGND'],gates=[('CLK',[0,1,2,3],0)])
pspecs=[
 dict(kind='p',cols=[-2,-1],nets=['VPWR','P'],gates=[('CLK',[0],-2)]),
 dict(kind='p',cols=[-6,-5,-4],nets=['VPWR','OUTN','VPWR'],gates=[('CLK',[0],-6),('OUTP',[1],-4)]),
 dict(kind='p',cols=[-10,-9,-8],nets=['VPWR','QP','VPWR'],gates=[('QN',[0],-10),('OUTN',[1],-8)]),
]
specs=nspecs+[mirror(s) for s in nspecs]+[m0]+pspecs+[mirror(s) for s in pspecs]
terms={}  # net -> list of (i,j)
pads=[]
def addterm(net,i,j): terms.setdefault(net,[]).append((i,j))
for s in specs:
    k=s['kind']; yc=0 if k=='n' else YP
    cols=s['cols']
    R(DIFF,X(cols[0])-145,yc-500,X(cols[-1])+145,yc+500)
    jc=0 if k=='n' else Jp
    for c,net in zip(cols,s['nets']):
        if net is None: continue
        RC(LICON,X(c),yc-170,170,170);RC(LICON,X(c),yc+170,170,170)
        R(LI,X(c)-85,yc-335,X(c)+85,yc+335)
        RC(MCON,X(c),yc,170,170)
        addterm(net,c,jc)
    sgn=1 if k=='n' else -1
    yb=yc+sgn*920
    jb=2 if k=='n' else Jp-2
    for net,ks,cc in s['gates']:
        gx=[X(cols[kk])+230 for kk in ks]
        for g in gx:
            if k=='n': R(POLY,g-75,yc-630,g+75,yb)
            else: R(POLY,g-75,yb,g+75,yc+630)
        cx=X(cc)
        R(POLY,min(min(gx)-75,cx-165),yb-135,max(max(gx)+75,cx+165),yb+135)
        RC(LICON,cx,yb,170,170); RC(NPC,cx,yb,370,370)
        R(LI,cx-85,yb-165,cx+85,yb+165); RC(MCON,cx,yb,170,170)
        addterm(net,cc,jb)
    # implants for strip handled as bands
# bands
R(NSDM,-6250,-625,6250,625)
R(PSDM,-4900,YP-625,4900,YP+625)
# taps
def tapstrip(y,xe,nk,imp,rail):
    R(TAP,-xe,y-145,xe,y+145)
    R(imp,-xe-125,y-145-125,xe+125,y+145+125)
    for k in range(-nk,nk+1):
        RC(LICON,380*k,y,170,170); RC(MCON,380*k,y,170,170)
    R(LI,-380*nk-165,y-85,380*nk+165,y+85)
    R(M1,-xe,y-200,xe,y+200)
YG=-920; YV=Y(16)
tapstrip(YG,6200,15,PSDM,'VGND')
tapstrip(YV,4900,12,NSDM,'VPWR')
R(NW,-5200,YP-1300,5200,YV+145+180+55)
# supply strips
reserved={}
for net,yr in (('VGND',YG),('VPWR',YV)):
    for (i,j) in terms.pop(net):
        y=Y(j)
        RC(M1,X(i),y,320,320)
        R(M1,X(i)-70,min(y,yr),X(i)+70,max(y,yr))
        reserved[(i,j,0)]=net
# signal pads
for net,l in terms.items():
    for (i,j) in l:
        RC(M1,X(i),Y(j),320,320)
        assert (i,j,0) not in reserved,(net,i,j)
        reserved[(i,j,0)]=net
# router
IMIN,IMAX,JMIN,JMAX=-14,14,0,Jp
def route(order,seed):
    rnd=random.Random(seed)
    occ=dict(reserved); edges={}
    for net in order:
        tl=terms[net]
        tree={(tl[0][0],tl[0][1],0)}
        rest=list(tl[1:])
        edges[net]=[]
        while rest:
            # pick nearest remaining
            tgt=min(rest,key=lambda t:min(abs(t[0]-n[0])+abs(t[1]-n[1]) for n in tree)+rnd.random()*0.5)
            rest.remove(tgt); tg=(tgt[0],tgt[1],0)
            dist={};prev={};pq=[]
            for n in tree: dist[n]=0;heapq.heappush(pq,(0,n))
            found=False
            while pq:
                d,n=heapq.heappop(pq)
                if d>dist.get(n,1e9):continue
                if n==tg: found=True;break
                i,j,l=n
                nb=[]
                if l==0:
                    nb+= [((i+1,j,0),1),((i-1,j,0),1),((i,j+1,0),3),((i,j-1,0),3),((i,j,1),6)]
                else:
                    nb+= [((i,j+1,1),1),((i,j-1,1),1),((i+1,j,1),3),((i-1,j,1),3),((i,j,0),6)]
                for m,c in nb:
                    if not(IMIN<=m[0]<=IMAX and JMIN<=m[1]<=JMAX):continue
                    o=occ.get(m)
                    if o is not None and o!=net:continue
                    nd=d+c
                    if nd<dist.get(m,1e9):
                        dist[m]=nd;prev[m]=n;heapq.heappush(pq,(nd,m))
            if not found: return None
            n=tg
            while n not in tree:
                p=prev[n]; edges[net].append((p,n)); occ[n]=net;occ[p]=net
                tree.add(n); n=p
            # tree add also p's along path
            n=tg
        # nodes already added
    return edges
nets=list(terms.keys())
edges=None
for seed in range(2000):
    order=nets[:]
    random.Random(seed).shuffle(order)
    edges=route(order,seed)
    if edges: print("routed with seed",seed);break
if not edges: print("ROUTING FAILED");sys.exit(1)
for net,el in edges.items():
    vias=set()
    for a,b in el:
        (i1,j1,l1),(i2,j2,l2)=a,b
        if l1!=l2:
            vias.add((i1,j1)); continue
        l=M1 if l1==0 else M2
        x1,x2=sorted((X(i1),X(i2)));y1,y2=sorted((Y(j1),Y(j2)))
        R(l,x1-70,y1-70,x2+70,y2+70)
    for (i,j) in vias:
        RC(VIA,X(i),Y(j),150,150);RC(M1,X(i),Y(j),320,320);RC(M2,X(i),Y(j),320,320)
# ports
def port(net,l,x,y,w=320,h=320):
    for lt,lp in ((M1,(68,5)),):
        pass
    R((68,16),x-w//2,y-h//2,x+w//2,y+h//2)
    T((68,5),net,x,y);T((68,16),net,x,y)
for net in ['CLK','INP','INN','QP','QN']:
    i,j=terms[net][0]
    port(net,None,X(i),Y(j))
# VPWR/VGND pin on rails
port('VGND',None,0,YG,400,400)
port('VPWR',None,0,YV,400,400)
ly.write(D+'comp_latch.gds')
print({n:len(v) for n,v in terms.items()})
