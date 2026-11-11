The script did not write dec4to16.gds (exit code 1):
Traceback (most recent call last):
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.freepdk45/a2/sub.py", line 333, in <module>
    place_and_route()
    ~~~~~~~~~~~~~~~^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.freepdk45/a2/sub.py", line 202, in place_and_route
    inv = inv_cell("inv")
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.freepdk45/a2/sub.py", line 155, in inv_cell
    mos(c, "pmos", cx, pmos_y, 0.18, 0.05)
    ~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.freepdk45/a2/sub.py", line 128, in mos
    well(cell, well_kind, x1 - 0.055, y1 - 0.055, x2 + 0.055, y2 + 0.055)
    ~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.freepdk45/a2/sub.py", line 111, in well
    rect(cell, kind, x1, y1, x2, y2)
    ~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.freepdk45/a2/sub.py", line 73, in rect
    cell.shapes(LAYER(name)).insert(dbox((x1, y1, x2, y2)))
                ^^^^^
NameError: name 'LAYER' is not defined. Did you mean: 'LAYERS'?