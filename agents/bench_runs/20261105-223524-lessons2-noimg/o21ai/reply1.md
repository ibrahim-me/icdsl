I'll analyze the transistor connectivity, choose a gate order that works for both rows, then lay out the cell parametrically.

Key insight: n2 is shared by M2/M5 (series) and M3 connects to n2 via a contact on the n2 column plus a strap to M3's drain column. Gate order A2, A1, B1 works for both rows:
- p-row: VPWR | A2 | n1 | A1 | Y | B1 | VPWR (M0/M4 share n1)
- n-row: VGND | A2 | n2 | A1 | VGND | B1 | Y (M2/M5 share n2; M3 drain column = n2 via strap)

Let me write the cell:

```icl
pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  # diffusion rows: n-row above p-tap, p-row below n-tap, centred
  nd  = rect diff w=(4*L + 1.85) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.85) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # same gate order A2, A1, B1 in both rows; pitch leaves room for a contact column
  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + max(0.28, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + max(0.28, 0.54 - L))

  # n-row: VGND | A2 | n2 | A1 | VGND | B1 | Y  (M2/M5 share n2 column)
  sn  = array licon in=nd left_of=ga2          # VGND (M5 drain)
  dn  = array licon in=nd right_of=ga2         # n2 (M5 source, M2 drain)
  s2  = array licon in=nd left_of=ga1          # VGND (M2 source)
  d3  = array licon in=nd right_of=gb1         # Y (M3 source)
  snl = enclose sn li
  dnl = enclose dn li net=n2
  s2l = enclose s2 li
  d3l = enclose d3 li net=Y
  gndn = strap li from=snl to=vgnd_li
  gnd2 = strap li from=s2l to=vgnd_li
  # M3 drain = n2: contact on the shared n2 column, strap to the Y column
  n2c = contact licon in=nd between=[ga1, gb1] cx=(dnl.cx)
  n2l = enclose n2c li net=n2
  n2y = strap li from=n2l to=d3l

  # p-row: VPWR | A2 | n1 | A1 | Y | B1 | VPWR  (M4/M0 share n1)
  sp  = array licon in=pd left_of=ga2          # VPWR (M4 drain)
  dp  = array licon in=pd right_of=ga2         # n1 (M4 source, M0 drain)
  s0  = array licon in=pd left_of=ga1          # Y (M0 source)
  d1  = array licon in=pd right_of=gb1         # VPWR (M1 source)
  spl = enclose sp li
  dpl = enclose dp li net=n1
  s0l = enclose s0 li net=Y
  d1l = enclose d1 li
  pwr1 = strap li from=spl to=vpwr_li
  pwr2 = strap li from=d1l to=vpwr_li
  # n1 column already shared by M4/M0; Y column shared by M0/M1

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, s2l.top + 0.25, d3l.top + 0.25)
  gca2 = contact licon cx=(ga2.cx) bottom=cb
  gca1 = contact licon cx=(ga1.cx) bottom=cb
  gcb1 = contact licon cx=(gb1.cx) bottom=cb
  pca2 = enclose gca2 poly by=minx
  pca1 = enclose gca1 poly by=minx
  pcb1 = enclose gcb1 poly by=minx
  gna  = enclose [gca2, gca1, gcb1] npc
  aa   = enclose gca2 li net=A2
  ab   = enclose gca1 li net=A1
  bb   = enclose gcb1 li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # supply straps
  p1 = strap li from=dpl to=vpwr_li   # p-row right VPWR (M1 source) - already have pwr2; keep one
  # (d1l is the right VPWR column; spl is the left VPWR column)

  # met1 pins
  a1m = contact mcon in=aa
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=ab
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=bb
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=s0l
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out on=yp
end
```

Wait, I have some issues to clean up:
1. I defined `p1 = strap li from=dpl to=vpwr_li` and also `pwr2 = strap li from=d1l to=vpwr_li`. dpl and d1l are the same object (dpl = enclose dp li, d1l = enclose d1 li, and dp and d1 are the same array). That's a duplicate. Let me remove the duplicate.

