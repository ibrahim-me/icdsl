The script did not build:
ERROR port 'WL': on= must be a shape on a conductor layer
  hint: e.g. p = c.rect('m1', ...); c.port('A', on=p)
  sub.py, line 119: cell = sram6t(c)
  sub.py, line 103: c.port("WL", on=poly(xg1, yn, poly_w, cell_h - 2 * mw, "WL") if False else None)