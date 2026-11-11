The script did not build:
ERROR empty rectangle on m2: x 0.0 .. 1600.0, y 1380.0 .. 25.6
  hint: the upper edge is not above the lower edge in y: x0 < x1 and y0 < y1 (or left < right, bottom < top) are needed; swap them or check the shapes they come from
  sub.py, line 131: TOP.rect(c1, x0=inst.pin("VDD").x0, y0=inst.pin("VDD").y0,

Note: this task comes with a netlist, and the script does not use it. `TOP = from_spice("netlist.spice")` builds the complete layout from the netlist (CANVAS.md, sections 0 and 8). Draw devices and wires yourself only for what that level cannot express.