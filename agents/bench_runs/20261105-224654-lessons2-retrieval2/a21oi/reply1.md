I'll design the `a21oi` cell. Let me analyze the transistor netlist and derive a stick plan.

**Logic:** Y = !((A1 & A2) | B1). Pull-down: B1 directly (M3), or A1&A2 series (M0→M5 via n1). Pull-up: n2 = VPWR when A1=0 and A2=0 (M4/M1 series), then Y = VPWR when B1=0 (M2). n2 is a 3-way node (M4 source, M1 drain, M2 source), so it must be split into two diffusion columns joined by metal.

**Stick plan (gate order A2, A1, B1 for both rows):**
- n-row: VGND | [A2=M0] | (n1, series) | [A1=M5] | Y | [B1=M3] | VGND
- p-row: n2 | [A2=M4] | VPWR | [A1=M1] | n2 | [B1=M2] | Y

n2 appears in two non-adjacent columns → label both `net=n2` and `route n2 layers=m1,m2`.

```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=7 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  # stick plan (gate order A2 A1 B1; (net) = series node, no contact; | = island break)
  #   p: n2 [A2] VPWR [A1] n2 [B1] Y
  #   n: VGND [A2] (n1) [A1] Y [B1] VGND
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  nd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # n row: VGND | A2 | (n1) | A1 | Y | B1 | VGND
  cn0 = array licon in=nd1 left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=nd1 right_of=g1
  cn1l = enclose cn1 li net=n1
  cn2 = array licon in=nd1 right_of=g2
  cn2l = enclose cn2 li net=Y
  cn3 = array licon in=nd1 right_of=g3
  cn3l = enclose cn3 li net=VGND
  cn3s = strap li from=cn3l to=vgnd_li
  # p row: n2 | A2 | VPWR | A1 | n2 | B1 | Y  (n2 split into two columns, joined by route)
  cp0 = array licon in=pd1 left_of=g1
  cp0l = enclose cp0 li net=n2
  cp1 = array licon in=pd1 right_of=g1
  cp1l = enclose cp1 li net=VPWR
  cp1s = strap li from=cp1l to=vpwr_li
  cp2 = array licon in=pd1 right_of=g2
  cp2l = enclose cp2 li net=n2
  cp3 = array licon in=pd1 right_of=g3
  cp3l = enclose cp3 li net=Y
  cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gn = enclose [gc1, gc2, gc3] npc
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)
  # inputs
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  # output: n and p drains line up vertically (cn2l / cp3l) -> vertical li strap
  ys = strap li from=cn2l to=cp3l net=Y
  ym = contact mcon in=ys
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  # internal nets: n1 is series (no contact); n2 is split across two columns -> route it
  route n2 layers=m1,m2 prefer=m2
end
```

Wait, I need to double check the n-row Y column: cn2 = right_of=g2, net=Y. And p-row Y: cp3 = right_of=g3, net=Y. These are at different x positions (cn2 between gates A1 and B1; cp3 right of gate B1). So they don't line up vertically — a vertical `strap li from=cn2l to=cp3l` won't work (coach note 12: two drain strips not exactly above each other cannot be joined by strap).

Hmm. Let me reconsider. In o21ai, the output Y was routed (port Y out with no on=, route Y layers=m1,m2). The n-row Y was at right_of=g3 (c4l net=Y) and p-row Y was at left_of=g1 (c5l net=Y) and right_of=g3 (c8l net=Y) — multiple pieces, all routed.

