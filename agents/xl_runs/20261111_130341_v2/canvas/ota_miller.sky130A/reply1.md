```python
from icdsl.canvas import *
tech = use()
c0, c1 = tech.c0, tech.metal(1)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

# ------------------------------------------------------------------ netlist
netlist = """
* ota_miller - two-stage Miller OTA (canvas)
.subckt ota_miller INP INN OUT IB VDD VSS
XM8_0 IB IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM8_1 VSS IB IB VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM5_0 tail IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM5_1 VSS IB tail VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM5_2 tail IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM5_3 VSS IB tail VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_0 OUT IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_1 VSS IB OUT VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_2 OUT IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_3 VSS IB OUT VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_4 OUT IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_5 VSS IB OUT VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_6 OUT IB VSS VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM7_7 VSS IB OUT VSS sky130_fd_pr__nfet_01v8 w=2 l=1
XM1_0 d1 INN tail VSS sky130_fd_pr__nfet_01v8 w=4 l=0.5
XM1_1 tail INN d1 VSS sky130_fd_pr__nfet_01v8 w=4 l=0.5
XM2_0 d2 INP tail VSS sky130_fd_pr__nfet_01v8 w=4 l=0.5
XM2_1 tail INP d2 VSS sky130_fd_pr__nfet_01v8 w=4 l=0.5
XM3_0 d1 d1 VDD VDD sky130_fd_pr__pfet_01v8 w=4 l=1
XM3_1 VDD d1 d1 VDD sky130_fd_pr__pfet_01v8 w=4 l=1
XM4_0 d2 d1 VDD VDD sky130_fd_pr__pfet_01v8 w=4 l=1
XM4_1 VDD d1 d2 VDD sky130_fd_pr__pfet_01v8 w=4 l=1
XM6_0 OUT d2 VDD VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_1 VDD d2 OUT VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_2 OUT d2 VDD VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_3 VDD d2 OUT VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_4 OUT d2 VDD VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_5 VDD d2 OUT VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_6 OUT d2 VDD VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
XM6_7 VDD d2 OUT VDD sky130_fd_pr__pfet_01v8 w=4 l=0.5
"""
if have_res and have_mim:
    netlist += "XRZ d2 x sky130_fd_pr__res_generic_po w=1 l=8\nXCC x OUT sky130_fd_pr__cap_mim_m3_1 w=20 l=20\n"
else:
    netlist += ("XM9 x VDD VDD VDD sky130_fd_pr__nfet_01v8 w=1 l=1\n"
                "XMC OUT OUT OUT OUT sky130_fd_pr__nfet_01v8 w=1 l=1\n")
netlist += ".ends\n.end\n"

TOP = from_spice(netlist, top="ota_miller")
```