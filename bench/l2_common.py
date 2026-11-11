"""Shared helpers for the level-2 benchmark (reference netlists, sweep points, full check)."""
from __future__ import annotations

import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BENCH = json.load(open(os.path.join(ROOT, "bench", "l2_cells.json")))
ICL = os.path.join(ROOT, "bin", "icl")
PY = os.path.join(ROOT, ".venv", "bin", "python")


def cell_spec(name):
    return next(c for c in BENCH["cells"] if c["name"] == name)


def point_params(cell, pt):
    pv = {}
    for k, v in cell["params"].items():
        if k.startswith("L"):
            if pt.get("Lmin"):
                pv[k] = 0.15 if v > 0.15 else 0.3
            else:
                pv[k] = round(v * pt.get("Lscale", 1.0), 3)
        else:
            pv[k] = round(v * pt.get("wscale", 1.0), 3)
    return pv


def nominal(cell):
    return point_params(cell, BENCH["sweep"][0])


def reference_spice(cell, pv):
    ports = [p["name"] for p in cell["ports"]]
    out = [f"* benchmark reference for {cell['name']}", f".subckt {cell['name']} " + " ".join(ports)]
    pw = next((p["name"] for p in cell["ports"] if p["dir"] == "power"), "VPWR")
    gn = next((p["name"] for p in cell["ports"] if p["dir"] == "ground"), "VGND")
    for d in cell["devices"]:
        b = gn if d["kind"] == "nmos" else pw
        model = "sky130_fd_pr__nfet_01v8" if d["kind"] == "nmos" else "sky130_fd_pr__pfet_01v8"
        w = pv[d["w"]] * d["nf"]
        out.append(f"X{d['name']} {d['d']} {d['g']} {d['s']} {b} {model} w={w:g} l={pv[d['l']]:g}")
    return "\n".join(out + [".ends", ".end", ""])


def judge(path, cell, pv):
    """Run the geometric judge in a subprocess (keeps the harness process small)."""
    cmd = [PY, os.path.join(ROOT, "bench", "l2_judge_json.py"), path, cell["name"], json.dumps(pv)]
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
    try:
        return json.loads(p.stdout.strip().splitlines()[-1])
    except Exception:
        return {"ok": False, "results": [], "error": (p.stderr or p.stdout)[-500:]}


def run_check(path, cell, pv, out):
    """magic DRC + netgen LVS against the independent reference + geometric judge."""
    os.makedirs(out, exist_ok=True)
    ref = os.path.join(out, f"{cell['name']}.reference.spice")
    open(ref, "w").write(reference_spice(cell, pv))
    cmd = [ICL, "check", path, "--top", cell["name"], "--json", "--out", out, "--ref", ref]
    for k, v in pv.items():
        cmd += ["--param", f"{k}={v}"]
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=900)
    try:
        rep = json.loads(p.stdout)
    except json.JSONDecodeError:
        return {"status": "ERROR", "error": "tool crashed: " + (p.stderr[-800:] or p.stdout[-800:]), "line": 0}
    if rep.get("status") != "ERROR":
        j = judge(path, cell, pv)
        rep["judge"] = j
        if rep.get("status") == "CLEAN" and not j.get("ok"):
            rep["status"] = "CONSTRAINTS"
    return rep