2. The `route Y layers=m1` — but Y pin is on s0l (p-row Y column) and d3l (n-row Y column) and they're connected by... wait. Let me recheck.

Y connections:
- M0 source = Y (p-row, column s0 = left of ga1)
- M1 drain = Y (p-row, column d1 = right of gb1) — wait, M1: d=Y, s=VPWR, g=B1. M1 is right of gb1. So M1's left column (drain) = Y, right column (source) = VPWR. So d1 (right of gb1) = VPWR (M1 source), and the column left of gb1 = Y (M1 drain).

Hold on, I need to redo the p-row column assignments carefully.

p-row order left to right: ga2 (A2), ga1 (A1), gb1 (B1).
Columns: c0 (left edge), c1 (between ga2, ga1), c2 (between ga1, gb1), c3 (right edge).

Devices:
- M4 (g=A1=ga1): d=VPWR, s=n1. M4 is between c1 and c2.
- M0 (g=A2=ga2): d=n1, s=Y. M0 is between c0 and c1.
- M1 (g=B1=gb1): d=Y, s=VPWR. M1 is between c2 and c3.

M0: between c0, c1: {d=n1, s=Y} → {c0, c1} = {n1, Y}
M4: between c1, c2: {d=VPWR, s=n1} → {c1, c2} = {VPWR, n1}
M1: between c2, c3: {d=Y, s=VPWR} → {c2, c3} = {Y, VPWR}

Shared columns:
- c1 shared by M0 and M4: M0 c1 and M4 c1 must match. M0 c1 ∈ {n1, Y}, M4 c1 ∈ {VPWR, n1}. Common = n1. So c1 = n1. Then M0 c0 = Y, M4 c2 = VPWR.
- c2 shared by M4 and M1: M4 c2 = VPWR, M1 c2 ∈ {Y, VPWR}. Common = VPWR. So c2 = VPWR. Then M1 c3 = Y.

So p-row: c0=Y, c1=n1, c2=VPWR, c3=Y.
- c0 = Y (M0 source) — left edge
- c1 = n1 (M0 drain, M4 source)
- c2 = VPWR (M4 drain, M1 source)
- c3 = Y (M1 drain) — right edge

Hmm interesting, so Y is at both c0 (left edge) and c3 (right edge), and VPWR is at c2 (internal). VPWR at internal column c2 needs a contact to vpwr_li. Y at c0 and c3 (both edges).

Wait, this is different from what I had. Let me redo. I previously assumed order A2, A1, B1 gives VPWR | A2 | n1 | A1 | Y | B1 | VPWR but that was wrong. Let me recompute.

Actually, the issue is which device is where. Let me reassign based on gate positions:
- ga2 = A2 → M0 (g=A2) is at ga2. M0 between c0 and c1.
- ga1 = A1 → M4 (g=A1) is at ga1. M4 between c1 and c2.
- gb1 = B1 → M1 (g=B1) is at gb1. M1 between c2 and c3.

So:
- M0 (ga2): c0, c1 = {n1(drain), Y(source)}
- M4 (ga1): c1, c2 = {VPWR(drain), n1(source)}
- M1 (gb1): c2, c3 = {Y(drain), VPWR(source)}

c1 shared M0/M4: n1. So c1=n1, c0=Y (M0 source), c2=VPWR (M4 drain).
c2 shared M4/M1: M4 c2=VPWR, M1 c2 ∈ {Y, VPWR} → c2=VPWR, c3=Y (M1 drain).

p-row: c0=Y | ga2(A2) | c1=n1 | ga1(A1) | c2=VPWR | gb1(B1) | c3=Y

So:
- left_of ga2 (c0) = Y → array licon in=pd left_of=ga2 = Y column
- right_of ga2 (c1) = n1 → array licon in=pd right_of=ga2 = n1 column
- left_of ga1 (c1) = n1 (same)
- right_of ga1 (c2) = VPWR → array licon in=pd right_of=ga1 = VPWR column
- left_of gb1 (c2) = VPWR (same)
- right_of gb1 (c3) = Y → array licon in=pd right_of=gb1 = Y column

