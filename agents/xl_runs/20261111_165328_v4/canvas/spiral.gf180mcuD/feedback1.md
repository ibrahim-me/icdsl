The script did not build:
ERROR empty rectangle on m4: x -0.14 .. -31.5, y -2.51 .. 2.51
  hint: the upper edge is not above the lower edge in x: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 37: up = c.rect(bot, x0=v.lower.left, x1=ux, y0=v.lower.bottom - W / 2,