For our cell, let me check which columns line up vertically. Gates g1, g2, g3 are at the same x in both rows. Columns:
- left_of g1: same x in both rows ✓ (cn0l VGND and cp0l n2 — different nets, fine, they're separate columns vertically aligned but different rows/diffusions)
- right_of g1: cn1l (n1) and cp1l (VPWR) — aligned
- right_of g2: cn2l (Y) and cp2l (n2) — aligned, different nets
- right_of g3: cn3l (VGND) and cp3l (Y) — aligned, different nets

So no Y-to-Y vertical alignment. Options:
1. Route Y: label cn2l and cp3l both net=Y, `route Y layers=m1,m2`, `port Y out` (no on=). This matches o21ai/nand3 style.
2. Rearrange so Y columns align.

For option 2: we need n-row Y column and p-row Y column at same x. n-row Y is between gates A1 and B1 (right_of g2). p-row Y is right of B1 (right_of g3) or left of B1 (left_of g3 = right_of g2 position!). 

p-row: n2 | [A2] | VPWR | [A1] | n2 | [B1] | Y. The column left_of g3 = right_of g2 position. Could that be Y? M2 (B1): {n2, Y}. Column between g2 (A1, M1) and g3 (B1, M2): shared by M1 and M2. M1's columns: {n2, VPWR}. M2's columns: {n2, Y}. Intersection = n2. So that column must be n2 (it's cp2). Then cp3 (right of g3) = Y. So p-row Y is at right_of g3, n-row Y is at right_of g2. Misaligned by one gate pitch.

Alternatively n-row: could Y be at right_of g3? n-row: VGND | [A2] | (n1) | [A1] | Y | [B1] | VGND. Column right_of g3 = M3's drain = VGND. Fixed. Column right_of g2 = M5 drain = M3 source = Y. Fixed.

So Y columns are at different x. Use route Y. That's clean and matches the verified examples.

But wait — can I use a strap for part and route for the rest? Simplest: route Y layers=m1,m2 prefer=m2, port Y out (no on=). The router will connect cn2l (net=Y) and cp3l (net=Y) and the port pin.

Actually, hold on. Let me reconsider whether to make the p-row a single island or break it. With single island pd1 spanning all gates, cp0l (n2, left end) and cp2l (n2, between g2 and g3) — both net=n2, route connects them. Good.

But there's a subtlety: cp0l is an end column (left of g1) with net n2 — it gets an end contact (0.265 from gate). cp2l is an internal column with a contact. Both labeled net=n2. Route n2 joins them. Fine.

Also need to double check: does the route tool handle connecting two li strips on m1/m2? The examples do `route n2 layers=m1,m2 prefer=m2` for exactly this (o21ai routes n2 between c1l and c3l which are... in o21ai, n2 is c1l (left of g1, net=n2) and c3l (right of g2, net=n2) — also split! And it routes n2. Great, same pattern.)

Now, width=7 columns of 0.46 = 3.22 µm. Let me verify the span fits at L=0.25:
span = 0.53 + 3*0.25 + max(0.28, 0.54-0.25) + max(0.28, 0.54-0.25)
= 0.53 + 0.75 + 0.29 + 0.29 = 1.86 µm. Cell width = 7*0.46 = 3.22 µm. Fits easily.

At L=0.15: span = 0.53 + 0.45 + max(0.28, 0.39) + max(0.28, 0.39) = 0.53+0.45+0.39+0.39 = 1.76 µm. Cell 3.22 µm. Fine.

Hmm, but wait — width=7 might be more than needed but it's safe. The examples use width=6 or 7. Let me check coach note 4: "Choose width (columns of 0.46) so it fits at L=0.25 as well." span at L=0.25 is 1.86 µm ≈ 4 columns (1.84 µm). So width=5 would barely fit (2.30 µm > 1.86). width=7 is comfortable. But also the cell must accommodate the taps/rails template. width=7 is fine.

Actually, let me reconsider: is there any issue with the n-row diffusion nd1 spanning all three gates with n1 series (no contact)? cn1l = enclose cn1 li net=n1 — it's a contact column between g1 and g2 with net n1 but no strap/port. That's the series node. Coach note: "A diffusion region with two series gates and no contact between them needs only 0.21 (poly spacing) between the gates." We use max(0.28, 0.54-L) ≥ 0.28 ≥ 0.21. Fine. And cn1l has a li enclosure but no metal — it's just a labeled li strip, net=n1, used by devices M0 (drain) and M5 (source). LVS sees the diffusion connection through the shared diff region. Good — like o21ai's (n1).

Wait, in o21ai, n1 was c1l (left of g1) net=n2... no. Let me recheck o21ai: n-row: n2 [A2] VGND [A1] n2 [B1] Y. c1 = left_of g1 net=n2 (c1l), c3 = right_of g2 net=n2 (c3l). So n2 appears at left_of g1 and right_of g2 — split, routed. And there's no series-no-contact node in n-row of o21ai. In nand3: n-row: Y [A] (n2) [B] (n1) [C] VGND — n2 between g1 and g2 (c? ), n1 between g2 and g3. c1 = left_of g1 net=Y... hmm nand3 n-row: c1 = left_of g1 (net=Y), c2 = right_of g3 (net=VGND). The internal series nodes n2 (between g1,g2) and n1 (between g2,g3) — are there contact arrays there? Looking at nand3 code: only c1 (left_of g1) and c2 (right_of g3) have array licon. The series nodes between gates have NO contacts — just the shared diffusion. Right, because "array licon in=nd1 left_of=g1" etc. only where contacts needed.

In our n-row, n1 is between g1 and g2 — no contact needed. We don't create an array there. Good, I didn't. cn1 was right_of g1... wait I wrote `cn1 = array licon in=nd1 right_of=g1` with net=n1. That's the column between g1 and g2 — but I gave it a contact and net=n1. Is that a problem? A contact on the series node n1 is not wrong electrically (it's still net n1), but it's unnecessary and adds a contact. Coach note: "(net) = series node, no contact". So I should NOT put a contact on n1. Let me remove cn1/cn1l.

But wait — if there's no contact between g1 and g2 in the n-row, is the diffusion still one rectangle nd1 spanning everything? Yes, nd1 is one rect. The devices M0 and M5 share the diffusion region between their gates — that's the series connection n1. No contact needed. LVS: M0 drain and M5 source both connect to the same diff node. Good.

So n-row contacts: left_of g1 (VGND), right_of g2 (Y), right_of g3 (VGND). No contact between g1-g2 (n1 series) or... wait, what about between g2 and g3? That's Y (cn2), has contact. And M3 (B1): source=Y (left column = right_of g2 = cn2), drain=VGND (right column = right_of g3 = cn3). ✓.

Let me also double check M0: g=A2 (g1), source=VGND (left_of g1 = cn0), drain=n1 (right_of g1 = between g1 and g2, no contact). ✓
M5: g=A1 (g2), source=n1 (left column = between g1 and g2, no contact), drain=Y (right_of g2 = cn2). ✓

Now p-row: M4 (A2, g1): source=n2 (left_of g1 = cp0), drain=VPWR (right_of g1 = cp1). ✓ (M4 d=VPWR g=A2 s=n2)
M1 (A1, g2): source=VPWR (left column = right_of g1 = cp1), drain=n2 (right_of g2 = cp2). ✓ (M1 d=n2 g=A1 s=VPWR)
M2 (B1, g3): source=n2 (left column = right_of g2 = cp2), drain=Y (right_of g3 = cp3). ✓ (M2 d=Y g=B1 s=n2)

n2: cp0 (left end, contact) and cp2 (internal, contact), both net=n2, route n2 joins. ✓
VPWR: cp1, strap to vpwr_li. ✓
Y: cp3 (p-row drain) and cn2 (n-row drain) — different x, route Y. ✓

Now gate contacts: gc1 on g1 (A2), gc2 on g2 (A1), gc3 on g3 (B1), all at bottom=cb. cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25) — only n-row items per coach note 1. I included cn0l, cn2l, cn3l (n-row contact li tops). Good, no p-row items.