So p-row:
- sp (left of ga2) = Y
- dp (right of ga2) = n1
- (left of ga1) = n1 (same column as dp)
- (right of ga1) = VPWR
- (left of gb1) = VPWR (same)
- d1 (right of gb1) = Y

So Y is at left edge (left of ga2) and right edge (right of gb1). VPWR is internal (right of ga1 / left of gb1). n1 is internal (right of ga2 / left of ga1).

This means:
- Y pin: can use left edge column (left of ga2) or right edge column (right of gb1). Both are Y. Let me use right of gb1 (d1) for Y pin, and strap left-of-ga2 (Y) to right-of-gb1 (Y)? They're both Y but at opposite ends. Actually I can just put the Y pin on one of them. But M0 source=Y is at left edge and M1 drain=Y is at right edge. Both need to be Y net. If I only put a pin on one, the other Y column still needs to be labeled net=Y (enclose li net=Y) so LVS knows it's Y. But are they connected? c0=Y and c3=Y are not adjacent (separated by the whole row). They're both labeled net=Y but not physically connected → LVS open!

Hmm. So I need to connect c0(Y) and c3(Y). They're at opposite ends. That's a long route. Alternatively, use m1/m2 route.

Wait, this is getting complicated. Let me reconsider the gate order to get a cleaner p-row.

The issue is M1 has s=VPWR and d=Y, while M4 has d=VPWR and s=n1. So VPWR appears on M4's drain and M1's source. If M4 and M1 are adjacent (share a column), that column could be VPWR. M4 is at ga1, M1 is at gb1. They're adjacent (c2 between them). So c2 = VPWR works (M4 drain, M1 source). Good, that's what we have: c2=VPWR internal.

And Y: M0 source (c0) and M1 drain (c3). M0 at ga2 (leftmost gate), M1 at gb1 (rightmost gate). So Y is at both outer edges. To connect them, route along the top/bottom with m1/m2.

Alternatively, choose a different gate order so Y columns are adjacent or one is internal and shared.

Let me reconsider. We have 3 p-devices: M4(A1), M0(A2), M1(B1). And we need same gate order as n-row.

Let me reconsider the n-row to find the best order, then match p-row.

n-row devices: M2(A1), M5(A2), M3(B1).
- M2: s=VGND, d=n2
- M5: s=n2, d=VGND
- M3: d=n2, s=Y

We found valid column assignments. Let me pick the order that gives the cleanest result and matches a clean p-row.

Let me reconsider: maybe I should allow the n-row and p-row to have the SAME gate order but I get to choose the order. Let me find an order where both rows are clean.

Let me reconsider p-row for different gate orders. The p-row column assignment depends on order.

p-devices and their {source, drain}:
- M4(A1): {VPWR, n1}
- M0(A2): {n1, Y}
- M1(B1): {Y, VPWR}

This is a nice chain: VPWR - M4 - n1 - M0 - Y - M1 - VPWR. So if order is A1, A2, B1 (M4, M0, M1):
- c0=VPWR (M4 drain), c1=n1 (M4 source, M0 drain), c2=Y (M0 source, M1 drain), c3=VPWR (M1 source).
- p-row: VPWR | A1 | n1 | A2 | Y | B1 | VPWR. Clean! VPWR at both edges, n1 internal, Y internal.

But we need same order as n-row. Can n-row do order A1, A2, B1 (M2, M5, M3)?

n-row order A1, A2, B1 (M2, M5, M3):
- M2(A1): c0,c1 = {VGND, n2}
- M5(A2): c1,c2 = {n2, VGND}
- M3(B1): c2,c3 = {n2, Y}

c1 shared M2/M5: M2 c1 ∈ {VGND,n2}, M5 c1 ∈ {n2,VGND}. 
c2 shared M5/M3: M5 c2 ∈ {n2,VGND}, M3 c2 ∈ {n2,Y}.

