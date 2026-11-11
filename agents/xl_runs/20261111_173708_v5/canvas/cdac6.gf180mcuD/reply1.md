I'll analyze the gf180mcuD rule sheet and design a regular capacitor array with deterministic routing. Let me write the script.
```python
from icdsl.canvas import *

tech = use()
assert tech.name == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4
top_m = tech.stack[-1]
assert "cap_mim" in tech.d["devices"], "gf180mcuD must have cap_mim"

# ------------------------------------------------------------------ array
CAP = 5.0          # unit cap: 5 x 5 um  (cap_mim wmin=5)
PX, PY = 8.6, 9.6  # x/y pitch (leaves routing channels)
COLS, ROWS = 8, 8
assert COLS * ROWS == 64

counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
net_list = []
while any(counts.values()):
    for n in order:
        if counts[n] > 0:
            net_list.append(n)
            counts[n] -= 1
assert len(net_list) == 64

c = Cell("cdac6")
caps = []
for r in range(ROWS):
    for col in range(COLS):
        k = c.capacitor("cap_mim", w=CAP, h=CAP,
                        at=(col * PX, r * PY),
                        nets=("TOP", net_list[r * COLS + col]))
        caps.append(k)

# ------------------------------------------------------------------ TOP rail (all top plates)
# one m1 rail per row at the top-pad y, plus a vertical m1 bus to the right of the array
array_right = COLS * PX
bus_x = array_right + 1.2
rail_y = {}
for r in range(ROWS):
    row = caps[r * COLS:(r + 1) * COLS]
    ys = [t.top_pad.cy for t in row]
    assert max(ys) - min(ys) < 0.01
    y = ys[0]
    x0 = min(t.top_pad.left for t in row) - 0.2
    x1 = bus_x + 0.3
    c.rect(c0, x0=x0, x1=x1, y0=y - 0.12, y1=y + 0.12, net="TOP")
    rail_y[r] = y
c.rect(c0, x0=bus_x - 0.3, x1=bus_x + 0.3,
       y0=min(rail_y.values()) - 1.0, y1=max(rail_y.values()) + 1.0, net="TOP")
c.port("TOP", on=c.rect(c0, x0=bus_x, x1=bus_x + 2.6,
                        y0=(min(rail_y.values()) + max(rail_y.values())) / 2 - 1.4,
                        y1=(min(rail_y.values()) + max(rail_y.values())) / 2 + 1.4,
                        net="TOP"))

# ------------------------------------------------------------------ bottom plates -> router on c2/c3
rtr = Router(c, v=c3, h=c2, pin_layer=c2, via_top_dir="v")
for net in ("B5", "B4", "B3", "B2", "B1", "B0", "VSS"):
    pads = [t.b for t, n in zip(caps, net_list) if n == net]
    pins = []
    for p in pads:
        pins.append(c.rect(c2, x0=p.left - 0.35, x1=p.right + 0.35,
                           y0=p.bottom - 0.35, y1=p.top + 0.35, net=net))
        c.via(c0, c2, at=p.bbox, net=net, dir="h")
    rtr.add(net, *pins)

# bit buses on c3 to the right of the array, ports on c3
bus_y = {}
for net in ("B5", "B4", "B3", "B2", "B1", "B0", "VSS"):
    bus_y[net] = -1.0  # placeholder, set below
# place buses stacked vertically below the array
by = -2.6
for net in ("B0", "B1", "B2", "B3", "B4", "B5", "VSS"):
    c.rect(c3, x0=0.0, x1=array_right + 3.0, y0=by, y1=by + 1.6, net=net)
    bus_y[net] = by + 0.8
    by += 2.2

# connect router results to the bit buses
done = rtr.run()
for net, shape in done.items():
    # route from the router shape up to the c3 bit bus (vertical c2 segment + via)
    sx, sy = shape.cx, shape.cy
    ty = bus_y[net]
    c.wire(c2, [(sx, sy), (sx, ty)], net=net, width=0.6, first="v")
    c.via(c2, c3, at=(sx, ty), net=net, dir="v")
    c.port(net, on=c.rect(c3, x0=sx - 1.0, x1=sx + 1.0,
                          y0=ty - 0.85, y1=ty + 0.85, net=net))

TOP = c
```

Let me reconsider a few things before finalizing:

1. The `Router` with `v=c3, h=c2, pin_layer=c2`: columns on c3 (vertical), trunks on c2 (horizontal), pins on c2. Pins are my c2 rectangles around bottom pads. The router connects same-net pins. It returns a shape per net. Then I connect that shape to the c3 bit bus.

2. Concern: the router treats same-net shapes — "A same-net shape is reused only where the new wire contains it or is contained by it; otherwise it is avoided." My c2 pin rectangles are same-net as the net being routed, so they're reused/contained. Good. But different nets' c2 pin rectangles are obstacles for each other — fine.

3. The TOP m1 rail: it runs horizontally at top_pad y through each row. It overlaps each top pad (m1) → connected. But does it overlap any bottom pad? Bottom pads are at bottom_pad y within each cell. If top_pad.cy != bottom_pad.cy, no overlap. For a symmetric cap PCell, top_pad and bottom_pad might be at the same center but different... no, they're different plates, likely at different positions or same center with via stacks. Hmm, if both pads are at the cell center (same x,y) on m1, they'd overlap each other (short!) — that can't be. So they must be at different locations. Likely top_pad at top edge, bottom_pad at bottom edge, or side by side. My rail at top_pad y could hit a bottom pad only if some cap's bottom pad shares that y. Within a row, all top pads share y=rail_y[r]. Bottom pads in that row share bottom_pad y (different). Bottom pads in OTHER rows have different y. So the horizontal rail at row r's top_pad y only potentially hits bottom pads in row r if bottom_pad.cy == top_pad.cy — unlikely. I'll assume distinct. To be safe, I could make the rail thin and check. Let me keep it but it should be fine.

Actually, wait: there's a real risk. The m1 rail passes through every cap cell in the row at y=top_pad_y. Within a cell, at that y, the only m1 feature is the top pad (good). But the rail is a continuous rectangle from x0 to bus_x — it crosses all 8 cells. Fine.

4. The vertical TOP bus at bus_x spans all y from min rail to max rail + margin. It's at x = bus_x ± 0.3, which is to the right of the array (array_right = COLS*PX = 68.8, bus_x = 70.0). The rightmost column of caps is at x from 7*PX=60.2 to 60.2+5=65.2. Their top pads are within that. The rail extends to bus_x+0.3=70.3. The vertical bus at 69.7-70.3. No caps there. Good. But the vertical bus crosses the horizontal rails — same net (TOP), they merge, fine.

5. Port TOP: a c2? No, I made it c0 at bus_x. It's on the vertical bus. Good. But port on c0 — top-level pin on m1 is fine.