Wait, coach note 1 says cb may use ONLY n-row items: `cb = max(nd.top + 0.19, <n-row contact li>.top + 0.25, ...)`. I have cn0l, cn2l, cn3l — all n-row. Good. (I removed cn1l.)

Now, the gate contacts are at cx=g1.cx, g2.cx, g3.cx. Gate pitch: g2.left = g1.right + max(0.28, 0.54-L). At L=0.15: pitch = 0.15 + 0.39 = 0.54. Gate contact poly pad: enclose gc poly by=minx — poly contact enclosure 0.05/0.08, so pad ≈ L + 2*0.05 = 0.25 wide? Coach note says poly pads are 0.33 wide, need pitch ≥ 0.54. At L=0.15, pitch = 0.54 ✓ (0.54-L = 0.39 > 0.28). At L=0.25: pitch = 0.15 + max(0.28, 0.29) = 0.15+0.29 = 0.44. Hmm, 0.44 < 0.54! But at L=0.25, the gate is wider (0.25), poly pad ≈ 0.25 + 0.16 = 0.41, pitch 0.44 — gap between pads = 0.03. Is that OK? Poly spacing is 0.21 between poly shapes... but the gate contact pads are on poly layer (enclose gc poly). Two adjacent gate poly pads: g1's pad and g2's pad. The gates themselves are spaced by 0.29 (poly spacing 0.21 min, but we have 0.29 gap). The pads extend 0.05 (minx) beyond each gate → pad gap = 0.29 - 0.10 = 0.19 < 0.21 poly spacing! DRC violation poly.2?

