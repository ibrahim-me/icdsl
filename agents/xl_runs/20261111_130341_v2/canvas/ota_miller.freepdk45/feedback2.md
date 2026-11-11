The script did not build:
ERROR empty rectangle on m1: x 8.515 .. 14.775, y 7.57 .. 3.975
  hint: the upper edge is not above the lower edge in y: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 108: out_bar = strap(c, c0, "OUT", M6.sd[0].left, M7.sd[0].right, M6.sd[0].bottom, M7.sd[0].top)
  sub.py, line 34: return cell.rect(layer, x0=x0, x1=x1, y0=y0, y1=y1, net=net)