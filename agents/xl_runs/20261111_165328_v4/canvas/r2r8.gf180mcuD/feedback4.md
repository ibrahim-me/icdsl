The script did not build:
ERROR empty rectangle on m1: x 3.515 .. 6.485, y 0.905 .. 0.095
  hint: the upper edge is not above the lower edge in y: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 116: join(plist, net)
  sub.py, line 72: c.rect(c0, x0=min(a.left, b.left) - 0.2, x1=max(a.right, b.right) + 0.2,