I'll analyze the netlist and build a portable canvas script. Let me first check the PDK rule sheet to confirm layer names and rules.

```bash
bin/icl inspect ota_miller.py --pdk sky130A 2>/dev/null | head -5; echo "---"; ls examples/canvas/ 2>/dev/null
```
<|close|>argument<|sep|><|open|>argument key="path" type:"string"<|sep|>ota_miller.py<|close|>argument<|sep|><|open|>argument key="pdk" type:"string"<|sep|>sky130A<|close|>argument<|sep|><|close|>call<|sep|><|close|>tools<|sep|><|close|>message<|sep|>