Try c1=n2: M2 c0=VGND. M5 c1=n2, c2=VGND. M3 c2=VGND ∉ {n2,Y}. Fail.
Try c1=VGND: M2 c0=n2. M5 c1=VGND, c2=n2. M3 c2=n2, c3=Y. ✓
So c0=n2, c1=VGND, c2=n2, c3=Y. n2 at c0 and c2 (non-adjacent). Not clean — n2 split.

So order A1,A2,B1 gives clean p-row but split n2 in n-row.

What about order A2, A1, B1 for p-row?
- M0(A2): c0,c1 = {n1, Y}
- M4(A1): c1,c2 = {VPWR, n1}
- M1(B1): c2,c3 = {Y, VPWR}

c1 shared M0/M4: {n1,Y} ∩ {VPWR,n1} = n1. c1=n1, c0=Y (M0), c2=VPWR (M4).
c2 shared M4/M1: M4 c2=VPWR, M1 c2 ∈ {Y,VPWR} → c2=VPWR, c3=Y (M1).
p-row: c0=Y, c1=n1, c2=VPWR, c3=Y → Y | A2 | n1 | A1 | VPWR | B1 | Y.
Y at both edges (c0, c3), VPWR internal c2, n1 internal c1. Y split across edges → need to connect c0 and c3.

n-row order A2, A1, B1 (M5, M2, M3): we computed c0=n2, c1=VGND, c2=n2, c3=Y. n2 split (c0, c2).

Hmm both have a split net. Let me think about which is easier to route.

Actually, the cleanest might be to accept one split net and route it with m1/m2. Let me reconsider.

Actually, wait. Let me reconsider the n-row. The problem is n2 is needed by M2(drain), M5(source), M3(drain) — three terminals. In a single row with 3 gates (4 columns), can n2 be a single column shared appropriately?

n2 column shared by at most 2 devices (one on each side). The third device needs n2 on its outer side or via contact.

Let me think: if n2 is column c1 (internal), shared by device on left (c0-c1) and device on right (c1-c2). The third device (c2-c3 or involving c3) needs n2 at c2 or c3.

If M2 and M5 share n2 at c1: M2(d=n2) left of c1, M5(s=n2) right of c1. Then M2's other side c0=VGND, M5's other side c2=VGND. M3 needs n2: M3 is at c2-c3 or elsewhere. If M3 is right of c2 (c2-c3), M3's left=c2=VGND but M3 needs {n2,Y}. Fail. So M3 can't be adjacent to c2=VGND.

So if M2 and M5 share n2, M3 is isolated from n2 in the row → M3's n2 must come from a contact on the n2 column (c1) routed to M3's drain column. That's the strap approach: contact on n2 column, strap to M3 drain column.

OK so regardless, one of {M2, M5, M3} connects to n2 via a contact+strap rather than direct column sharing. That's fine and normal.

Let me just pick an order and handle the routing. Let me go with a clean approach:

Choose gate order: A2, A1, B1 (ga2, ga1, gb1).

n-row: M5(A2), M2(A1), M3(B1).
- c0, c1 (M5): {n2(s), VGND(d)}
- c1, c2 (M2): {VGND(s), n2(d)}
- c2, c3 (M3): {n2(d), Y(s)}

c1 shared M5/M2: M5 c1 ∈ {n2, VGND}, M2 c1 ∈ {VGND, n2}. 
c2 shared M2/M3: M2 c2 ∈ {VGND, n2}, M3 c2 ∈ {n2, Y}.

Try c1=n2: M5 c0=VGND. M2 c1=n2, c2=VGND. M3 c2=VGND ∉ {n2,Y}. Fail.
Try c1=VGND: M5 c0=n2. M2 c1=VGND, c2=n2. M3 c2=n2, c3=Y. ✓
n-row: c0=n2, c1=VGND, c2=n2, c3=Y.
- c0 = n2 (left edge, M5 source)
- c1 = VGND (M5 drain, M2 source)
- c2 = n2 (M2 drain, M3 drain)
- c3 = Y (M3 source, right edge)

