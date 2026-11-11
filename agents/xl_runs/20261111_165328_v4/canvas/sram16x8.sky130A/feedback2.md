The script did not build:
ERROR stick sram6t_stick: both strips need the same odd number of entries (net gate net gate ... net); got 11 and 10
  hint: pad the shorter strip with '-' entries
  sub.py, line 29: sram6t = make_sram6t()
  sub.py, line 16: sc = stick("sram6t_stick",