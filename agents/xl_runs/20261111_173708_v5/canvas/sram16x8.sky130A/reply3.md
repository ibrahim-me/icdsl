I'll start by inspecting the PDK and checking the environment.
<|open|>argument key="command" type="string"<|sep|>bin/icl inspect sram.py --pdk sky130A 2>&1 | head -60; echo "---LS---"; ls -la netlist.spice 2>&1; pwd
<|close|>argument<|sep|><|close|>call<|sep|><|close|>tools<|sep|><|close|>message<|sep|>
```