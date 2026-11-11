The script did not build:
ERROR from_spice: subcircuit ota_miller has more than one n width ([2.0, 4.0])
  hint: a stick cell has one width per strip and one gate length: draw this cell with mos() or split it into subcircuits
  sub.py, line 12: TOP = from_spice("netlist.spice")  # stick cells + rows + router; ports for INP INN OUT IB VDD VSS