The script did not build:
ERROR empty rectangle on m2: x 1.335 .. 1.335, y 0.25 .. 1.75
  hint: the upper edge is not above the lower edge in x: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 118: sram6t(top, cc*PX, r*PY, "BL%d"%cc, "BLB%d"%cc, wl, "VDD", "VSS")
  sub.py, line 92: c.rect(c1, x0=pR.gates[0].right, x1=pR.gates[0].right, y0=gy-MW/2, y1=gy2+MW/2, net="Q")