The script did not build:
ERROR empty rectangle on m5: x 47.6 .. 39.6, y 67.4 .. 73.4
  hint: the upper edge is not above the lower edge in x: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 54: c.rect(top, x0=ox, x1=ox + dx, y0=oy - w / 2, y1=oy + w / 2, net="L") if dx or dy else None