"""Signoff wrappers: magic (DRC + extraction) and netgen (LVS) with the SKY130A decks."""
from __future__ import annotations

import json
import os
import re
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOOLS = os.environ.get("ICL_TOOLS", os.path.join(ROOT, "tools", "install", "bin"))
PDK_ROOT = os.environ.get("PDK_ROOT", os.path.join(ROOT, "pdk"))
PDK = "sky130A"
TECHDIR = os.path.join(PDK_ROOT, PDK, "libs.tech")
MAGICRC = os.path.join(TECHDIR, "magic", f"{PDK}.magicrc")
NETGEN_SETUP = os.path.join(TECHDIR, "netgen", f"{PDK}_setup.tcl")


def _env():
    e = dict(os.environ)
    e["PATH"] = TOOLS + os.pathsep + e.get("PATH", "")
    e["PDK_ROOT"] = PDK_ROOT
    e["PDK"] = PDK
    return e


def _magic(script, workdir, timeout=600):
    workdir = os.path.abspath(workdir)
    path = os.path.join(workdir, "_run.tcl")
    with open(path, "w") as f:
        f.write(script)
    p = subprocess.run(["magic", "-dnull", "-noconsole", "-rcfile", MAGICRC, path],
                       cwd=workdir, env=_env(), capture_output=True, text=True, timeout=timeout)
    return p.stdout + p.stderr


def magic_drc(gds, top, workdir):
    workdir = os.path.abspath(workdir)
    """Run magic full DRC on the (flattened) top cell. Returns list of {rule, boxes_um}."""
    out = os.path.join(workdir, f"{top}.magic_drc.txt")
    script = f"""
gds noduplicates true
gds read {os.path.abspath(gds)}
load {top}
select top cell
expand
flatten -nolabels __drcflat
load __drcflat
select top cell
drc euclidean on
drc style drc(full)
drc check
drc catchup
set oscale [cif scale out]
set fout [open {out} w]
set res [drc listall why]
foreach {{why boxes}} $res {{
    foreach b $boxes {{
        puts $fout "[format %.3f [expr {{$oscale*[lindex $b 0]}}]] [format %.3f [expr {{$oscale*[lindex $b 1]}}]] [format %.3f [expr {{$oscale*[lindex $b 2]}}]] [format %.3f [expr {{$oscale*[lindex $b 3]}}]]\\t$why"
    }}
}}
close $fout
puts "DRC_DONE"
quit -noprompt
"""
    log = _magic(script, workdir)
    if not os.path.exists(out):
        raise RuntimeError("magic DRC failed:\n" + log[-3000:])
    errs = []
    for line in open(out):
        line = line.rstrip("\n")
        if not line:
            continue
        coords, why = line.split("\t", 1)
        x0, y0, x1, y1 = (float(v) for v in coords.split())
        errs.append({"rule": why.strip(), "box_um": [x0, y0, x1, y1]})
    return errs, log


def magic_extract(gds, top, workdir):
    workdir = os.path.abspath(workdir)
    """Extract a SPICE netlist for LVS. Returns path."""
    exdir = os.path.join(workdir, "ext")
    os.makedirs(exdir, exist_ok=True)
    out = os.path.join(workdir, f"{top}.extracted.spice")
    script = f"""
gds noduplicates true
gds read {os.path.abspath(gds)}
load {top}
select top cell
cd {exdir}
extract do local
extract all
ext2spice lvs
ext2spice -o {out}
puts "EXT_DONE"
quit -noprompt
"""
    log = _magic(script, workdir)
    if not os.path.exists(out):
        raise RuntimeError("magic extraction failed:\n" + log[-3000:])
    return out, log


def netgen_lvs(layout_spice, ref_spice, top, workdir):
    workdir = os.path.abspath(workdir)
    layout_spice, ref_spice = os.path.abspath(layout_spice), os.path.abspath(ref_spice)
    out = os.path.join(workdir, f"{top}.lvs.txt")
    cmd = ["netgen", "-batch", "lvs", f"{layout_spice} {top}", f"{ref_spice} {top}",
           NETGEN_SETUP, out, "-json"]
    p = subprocess.run(cmd, cwd=workdir, env=_env(), capture_output=True, text=True, timeout=600)
    log = p.stdout + p.stderr
    txt = open(out).read() if os.path.exists(out) else ""
    jpath = os.path.splitext(out)[0] + ".json"
    data = json.load(open(jpath)) if os.path.exists(jpath) else None
    match = "Circuits match uniquely" in log or "Netlists match uniquely" in log
    pins_ok = "Cell pin lists are equivalent" in log or "pin lists are equivalent" in txt
    final = re.findall(r"Final result:\s*\n?\s*([^\n]+)", log + txt)
    return {"match": match and ("mismatch" not in (final[-1] if final else "").lower()),
            "final": final[-1].strip() if final else "",
            "pins_equivalent": pins_ok,
            "report": out, "json": data, "log": log}


def strip_dummies(spice_path, out_path):
    """Copy a SPICE netlist without dummy transistors (drain == source). Used when LVS runs against an
    independent reference netlist that does not list the matching dummies. Returns the number removed."""
    lines = open(spice_path).read().splitlines()
    out, n, skip = [], 0, False
    for ln in lines:
        if ln.startswith("+") and skip:
            continue
        skip = False
        t = ln.split()
        if t and t[0][:1].upper() in ("X", "M") and len(t) >= 6 and \
                any(k in ln for k in ("nfet", "pfet")) and t[1] == t[3]:
            n += 1
            skip = True
            continue
        out.append(ln)
    open(out_path, "w").write("\n".join(out) + "\n")
    return n
