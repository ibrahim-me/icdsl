import sys, klayout.db as kdb
sys.path.insert(0, '/home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-raw-maj3/gen')
from frame import Cell, build_frame, W
lib = kdb.Layout(); lib.dbu = 0.001
top = Cell('maj3', lib)
build_frame(top)
lib.write('/home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-raw-maj3/maj3.gds')
print('wrote')
