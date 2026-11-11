The script did not build:
ERROR TypeError: 'Rect' object is not iterable
  sub.py, line 93: pts = [p for r, which in lst for p in (r.a if which == "a" else r.b)]