6. Bottom routing: router result shape per net — where is it? `h = r.run()` returns {net: drawn shape}. I connect from shape.cx,cy vertically on c2 to the bit bus at bus_y[net]. The bit buses are below the array (y negative). The router shape is somewhere among the pins (in the array region). A vertical c2 wire from shape down to bus_y. It might cross other nets' pins/router shapes — different layers? No, c2 is same layer for all bottom nets! A vertical c2 wire for net B5 at x=sx could cross a horizontal c2 trunk for net B4 → short on same layer!

This is a problem. The router already routed each net on c2/c3 avoiding obstacles. The result shape is the routed wire. If I then add more c2 wires manually, they might conflict.

Better: let the router connect directly to the bit buses. Add the bit bus (c3) as a pin for each net, OR route on c3. Let me restructure:

- Put bit buses on c3 (vertical layer = columns). 
- Router: v=c3 (columns), h=c2 (trunks), pin_layer=c2.
- For each net, pins = c2 rectangles around bottom pads PLUS a connection to the c3 bit bus.

Hmm, but the bit bus is on c3 and pins on c2. The router would need a via between pin (c2) and bus (c3). 

Alternative: Make the bit buses on c2 too (same layer as routing), and have the router connect pins to the bus shape. If I add the bus rectangle as a pin for the net, the router includes it. Let me add each bit bus as a pin:

```
rtr.add(net, *pins, bus_rect)
```
where bus_rect is on c2. But I wanted buses on c3. Let me just put everything on c2 for bottom nets: bit buses as horizontal c2 strips below the array, one per net, stacked in y. Router connects bottom pads (c2 pins) to the bus (c2 pin). Then ports on c2.

But c2 horizontal buses stacked in y, each a different net — they don't touch (different y). The router routes on c2 (horizontal trunks) and c3 (vertical columns). Pins on c2. To connect a pin to a bus (both c2), the router uses horizontal trunks on c2 directly if they align, or vertical columns on c3 + horizontal trunks. Should work.

Let me redo:
- Bit buses: horizontal c2 strips, one per net, at different y below array, spanning full array width + port area.
- Router pins: c2 rect around each bottom pad + the bus strip for that net.
- rtr.run() connects all pads of a net to its bus.
- Port: on the bus strip.

But the bus strip is a pin (same net) — router reuses it. Good. The router will route from pads to bus. Since bus is a long strip, pads connect to it.

However, there's a subtlety: the router "one trunk per pin row plus a spine column" etc. With many pins (32 for B5) and a bus, it should find a solution.

Also, the TOP m1 rails are on m1 (c0), bottom routing on c2/c3 — different layers, no conflict. The vias c0→c2 at bottom pads: via stack goes through c1. At the pad location, is there a TOP m1 rail? TOP rail is at top_pad y, via at bottom pad location (bottom_pad y). Different y → no conflict. Good. But the via c0→c2 occupies some x,y; the c2 routing starts there. Fine.

Wait, `c.via(c0, c2, at=p.bbox, ...)` — `at` should be a point, not a bbox. Let me use `at=p.bbox` — the docs say `at=(x, y)`. Let me use `at=(p.cx, p.cy)`. Actually via with `at` as a point creates a single via; the pad might be larger than the via. The via connects c0 to c2; the c0 pad overlaps the via (if via is within pad) → connected. Let me place via at pad center. But the via has a size (cut stack) and pads on c0 and c2. The c2 pad of the via might be smaller than my c2 pin rect. My c2 pin rect (p expanded by 0.35) contains the via's c2 pad → connected (overlap). Good.

Actually, simpler: instead of separate via + pin rect, the via itself creates c0 and c2 pads. Let me just use the via's c2 pad as the pin. But I need to know its size. `c.via_size(c0, c2)`. Let me use the via and then make the pin rect from the via's upper pad. Hmm, complexity. Let me just do: via at pad center, then c2 pin rect expanded around pad (contains via c2 pad). Overlap → connected. Good.

Let me also double check: does connecting c0 pad (bottom plate) to c2 via and c2 pin create electrical connection bottom_plate(m4) → ... → top_pad? No: bottom_pad is the m1 pad connected to the bottom plate via the via stack inside the capacitor. So bottom_pad (m1) is electrically the bottom plate. I connect bottom_pad (m1) via c0→c2 via to c2 routing → bit net. Good. The capacitor's internal via stack (m1 to m4/m5) is inside the PCell. Good.

7. Area: array 8*8.6=68.8 wide, 8*9.6=76.8 tall. Plus buses below (7 nets * 2.2 = 15.4) and port. Total roughly 68.8 x (76.8+15+margin) ≈ 68.8 x 95 ≈ 6536 um2. Budget 10578. Reference 73.6x71.86=5289. We're within budget. Good. Actually height: array from y=0 to 76.8, buses from -2.6 downward. Top port at rail center y ~ 38. Total bbox: x from 0 to ~73 (bus_x+2.6), y from ~-18 to ~78. Area ≈ 73*96 = 7008. Within 10578. 

But wait, I should center or it doesn't matter; bbox is what counts. Fine.

8. The router might fail with 32 pins for B5. If it does, I need a fallback. Let me make the router call robust and if it fails, the script errors. Let me think if 32 pins on c2 to one bus is routable. The router tries: bridge pins that abut, shared column, trunk per pin row + spine, one trunk. With 32 pins scattered in 8x8, "one trunk per pin row" = up to 8 trunks (rows) + spine column. Should be OK. The bus is a long horizontal strip below; pins connect up to it. Might need the spine. Let me trust the router with retries.

Actually, there's a concern: the router considers "Everything already on the two routing layers, in this cell or below, is an obstacle." The TOP m1 rails are on c0, not c2/c3, so not obstacles for c2/c3 routing. Good. The c2 pin rects of different nets are obstacles — the router avoids them. Good.

9. `rtr.add(net, *pins)` — pins must be shapes. My c2 rects are shapes. Good. But I also want the bus as a pin. Let me add bus rects as pins too. But I create buses after... let me create buses first, then add pins including bus.

Let me restructure the bottom section:

```
# bit buses on c2, stacked below array
buses = {}
by = -2.6
for net in ("B0","B1","B2","B3","B4","B5","VSS"):
    b = c.rect(c2, x0=-1.0, x1=array_right+1.0, y0=by, y1=by+1.6, net=net)
    buses[net] = b
    by += 2.2

rtr = Router(c, v=c3, h=c2, pin_layer=c2)
for net in ("B5","B4","B3","B2","B1","B0","VSS"):
    pins = [buses[net]]
    for t, n in zip(caps, net_list):
        if n == net:
            p = t.b
            pins.append(c.rect(c2, x0=p.left-0.3, x1=p.right+0.3, y0=p.bottom-0.3, y1=p.top+0.3, net=net))
            c.via(c0, c2, at=(p.cx, p.cy), net=net, dir="h")
    rtr.add(net, *pins)

done = rtr.run()
for net, shape in done.items():
    c.port(net, on=buses[net])
```