So n2 at c0 (left edge) and c2 (internal, shared M2 drain & M3 drain). M5 source = n2 at c0 (left edge). M2 drain = n2 at c2. M3 drain = n2 at c2. 

So c2 (n2) is shared by M2 drain and M3 drain — good, two devices. M5 source = n2 at c0 (left edge). c0 and c2 both n2, not adjacent (c1=VGND between). So connect c0(n2) to c2(n2) via contact on c0 or c2 and strap/route.

Hmm, c0 is left edge. Having n2 at the left edge of the diffusion row is a bit awkward but OK — it just means n2 diffusion touches the left edge. Actually, we might want n2 not at the edge. But it's workable: put a licon on c0 (n2) and strap to c2 (n2)? But c0 and c2 are separated by c1 (VGND) and ga1 gate. Can't strap directly (would cross VGND). Need to route around with m1/m2, or put contact on c2 and route to c0.

This is getting messy. Let me step back and choose the order that minimizes routing.

Alternative: accept that n2 is shared by M2 and M3 at c2 (internal column), and M5 connects to n2 via... M5 source = n2. If M5 is at an edge with n2 on the outer side (c0), then n2 comes out at the edge. We can put a contact on c0 (n2) and that's the n2 node; then route from c0 to c2? No...

Actually, simplest: make n2 a single internal column shared by two devices, and the third device's n2 terminal connects via a contact landing on... no, a contact lands on one column.

Let me reconsider: maybe use TWO n2 columns and connect them with a strap if they're adjacent, or route.

Hold on. Let me reconsider the whole topology. What if n-row order is A1, B1, A2 or similar so that n2 ends up as one clean column?

Let me reconsider: we want n2 to be ONE column shared by two devices, and the third device also on n2 but that's the third terminal. Actually three terminals on one net in a row: the net can span multiple columns if we connect them. The cleanest is: n2 column shared by two devices (series), third device has n2 on its outer edge column, and we connect edge column to internal column... they're not adjacent if there's a gate between.

Hmm, what if the third device is at the other edge and n2 is its outer column = the same edge? No.

Let me just try all 6 orders for n-row and see which gives n2 as a single column (or two adjacent columns):

We need columns c0-c1-c2-c3 with edges (devices) e1(M2:{VGND,n2}), e2(M5:{n2,VGND}), e3(M3:{n2,Y}) assigned to the 3 gate positions in some order, column labels consistent, and n2 appearing in as few columns as possible (ideally 1, but 3 terminals need n2 on 3 device-sides; a column has 2 sides so max 2 terminals per column; so n2 needs at least 2 columns unless one column is shared... no, 2 columns max 4 terminals). So n2 will be in 2 columns minimum (3 terminals). If those 2 columns are adjacent, we can strap them. If not adjacent, need route.

For n2 to be in 2 adjacent columns: e.g., c1 and c2 both n2. Then the device between c1-c2 has both sides n2? That would be a device with source=drain=n2 — not our case. So adjacent n2 columns c1, c2: the device between them (e at gate between c1,c2) would connect c1-c2 = n2-n2, meaning that device's source and drain both n2. Not valid for our transistors (each has distinct source/drain nets). So n2 columns can't be adjacent with a device between them unless that device is shorted. So n2 columns must be non-adjacent (separated by a non-n2 column), OR at an edge and internal.

Conclusion: n2 will be in 2 non-adjacent columns, requiring a route (m1/m2) or a contact+strap that goes around. Actually, we can put a contact on one n2 column and route m1 to the other n2 column's contact. That's two contacts + m1 route. Fine.

Alternatively, realize that one of the "n2" terminals can just be a contact on the shared column and the device reaches it... no, each transistor's source/drain must physically touch its diffusion column.

OK, I think the cleanest practical approach: 
- n2 shared column (internal) for two devices.
- Third device's n2 column gets a contact, and we route m1/m2 to connect to the shared column's contact.

