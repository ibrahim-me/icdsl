The script did not build:
centreline bbox: x [-35.1667,32.8333] y [-30,43]
ERROR TypeError: Cell.path() got an unexpected keyword argument 'first'
  sub.py, line 72: c.path(top, [p0, p1], width=W, net="L", first="ext", last="ext")
  hint: the call is Cell.path(self, layer, pts, width, net=None, ends='flush')
        Any-angle path of the given width (um) -> polygon. ends: flush | ext (half a width) | round. When every segment is Manhattan or 45 degrees the outline is built exactly: all its edges are again Manhattan or 45 degrees with on-grid vertices (diagonal legs come out up to 1.5 grids wider than `width`, never narrower). Other angles: the hull is snapped to the grid.