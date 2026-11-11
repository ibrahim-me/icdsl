- A0's and A1's gate contacts are only 0.06 apart (li, mcon and met1 all collide: SHORT A0/A1). Gate pitch must be >= 0.54 so each pad keeps 0.21 from the next; do not shift two neighbouring contacts toward each other.
- Several supply columns are shorted to internal nets (VGND/n5, VPWR/n1): only a column that IS on a supply gets a strap to vgnd_li / vpwr_li.
- A plan that works - five gate columns left to right: S, S, A0, A1, n1:
    p row (one diffusion): n1 | S | VPWR | S | (n2 = series) | A0 | Y | A1 | (n4 = series) | n1 | VPWR
    n row island 1: n3 | S | VGND | S | n1
    n row island 2: n5 | A0 | Y | A1 | n3
    n row island 3: VGND | n1 | n5
  (n1 = output of the S inverter; it drives the last gate.) The n-row breaks need 0.80 gaps between the 2nd/3rd and 4th/5th gates.
- Join n1, n3, n5 and Y with `route <net> layers=m1,m2`, `port Y out`.