Hmm wait. Let me reconsider. `enclose gc poly by=minx` — minx means extra on left/right. The poly enclosure of a poly contact is 0.05 (0.08 one axis). by=minx → left/right enclosure = min (0.05?), top/bottom = min all-round? Let me re-read: "by=min: all-round rule + the one-direction extra on top/bottom; minx: extra on left/right". Hmm, actually from the rules: "poly enclosure of a poly contact 0.05 (0.08 one axis)". So by=minx probably gives 0.08 on left/right and 0.05 top/bottom? Or the reverse.

The coach note 2 says: "The poly pads are 0.33 wide, so neighbouring gates need a centre-to-centre pitch of at least 0.54 um." and "g2 = cross [nd, pd] poly w=L left=(g1.right + max(0.28, 0.54 - L))". So they explicitly use max(0.28, 0.54 - L) as the gap between gates. At L=0.25: gap = max(0.28, 0.29) = 0.29, pitch = 0.54. Wait: g2.left = g1.right + 0.29, so pitch = L + 0.29 = 0.25 + 0.29 = 0.54. I miscalculated before. pitch = L + gap = 0.25 + 0.29 = 0.54 ✓. At L=0.15: pitch = 0.15 + 0.39 = 0.54 ✓. So pitch is always 0.54 when 0.54-L > 0.28, i.e., L < 0.26. At L=0.25, 0.54-0.25 = 0.29 > 0.28, so gap=0.29, pitch=0.54. Good, the examples use this exact formula and are verified clean. I'll copy it.

In my code I wrote `g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L))`. ✓ matches.

Now, I used `rect poly` for gates instead of `cross`. The examples (o21ai, nand3) use `rect poly w=L left=... yspan=(ny0 - 0.13, py1 + 0.13)` — a vertical poly rectangle crossing both rows. That works and is verified. The `cross` verb is also fine but `rect` with yspan is what the verified examples use. I'll use rect poly like the examples.

One concern: `rect poly ... yspan=(ny0 - 0.13, py1 + 0.13)` — the poly extends 0.13 beyond the diff rows (poly endcap past diff 0.13). ny0 - 0.13 is below nd1 bottom (ny0), py1 + 0.13 above pd1 top (py1). ✓.

Now the well: `well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)`. nd1.top = ny0 + WN, pd1.bottom = py1 - WP. ✓ matches examples.

Now, `route n2 layers=m1,m2 prefer=m2` — n2 connects cp0l and cp2l (both li, net=n2). The router will create m1/m2 shapes and vias. Good. Do I need a port for n2? No, internal net, no port. Coach note 8: "Internal nets (n1, n2...) that are not ports need no met1 pin." But n2 needs route to connect the two pieces. ✓.

Now Y: cn2l (n-row, net=Y) and cp3l (p-row, net=Y) — route Y layers=m1,m2 prefer=m2, and `port Y out` (no on=, pin goes on routed met1). Like o21ai/nand3.

Wait, but should I also consider a strap? cn2l is at right_of g2 (x = g2.right + contact offset), cp3l at right_of g3. Different x. Can't strap vertically. Could I make them align? If I put p-row Y at left_of g3 (= right_of g2 position)... but we determined that column must be n2 (shared by M1 and M2). Unless I change gate order.

