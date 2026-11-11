## Coach notes (from reviewing ~130 earlier attempts on this benchmark - follow them)
1. `cb`, the bottom of the gate contacts, may use ONLY n-row items:
   `cb = max(nd.top + 0.19, <n-row contact li>.top + 0.25, ...)`. Never put the p row (`pd`, p-side
   contact li) into that max(): it pushes every gate contact up into the n-tap row (errors licon.14,
   var.*, licon.7, poly.2 and an LVS short of the inputs to VPWR).
2. Each gate contact sits ON its own gate: `gcX = contact licon cx=gX.cx bottom=cb` (shift by at most
   0.1), `enclose gcX poly by=minx`, `enclose gcX li net=<input>`. The poly pads are 0.33 wide, so
   neighbouring gates need a centre-to-centre pitch of at least 0.54 um. Place each gate from the
   previous one: `g2 = cross [nd, pd] poly w=L left=(g1.right + max(0.28, 0.54 - L))` (0.28 = room for
   a contact column; use max(0.21, 0.54 - L) for a series node without contact).
3. One `enclose [gc1, gc2, ...] npc` around all gate contacts.
4. Diffusion width = sum of the gaps + 2*0.265 end contacts + gates; derive it from L and the gaps so
   it follows the sweep. Choose `width` (columns of 0.46) so it fits at L=0.25 as well.
5. A net that runs from a drain to a gate inside the cell (buf, and2, or2, xor2, mux2i: n1, n2...)
   must be connected: give the drain li strips AND the gate contact li the same `net=n1` and write
   `route n1 layers=m1,m2`. Without it LVS fails (open net).
6. When the n-side and p-side drains of an output do not line up, label every drain strip `net=Y`,
   write `route Y layers=m1,m2` and `port Y out` (no on= : the pin goes on the routed met1).
   When they do line up, a vertical `strap li from=<n drain li> to=<p drain li>` is simplest.
7. Supply columns: every source column on VGND/VPWR needs its contact array and a
   `strap li from=<li> to=vgnd_li` (or `vpwr_li`).
8. Use only verbs and keys from the reference. Not allowed: `side=` on stdcell ports, `x=`/`y=`/`pos=`
   on rect. A contact column between two gates: `array licon in=nd between=[g1, g2]`. Keep the `param` and `device` lines unchanged, every name unique
   and defined before use.
9. Read the CONNECTIVITY section of the feedback first: SHORT = two labelled nets touch at the named
   shapes; OPEN = one net is in several pieces (join them); a DEVICE with no matching transistor means
   its gate has no contact on it or its source/drain columns carry the wrong nets.
10. ONE poly gate per gate net column, crossing BOTH rows (`cross [nd, pd]`), with ONE gate contact.
   The n row and the p row therefore have the SAME gate order - choose an order that works for both
   rows (break a row into separate diffusion islands where neighbours cannot share a node: an island
   break needs a 0.80 gap between the two gates). Never draw a second set of gates on top of the first.
11. A vertical li strap that joins the n and p drains (the output) right next to a gate passes only
   0.045 um from that gate's contact li (li.3 needs 0.17). Shift the gate contacts AWAY from the strap
   by 0.13 (`cx=(g.cx - 0.13)` if the strap is on the right) - shift all gate contacts together so the
   pads keep their 0.21 spacing - or join the output with `route` instead of the strap.
12. Two drain strips that are not exactly above each other cannot be joined by `strap`; a strap with
   cy= runs horizontally along a row and shorts every column it crosses. Use `route <net>` instead.
13. Two-stage cells (buf, and2, or2, xor2, mux2i): the internal net (n1, n2) drives the gate right next
   to the output column. Put that gate's contact on the side AWAY from the output strap, and put the
   output pin (mcon + met1) on the output strap at the height of a diffusion row (e.g. `cy=pd.cy`),
   never at the gate-contact height - otherwise the output met1 blocks the internal net's route and
   the output li touches the gate-contact li (SHORT X/n1).
14. When the feedback says "the side labelled n3 should be n5", the gates are fine - change the
   `net=` label of that contact column (and its strap/route) as stated.
