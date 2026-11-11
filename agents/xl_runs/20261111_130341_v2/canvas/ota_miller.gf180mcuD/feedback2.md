The script did not build:
ERROR AttributeError: 'Mos' object has no attribute 'pin'
  sub.py, line 72: r.add("VSS", P(m8, "sd[0]"), grn.straps[0])
  sub.py, line 70: return inst.pin(name)
  hint: a Mos has values bbox, bottom, center, cx, cy, diff, gates, gx, h, implant, kind, left, nets_g, nets_sd, pitch, right, sd, sx, top, w, well, x0, x1, y0, y1; methods g, nmbox, s