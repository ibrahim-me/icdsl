The script did not build:
ERROR TypeError: guard_ring() got an unexpected keyword argument 'x0'
  sub.py, line 74: gr = c.guard_ring("ntap", x0=x0g, y0=y0g, x1=x1g, y1=y1g, net="VSS")
  hint: the call is guard_ring(self, kind, around, space=None, width=None, net=None, well=True)
        Closed tap ring around a box / shape / list of shapes. kind 'ptap' | 'ntap'. space = distance from the contents to the ring's inner edge (um), width = ring width. A ring whose recipe has a well (n-tap ring; p-tap ring on a PDK with a drawn p-well) fills its interior with that well; well=False leaves the well to you (needed when the contents sit in the other well). Returns a Group with .inner / .ou