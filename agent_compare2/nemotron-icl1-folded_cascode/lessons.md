## Coach notes for analog assembly (from reviewing earlier attempts - follow them)
1. `pair A B axis=<x> ...` places BOTH objects (B = mirror image of A). Leave A unplaced and let pair
   choose the spacing; its keys are only axis=, above=/below=/at_y=, gap=, vgap= (no align=). If A is
   already placed, `pair A B axis=<x>` only mirrors it into B. Use the SAME axis expression for every
   pair (e.g. axis=MT.cx) and centre the unpaired objects on it (`place MT at=(0,0)` first, pairs
   above/below it).
2. `route A B symmetric axis=...` needs pins that are mirror images: draw the two halves with `pair`
   (not with a common_centroid / interdigitated pattern, whose pins are not mirrored).
3. Guard rings: place everything first, then `guardring G around=[...] kind=ptap|ntap net=...`. Objects
   placed relative to the enclosed ones (above=/below=/right_of=/left_of=) are pushed away
   automatically to make room; objects placed with at=(x,y) are not - place them relative to others.
4. A pattern object (interdigitate / common_centroid) holds ALL fingers of its devices; place the
   pattern object (its name=), not the devices. Every letter is one finger: ABBA for 2+2 fingers,
   ABBBBA for 2+4 (1:2), ABCD/DCBA for four 2-finger devices on a 2-D common centroid.
5. Taps: nmos need a ptap and every pmos n-well island needs an ntap; `tap T kind=ntap net=VPWR
   cols=N` placed right above/below the pmos rows (gap=min) keeps it in the same well.
6. Area budgets: put rows directly on top of each other with gap=min, a tap row sharing the width of
   the rows it serves, the tail beside the input pair instead of in its own row, no dummies
   (dummies=0) when the matching rule does not need them.
7. Keep the given `port` and device lines unchanged; names of new objects must not clash with nets
   or devices.
8. Latch-up: every nmos diffusion must be within 15 um of a p-tap and every pmos diffusion within 15 um
   of an n-tap - also at the LARGEST sweep widths. Tall stacks of pairs need a tap row (or ring) in the
   middle, not only at the ends; the compiler reports the device and its distance.
9. `route A B symmetric` only works when the pins of A and B are mirror images (devices placed with
   `pair`); for internal nets of mirrored halves let the router route them normally.