Alternative gate order to align Y: What if p-row order is A2, A1, B1 but we want Y column at right_of g2 position. Column right_of g2 is shared by M1 (A1) and M2 (B1) → must be n2 (intersection of {n2,VPWR} and {n2,Y}). So p-row Y can't be there. p-row Y is right_of g3 (M2's drain). n-row Y is right_of g2 (M5's drain = M3's source). They're inherently at different x with this gate order.

Could I choose a different gate order where n-row Y and p-row Y align? n-row Y is between M5 (A1) and M3 (B1) — i.e., right_of A1 gate if order is ..., A1, B1, ... or left_of B1 gate. p-row Y is M2's drain, an end column (M2 only connects to n2 and Y; if M2 is at an end, Y is the outer column).

For alignment, we'd want n-row Y column and p-row Y column at same x. Suppose gate order A2, B1, A1:
- n-row: M0(A2), M3(B1), M5(A1). Adjacency: M0∩M3={VGND}, M3∩M5={Y}. So: VGND | [A2] | VGND | [B1] | Y | [A1] | n1? M5: {n1, Y}, left column = Y (right_of B1), right column = n1 (end). n-row: VGND [A2] VGND [B1] Y [A1] n1(end). Y at right_of B1.
- p-row: M4(A2), M2(B1), M1(A1). M4∩M2={n2}, M2∩M1={n2}. n2 | [A2] | n2 | [B1] | n2 | [A1] | VPWR? M2: {n2, Y} — columns are n2 (left, right_of A2) and n2 (right, right_of B1)? Both n2 — conflict, M2 needs Y. So order A2,B1,A1 doesn't work for p-row (M2 would need Y on one side but both neighbors want n2).

The fundamental issue: M2 (B1) needs {n2, Y}; if B1 is internal, both neighbors are n2 (since M1∩M2={n2}, M4∩M2={n2}), leaving no room for Y. So B1 must be at an end with Y as the outer column. Similarly in n-row, M3 (B1) needs {Y, VGND}; if B1 internal, neighbors: M0∩M3={VGND}, M5∩M3={Y} — so B1 internal works with VGND on one side, Y on other. So n-row wants B1 internal (A2, B1, A1 or A1, B1, A2), p-row wants B1 at end. Conflict → can't perfectly align. 

So route Y is the right call. Both verified examples route Y. Good.

