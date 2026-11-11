import klayout.db as kdb
OUT = "/home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-raw-folded_cascode/folded_cascode.gds"
ly = kdb.Layout(); ly.dbu = 0.001
top = ly.create_cell("folded_cascode")
LAY = dict(nwell=(64,20), diff=(65,20), tap=(65,44), poly=(66,20), licon=(66,44), npc=(95,20),
           nsdm=(93,44), psdm=(94,20), li=(67,20), mcon=(67,44), m1=(68,20), via=(68,44), m2=(69,20),
           li_t=(67,5), m1_t=(68,5), m2_t=(69,5), li_p=(67,16), m1_p=(68,16), m2_p=(69,16))
LI = {k: ly.layer(*v) for k, v in LAY.items()}
def n(v): return int(round(v*1000))
def R(l, x1, y1, x2, y2):
    top.shapes(LI[l]).insert(kdb.Box(n(x1), n(y1), n(x2), n(y2)))
def T(l, x, y, s):
    top.shapes(LI[l]).insert(kdb.Text(s, n(x), n(y)))
def licon_at(x, y, poly=False):
    R('licon', x-.085, y-.085, x+.085, y+.085)
    if poly: R('npc', x-.185, y-.185, x+.185, y+.185)

X0 = 7.0
GATEX = X0 - 0.8
PITCH_T = 0.42
tracks = {
 'R6': ['VPWR','tail'],
 'R5': ['f1','tail','f2'],
 'R1': ['y','VPWR','z','x'],
 'R2': ['y','x','z','OUT'],
 'R3': ['f1','x','f2','OUT'],
 'R4': ['f1','VGND','f2'],
}
rows = [
 ('R6','p',"c:VPWR g c:tail g c:VPWR g c:tail g c:VPWR", ('bar','VBP',True)),
 ('R5','p',"c:f1 g:A c:tail g:B c:f2 g:B c:tail g:A c:f1", ('dual','INP','INN')),
 ('R1','p',"c:y g c:VPWR g c:z g c:VPWR g c:y", ('bar','x',False)),
 ('R2','p',"c:y g c:x | c:z g c:OUT g c:z | c:x g c:y", ('bar','VCP',True)),
 ('R3','n',"c:f1 g c:x | c:f2 g c:OUT g c:f2 | c:x g c:f1", ('bar','VCN',True)),
 ('R4','n',"c:f1 g c:VGND g c:f2 g c:VGND g c:f1", ('bar','VBN',True)),
]
# vertical placement
yb = {}; ty = {}
cur = 40.0
for name, kind, toks, gs in rows:
    yb[name] = cur
    ty[name] = {net: cur - 1.2 - PITCH_T*i for i, net in enumerate(tracks[name])}
    last = cur - 1.2 - PITCH_T*(len(tracks[name])-1) - 0.13
    nxt_T = 1.70
    cur = last - 0.35 - 1.70   # conservative
term = {name: [] for name, *_ in rows}   # (net, x)
rowx = {}
for name, kind, toks, gs in rows:
    y0 = yb[name]; tk = toks.split()
    ym = y0 - 0.75
    x = X0; pos = []  # items
    gates = []; cols = []; islands = []; isl_start = None
    for i, t in enumerate(tk):
        prev = tk[i-1] if i > 0 else None; nxt = tk[i+1] if i+1 < len(tk) else None
        if t == '|':
            islands.append((isl_start, x)); isl_start = None; x += 0.28; continue
        if isl_start is None: isl_start = x
        if t.startswith('c:'):
            le = prev is None or prev == '|'; re = nxt is None or nxt == '|'
            w = 0.265 if (le or re) else 0.28
            cx = x + (0.125 if le else 0.14)
            cols.append((t[2:], cx)); x += w
        else:
            lab = t.split(':')[1] if ':' in t else None
            gates.append((x, lab)); x += 0.5
    islands.append((isl_start, x))
    xr = x
    rowx[name] = xr
    dl = 'diff'; imp = 'psdm' if kind == 'p' else 'nsdm'
    for a, b in islands:
        R('diff', a, y0, b, y0+1.0)
    R(imp, X0-0.125, y0-0.125, xr+0.125, y0+1.125)
    # columns
    for net, cx in cols:
        for ly0 in (0.075, 0.415, 0.755):
            licon_at(cx, y0+ly0+0.085)
        R('li', cx-.085, ym-.165, cx+.085, y0+1.005)
        R('mcon', cx-.085, ym-.085, cx+.085, ym+.085)
        R('m1', cx-.13, ym-.16, cx+.13, ym+.16)
        R('via', cx-.075, ym-.075, cx+.075, ym+.075)
        term[name].append((net, cx))
    # gates
    kind_g = gs[0]
    barb = (y0-0.50, y0-0.23)
    if kind_g == 'bar':
        net, pin = gs[1], gs[2]
        for gx, _ in gates:
            R('poly', gx, barb[0], gx+0.5, y0+1.13)
        R('poly', GATEX-0.2, barb[0], xr-0.0, barb[1])
        # bar must connect the rightmost gate: gates already cover to xr
        cy = y0 - 0.365
        licon_at(GATEX, cy, True)
        if pin:
            R('li', GATEX-.085, cy-.17, GATEX+.085, cy+.17)
            T('li_t', GATEX, cy, net); R('li_p', GATEX-.085, cy-.17, GATEX+.085, cy+.17)
        else:
            R('li', GATEX-.085, ym-.165, GATEX+.085, cy+.17)
            R('mcon', GATEX-.085, ym-.085, GATEX+.085, ym+.085)
            R('m1', GATEX-.13, ym-.16, GATEX+.13, ym+.16)
            R('via', GATEX-.075, ym-.075, GATEX+.075, ym+.075)
            term[name].append((net, GATEX))
    else:
        A, B = gs[1], gs[2]
        ga = [g for g in gates if g[1] == 'A']; gb = [g for g in gates if g[1] == 'B']
        for gx, _ in gb:
            R('poly', gx, barb[0], gx+0.5, y0+1.13)
        R('poly', gb[0][0], barb[0], gb[-1][0]+0.5, barb[1])
        for gx, _ in ga:
            R('poly', gx, y0-0.13, gx+0.5, y0+1.62)
        R('poly', ga[0][0], y0+1.35, ga[-1][0]+0.5, y0+1.62)
        cyb = y0 - 0.365; cxb = gb[0][0] + 0.25
        licon_at(cxb, cyb, True); R('li', cxb-.085, cyb-.17, cxb+.085, cyb+.17)
        T('li_t', cxb, cyb, B); R('li_p', cxb-.085, cyb-.17, cxb+.085, cyb+.17)
        cyt = y0 + 1.485; cxt = ga[0][0] + 0.25
        licon_at(cxt, cyt, True); R('li', cxt-.085, cyt-.17, cxt+.085, cyt+.17)
        T('li_t', cxt, cyt, A); R('li_p', cxt-.085, cyt-.17, cxt+.085, cyt+.17)
