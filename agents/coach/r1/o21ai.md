- Each input needs ONE poly gate crossing BOTH rows (`cross [nd, pd]`) with ONE gate contact. You drew separate n and p gates in different orders, so A1's and A2's gate contacts sit on top of each other (SHORT A1/A2) and the routes cannot reach them.
- Use the gate order A2, A1, B1 for both rows:
    n row (one diffusion, width WN):  n2 | A2 | VGND | A1 | n2 | B1 | Y
    p row, island 1 (width WP):  Y | A2 | (n1 = series node, no contact) | A1 | VPWR
    p row, island 2 (width WP2, under B1 only):  VPWR | B1 | Y
  The two p islands need 0.27 diff spacing, so the gap between gate A1 and gate B1 is 0.80 (contact + spacing + contact); in the n row that wide gap just holds the n2 contact column.
- Gaps elsewhere: max(0.28, 0.54 - L) with a contact column, max(0.21, 0.54 - L) at the series node n1.
- Join n2 (two n columns) and Y (n column + two p columns) with `route n2 layers=m1,m2` and `route Y layers=m1,m2` + `port Y out`. Inputs: one mcon + met1 pad on each gate contact.