Actually, wait. Let me reconsider keeping B1 internal in both rows (order A2, A1, B1 has B1 at end; order A2, B1, A1 has B1 internal). We showed p-row fails with B1 internal because M2 needs Y but both sides n2. Unless we break the p-row into islands (like o21ai's break). With an island break, B1 could be at the start of an island with Y as outer column. E.g., p-row: Island1: n2 [A2] VPWR [A1] n2 (break) Island2: Y [B1] n2? Hmm, but then gate order isn't the same across the break... coach note 10 says same gate order, but islands can break it (o21ai has a break and the order after the break is VPWR VPWR [B1] Y — B1 is after the break).

This is getting complicated. The simplest, verified-clean approach: route Y. Let me go with order A2, A1, B1 in both rows, route Y and route n2.

Actually, let me reconsider: can I avoid routing n2 by making n2 contiguous? n2 touches M4 (A2), M1 (A1), M2 (B1). For n2 to be a single contiguous diffusion column, it must be between two gates shared by two devices, touching at most 2 devices. Since n2 touches 3 devices, it can't be one column. Unless one of the devices connects to n2 via... no, each device's source/drain are adjacent columns. So n2 needs ≥ 2 columns → route. Confirmed, route n2. (Same as o21ai routing n2.)

Now let me also double-check: cp0l is left_of g1, an end column with net n2 and a contact. cp2l is right_of g2, net n2, contact. Both on p-row pd1. Route n2 connects them. But also — does n2 need to connect to any gate contact? No, n2 is not a gate net. Good.

Now, are there any DRC concerns with cp0l being an end column (diffusion end) with a contact? End contact: 0.265 from gate edge. array licon left_of=g1 handles that. ✓.

Let me also verify the `strap li from=cn0l to=vgnd_li` and `from=cn3l to=vgnd_li` — vertical straps? cn0l is at left_of g1 (x ≈ g1.left - 0.265 + contact), vgnd_li is a template rail spanning the cell. A vertical li strap from cn0l to vgnd_li: they need to be vertically aligned (same x)? `strap` joins two aligned shapes. cn0l is a column at x≈left side; vgnd_li is a horizontal rail. Hmm, in o21ai: `c2s = strap li from=c2l to=vgnd_li` where c2l is right_of g1 (net=VGND) and vgnd_li is the ground rail. So strap connects a contact column to the rail — they must overlap in x. The strap is vertical (along the column) reaching up to the rail. Since cn0l (left_of g1) and vgnd_li — vgnd_li spans the whole cell width at some y, so it overlaps cn0l's x. The strap goes from cn0l up to vgnd_li. That works (o21ai does it). ✓.

Similarly cp1s = strap li from=cp1l to=vpwr_li. ✓.

Now, one more: the n-row VGND contacts cn0l (left end) and cn3l (right end) both strapped to vgnd_li. Good — M0 source and M3 drain both to VGND.

Let me also reconsider width. span at L=0.25 = 0.53 + 0.75 + 0.29 + 0.29 = 1.86 µm. At L=0.18 (sweep point 1): span = 0.53 + 0.54 + max(0.28, 0.36) + max(0.28, 0.36) = 0.53+0.54+0.36+0.36 = 1.79. At L=0.15: 1.76. So max span ≈ 1.86 µm at L=0.25. width columns: 0.46 each. 4 columns = 1.84 < 1.86 (too tight!). 5 columns = 2.30 > 1.86 ✓. So width=5 minimum. The examples use 6 or 7 for margin and to fit taps/rails/ports. I'll use width=7 like o21ai for safety (also accommodates H up to 4.08, more routing room). Actually width doesn't depend on H. width=7 is fine and safe.

Hmm, but actually, does a wider cell cause issues? No, just more empty space. The template rails span the cell. Fine. I'll use width=7.

Wait, let me reconsider the sweep: "L=0.15 widths x0.85" — widths scaled by 0.85? "L=0.15 widths x0.85 H=2.72" — so WN, WP scaled by 0.85, and cell width columns scaled? "widths x0.85" probably means WN/WP x0.85 (device widths), not the cell width column count. The cell width=7 columns is fixed. Device widths shrink, diffusion rows shrink (h=WN, h=WP), but nd1/pd1 xspan is determined by gates, not device width. So cell width stays 3.22 µm. Fine. And "L=0.15 widths x1.35 H=3.26", "L=0.15 widths x1.9 H=4.08" — device widths grow, H grows. Diffusion rows get taller (h=WP up to 0.75*1.9=1.425). py1 - WP to py1 — the p-row gets taller upward. ny0 = ptap.top + 0.27 fixed. nd1 height = WN up to 0.49*1.9=0.931. The well and taps template handle vertical. Should be OK as long as rows don't overlap taps. ny0 = ptap.top + 0.27, nd1 from ny0 to ny0+WN. p-row from py1-WP to py1, py1 = ntap.bottom - 0.27. The well splits between them. With H=4.08 there's plenty of vertical room. The verified examples presumably handle this; our structure is identical to o21ai/nand3 vertically. Good.

Now, `cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25)`. nd1.top = ny0 + WN. cn0l.top = ny0 + WN (same row). So all the n-row contact li tops are at nd1.top (li encloses licon which is in diff; li top ≈ diff top + enclosure). Actually licon is in nd (diff), li encloses it. li top = nd.top + ~0.08. So cn0l.top ≈ nd1.top + 0.08. Then cb = max(nd1.top+0.19, nd1.top+0.08+0.25=nd1.top+0.33, ...) = nd1.top + 0.33. Gate contact bottom at nd1.top + 0.33, which is ≥ nd1.top + 0.19 (poly contact to diffusion 0.19) ✓ and ≥ li top + 0.25 (li-to-li 0.17 + ... coach note: 0.17 li-to-li above contact strips). The example uses exactly this. ✓.

Coach note 1: cb only n-row items ✓ (nd1, cn0l, cn2l, cn3l — all n-row).

Now gate contact poly pad: `gp1 = enclose gc1 poly by=minx`. The pad must overlap the gate (g1). gc1 is at cx=g1.cx, on the gate line. ✓. `gl1 = enclose gc1 li net=A2` — li over the gate contact, net A2. Then mcon in=gl1, m1 enclosure, port. ✓.

`gn = enclose [gc1, gc2, gc3] npc` — npc around all gate contacts ✓ (coach note 3).

Now, potential issue: `enclose gc1 poly by=minx` creates a poly pad that extends beyond g1. Adjacent gate pads: gap between g1 and g2 is max(0.28, 0.54-L). Pad extends minx (0.08?) each side → pad gap = gap - 2*0.08. At L=0.15: gap=0.39, pad gap=0.23 ≥ 0.21 poly spacing ✓. At L=0.25: gap=0.29, pad gap=0.13 < 0.21 ✗?! 

Hmm, but the verified examples use exactly this and are clean over the sweep including L=0.25. So either minx enclosure is smaller (0.05 each side → pad gap = 0.29 - 0.10 = 0.19, still < 0.21) or the poly pads don't actually need 0.21 between them because... Actually, the gate poly rectangles g1 and g2 are already spaced by `gap` (≥ 0.28 > 0.21). The `enclose gc poly` pads are on the same poly layer but they're part of the gate poly (they enclose the contact which is ON the gate). The pad merges with the gate poly — it's one continuous poly shape (the gate plus pad extension). So there's no separate pad shape between gates; the pad just extends the existing gate poly outward. The gate poly spacing is governed by g1/g2 gap (≥ 0.28). The pad extension goes outward (away from the neighboring gate) since the contact is centered on the gate. So no DRC issue. The coach note's "0.54 pitch" is about the contact pads not overlapping each other when contacts are large, but since pads merge with gates, the constraint is just gate spacing ≥ 0.21 and contact-to-contact spacing. Contacts gc1, gc2 are at pitch ≥ 0.54, licon spacing 0.17 — fine. OK, copying the verified formula is safe.

Now let me also double check: do I need `npc` enclosure? Yes, poly contacts need npc (0.1 enclosure). ✓.

Let me also verify there are no dangling nets: nets used: VGND, VPWR (template rails, devices reference them), n1 (M0 d, M5 s, cn1? no contact — but n1 is in device netlist and... is n1 used in geometry? I removed cn1l. n1 appears only in device statements. Is that OK? The devices M0 d=n1 and M5 s=n1 — LVS checks the diff connection between them (shared diffusion, no contact). n1 doesn't need a geometry label. But "a net used once triggers a dangling warning" — n1 is used twice (M0 d, M5 s). Fine, no warning. n2: M1 d, M2 s, cp0l, cp2l, route. Used multiple times. Y: M2 d, M3 s, cn2l, cp3l, route, port. A1: M1 g, M5 g, gl2, port. A2: M0 g, M4 g, gl1, port. B1: M2 g, M3 g, gl3, port. All good.

Wait, n1: only in device statements (M0 d=n1, M5 s=n1). That's 2 uses, not dangling. And geometrically they share diffusion (adjacent columns? No — M0 drain is right_of g1, M5 source is left_of g2 = right_of g1 — same column!). Yes! right_of g1 is the column between g1 and g2. M0 (g1) drain = right_of g1 column. M5 (g2) source = left_of g2 column = same column (right_of g1). So they share the diffusion column = n1 series node, no contact. LVS sees one diff node. 

But I don't have a contact or label on that column. Is that OK for LVS? The net n1 is defined by the two device terminals. The geometry: the diffusion rectangle nd1 is continuous, and the column between g1 and g2 is part of nd1. M0's drain region and M5's source region are the same diff area. netgen should recognize them as the same node n1. In o21ai/nand3, series nodes (n1, n2) between gates have no contacts/labels and it's fine. ✓.

Now, one concern: in the n-row, between g1 and g2 there's no contact array, so no li there. That's fine.

Let me also reconsider: I have `cn1 = array licon in=nd1 right_of=g1` in my draft — I decided to remove it (no contact on series node). Let me make sure the final code doesn't have it. Also `cn1l` references — remove.

Let me also double-check the p-row cp0 (left_of g1, net n2) — end contact column. And cp2 (right_of g2, net n2). Both net n2,