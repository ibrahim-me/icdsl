"""Signoff: magic DRC, magic extraction + netgen LVS, and (when the PDK data names one) the foundry's
KLayout DRC deck as a second, independent DRC. A PDK without a magic tech file (asap7) is judged by
its KLayout deck alone and extracted with KLayout (signoff.extract in the PDK data); LVS stays netgen.
The decks come from the Tech object (`signoff` entry of the PDK data), nothing here names a PDK."""
from __future__ import annotations

import json
import os
import re
import subprocess

from .tech import ROOT, PDK_ROOT

TOOLS = os.environ.get("ICL_TOOLS", os.path.join(ROOT, "tools", "install", "bin"))
TIMEOUT = int(os.environ.get("ICL_SIGNOFF_TIMEOUT", "3600"))    # seconds per tool run


def _run(cmd, cwd, env, timeout=None, what="tool"):
    """subprocess.run that kills the whole process group on timeout and says so in plain words."""
    import signal
    timeout = timeout or TIMEOUT
    p = subprocess.Popen(cmd, cwd=cwd, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                         start_new_session=True)
    try:
        out, err = p.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        try:
            os.killpg(p.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        p.communicate()
        raise RuntimeError(f"{what} did not finish in {timeout} s (a layout with very many errors or shorts "
                           "takes this long; a correct layout of this size takes seconds)")
    return out + err


def _env(tech):
    e = dict(os.environ)
    e["PATH"] = TOOLS + os.pathsep + e.get("PATH", "")
    e["PDK_ROOT"] = PDK_ROOT
    e["PDK"] = tech.name
    return e


def _magic(tech, script, workdir, timeout=None, what="magic"):
    workdir = os.path.abspath(workdir)
    os.makedirs(workdir, exist_ok=True)
    path = os.path.join(workdir, "_run.tcl")
    with open(path, "w") as f:
        f.write(script)
    return _run(["magic", "-dnull", "-noconsole", "-rcfile", tech.deck("magicrc"), path], workdir, _env(tech),
                timeout, what)


def drc(tech, gds, top, workdir):
    """magic DRC (the PDK's full style) on the flattened top cell -> [{rule, box_um}], log."""
    workdir = os.path.abspath(workdir)
    out = os.path.join(workdir, f"{top}.magic_drc.txt")
    if os.path.exists(out):
        os.remove(out)
    style = tech.d["signoff"].get("drc_style")
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
{('drc style ' + style) if style else ''}
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
    log = _magic(tech, script, workdir, what="magic DRC")
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


def magic_ready(tech):
    """True when the PDK data names a magic tech file (magic DRC and magic extraction are then used)."""
    return bool(tech.d["signoff"].get("magicrc"))


def klayout_deck(tech):
    k = tech.d["signoff"].get("klayout")
    if not k:
        return None
    return k["deck"] if os.path.isabs(k["deck"]) else os.path.join(tech.root, k["deck"])


def klayout_ready(tech, force=False):
    """True when the PDK data names a KLayout DRC deck and a klayout binary is available.
    ICL_KLAYOUT=0 switches the deck off as a second judge; force=True ignores that (the deck of a
    PDK without magic is the only judge)."""
    import shutil
    deck = klayout_deck(tech)
    if not deck or (not force and os.environ.get("ICL_KLAYOUT", "1") == "0"):
        return False
    return os.path.exists(deck) and bool(shutil.which("klayout", path=_env(tech)["PATH"]))


def klayout_drc(tech, gds, top, workdir, timeout=None):
    """The foundry KLayout DRC deck -> ([{rule, text, box_um}], [waived rule ids that fired], log).
    PDK data: signoff.klayout = dict(deck=path, top=name of the deck's top-cell variable,
    args={deck variable: value}, waive={rule id: reason}) - waived rules (die-level density and the like)
    are dropped and reported separately."""
    import xml.etree.ElementTree as ET
    k = tech.d["signoff"]["klayout"]
    workdir = os.path.abspath(workdir)
    os.makedirs(workdir, exist_ok=True)
    deck = k["deck"] if os.path.isabs(k["deck"]) else os.path.join(tech.root, k["deck"])
    out = os.path.join(workdir, f"{top}.klayout_drc.lyrdb")
    if os.path.exists(out):
        os.remove(out)
    cmd = ["klayout", "-b", "-r", deck, "-rd", f"{k.get('input', 'input')}={os.path.abspath(gds)}",
           "-rd", f"{k.get('report', 'report')}={out}", "-rd", f"{k.get('top', 'topcell')}={top}"]
    for a, v in k.get("args", {}).items():
        cmd += ["-rd", f"{a}={v}"]
    log = _run(cmd, workdir, _env(tech), timeout, "the KLayout DRC deck")
    if not os.path.exists(out):
        raise RuntimeError("KLayout DRC failed:\n" + log[-3000:])
    root = ET.parse(out).getroot()
    text = {}
    for c in root.iter("category"):
        n, d = c.find("name"), c.find("description")
        if n is not None and n.text:
            text[n.text.strip().strip("'")] = (d.text or "").strip() if d is not None else ""
    waive = k.get("waive", {})
    errs, waived = [], set()
    for it in root.iter("item"):
        rule = (it.findtext("category") or "?").strip().strip("'")
        if rule in waive:
            waived.add(rule)
            continue
        nums = [float(v) for v in re.findall(r"-?\d+(?:\.\d+)?(?:e-?\d+)?", " ".join(
            v.text or "" for v in it.iter("value")).split(":", 1)[-1])]
        xs, ys = nums[0::2], nums[1::2]
        box = [min(xs), min(ys), max(xs), max(ys)] if xs and len(xs) == len(ys) else [0, 0, 0, 0]
        errs.append({"rule": rule + (": " + text[rule] if text.get(rule) else ""), "box_um": [round(v, 4) for v in box]})
    return errs, sorted(waived), log


def _extract_klayout(tech, gds, top, workdir, ports=None):
    """Flat netlist extraction with KLayout's LayoutToNetlist, for a PDK without a magic tech file.
    Everything comes from the PDK data: signoff.extract = dict(
        derive=[(name, a, '&' | '-' | '|', b)],            derived layers, in order
        mos=[dict(model, sd, gate, poly, well)],            4-terminal MOS devices
        conductors=[...], connect=[(a, b)],                 what conducts and what connects where it overlaps
        labels={label layer: conductor},                    where a label layer names a derived conductor
        substrate=dict(layer, ties=[...], net))             an empty bulk layer and the layers tied to it
    Net names are the texts on the PDK's label layers. `ports` = pin order of the top subcircuit.
    -> SPICE netlist path, log text."""
    import klayout.db as kdb
    spec = tech.d["signoff"]["extract"]
    workdir = os.path.abspath(workdir)
    os.makedirs(workdir, exist_ok=True)
    out = os.path.join(workdir, f"{top}.extracted.spice")
    if os.path.exists(out):
        os.remove(out)
    ly = kdb.Layout()
    ly.read(os.path.abspath(gds))
    cell = ly.cell(top)
    if cell is None:
        raise RuntimeError(f"KLayout extraction: no cell {top!r} in {gds}")
    cell.flatten(True)
    l2n = kdb.LayoutToNetlist(kdb.RecursiveShapeIterator(ly, cell, []))
    sub = spec.get("substrate") or {}
    reg = {}

    def layer(name):
        if name not in reg:
            if name == sub.get("layer"):
                reg[name] = l2n.make_layer(name)                     # empty: the substrate itself
            else:
                reg[name] = l2n.make_layer(ly.layer(*tech.layer(name)), name)
        return reg[name]
    for name, a, op, b in spec.get("derive", []):
        ra, rb = layer(a), layer(b)
        reg[name] = (ra & rb) if op == "&" else (ra - rb) if op == "-" else (ra + rb)
        l2n.register(reg[name], name)
    models = {}
    for m in spec.get("mos", []):
        ex = kdb.DeviceExtractorMOS4Transistor(m["model"])
        l2n.extract_devices(ex, {"SD": layer(m["sd"]), "G": layer(m["gate"]), "tG": layer(m["poly"]),
                                 "W": layer(m["well"])})
        models[m["model"].upper()] = m["model"]
    for c in spec.get("conductors", []):
        l2n.connect(layer(c))
    for a, b in spec.get("connect", []):
        l2n.connect(layer(a), layer(b))
    target = spec.get("labels", {})
    for name, ld in tech.label_layer.items():
        c = target.get(name, name)
        if c in spec.get("conductors", []):
            l2n.connect(layer(c), l2n.make_text_layer(ly.layer(*ld), name + "_label"))
    if sub:
        l2n.connect_global(layer(sub["layer"]), sub["net"])
        for tie in sub.get("ties", []):
            l2n.connect_global(layer(tie), sub["net"])
    l2n.extract_netlist()
    nl = l2n.netlist()
    ckt = nl.circuit_by_name(top) or next(iter(nl.each_circuit_top_down()), None)
    if ckt is None:
        raise RuntimeError("KLayout extraction produced no circuit")
    ports = list(ports or [])
    auto = {}

    def nname(net):
        """SPICE name of a net: the port among its names, else its (first) label, else a number."""
        if net is None:
            auto[len(auto)] = n = f"_nc{len(auto)}"
            return n
        names = [n for n in (net.name or "").split(",") if n]
        for p in ports:
            if p in names:
                return p
        if names:
            return names[0]
        return auto.setdefault(("n", net.cluster_id), f"_n{net.cluster_id}")
    lines, used, ndev = [], [], 0
    for dev in ckt.each_device():
        dc = dev.device_class()
        tn = {td.name: nname(dev.net_for_terminal(td.id())) for td in dc.terminal_definitions()}
        used += list(tn.values())
        lines.append(f"M{ndev} {tn['D']} {tn['G']} {tn['S']} {tn['B']} {models.get(dc.name.upper(), dc.name)} "
                     f"w={dev.parameter('W'):.6g}u l={dev.parameter('L'):.6g}u")
        ndev += 1
    named = []
    for net in ckt.each_net():
        n = nname(net)
        if not n.startswith("_n") and n not in named:
            named.append(n)
    pins = [p for p in ports if p in named] if ports else sorted(n for n in named if n != sub.get("net"))
    with open(out, "w") as f:
        f.write(f"* {top}: KLayout extraction ({tech.name}), flat\n.subckt {top} {' '.join(pins)}\n"
                + "\n".join(lines) + "\n.ends\n")
    log = (f"KLayout extraction: {ndev} devices, {len(list(ckt.each_net()))} nets, pins {' '.join(pins)}"
           + ("" if not ports or len(pins) == len(ports) else
              "; ports with no labelled net in the layout: " + " ".join(p for p in ports if p not in named)))
    return out, log


def extract(tech, gds, top, workdir, ports=None):
    """Layout netlist -> SPICE path, log. magic's hierarchical extraction (LVS style) by default; a PDK
    whose data has signoff.extract = dict(tool="klayout", ...) is extracted with KLayout instead, and
    `ports` (pin order of the top cell) is used only there."""
    if tech.d["signoff"].get("extract", {}).get("tool") == "klayout":
        return _extract_klayout(tech, gds, top, workdir, ports)
    workdir = os.path.abspath(workdir)
    exdir = os.path.join(workdir, "ext")
    os.makedirs(exdir, exist_ok=True)
    for f in os.listdir(exdir):
        if f.endswith(".ext"):
            os.remove(os.path.join(exdir, f))
    out = os.path.join(workdir, f"{top}.extracted.spice")
    if os.path.exists(out):
        os.remove(out)
    so = tech.d["signoff"]
    style = so.get("ext_style")             # extraction style to select (default: the tech file's own)
    script = f"""
gds noduplicates true
gds read {os.path.abspath(gds)}
load {top}
select top cell
cd {exdir}
{('extract style ' + style) if style else ''}
extract do local
extract all
ext2spice lvs
ext2spice -o {out}
puts "EXT_DONE"
quit -noprompt
"""
    log = _magic(tech, script, workdir, what="magic extraction")
    if not os.path.exists(out):
        raise RuntimeError("magic extraction failed:\n" + log[-3000:])
    fix = so.get("ext_scale")               # factor on every extracted length (a tech file whose
    if fix:                                 # extract section states its scale wrongly)
        _SI = {"f": 1e-15, "p": 1e-12, "n": 1e-9, "u": 1e-6, "m": 1e-3, "": 1.0}

        def sub(m):
            k = fix * fix if m.group(1).lower() in ("ad", "as") else fix
            return f"{m.group(1)}={float(m.group(2)) * _SI[m.group(3).lower()] * k:.6g}"
        txt = open(out).read()
        txt = re.sub(r"\b(w|l|ad|as|pd|ps)=([-+0-9.eE]+?)([fpnum]?)(?=\s|$)", sub, txt, flags=re.I | re.M)
        open(out, "w").write(txt)
    return out, log


def lvs(tech, layout_spice, ref_spice, top, workdir):
    workdir = os.path.abspath(workdir)
    layout_spice, ref_spice = os.path.abspath(layout_spice), os.path.abspath(ref_spice)
    out = os.path.join(workdir, f"{top}.lvs.txt")
    for f in (out, os.path.splitext(out)[0] + ".json"):
        if os.path.exists(f):
            os.remove(f)
    cmd = ["netgen", "-batch", "lvs", f"{layout_spice} {top}", f"{ref_spice} {top}",
           tech.deck("netgen"), out, "-json"]
    log = _run(cmd, workdir, _env(tech), None, "netgen LVS")
    txt = open(out, errors="replace").read() if os.path.exists(out) else ""
    match = "Circuits match uniquely" in log or "Netlists match uniquely" in log
    pins_ok = "Cell pin lists are equivalent" in log or "pin lists are equivalent" in txt
    final = re.findall(r"Final result:\s*\n?\s*([^\n]+)", log + txt)
    prop_err = "property errors" in log or "property errors" in txt
    res = {"match": bool(match and not prop_err and ("mismatch" not in (final[-1] if final else "").lower())),
           "final": (final[-1].strip() if final else "(netgen produced no result)")
           + (" BUT device properties (w, l, ...) differ" if prop_err else ""),
           "pins_equivalent": pins_ok, "report": out, "log": log}
    m = re.findall(r"Circuit 1 contains (\d+) devices, Circuit 2 contains (\d+) devices", log)
    if m:
        res["devices_layout_vs_ref"] = [int(m[-1][0]), int(m[-1][1])]
    m = re.findall(r"Circuit 1 contains (\d+) nets,\s+Circuit 2 contains (\d+) nets", log)
    if m:
        res["nets_layout_vs_ref"] = [int(m[-1][0]), int(m[-1][1])]
    if not res["match"]:
        keep, grab = [], False
        for l in [l for l in txt.splitlines() if l.strip()]:
            if "mismatch" in l.lower() or "no matching" in l.lower() or "Net:" in l or "failed" in l.lower() \
                    or "property" in l.lower() or "circuit1:" in l:
                grab = True
            if grab:
                keep.append(l.rstrip())
            if len(keep) > 50:
                break
        res["details"] = keep
    return res


def count_devices(spice_path):
    """Number of device lines (flattened through the hierarchy) of a SPICE netlist's last subckt."""
    subs, cur, order = {}, None, []
    for ln in open(spice_path, errors="replace").read().replace("\n+", " ").splitlines():
        t = ln.split()
        if not t:
            continue
        if t[0].lower() == ".subckt":
            cur = t[1]
            subs[cur] = []
            order.append(cur)
        elif t[0].lower() == ".ends":
            cur = None
        elif cur and t[0][:1].upper() in "XMRCDQ":
            words = [w for w in t[1:] if "=" not in w]
            subs[cur].append(words[-1])
    memo = {}

    def n(c):
        if c not in memo:
            memo[c] = sum(n(m) if m in subs else 1 for m in subs[c])
        return memo[c]
    return n(order[-1]) if order else 0
