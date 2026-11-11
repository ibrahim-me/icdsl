The script did not build:
ERROR empty rectangle on m3: x 24.2 .. 24.48, y 115.06 .. 112.72
  hint: the upper edge is not above the lower edge in y: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 102: c.rect(c2, x0=trunk_x - M3W / 2, y0=y0 - ENC + M4W / 2, x1=trunk_x + M3W / 2, y1=pin_cy, net=net)