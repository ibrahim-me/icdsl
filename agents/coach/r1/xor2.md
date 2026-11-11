- All your gates are shorted together (gate A+B+n1): gate contacts of different inputs touch (aa / pbb overlap). One gate contact per gate column, ON its gate, pads 0.21 apart (pitch >= 0.54).
- A plan that works - five gate columns left to right: A, B, A, B, n1:
    n row (one diffusion): VGND | A | n1 | B | VGND | A | (n4 = series, no contact) | B | X | n1 | VGND
    p row island 1:        VPWR | A | n2 | B | VPWR | A | (n3 = series, no contact) | B | n1
    p row island 2 (under the n1 gate only): X | n1 | n2
  Between the 4th gate (B) and the 5th (n1) the p row has a diffusion break (n1 contact, 0.27 spacing, X contact), so that gap is 0.80; the n row uses it for its X contact column.
- Label every contact column with its net; join n1 (n column + p column + the n1 gate contact), n2 (two p columns) and X (n column + p column) with `route <net> layers=m1,m2`, `port X out`.