Wait, but the router returns a shape per net; the bus is already a pin (same net, contained/reused). I can just port the bus. But does the router actually connect all pins to the bus? It routes the net connecting all pins including the bus. Yes. Then port on bus. Good. I don't even need `done` for ports, but I need `rtr.run()` to succeed (it draws the wires). Let me call `done = rtr.run()` and port on buses.

But there's a catch: the bus rect is on c2 and is a pin for net B5. Other nets' routing must avoid it (it's a different-net obstacle on c2). The router avoids different-net shapes. Good. But the buses are long horizontal strips spanning the array width at different y — they're obstacles. The router routes vertical columns on c3 and horizontal trunks on c2. A c2 trunk for net B4 at some y might cross the B5 bus (c2, different net) → same layer conflict! The router should avoid since B5 bus is an obstacle. It routes around. Should be OK but the buses span the full width, blocking horizontal trunks. Hmm. The router uses c3 for vertical columns and c2 for horizontal trunks. To get from a pin (in array) to the bus (below), it might go vertical on c3 then horizontal on c2 to the bus. But horizontal c2 at the bus's y is blocked by other buses. It can connect to its own bus directly (same net, overlap). 

Actually, the simplest: each pin connects vertically on c3 down to its bus's y, then horizontally on c2 to the bus. But horizontal on c2 at bus y crosses other buses (different net, obstacle). Unless it goes to its own bus which is at that y — it can terminate at its own bus without crossing others if it approaches from above/below. Since buses are stacked, a pin above all buses connects down on c3 to its bus's y, then the c3 column is at the pin's x; to reach the bus (which spans all x at that y), the c3 column just needs to touch the bus at (pin_x, bus_y). c3 column and c2 bus cross at different layers (c3 over c2) — but they're different nets! c3 column (net B5) crossing c2 bus (net B4) at different layers is fine (no via). But to CONNECT B5 column to B5 bus, need a via c3→c2 at the bus. The via lands on c2 bus (B5) — good, and at that point is there a B4 bus? No, different y. So via at (pin_x, B5_bus_y) connects c3 column to c2 B5 bus. The c3 column passes over other c2 buses (B4, etc.) at different y — no via there, just crossing different layers — fine.

OK this can work. The router handles it. Let me not over-engineer; the router is designed for this.

However, I'm worried about the router failing. Let me add a fallback: if router fails, route manually. But I can't easily catch. Let me just trust it and keep pin count manageable. Actually, let me reduce complexity: instead of routing each bottom pad individually to a bus, note that all pads of a net connect to the same bus. The router connects them. Fine.

10. One more: `c.via(c0, c2, at=(p.cx, p.cy), net=net, dir="h")`. The via stack c0→c2 on gf180: contact (diff/poly→m1), via1 (m1→m2). Wait, c0=c0? For gf180, c0 = m1. So `c.via(c0, c2)` = via from m1 to m3? That's contact? No. Let me check the cuts for gf180:
- contact: diff|poly -> m1, size 0.22
- via1: m1 -> m2
- via2: m2 -> m3
- via3: m3 -> m4
- via4: m4 -> m5

So c0=m1, c1=m2, c2=m3. `c.via(c0, c2)` = m1 → m3, which is a cut stack contact+via1+via2? The `via` helper does "cut stack with pads". So c.via(c0, c2) builds m1→m2→m3 stack. That's fine, connects m1 pad to m3. But I want to route on c2 (m3) and c3 (m4). Hmm wait I set v=c3, h=c2. c2=m3, c3=m4. So routing on m3/m4. Via from m1 (c0) to m3 (c2) — that's contact+via1+via2 stack. OK.

But actually, do I need to route bottom nets on m3/m4? The MIM capacitor plates are on m4/m5. Routing on m4 (c3) is directly the plate layer — but the cap's bottom plate is on m4 or m5. If I route on m4, I might overlap the capacitor's plate (m4) → short! The cap_mim_2f0_m4m5: one plate m4, one m5. If bottom plate is m4 and I route m4 wires under/near the cap, they'd short to the bottom plate.

Hmm. But the capacitor PCell places the MIM (capm layer = dielectric) and plates. The m1 pads connect via vias up to the plates. The plate metal (m4/m5) within the cap cell is occupied by the plate. If I route m4 wires through cap cells, they'd overlap the plate → DRC short (different nets on same layer overlapping) or at least unwanted connection.

So I should NOT route on m4/m5 through the capacitor array. Route bottom nets on m1/m2 (c0/c1) or m2/m3. Let me use c0 (m1) and c1 (m2) for bottom routing, avoiding m4/m5.

But the TOP rail is on m1 (c0) too! TOP rail at top_pad y, bottom routing on m1 at bottom_pad y — different y, but vertical segments might cross. Let me separate: TOP on m1, bottom nets on m2 (c1) with vias m1→m2 at pads. m2 wires cross over TOP m1 rails (different layer, fine). Vias m1→m2 at bottom pad locations — at bottom_pad y, no TOP rail (TOP at top_pad y). Good.

So: Router(v=c2, h=c1, pin_layer=c1) for bottom nets. Columns on c2 (m3), trunks on c1 (m2), pins on c1 (m2). Via c0→c1 at bottom pads (contact+via1). Then route on m1/m2. m2 trunks cross TOP m1 rails — different layer, fine. No m4/m5 usage. 

But wait, the capacitor's top plate might be on m4 and bottom on m5, or vice versa. The m1 pads connect up. Routing on m1/m2 is safe (below m4). Good.

Let me also reconsider: the TOP rail on m1 — does it cross the capacitor's internal via stacks (m1→m4)? The capacitor's internal vias from m1 pad to m4 plate are at the pad locations. My TOP m1 rail overlaps the top pad (m1) — that's the connection, good. The internal via stack is at the top pad location too (m1 pad → up). My rail overlaps the m1 pad; the via stack is also there — same net (TOP), fine. No conflict.

For bottom pads: my c0→c1 via at bottom pad center, and the capacitor's internal via stack is also at the bottom pad (m1 → down plate). Both at bottom pad m1, same net (the bit net), fine. My c1 via pad connects to m2 routing. Good.

But: does my c0→c1 via (at bottom pad) overlap the TOP m1 rail? The via is at bottom_pad (x,y). TOP rail is at top_pad y. If bottom_pad.cy != top_pad.cy, the via (small, around bottom pad) doesn't touch the rail. Good. But the via's c0 pad might be larger than the bottom pad? via_size(c0,c1) gives pad sizes. The c0 pad of the via should be within or equal to the contact enclosure over the m1 pad. The m1 bottom pad is sized by the PCell. The via c0 pad (contact pad) might be larger than the m1 pad → extends beyond → could hit TOP rail if close. The via c0 pad is centered at bottom pad; extends by pad_size/2. If top_pad and bottom_pad are far apart (e.g., top edge vs bottom edge of 5x5 cell), no issue. If they're close... Let me assume the PCell places top_pad and bottom_pad at opposite edges or with sufficient separation. For a 5x5 cap, pads likely at corners or mid-edges. Separation should be ≥ a few um. The via pad is ~0.3-0.5 um. Safe.

Actually, I realize I don't know the pad positions. Let me make the script robust by reading them and designing routing relative to actual positions. But I can't run it. Let me make reasonable assumptions and keep clearances generous.

Let me reconsider: maybe top_pad and bottom_pad are both small m1 pads at the center of the cap but the cap PCell puts them at different locations to avoid short. Given they're different nets, they can't overlap. Most likely they're at two corners or opposite sides. Separation ≥ ~2 um. Fine.

Let me also handle: the TOP rail passes through each cap cell at top_pad y. Within the cell, at that y, is there anything else on m1? The bottom pad is at bottom_pad y (different). The internal via stacks are at the pads. So rail only hits top pad. Good. But the rail is a long rectangle; within a cell it spans the full cell width at top_pad y. If bottom pad happens to be at same y (unlikely), short. I'll add a small check: assert top_pad.cy != bottom_pad.cy for the first cap. Actually, let me just make the rail not span full cell but connect pads with short segments? No, a continuous rail is fine and simpler. I'll trust distinct y.

Hmm, but actually there's another subtlety: the TOP rail at row r's top_pad y passes through ALL cells in row r, including cells where... all cells in row r have top pads at that y (same row). So rail connects all top pads in row r. Good. It doesn't pass through other rows. Good.

11. Let me also make sure the TOP rail doesn't short to bottom pads of the SAME row via the vertical bus or extensions. The rail extends to bus_x (right of array). At the right end, it turns up via the vertical bus. Bottom pads in the rightmost column are at x within the last cell (≤65.2), bus at 69.7+. No overlap. Good.

12. Ports: TOP port on c0 vertical bus. Bottom ports on c2 (m2) buses. All good. Pin names: TOP B0 B1 B2 B3 VSS B4 B5 — matches netlist order (order doesn't matter for LVS, just names).

Wait, the netlist pins: TOP B0 B1 B2 B3 VSS B4 B5. My ports: TOP, B5, B4, B3, B2, B1, B0, VSS. Same set. Good.

13. LVS: 64 cap_mim devices, each 5x5. The netlist has XC0..XC63 each cap_mim_2f0_m4m5_noshield c_width=5u c_length=5u. My 64 capacitors each w=5,h=5. LVS checks same devices, W/L, connectivity. The model name must match: cap_mim_2f0_m4m5_noshield. The PCell uses the PDK recipe which maps to that model. Good. Connectivity: all top plates to TOP, bottom plates to correct bits. Good.

But wait — LVS "same W/L": for capacitors, W and L. My caps are 5x5. Netlist c_width=5 c_length=5. Good. But does the extracted cap report width/length as 5? The PCell draws w=5,h=5. Should match.

14. DRC: cap_mim min width 5 um — my caps are exactly 5. Good. capm space 0.6 um — caps spaced by pitch 8.6/9.6, the capm (dielectric) is 5x5, space between caps = 8.6-5=3.6 (x) and 9.6-5=4.6 (y) ≥ 0.6. Good. But the MIM plates (m4/m5) are 5x5 too, same spacing. Good.

m1 width min 0.23, space 0.23. My rails are 0.24 tall (y0=y-0.12,y1=y+0.12 → 0.24) ≥ 0.23. Good. Via enclosure m1>via1: 0,0.06 — the via c0 pad must be enclosed by m1. The via helper handles enclosure. The bottom pad (m1) must enclose the via c0 pad. The PCell's bottom pad size — is it big enough for the via? The via c0 pad size for contact is 0.22x0.22 with enclosure. The bottom pad is probably larger (designed for it). Should be OK; the PCell is designed to connect. Actually, the bottom_pad is the m1 pad that the PCell intends for external connection; it should be via-compatible. I'll trust it but make my via not larger than needed. `c.via(c0,c1,at=...)` uses default via size (minimum). The via c0 pad = contact pad ~0.22+2*0.07 enclosure? The m1 pad must extend 0.07 beyond contact on all sides (diff>contact 0.07, but that's diff>contact; for m1>contact it's 0.005,0.06). The bottom pad likely ≥ contact pad + enclosure. Trust PCell.

15. The router: let me make sure `Router(c, v=c2, h=c1, pin_layer=c1)` is valid. v=vertical layer for columns, h=horizontal for trunks, pin_layer for pins. Defaults v=c2,h=c3,pin=c1. I'm overriding v=c2 (m3), h=c1 (m2). That's fine (two layers). But c1=m2 and c2=m3 — adjacent, via between them (via2). Good.

Wait, but I want bottom routing on m1/m2 (c0/c1), not m2/m3 (c1/c2). Because m3 is near m4 plates. Let me use v=c1, h=c0? Columns on c1 (m2), trunks on c0 (m1), pins on c0 (m1). But TOP rail is on c0 (m1) — obstacles! The router treats c0 shapes (TOP rail) as obstacles for c0 routing. Bottom pads are on c0; routing on c0 would hit TOP rails. Bad.

So route bottom nets on c1/c2 (m2/m3): pins on c1 (m2) via c0→c1 at bottom pads. Trunks on c1 (m2), columns on c2 (m3). m2/m3 are below m4/m5 plates? m3 is below m4. The capacitor plates are m4/m5. m3 is below m4 — routing on m3 under the cap is fine (different layer from m4 plate). But m3 wires under the cap cross the cap's m4 plate — different layer, fine, no via. OK. But is m3 used by the capacitor internally? The cap's via stack goes m1→m2→m3→m4→m5 possibly. If the PCell uses m3 for internal routing within the cap cell, my m3 wires might conflict. Unlikely; the PCell uses vias, not m3 routing, within the cell. The m3 might have a via pad. My m3 wires at via locations — the via c2 (m3) pad is at the bottom pad; my c1/c2 routing starts there. Fine.

Hmm, but actually routing on m3 (c2) as "columns" — vertical m3 wires. They pass through cap cells vertically. Within a cap cell, m3 is free (except via pads). OK.

But wait, there's a real concern: the MIM capacitor's top/bottom plates are on m4/m5, but there might be a shield or the capm layer. "noshield" so no shield. The m4 plate under m3 routing — different layer, fine.

I think c1/c2 routing is acceptable. But to be safest regarding the plate layers, maybe route on c0/c1 (m1/m2) and keep TOP on... TOP also needs m1. Conflict. 

Alternative: Route TOP on m2 (c1) and bottom nets on m1 (c0)? TOP rail on m2 at top_pad y, vias m1→m2 at top pads. Bottom nets on m1 at bottom_pad y. m1 bottom routing crosses TOP m2 vias? TOP vias are at top pad locations (m1→m2 via at top pad). Bottom m1 wires at bottom_pad y — different y, but vertical m1 segments might cross TOP via locations. The TOP via is at top_pad (x,y); a bottom m1 vertical wire passing through that (x,y) on m1 would hit the via's m1 pad → short (different net). Risk.

This is getting too deep. Let me just go with: TOP on m1 (c0) rails, bottom nets on m2/m3 (c1/c2) router. Accept the small risk and it's the most standard. The router avoids obstacles. Let me also ensure the router's c1 (m2) trunks don't need to cross TOP m1 rails — they're different layers, fine.

Actually, the cleanest separation: TOP on m1, bottom nets entirely on m2 and above. The router with h=c1 (m2 trunks), v=c2 (m3 columns), pins on c1 (m2). Vias c0→c1 at bottom pads connect m1 pad to m2. All bottom routing on m2/m3. TOP on m1. The only interaction: via c0→c1 at bottom pad (m1 pad + m2 pad). The m1 pad is the bottom pad; TOP rail is at top_pad y (different). No short. 

Let me finalize with this. Also, the router pins on c1: I create c1 rects around bottom pads, plus via c0→c1 at pad center. The via's c1 pad is within my c1 rect → connected. Good.

Let me also reconsider whether `c.via(c0, c1, ...)` for gf180: c0=m1, c1=m2 → via1 stack. But to connect m1 pad to m2, we need via1 (m1→m2). `c.via(c0,c1)` builds the cut stack between m1 and m2 = via1. Good. Size default via1 0.26. Enclosure m1>via1: 0,0.06 (two opposite sides) and m2>via1: 0.01,0.06. The via helper handles pads. The m1 bottom pad must enclose via1 c0 pad. Trust PCell pad is big enough. If not, DRC error. The bottom pad is designed for connection; likely ≥ via pad + enclosure. OK.

16. Let me reconsider the router's handling of the bus as a pin. The bus is a long c1 rect. For net B5 with 32 pads + bus, the router connects all. The bus spans x from -1 to array_right+1 at some y below array. Pins are in the array (y 0..76.8). The router will route from each pin to the bus. With trunks on c1 (horizontal) and columns on c2 (vertical): a pin connects vertically on c2 to the bus's y, then... the bus is on c1, so need via c2→c1 at the bus. Or the pin connects horizontally on c1 to a column, etc. The router figures it out. The bus being a pin means it's part of the net (reused). Good.

But the buses for different nets are stacked vertically (different y), all on c1, spanning full width. They're obstacles for each other. The router routes c1 trunks and c2 columns. To reach bus B5 (at y_b5), a pin goes vertical on c2 to y_b5 then via to c1 bus. The c2 column passes over other c1 buses (different nets) at different y — crossing different layers, fine, no via. At y_b5, via c2→c1 connects to B5 bus. But at (pin_x, y_b5), is there another net's c1 bus? Only B5's bus is at y_b5. Others at different y. So via lands on B5 bus only. Good. But the c2 column at pin_x passes through y range; at other buses' y (B4, etc.) it crosses their c1 bus — different layer (c2 over c1), no via, fine. 

However, the c2 column for B5 at pin_x and the c2 column for B4 at another pin_x — different x, fine. If two pins same x different nets — columns overlap on c2 → short! Pins in the same column (same x) but different nets: their c2 vertical columns would overlap → DRC short on c2. The router should avoid by using different x or routing around. Since pins are at different x (different columns of the array), columns are at different x. But multiple pins in the same array column (same x, different rows, different nets) → same x → c2 columns overlap vertically → short. The router handles obstacles: when routing the second net, the first net's c2 column is an obstacle; it routes around (different x). Should be OK with retries.

I think it'll work. Let me also set the router to be robust. If it fails, I'll need to revisit, but I can't iterate. Let me add some margin and trust.

Actually, let me reconsider the scale of routing: 64 pads, up to 32 for one net, to a bus. The router might struggle but is designed for rows of cells. This is a dense array. Risk of failure. 

Alternative more deterministic bottom routing: Since I control placement, let me interleave such that routing is regular, OR route bottom nets with dedicated vertical m2 buses per column-group.

Hmm, let me think of a fully deterministic bottom routing that avoids the router:

Deterministic scheme: 
- For each bit net, route all its bottom pads to a vertical bit bus on m2 (c1) placed at the right side (x = bus_x + something), one bus per bit stacked... no, vertical buses stacked in x.

Actually, here's a clean deterministic approach:
- Bit buses: vertical m2 (c1) buses at the right of the array, one per bit, spaced in x. 7 buses.
- Each bottom pad connects to its bit's bus via a horizontal m2 (c1) wire at the pad's y, going right to the bus. But pads in the same row have different nets → their horizontal wires at the same y would overlap/conflict if they run on m2 at the same y. Different nets on m2 at same y overlapping = short. So can't run all at pad y.

To avoid, route each bottom pad vertically on m2 to a dedicated horizontal track... this is exactly what the router does. 

OK, I'll use the router. It's the right tool. Let me also prepare a manual fallback in code: wrap router in try/except and if it fails, do a simple per-net routing. But a manual fallback for 64 scattered pads is hard. Let me just trust the router and maybe reduce risk by ordering nets and giving the router the biggest net first. The router retries failed nets first anyway.

Let me also reconsider: maybe don't interleave; cluster by bit to make routing trivial and deterministic. Interleaving is not judged. Clustering:
- Place B5 caps (32) in a 4x8 block, B4 (16) in 2x8, etc. But then bottom pads of a bit are contiguous → connect with a single m2 rail per bit group. Very clean. Top plates still connect via the m1 TOP grid (passes through all). 

But clustering puts all B5 bottom plates together — the bottom plate of B5 caps forms a contiguous region; connecting them with one rail is easy. Let me do clustering for reliability, since interleaving isn't judged. Actually, the task explicitly says interleaving is "good practice, not judged" — so clustering is acceptable for passing. But for a real DAC it's bad matching. Since grading is DRC+LVS+area, clustering passes. However, I'd rather do a mild interleave to be safe for any hidden matching check... but there's no matching check stated. Let me do a balanced approach: interleave moderately but keep routing via router.

Hmm, decision: I'll interleave (round-robin) as the task suggests, and use the router for bottom nets. If I'm worried about router failure, clustering is the safe fallback. Let me go with interleaving + router, but write the router call carefully.

Actually, let me reconsider the router's capacity once more. The router doc: "Per net it tries, in order: bridge pins that abut; one shared column (pins that overlap in x); one trunk per pin row plus a spine column; one trunk." With pins spread over 8 rows and 8 columns, "one trunk per pin row plus a spine column" = up to 8 horizontal trunks (c1) at each pin row + a spine column (c2). This connects all pins. Then connect to the bus. Should be feasible. The bus is an extra pin. OK.

Let me also make the bit buses not span the full width to reduce obstacle issues — span just enough. Actually spanning full width is fine; they're at distinct y below the array.

Let me also reconsider: do I even need the bus? The router returns a shape per net; I can port that shape directly. The shape is the routed wire connecting all pins. I can port `done[net]`. But the shape might be in the middle of the array; porting it is fine (a port can be on any shape). But for a clean pin, porting the bus (at the edge) is nicer. Let me port the bus. But I must ensure the router connected the bus to all pins (it did, bus is a pin). So porting the bus = porting the net. Good. I'll port the bus rects.

Wait, but if I add the bus as a pin and the router "reuses" same-net shapes where contained, the bus remains and wires connect to it. Good.

Let me also double check: `rtr.add(net, *pins)` where pins includes the bus (c1 rect) and pad rects (c1 rects). All on c1 (pin_layer). Good.

Let me write the final script. I'll also add `c.port` for each bit on its bus.

One more: the TOP port and bit ports — port names must match netlist: TOP, B0..B5, VSS. Good.

Let me also handle the `dir` for ports — optional.

Let me also reconsider array placement starting at (0,0) — bbox starts at 0. Fine. Maybe center it; not necessary.

Let me also verify pitch doesn't make caps touch: cap 5x5, pitch 8.6 x 9.6 → space 3.6 x 4.6 ≥ m1 space 0.23 and cap space 0.6. Good. But the capm/dielectric and plates are 5x5; space between adjacent caps' plates = 3.6 (x) ≥ 0.6. Good.

Now, the TOP rail height 0.24 ≥ m1 width 0.23. Good. Rail space to other m1: bottom pads are m1 at different y. The rail at top_pad y; bottom pad at bottom_pad y. Vertical separation = |top_pad.cy - bottom_pad.cy|. If pads are at opposite edges of 5x5 cell, separation ~5 - pad_sizes ≥ ~4 um ≥ m1 space 0.23. Good. But the rail passes through cells; within a cell, rail (m1) at top_pad y and bottom pad (m1) at bottom_pad y — separation ≥ ~4 um. Good. No short.

But wait: the rail is continuous horizontally through the cell at top_pad y. The bottom pad is at bottom_pad y, centered in x perhaps. Separation vertical ≥ 4 um. Fine.

Also the vertical TOP bus (m1) at bus_x spans y from min rail to max rail. It crosses... nothing on m1 in that x region (right of array). Good. It connects row rails. Fine.

Now, the TOP rail overlaps the top pad. The top pad is m1. The rail merges with it. But the top pad also has the capacitor's internal via stack (m1→m4 plate). The rail overlapping the m1 pad is fine (same net TOP). The via stack is at the pad. Good.

Alright, also I should make sure I don't route the TOP rail over a bottom pad of a DIFFERENT row — no, rail is only at row r's y, within row r's x range. Bottom pads of row r are at bottom_pad y (different). Bottom pads of other rows at other y. So no overlap. 

Let me also consider: the rail extends left to min(top_pad.left)-0.2 and right to bus_x+0.3. The leftmost top pad's left — rail starts slightly before it. Fine. It might extend into the previous row's region? No, it's at row r's y only.

OK, I'm fairly confident. Let me also add the `via_top_dir` param — not sure it exists. Let me not use unknown params. `c.via(c0, c1, at=(x,y), net=net)` — dir optional. I'll omit dir.

Let me also reconsider `c.rect(c0, ...)` for rails — net="TOP". Good.

Let me write it cleanly. I'll compute pad positions from the first cap to assert separation, but not hardcode.

Actually, I realize there might be an issue with how `capacitor` names the pads: `cc.top_pad` and `cc.bottom_pad` (docs) but pcells.py uses `k.b` for bottom. Let me check: docs say `cc.top_pad, cc.bottom_pad`; pcells.py example uses `k.top_pad` and `k.b`. Inconsistent in docs. Let me use both safely: try `k.bottom_pad` else `k.b`. I'll write a helper. Actually, to be safe, let me use `k.top_pad` and get bottom via `getattr(k, 'bottom_pad', k.b)`. Hmm. The pcells.py (which runs on gf180) uses `k.b`. Let me use `k.b` for bottom and `k.top_pad` for top. But docs say bottom_pad. Let me support both:

```
def bottom_pad(k):
    return getattr(k, "bottom_pad", None) or getattr(k, "b")
```

But `k.b` might be a shape; `getattr(k,"bottom_pad",None) or k.b` — if bottom_pad exists use it. Fine.

Similarly top: `k.top_pad`.

Let me write the script now.

Also, I want to double-check the `Router` import: `from icdsl.canvas import *` includes Router. Yes.

Let me also make the script not fail if router has issues — but I'll trust it.

Let me also reconsider: should I use `from_spice`? The task says netlist is available. But manual is fine and gives control. The grading checks LVS against netlist. Manual with 64 caps is straightforward. I'll go manual.

Actually, wait — let me reconsider using `from_spice` style="rows" which would auto-place 64 caps and route. But it clusters in netlist order and brings plates down below. It might not meet area or might route poorly. Manual is more predictable. Going manual.

Let me also reconsider area more carefully with my numbers:
- Array: x 0..68.8 (8 cols * 8.6), y 0..76.8 (8 rows * 9.6).
- TOP bus at x=70.0, port extends to 72.6. So x max ~72.6.
- Bit buses below: y from -2.6 down, 7 buses * 2.2 = 15.4, so y min ~ -18.0. Bus height 1.6, last bus at by = -2.6 + 6*2.2 = 10.6? Wait let me recompute: by starts -2.6, after 7 buses (increment 2.2 each), last bus y0 = -2.6 + 6*2.2 = 10.6, y1 = 12.2. That's ABOVE the array (array starts at y=0)! That overlaps the array. Mistake.

Let me fix: buses should go below the array (negative y). by starts at -2.6 and decreases. Let me do:
```
by = -2.6
for net in ...:
    c.rect(c2, x0=-1, x1=array_right+1, y0=by-1.6, y1=by, net=net)  # bus below
    bus_y[net] = by - 0.8
    by -= 2.2
```
7 buses: by goes -2.6, -4.8, -7.0, -9.2, -11.4, -13.6, -15.8. Bus rectangles from by-1.6 to by. Last bus y0 = -15.8-1.6 = -17.4. So y min ~ -17.4. 
- y max = 76.8 (array top). 
- Total height = 76.8 - (-17.4) = 94.2. Width = 72.6 - 0 = 72.6 (x min 0, but buses start at x=-1 → x min -1). Width = 72.6 - (-1) = 73.6. Area = 73.6 * 94.2 = 6933 um2. Budget 10578. ✓. Reference 5289. We're 1.31x reference area, within 2x budget. 

But height 94.2 vs reference 71.86 — taller but narrower. Area within budget. Good. Could reduce by using fewer rows of buses or tighter pitch, but fine.

Actually, I can place buses to the right instead of below to make it squarer, but area is fine. Let me keep below.

Hmm, but the router routing from pads (in array, y 0..76.8) down to buses (y -17.4..-2.6) — long vertical routes on c2 (columns) crossing the array vertically. c2 columns at pin x going down to bus y. They pass through the array vertically at that x, crossing other pads/router shapes. The router handles obstacles. Long but OK. Alternatively place buses on the right (x) to shorten. But area fine either way. Let me place buses below; router will route vertical columns down. The columns pass through the array — at a given x (pin's x), going down through rows below that pin. It might cross bottom pads of other nets in the same column below. Router avoids (obstacles) by jogging. Should be OK with retries.

Actually, to reduce routing complexity, let me place the bit buses on the RIGHT side (vertical buses) — no. Let me keep below; trust router.

Wait, actually, a cleaner deterministic routing that avoids the router entirely for bottom nets:

Since I interleave, each row has a mix. But what if I route bottom nets on m2 with horizontal segments per pad to a vertical bus, using the router only minimally... no.

Let me just go with router. Final script:

Let me also make sure to set `TOP = c` at the end and the top cell name is "cdac6". The `Cell("cdac6")` sets name. TOP variable = c. The build uses TOP variable or last cell. Good.

Let me write it.

Actually, let me reconsider the via for bottom pads: `c.via(c0, c1, at=(p.cx, p.cy), net=net)`. But the bottom pad `p` is on c0 (m1). The via c0→c1 needs the c0 pad (on m1) to be the bottom pad or overlap it. The via creates its own c0 pad (via1 pad on m1? No—via1 is m1→m2, the lower pad is on m1). The via's lower pad (m1) must overlap/enclose or be enclosed by the bottom pad (m1) for connection. If via is at pad center and via pad ≤ pad size, the via pad is within the bottom pad → they merge (same net) → connected. But actually for connection, the via lower pad (m1) and bottom pad (m1) just need to touch/overlap (same layer, same net → merge). If via pad is smaller and centered, it's inside the bottom pad → merged. Good. Then via upper pad (m2) connects to my c1 pin rect (which contains the via center) → merged. Good.

But DRC: m1>via1 enclosure 0,0.06 — the bottom pad (m1) must enclose the via1 lower pad by 0.06 on two opposite sides (or 0 on others). If via pad is within bottom pad with margin ≥0.06, OK. The bottom pad size — PCell designed it; likely ≥ via pad + 0.12. Trust. If bottom pad is exactly via size, enclosure fails. Risk. But PCell pads are meant for vias. OK.

Alternatively, skip the explicit via and just make my c1 pin rect overlap the bottom pad? They're different layers (c0 vs c1) — overlap without via = no electrical connection (and DRC might flag overlap of different layers? No, different layers can overlap; need via to connect). So I need the via. Keep it.

Let me also make the c1 pin rect large enough to contain the via's c1 pad and connect to routing. via1 upper pad (m2) size 0.26. My pin rect is pad expanded by 0.3 → contains it. Good.

Now, the router's pin_layer=c1, pins are my c1 rects. The via's c1 pad is inside the pin rect (same net) → the pin rect and via pad merge. The router sees the pin rect. Good.

Let me finalize. I'll also add a check/assert for pad separation to catch assumptions:

```
t0 = caps[0]
assert abs(t0.top_pad.cy - t0.bottom_pad.cy) > 1.0, "pad y too close"
```
But I don't know bottom pad attr name. Let me use helper. Actually, let me not assert to avoid failing on attr name; just proceed. The rail at top_pad y; if bottom pad shares y, we'd get a short DRC and I'd see it. But I can't iterate. Risk accepted; pads for different plates are almost certainly separated.

Hmm, let me reduce risk: make the TOP rail NOT a full-width continuous rail but connect top pads with short segments that stay within each cell's top region, then a vertical bus. Actually a full rail is fine if pads separated. Let me keep rail but make it only span the pads plus small margin, and ensure it's at top_pad y. If bottom pad is at same y, short — but unlikely.

Wait, actually there's a more likely issue: top_pad and bottom_pad might be at the SAME (x,y) center but the PCell puts them on m1 at different locations... no. Or top_pad at center-top and bottom_pad at center-bottom. Separated in y. Good. I'll proceed.

Let me also reconsider: maybe top_pad and bottom_pad are both at the cell center but one is on m1 and connects up, the other... no, both on m1 per docs. They must be spatially separated. Fine.

Let me write the final script.

Let me reconsider the router parameters once more. `Router(c, v=c1, h=c2, pin_layer=c1)`? I decided bottom routing on c1 (m2 trunks) and c2 (m3 columns), pins on c1. Wait, I said h=c1 (m2 horizontal trunks), v=c2 (m3 vertical columns), pin_layer=c1 (m2). But then vias c0→c1 at pads connect m1 pad to m2 pin. Routing on m2 (c1) and m3 (c2). m3 is below m4 plate — OK. But do I even need m3 columns? The router uses c2 for vertical columns. m3 wires under the array — fine. Alternatively use v=c1,h=c0? No, c0 has TOP rail. So v=c2 (m3), h=c1 (m2). OK.

Hold on, is m3 used by the capacitor internally? The cap_mim_2f0_m4m5 uses m4 and m5 plates. The via stack from m1 pad to m4 plate goes m1→m2(contact? no). Wait: m1 pad → via1 → m2 → via2 → m3 → via3 → m4 (plate). So the PCell uses m2, m3, m4 within the cap cell for the via stack pads! Specifically, there are via pads on m2, m3 at the pad location. So m2 and m3 have small pads at each cap's pad locations (the via stack intermediate pads). My routing on m2/m3 must avoid these intermediate via pads of OTHER nets? They're all within the cap cell at the pad locations. My c1 (m2) pin rect is at the bottom pad, expanded — it contains the via stack's m2 pad at the bottom pad (same net, fine). But the via stack also has m2/m3 pads at the TOP pad location (for the top plate connection) — those are TOP net, on m2/m3, at top_pad location. My m2 routing (trunks) might pass through top_pad locations and hit TOP's m2 via pad → short (different net)! 

Hmm. The TOP rail is on m1 (c0), not m2. The top plate's via stack: top_pad (m1) → via1 → m2 pad → via2 → m3 pad → via3 → m4 plate. So there IS an m2 pad at the top_pad location (TOP net). My m2 trunks passing through top_pad locations would hit it → short. 

To avoid, route bottom nets NOT through top_pad locations. The top_pad locations are at top_pad y in each cell. My m2 trunks are horizontal at various y. If a trunk is at top_pad y of some row, it crosses all cells in that row at top_pad y → hits TOP's m2 pads → short. 

This is a real problem. The TOP rail is on m1, but the top plate via stack puts TOP net on m2/m3 at top_pad locations. So m2/m3 have TOP-net features at top_pad positions throughout the array.

Options:
(a) Route TOP on m1 only and DON'T let the cap's via stack put TOP on m2/m3 — but the cap PCell does that internally; I can't control. The m2/m3 pads at top_pad are part of the cap (TOP net). They're small (via pads). My m2 routing must avoid them.
(b) Route bottom nets on m1 (c0) and m2 but keep m2 wires away from top_pad y lines. 

This is getting complicated. The fundamental issue: both plates' via stacks occupy m1/m2/m3/m4 at pad locations within each cell. Routing through cells risks hitting via pads of the other net.

Solution: Route in the channels BETWEEN cells, not through cells. But pads are inside cells; to get from pad to channel, need a short wire within the cell from pad to cell edge — that short wire might cross the other plate's via pad if at same location. If top_pad and bottom_pad are at different locations (e.g., top-left and bottom-right), a wire from bottom pad to cell edge might cross top pad's via stack. 

This is genuinely tricky without knowing pad layout. 

Let me reconsider: maybe the capacitor PCell places top_pad and bottom_pad at the SAME location but they're on different layers? No, docs say both are pads (probably both on c0/m1). If they were on different layers they wouldn't both be "pads" on c0.

Wait, re-read docs: "capacitor ... cc.top_pad, cc.bottom_pad". And pcells.py: `c.port("CT", on=k.top_pad); c.port("CB", on=k.b)`. It doesn't say what layer. They could be on different layers! E.g., top_pad on m5 (top plate directly) and bottom_pad on m1? Unlikely. More likely both on c0 (m1) for uniform connection. 

Given the via-stack complexity, the SAFEST approach: route each net entirely within the "pad layer" and use the router which treats everything as obstacles. But the router only routes on 2 layers. If I route bottom nets on c0 (m1), the TOP rail (m1) and TOP's via-stack m2/m3 pads — m2/m3 are not c0, so not obstacles for c0 routing, but TOP rail (c0) IS an obstacle. Bottom pads on c0; routing on c0 between them must avoid TOP rail (c0) at top_pad y lines. The TOP rail runs horizontally at top_pad y across each row — it's a horizontal c0 barrier across the array at each row's top_pad y. Bottom pads are at bottom_pad y. To route a bottom pad (at bottom_pad y) to a destination, a c0 wire might cross the TOP rail (c0) at top_pad y → short (same layer, different net). 

So c0 routing is blocked by TOP rails. 

The cleanest solution: route TOP and bottom nets on DIFFERENT layers and keep them separated:
- TOP: route on m1 (c0) — rails at top_pad y. (TOP net also has via-stack pads on m2/m3/m4 at top_pad locations, but those are small and at top_pad y; if I don't route on m2/m3 there, fine.)
- Bottom nets: route on m2 (c1) and m3 (c2), but AVOID top_pad locations (where TOP's m2/m3 via pads are). 

The bottom pads are at bottom_pad y. The TOP via-stack m2/m3 pads are at top_pad y. Different y. So if I route bottom nets on m2/m3 at bottom_pad y and connect vertically, I might cross top_pad y lines. A vertical m3 wire at bottom pad x going from bottom_pad y down to a bus — it crosses top_pad y of rows below? top_pad y of a row below is different from bottom_pad y. The vertical wire at x=bottom_pad.x passes through all y; at y = top_pad of some row, if that row's top pad has the same x (same column), the vertical wire hits TOP's m2/m3 via pad at (x, top_pad_y) → short. 

So vertical wires in the same column as a top pad cross TOP's via pads. Ugh.

The via pads are small (0.26 um). A vertical wire passing through (x_top, y_top) exactly hits it only if aligned. The router would route around small obstacles. The router treats the cap's m2/m3 via pads (TOP net) as obstacles on c1/c2 and routes around them. Since they're small (0.26), the router can jog around. The router is designed to avoid obstacles. So it should handle it! The router avoids all existing shapes on c1/c2 (including the cap's internal via pads on m2/m3) as obstacles. Good. So using the router on c1/c2, it will avoid TOP's via pads and bottom pads of other nets. 

So the router approach is actually robust: it treats everything on c1/c2 as obstacles and routes around. The only issue is whether it can find a path with dense obstacles. With 64 caps each having via-stack pads on m2/m3 at two locations, plus bottom pads — that's a lot of small obstacles. The router might struggle but it's the best shot.

Given the complexity, maybe clustering by bit and routing bottom nets with short local connections is more reliable. But the router should handle it.

Let me reconsider: maybe route bottom nets on m1 (c0) but place the TOP rail on a different layer. Route TOP on m2 (c1)? Then TOP rail on m2 at top_pad y, with vias m1→m2 at top pads. But TOP's own via stack already puts TOP on m2/m3 at top_pad. Adding an m2 rail at top_pad y connecting top pads — overlaps TOP's m2 via pads (same net, fine). Then bottom nets on m1 (c0) at bottom_pad y. m1 bottom routing crosses TOP's m2 rail? Different layer (m1 vs m2), fine. But m1 bottom wires might cross TOP's m1 top pads? TOP's top pads are on m1 at top_pad y. Bottom m1 wires at bottom_pad y — different y. Vertical m1 segments might cross top_pad locations → hit TOP's m1 top pad (same net TOP, but bottom wire is different net → short!). A bottom net's m1 vertical wire passing through a top pad's (x,y) → short with TOP. 

Same problem mirrored.

OK the core issue: top pads and bottom pads are interspersed in the array; routing any net through the array risks crossing the other net's pads. The router (maze-like, obstacle-avoiding) is the right tool. Let me use it and trust it. It routes on 2 layers with via between, avoiding all obstacles. With 2 layers and small obstacles, it should route 64 connections. The router retries failed nets. Let me go.

To maximize router success, route bottom nets on c1 (m2) and c2 (m3) — but these have TOP's via-stack pads as obstacles. Alternatively route on c0 (m1) and c1 (m2): c0 has TOP rail (obstacle), c1 has TOP's via1 pads. Either way obstacles. The router avoids them. Fine.

Let me choose c0/c1 (m1/m2) for bottom routing: pins on c0? But bottom pads are on c0; pin_layer=c0. Router columns on c1 (m2), trunks on c0 (m1). But c0 has TOP rail obstacle. Bottom pads on c0. Router routes trunks on c0 (avoiding TOP rail) and columns on c1. Vias c0↔c1. This keeps routing on m1/m2 (below m3/m4 plates) — safest regarding plate layers. TOP rail on m1 is an obstacle but router avoids. Bottom pads on m1. 

But TOP rail runs horizontally at top_pad y across each row — a full c0 barrier. Bottom pads at bottom_pad y. To get from a bottom pad to anywhere on c0, you're below the TOP rail of your row. You can go up on c1 (column) over the TOP rail (different layer) then across. The router does columns on c1. So: bottom pad (c0) → via up to c1 → column on c1 over the TOP rail → trunk on c1 → via down to c0 → destination. Works. The router handles it.

But c1 (m2) has TOP's via1 pads at top_pad locations (small obstacles) and the cap's via stack m2 pads. Router avoids. OK.

I'll go with Router(v=c1