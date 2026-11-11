"""Netlist-level baseline for the seven netlist tasks: the task netlist through from_spice, nothing
task-specific (stick cells for logic, device rows for the rest; from_spice chooses).

    XL_TASK=rca8 bin/icl build bench/xl/from_netlist.py --pdk sky130A --out build/nl.rca8.sky130A
    .venv/bin/python bench/xl/judge.py rca8 sky130A build/nl.rca8.sky130A/rca8.gds
"""
import os
from icdsl.canvas import *

tech = use()
TOP = from_spice(os.path.join(os.path.dirname(os.path.abspath(__file__)), "tasks", os.environ["XL_TASK"],
                              tech.name + ".spice"))
