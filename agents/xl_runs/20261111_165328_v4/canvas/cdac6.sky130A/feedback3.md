The script did not build:
ERROR empty rectangle on m2: x 0.0 .. -0.07, y 1.9 .. 3.1
  hint: the upper edge is not above the lower edge in x: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 96: c.rect(m2, x0=0.0, x1=pad.cx, y0=pad.cy - 0.6, y1=pad.cy + 0.6, net=net)