- A gate column is shared by the n row and the p row, so the gate order must be the SAME in both rows. You drew two sets of four gates (gp1..gp4 and gn1..gn4) on top of each other - every gate is shorted to every other. Draw only FOUR gates.
- Use the gate order A2, B2, B1, A1:
    p row: n1 | A2 | Y | B2 | (n2, series node: no contact) | B1 | VPWR | A1 | n1
    n row: VGND | A2 | n3 | B2 | Y | B1 | n3 | A1 | VGND
- Gaps: max(0.28, 0.54 - L) where a contact column sits between two gates, max(0.21, 0.54 - L) at the series node.
- Join n1 (both p-row ends), n3 (two n columns) and Y (n column + p column) with `route n1/n3/Y layers=m1,m2`, `port Y out`. One mcon + met1 pad per gate contact for the inputs.
