The script did not write r2r8.gds (exit code 1):
Traceback (most recent call last):
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/r2r8.sky130A/a4/sub.py", line 265, in <module>
    ly, top = build_r2r8()
              ~~~~~~~~~~^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/r2r8.sky130A/a4/sub.py", line 197, in build_r2r8
    bx = node_x[na]
         ~~~~~~^^^^
KeyError: 'x0'