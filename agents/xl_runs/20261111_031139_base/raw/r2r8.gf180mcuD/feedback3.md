The script did not write r2r8.gds (exit code 1):
Traceback (most recent call last):
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/r2r8.gf180mcuD/a3/sub.py", line 159, in <module>
    p1, p2 = res_unit(top, cx, cy)
             ~~~~~~~~^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/r2r8.gf180mcuD/a3/sub.py", line 112, in res_unit
    dbox(cell, L["sab"], cx - RL / 2 - 0.28, cy - HALF_PW - 0.28,
               ~^^^^^^^
KeyError: 'sab'