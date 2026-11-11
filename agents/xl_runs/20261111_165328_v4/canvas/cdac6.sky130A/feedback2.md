The script did not build:
ERROR via: m4 and m4 are the same layer
  hint: on sky130A the conductors are li < m1 < m2 < m3 < m4 < m5 (tech.c0 is the first); a contact to a device is via('poly' | diffusion layer, tech.c0)
  sub.py, line 59: c.via(m4, cap.top_pad.layer, at=cap.top_pad.cx, net="TOP",