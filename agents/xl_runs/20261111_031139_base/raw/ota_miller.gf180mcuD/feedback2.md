The script did not write ota_miller.gds (exit code 1):
Traceback (most recent call last):
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.gf180mcuD/a2/sub.py", line 418, in <module>
    build_ota_miller()
    ~~~~~~~~~~~~~~~~^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.gf180mcuD/a2/sub.py", line 371, in build_ota_miller
    x = b.resistor_poly(x, 10.0, 1.0, 8.0, 'd2', 'x', bulk_net='VSS')
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.gf180mcuD/a2/sub.py", line 256, in resistor_poly
    self.label("res_mk", "RES", x + l / 2, y + w / 2)
    ~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.gf180mcuD/a2/sub.py", line 90, in label
    self.top.shapes(self.layers[layer + "_label"]).insert(
                    ~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
KeyError: 'res_mk_label'