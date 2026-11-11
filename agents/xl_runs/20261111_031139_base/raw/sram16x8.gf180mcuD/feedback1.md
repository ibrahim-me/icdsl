The script did not write sram16x8.gds (exit code 1):
Traceback (most recent call last):
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/sram16x8.gf180mcuD/a1/sub.py", line 226, in <module>
    poly_gate(cell, x - n_l / 2.0, y_wl - TECH["rules"]["poly_endcap"], n_l, n_l + 2 * TECH["rules"]["poly_endcap"], is_pmos=False)
    ~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/sram16x8.gf180mcuD/a1/sub.py", line 143, in poly_gate
    ige = TECH["rules"]["implant_gate_ext"]
          ~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^
KeyError: 'implant_gate_ext'