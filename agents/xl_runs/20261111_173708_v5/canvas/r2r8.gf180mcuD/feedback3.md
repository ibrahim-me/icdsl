The script did not build:
ERROR TypeError: guard_ring() got an unexpected keyword argument 'x0'
  sub.py, line 75: gr = c.guard_ring("ptap", x0=min(xs0)-1.0, y0=min(ys0)-1.0,
  hint: the call is guard_ring(self, kind, around, space=None, width=None, net=None, well=True)
        Closed tap ring around a box / shape / list of shapes. kind 'ptap' | 'ntap'. space = distance from the contents to the ring's inner edge (um), width = ring width. A ring whose recipe has a well (n-tap ring; p-tap ring on a PDK with a drawn p-well) fills its interior with that well; well=False leaves the well to you (needed when the contents sit in the other well). Returns a Group with .inner / .ou