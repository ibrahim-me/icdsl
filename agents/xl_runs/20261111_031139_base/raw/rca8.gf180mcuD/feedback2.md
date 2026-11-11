The script did not write rca8.gds (exit code 1):
Traceback (most recent call last):
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/rca8.gf180mcuD/a2/sub.py", line 334, in <module>
    route_net(net, pts)
    ~~~~~~~~~^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/rca8.gf180mcuD/a2/sub.py", line 330, in route_net
    via(fa, x2, y1, "m1", "m2")
    ~~~^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/rca8.gf180mcuD/a2/sub.py", line 116, in via
    v = TECH["cuts"][upper]
        ~~~~~~~~~~~~^^^^^^^
KeyError: 'm2'