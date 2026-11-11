I'll start by inspecting the PDK rule sheet and checking whether the netlist file exists, then design the layout.
<|open|>argument key="command" type="string"<|sep|>bin/icl inspect sram.py --pdk sky130A 2>&1 | head -60
<|close|>argument<|sep|><|open|>argument key="argument" type="string"<|sep|>
<|close|>argument<|sep|><|open|>argument key="command" type="string"<|sep|>ls netlist.spice 2>&1; pwd
<|close|>argument<|sep|><|close|>call<|sep|><|close|>tools<|sep|><|close|>message<|sep|>