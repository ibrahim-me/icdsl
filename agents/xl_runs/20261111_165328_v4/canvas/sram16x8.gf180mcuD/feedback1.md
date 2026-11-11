The script did not build:
ERROR AttributeError: 'Tech' object has no attribute 'via_size'
  sub.py, line 156: ports, cw, ch = sram6t(TOP, ccol * pitch_x, r * pitch_y,
  sub.py, line 16: via = tech.via_size(c0, c1)
  hint: a Tech has values alias, c0, c1, c2, c3, c4, cuts, d, devices, grid, label_layer, metal1, name, pin_layer, roles, root, stack; methods area, conductor, cut_between, cut_stack, deck, describe, device, enc, layer, layers, lname, metal, nm, official_layers, rule, snap, space, width