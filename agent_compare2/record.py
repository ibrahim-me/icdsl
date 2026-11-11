#!/usr/bin/env python3
"""Record a finished subagent's usage: record.py <agentId> <tokens> <tool_uses> <duration_ms> [note]"""
import json, os, sys
D = os.path.dirname(os.path.abspath(__file__))
ids = json.load(open(os.path.join(D, "agents.json")))
p = os.path.join(D, "usage.json")
u = json.load(open(p)) if os.path.exists(p) else {}
aid, tok, tools, ms = sys.argv[1:5]
run = ids.get(aid, aid)
u.setdefault(run, {}).update(tokens=int(tok), tool_uses=int(tools), minutes=round(int(ms) / 60000, 1))
if len(sys.argv) > 5:
    u[run]["note"] = sys.argv[5]
json.dump(u, open(p, "w"), indent=1)
print(run, u[run])