But actually, simpler: since LVS just needs connectivity, I can label both n2 columns `net=n2` and add `route n2 layers=m1,m2` to connect them (with contacts). But the `route` verb — does it auto-add contacts? The doc says `route <net> layers=m1,m2`. And coach note 5: "give the drain li strips AND the gate contact li the same net=n1 and write route n1 layers=m1,m2". So route connects same-net strips. But for two li strips in the same row not vertically aligned, route m1,m2 would need them to be reachable. Hmm.

Actually, let me reconsider. Maybe there's a cleaner topology choice. Let me reconsider using the p-row as the driver for gate order since p-row can be very clean.

Cleanest p-row: order A1, A2, B1 → VPWR | A1 | n1 | A2 | Y | B1 | VPWR. n1 shared (M4 source, M0 drain), Y shared (M0 source, M1 drain), VPWR at both edges (M4 drain, M1 source). VPWR at both edges: connect both to VPWR rail (two straps, or one is enough if... no, both edges need VPWR connection but they're the same net; I can strap both to vpwr_li, or route). Actually VPWR at c0 and c3 (both edges). I can put contacts on both and strap to vpwr_li, or just one strap and label both net=VPWR... but they need physical connection. Two separate VPWR columns at edges, both need to connect to VPWR rail. I'll strap both to vpwr_li (two straps) — that's fine, both connect to the same VPWR rail.

So p-row order A1, A2, B1 is clean: n1 internal shared, Y internal shared, VPWR at edges (strap both to vpwr_li).

Now n-row must also be order A1, A2, B1 (M2, M5, M3). We found n-row: c0=n2, c1=VGND, c2=n2, c3=Y. n2 split (c0 edge, c2 internal), VGND internal c1 (shared M2 source, M5 drain), Y at c3 edge (M3 source).

Wait let me recompute n-row order A1, A2, B1 (M2 at ga1, M5 at ga2, M3 at gb1):
- M2(A1=ga1): c0,c1 = {VGND(s), n2(d)}
- M5(A2=ga2): c1,c2 = {n2(s), VGND(d)}
- M3(B1=gb1): c2,c3 = {n2(d), Y(s)}

c1 shared M2/M5: M2 c1 ∈ {VGND,n2}, M5 c1 ∈ {n2,VGND}.
c2 shared M5/M3: M5 c2 ∈ {n2,VGND}, M3 c2 ∈ {n2,Y}.

Try c1=n2: M2 c0=VGND. M5 c1=n2, c2=VGND. M3 c2=VGND ∉ {n2,Y}. Fail.
Try c1=VGND: M2 c0=n2. M5 c1=VGND, c2=n2. M3 c2=n2, c3=Y. ✓
n-row: c0=n2, c1=VGND, c2=n2, c3=Y.

So:
- c0 = n2 (left edge, M2 source? M2 c0 = n2 means M2's left column = n2. M2: s=VGND, d=n2. If c0=n2(drain), c1=VGND(source). So M2 is flipped: drain on left, source on right. OK valid.)
- c1 = VGND (M2 source, M5 drain)
- c2 = n2 (M5 source, M3 drain)
- c3 = Y (M3 source, right edge)

n2 at c0 (left edge) and c2 (internal). M2 drain=n2 at c0, M5 source=n2 at c2, M3 drain=n2 at c2. So c2(n2) shared by M5 source and M3 drain — good. M2 drain=n2 at c0 (left edge). Need to connect c0(n2) to c2(n2). Not adjacent (c1=VGND between). 

Hmm. So n2 is at left edge c0 and internal c2. 

Alternatively flip M2: c0=VGND, c1=n2. Then c1=n2 shared M2/M5: M2 c1=n2(drain), M5 c1=n2(source)? M5 c1 ∈ {n2,VGND}, so M5 c1=n2(source), c2=VGND(drain). Then c2 shared M5/M3: M5 c2=VGND, M3 c2 ∈ {n2,Y}. Fail (VGND). So that flip doesn't work.

So with order A1,A2,B1, n-row forces c0=n2, c1=VGND, c2=n2, c3=Y. n2 split between c0(edge) and c2(internal).

To connect c0(n2) and c2(n2): put licon on c0 and licon on c2, route m1/m2 between them. Or, since c0 is at the left edge, maybe I can make c0 not an issue by... Actually, it's fine. Let me just handle n2 with a route.

But wait — there's a subtlety. c0 is the left edge of the diffusion row. Is it OK to have a diffusion contact at the very edge? The diffusion row nd has width; c0 is at nd.left. A licon array `left_of=ga1` would be at c0 (between left edge and ga1). Actually `array licon in=nd left_of=ga1` places contacts in the column left of ga1, which is c0 (between nd.left and ga1). That's fine as long as there's room (0.265 from edge). We set ga2 left = nd.left + 0.265, but ga1 is the second gate. The column c0 is between nd.left and ga1. That's a wide column (contains ga2? no). Wait, order is ga1, ga2, gb1 (A1, A2, B1). So left to right: ga1(A1), ga2(A2), gb1(B1).

Hold on, I need to be consistent. If order is A1, A2, B1, then:
- ga1 = cross ... left=(nd.left + 0.265)  [A1, leftmost]
- ga2 = cross ... left=(ga1.right + pitch)  [A2]
- gb1 = cross ... left=(ga2.right + pitch)  [B1, rightmost]

Columns: c0 (left of ga1), c1 (between ga1, ga2), c2 (between ga2, gb1), c3 (right of gb1).

n-row order A1, A2, B1 = M2, M5, M3:
- M2(A1=ga1): c0,c1 = {VGND, n2}
- M5(A2=ga2): c1,c2 = {n2, VGND}
- M3(B1=gb1): c2,c3 = {n2, Y}

Same as before: c0=n2, c1=VGND, c2=n2, c3=Y.

p-row order A1, A2, B1 = M4, M0, M1:
- M4(A1=ga1): c0,c1 = {VPWR, n1}
- M0(A2=ga2): c1,c2 = {n1, Y}
- M1(B1=gb1): c2,c3 = {Y, VPWR}

c1 shared M4/M0: {VPWR,n1} ∩ {n1,Y} = n1. c1=n1, c0=VPWR (M4), c2=Y (M0).
c2 shared M0/M1: M0 c2=Y, M1 c2 ∈ {Y,VPWR} → c2=Y, c3=VPWR (M1).
p-row: c0=VPWR, c1=n1, c2=Y, c3=VPWR.
- VPWR at c0 (left edge) and c3 (right edge)
- n1 at c1 (internal, shared M4 source & M0 drain)
- Y at c2 (internal, shared M0 source & M1 drain)

This is clean! p-row: VPWR | A1 | n1 | A2 | Y | B1 | VPWR. n1 and Y internal shared, VPWR at both edges.

So with order A1, A2, B1:
- p-row: clean (VPWR edges, n1 internal, Y internal)
- n-row: c0=n2(edge), c1=VGND(internal), c2=n2(internal), c3=Y(edge). n2 split (c0 edge & c2 internal), VGND internal shared, Y at right edge.

n-row issues: n2 at c0(left edge) and c2(internal). Need to connect. Y at c3(right edge) — single Y column, good (M3 source = Y at right edge). VGND at c1 internal (shared M2 source & M5 drain) — strap to vgnd_li.

So the only split net is n2 (c0 and c2). I'll connect them: put licon on c2 (n2, internal, shared by M5 source & M3 drain) — that's the main n2 column. And M2 drain = n2 at c0 (left edge). Put a licon on c0 too, label net=n2, and route m1/m2 to connect c0 and c2 contacts. OR: since c0 is left edge and c2 is internal, route n2 with m1/m2.

Actually, simpler: I can avoid the split by NOT sharing M2/M5 on n2, but that doesn't help. Let me just connect c0(n2) and c2(n2) with a route.

Hmm, but actually, wait. Let me reconsider: is it a problem that M2's drain (n2) is at the left edge c0? The diffusion row nd extends from nd.left to nd.right. c0 is the column between nd.left and ga1. We have ga1 starting at nd.left + 0.265. So c0 width = 0.265 (from nd.left to ga1.left). A licon (0.17) fits in 0.265 with 0.047 margin each side — OK (diff enclosure of licon 0.04, need 0.17+0.08=0.25 li width... actually li encloses licon by 0.08 one axis, so li = 0.17+0.16=0.33? No: li width min 0.17, encloses licon by 0.08 on one axis. So if licon is 0.17x0.17, li must be at least 0.17+2*0.08=0.33 in the enclosure axis? The rule: "li encloses licon by 0.08 on one axis". So li extends 0.08 beyond licon on one axis (say x), making li width = 0.17+0.16=0.33 in x, and 0.17 in y. Or by=min gives all-round 0.08? The doc: "li width/spacing 0.17, li encloses licon by 0.08 on one axis". And enclose ... li with by=min. Hmm. In the worked example they just do `enclose sn li` and it works. So the tool handles it. I'll trust `enclose ... li`.

OK this is workable but the n2 split requires a route. Let me see if I can pick a better order to avoid any split.

The fundamental issue: n2 has 3 terminals (M2 d, M5 s, M3 d). In a 4-column row, to give all three n2 without splitting, we'd need n2 on 3 device-sides. Columns provide 2 sides each. With n2 in columns c1 and c2 (adjacent), the device between c1-c2 would have both sides n2 (invalid). So n2 must be in non-adjacent columns → at least 2 columns, non-adjacent → need a connection between them (route or strap around). Can't avoid with 3 terminals in one row unless two terminals are on the same column side... they can't be.

Wait, unless one device has n2 and the column is shared such that... no. 3 terminals, each column side = 1 terminal. Need 3 column-sides = at least 2 columns (4 sides) but the columns must not have a device between them that gets shorted. If n2 columns are c0 and c2 (separated by c1 with device between c0-c1 and c1-c2): device at c0-c1 has one side n2 (c0) and other side c1 (non-n2) — OK. Device at c1-c2 has c1(non-n2) and c2(n2) — OK. So c0 and c2 both n2, separated by c1 (non-n2), with devices (c0-c1) and (c1-c2) each having one n2 side. That's exactly our situation (c0=n2, c1=VGND, c2=n2). The two n2 columns c0 and c2 are NOT adjacent (c1 between), so no device is shorted. But they need to be connected (same net n2) → route between c0 contact and c2 contact.

So it's unavoidable: n2 needs a route between two columns. That's fine; I'll use `route n2 layers=m1,m2` with contacts on both columns. But coach note 5 style: give both li strips net=n2 and route. But c0 and c2 li strips are in the same row (nd), horizontally separated. `route n2 layers=m1,m2` — does the router connect two li strips in the same diffusion row? It would route m1 above with contacts. Should work. But to be safe, maybe explicitly: contact on c0 li (mcon), contact on c2 li (mcon), enclose m1, route. Hmm, the `route` verb is for the parent router (level 4). In a stdcell (level 1), can I use `route`? The worked example NAND2 uses `route Y layers=m1`. So yes, route is available in stdcell. But route connects pins/net segments. For two li strips both labeled net=n2 in the same row, `route n2 layers=m1,m2` should join them via m1 with vias/contacts.

Actually, simpler and more reliable: put a single n2 contact column and route. But let me reconsider — maybe I can make n2 a single column by choosing which devices share.

What if n2 is shared by M2 and M3 (both have n2 as drain), and M5 connects to n2 via... M5 source = n2. If M5 is adjacent to the n2 column on its source side. Let me see: n2 column c1 shared by M2 (drain, left side) and M3 (drain, right side)? But M2 and M3 would both be on n2's two sides: M2 left of c1 (M2 drain = c1 = n2), M3 right of c1 (M3