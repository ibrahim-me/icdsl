## Coach notes (from reviewing 65 earlier attempts on this benchmark - follow them)
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
8. Use only verbs and keys from the reference. Not allowed: `side=` on stdcell ports, `between=` on
   arrays, `x=`/`y=`/`pos=` on rect. Keep the `param` and `device` lines unchanged, every name unique
   and defined before use.
9. Read the CONNECTIVITY section of the feedback first: SHORT = two labelled nets touch at the named
   shapes; OPEN = one net is in several pieces (join them); a DEVICE with no matching transistor means
   its gate has no contact on it or its source/drain columns carry the wrong nets.
