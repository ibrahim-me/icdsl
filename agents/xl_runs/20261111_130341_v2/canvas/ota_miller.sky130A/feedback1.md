The script did not build:
ERROR from_spice: subcircuit ota_miller has an element this helper does not place: XRZ (sky130_fd_pr__res_generic_po)
  hint: from_spice handles MOS-only leaf cells and tops made of instances; draw the other parts with the canvas (resistor(), capacitor(), mos(), wires) and place them yourself
  sub.py, line 49: TOP = from_spice(netlist, top="ota_miller")