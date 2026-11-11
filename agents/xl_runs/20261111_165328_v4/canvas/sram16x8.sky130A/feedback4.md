The script did not build:
ERROR AttributeError: 'Cell' object has no attribute 'pin'
  sub.py, line 33: sram6t = make_sram6t()
  sub.py, line 30: c.port(net, on=sc.pin(net), dir="inout")
  hint: a Cell has values bbox, bottom, boundary, devices, foreign, h, labels, left, name, port_dir, port_order, ports, refs, registry, right, shapes, spice_text, src, stick, tech, top, w; methods all_cells, box, capacitor, count, device, flat, guard_ring, has_netlist, label, mos, netlist, nmbbox, path, place, polygon, port, rect, resistor, set_boundary, subckt, tap, via, via_size, wire