# fix: bar polys for 'bar' rows connect left extension to leftmost gate -> bar spans GATEX-0.2 .. xr (ok)

# tracks and trunks
trunk_nets = ['VPWR','tail','f1','f2','OUT','y','z','x']
TX = {net: 1.3 + 0.5*i for i, net in enumerate(trunk_nets)}
TAPX = 0.5
chan_of = {}
for name in tracks:
    for net in tracks[name]:
        chan_of.setdefault(net, []).append(name)
for name in tracks:
    for net, yt in ty[name].items():
        xs = [x for (nn, x) in term[name] if nn == net]
        # stub verticals
        ym = yb[name] - 0.75
        for x in xs:
            R('m2', x-.13, yt-.16, x+.13, ym+.16)
            R('via', x-.075, yt-.075, x+.075, yt+.075)
        lo = min(xs); hi = max(xs)
        if len(chan_of[net]) > 1:
            lo = min(lo, TX[net]); 
            R('via', TX[net]-.075, yt-.075, TX[net]+.075, yt+.075)
        if net == 'VPWR' and name in ('R6','R1'): lo = min(lo, TAPX)
        if net == 'VGND': lo = min(lo, TAPX)
        R('m1', lo-.16, yt-.13, hi+.16, yt+.13)
for net in trunk_nets:
    ys = [ty[c][net] for c in chan_of[net]]
    R('m2', TX[net]-.13, min(ys)-.16, TX[net]+.13, max(ys)+.16)
# taps
def tap(x, y, kind):
    R('tap', x-.165, y-.205, x+.165, y+.205)
    licon_at(x, y)
    R('li', x-.085, y-.17, x+.085, y+.17)
    R('mcon', x-.085, y-.085, x+.085, y+.085)
    R('nsdm' if kind == 'n' else 'psdm', x-.29, y-.33, x+.29, y+.33)
tap(TAPX, ty['R6']['VPWR'], 'n')
tap(TAPX, ty['R1']['VPWR'], 'n')
tap(TAPX, ty['R4']['VGND'], 'p')
# pins
def pin(net, x, y, w=0.4):
    R('m1_p', x-.1, y-.13, x+w, y+.13); T('m1_t', x+.05, y, net); T('m1_p', x+.05, y, net)
pin('VPWR', TAPX-0.0, ty['R6']['VPWR'])
pin('VGND', TAPX-0.0, ty['R4']['VGND'])
pin('OUT', X0-0.9+0.0, ty['R3']['OUT'], 0.5)
# nwell
xr_max = max(rowx.values())
R('nwell', TAPX-.165-.25, yb['R2']-0.3, xr_max+0.3, yb['R6']+1.25)
# OUT pin needs track under it: ensure OUT track in R3 spans X0-0.9
top.shapes(LI['m1']).insert(kdb.Box(n(X0-1.0), n(ty['R3']['OUT']-.13), n(X0-0.3), n(ty['R3']['OUT']+.13)))
ly.write(OUT)
print("written", yb)
