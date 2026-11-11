"""Search the ICL reference library by circuit structure (and by name / function text).

Each cell's transistor netlist becomes a graph (devices labelled nmos/pmos, nets labelled by role:
supply, input, output, internal; edges labelled gate or source/drain). Weisfeiler-Lehman relabelling
(3 rounds) turns it into a bag of local-structure labels; similarity is the cosine of the two bags,
scaled by the size ratio. Pin names and transistor widths do not matter, so a NAND3 finds NAND4,
NAND3B, A31OI ... before an XOR.

    python agents/libsearch.py nand3_1            # nearest library cells to a library spec
    python agents/libsearch.py --query "mux"      # by name / function text
"""
from __future__ import annotations

import hashlib
import json
import math
import os
import re
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
LIBDIR = os.path.join(ROOT, "library")
LIBERTY = os.path.join(ROOT, "pdk", "sky130A", "libs.ref", "sky130_fd_sc_hd", "lib",
                       "sky130_fd_sc_hd__tt_025C_1v80.lib")
SUPPLY = {"VPWR", "VGND", "VPB", "VNB"}


def _h(s):
    return hashlib.blake2b(s.encode(), digest_size=6).hexdigest()


def fingerprint(spec, rounds=3):
    """Bag of Weisfeiler-Lehman labels of the device/net graph of a task spec."""
    ins, outs = set(spec["inputs"]), set(spec["outputs"])

    def role(n):
        if n in ("VPWR", "VPB"):
            return "P"
        if n in ("VGND", "VNB"):
            return "G"
        return "I" if n in ins else "O" if n in outs else "n"
    adj, lab = {}, {}
    for i, d in enumerate(spec["devices"]):
        dn = f"#d{i}"
        lab[dn] = d["kind"][0]
        for t, n in (("g", d["g"]), ("sd", d["d"]), ("sd", d["s"])):
            nn = "$" + n
            lab.setdefault(nn, role(n))
            adj.setdefault(dn, []).append((t, nn))
            adj.setdefault(nn, []).append((t, dn))
    bag = Counter(lab.values())
    cur = dict(lab)
    for _ in range(rounds):
        nxt = {}
        for v, l in cur.items():
            nb = sorted(f"{t}:{cur[u]}" for t, u in adj.get(v, []))
            # supply nets have huge fan-out: summarise them by their own label only
            if l in ("P", "G"):
                nxt[v] = l
                continue
            nxt[v] = _h(l + "|" + ",".join(nb))
        cur = nxt
        bag.update(x for v, x in cur.items() if lab[v] not in ("P", "G"))
    return bag


def similarity(fa, fb, na, nb):
    dot = sum(fa[k] * fb.get(k, 0) for k in fa)
    if not dot:
        return 0.0
    cos = dot / math.sqrt(sum(v * v for v in fa.values()) * sum(v * v for v in fb.values()))
    return cos * math.sqrt(min(na, nb) / max(na, nb))


_LIB = {}


def liberty():
    """cell short name -> {"functions": {pin: expr}, "seq": "ff"|"latch"|None}"""
    if "lib" in _LIB:
        return _LIB["lib"]
    out, cell, pin, direction = {}, None, None, None
    if os.path.exists(LIBERTY):
        for line in open(LIBERTY):
            m = re.match(r'\s*cell \("sky130_fd_sc_hd__(\S+)"\)', line)
            if m:
                cell = m.group(1)
                out[cell] = {"functions": {}, "seq": None}
                continue
            if cell is None:
                continue
            m = re.match(r'\s*pin \("(\S+)"\)', line)
            if m:
                pin = m.group(1)
            m = re.match(r'\s*function : "(.*)";', line)
            if m and pin:
                out[cell]["functions"][pin] = m.group(1)
            if re.match(r"\s*ff \(", line):
                out[cell]["seq"] = "flip-flop"
            if re.match(r"\s*latch \(", line):
                out[cell]["seq"] = "latch"
    _LIB["lib"] = out
    return out


def describe(name):
    li = liberty().get(name, {})
    f = "; ".join(f"{p} = {e}" for p, e in li.get("functions", {}).items())
    if li.get("seq"):
        f = (li["seq"] + (": " + f if f else "")).strip()
    return f


class Library:
    """Lifted, verified cells: library/<variant>/<cell>.icl + index.json, specs from library/*_specs.json."""

    def __init__(self, variant="hd", only_clean=True, exclude_families=()):
        self.dir = os.path.join(LIBDIR, variant)
        spec_file = os.path.join(LIBDIR, "lib_specs.json" if variant == "hd" else "hd_specs.json")
        specs = {c["name"]: c for c in json.load(open(spec_file))["cells"]}
        index = json.load(open(os.path.join(self.dir, "index.json")))
        self.cells = {}
        for name, r in index.items():
            if only_clean and r.get("status") != "clean":
                continue
            sp = specs.get(name)
            if sp is None or sp.get("family") in exclude_families:
                continue
            self.cells[name] = {"spec": sp, "fp": fingerprint(sp), "path": os.path.join(self.dir, f"{name}.icl"),
                                "width_cols": r.get("width_cols")}

    def nearest(self, spec, k=3, exclude=()):
        fa, na = fingerprint(spec), len(spec["devices"])
        sc = []
        for name, c in self.cells.items():
            if name in exclude or c["spec"].get("family") == spec.get("family", object()):
                continue
            sc.append((similarity(fa, c["fp"], na, len(c["spec"]["devices"])), name))
        sc.sort(key=lambda t: (-t[0], len(self.cells[t[1]]["spec"]["devices"]), t[1]))
        return sc[:k]

    def query(self, text, k=8):
        t = text.lower().strip()
        hits = []
        for name, c in self.cells.items():
            d = describe(name).lower()
            score = 2 if t in name.lower() else (1 if t and t in d else 0)
            if score:
                hits.append((score, name))
        hits.sort(key=lambda x: (-x[0], len(self.cells[x[1]]["spec"]["devices"]), x[1]))
        return [n for _, n in hits[:k]]

    def summary(self, name, score=None):
        c = self.cells[name]["spec"]
        nmos = sum(1 for d in c["devices"] if d["kind"] == "nmos")
        s = (f"{name}: {len(c['devices'])} transistors ({nmos} n / {len(c['devices']) - nmos} p), inputs "
             f"{', '.join(c['inputs'])}; outputs {', '.join(c['outputs'])}")
        f = describe(name)
        if f:
            s += f"; {f}"
        if score is not None:
            s = f"[{score:.2f}] " + s
        return s

    def text(self, name):
        return open(self.cells[name]["path"]).read()


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("cell", nargs="?")
    ap.add_argument("--query", default="")
    ap.add_argument("-k", type=int, default=5)
    a = ap.parse_args()
    lib = Library()
    if a.query:
        for n in lib.query(a.query, a.k):
            print(lib.summary(n))
        return
    specs = {c["name"]: c for c in json.load(open(os.path.join(LIBDIR, "lib_specs.json")))["cells"]}
    sp = specs[a.cell]
    print("target:", a.cell, describe(a.cell))
    for s, n in lib.nearest(sp, a.k):
        print(" ", lib.summary(n, s))


if __name__ == "__main__":
    sys.exit(main())


# ----------------------------------------------------------------------------- edit-the-nearest start file
def net_map(src, dst, steps=200000):
    """Largest consistent correspondence of transistors src -> dst (same kind, gate to gate, source/drain
    to source/drain in either order), as a net map src net -> dst net. Supplies map to themselves. Several
    src nets may map to one dst net (e.g. o2bb2ai's A1_N and B2 both become xnor2's A); such merges are
    reported, fewest first, because the pieces then have to be connected."""
    sd, dd = src["devices"], dst["devices"]
    SUP = {"VPWR", "VGND"}
    m = {"VPWR": "VPWR", "VGND": "VGND"}
    rev = {"VPWR": {"VPWR"}, "VGND": {"VGND"}}
    used = [False] * len(dd)
    best = {"key": (-1, 0), "m": dict(m)}
    cnt = [0]
    order = sorted(range(len(sd)), key=lambda i: (sd[i]["g"] not in src["inputs"], i))

    def merges():
        return sum(len(v) - 1 for k, v in rev.items() if k not in SUP)

    def bind(pairs):
        added = []
        ok = True
        for a, b in pairs:
            if a in m:
                if m[a] != b:
                    ok = False
                    break
                continue
            if (a in SUP) != (b in SUP) or (a in SUP and a != b):
                ok = False
                break
            m[a] = b
            rev.setdefault(b, set()).add(a)
            added.append(a)
        if ok:
            return added
        for a in added:
            rev[m[a]].discard(a)
            if not rev[m[a]]:
                del rev[m[a]]
            del m[a]
        return None

    def unbind(added):
        for a in added:
            rev[m[a]].discard(a)
            if not rev[m[a]]:
                del rev[m[a]]
            del m[a]

    def go(k, n):
        cnt[0] += 1
        if cnt[0] > steps:
            return
        key = (n, -merges())
        if key > best["key"]:
            best["key"], best["m"] = key, dict(m)
        if k == len(order) or n + (len(order) - k) < best["key"][0]:
            return
        s = sd[order[k]]
        for j, t in enumerate(dd):
            if used[j] or t["kind"] != s["kind"]:
                continue
            for a, b in ((t["d"], t["s"]), (t["s"], t["d"])):
                added = bind([(s["g"], t["g"]), (s["d"], a), (s["s"], b)])
                if added is None:
                    continue
                used[j] = True
                go(k + 1, n + 1)
                used[j] = False
                unbind(added)
        go(k + 1, n)                       # leave this transistor unmatched
    go(0, 0)
    return best["m"], best["key"][0]


def start_file(target, lib_name, lib):
    """The library cell's ICL turned into a starting point for `target`: the target's name, parameters,
    devices and ports; the library geometry with net labels renamed where the circuits correspond."""
    src = lib.cells[lib_name]["spec"]
    txt = lib.text(lib_name)
    nm, matched = net_map(src, target)
    tnets = {d[k] for d in target["devices"] for k in ("d", "g", "s")} | {"VPWR", "VGND"}
    groups = {}
    for a, b in nm.items():
        if b not in ("VPWR", "VGND"):
            groups.setdefault(b, []).append(a)
    merged = {b: sorted(v) for b, v in groups.items() if len(v) > 1}
    out = [f"# STARTING POINT: the verified library cell {lib_name} ({describe(lib_name) or 'see /TASK.md'}),",
           f"# {len(src['devices'])} transistors; {matched} of them correspond to transistors of {target['name']}.",
           f"# Its device lines were replaced by {target['name']}'s; net labels were renamed where the circuits",
           "# correspond and removed elsewhere. Change the geometry until it implements the devices below.",
           "# The library cell's own devices (what the geometry below was drawn for):"]
    for d in src["devices"]:
        ren = lambda n: nm.get(n, f"{n}?")
        out.append(f"#   {d['name']} {d['kind']} d={ren(d['d'])} g={ren(d['g'])} s={ren(d['s'])}")
    for b, v in merged.items():
        out.append(f"# The library nets {', '.join(v)} all became {b}: their shapes are separate pieces now -")
        out.append(f"#   connect them (e.g. `route {b} layers=m1,m2`, and `port {b} ...` without on= if needed).")
    done_dev = False
    port_seen = set()
    for line in txt.splitlines():
        s = line.strip()
        if s.startswith("# ") and not out[-1].startswith("  ") and line.startswith("#") and "lifted from" in line:
            continue
        if s.startswith("param "):
            pl = " ".join(f"{k}={v}" for k, v in target["params"].items())
            out.append(f"param {pl} L=0.15 H=2.72")
            continue
        if s.startswith("stdcell "):
            out.append(re.sub(r"^stdcell \S+", f"stdcell {target['name']}", line))
            continue
        if s.startswith("device "):
            if not done_dev:
                for d in target["devices"]:
                    b = " b=VNB" if d["kind"] == "nmos" else " b=VPB"
                    out.append(f"  device {d['name']} {d['kind']} w={d['wparam']} l=L d={d['d']} g={d['g']} "
                               f"s={d['s']}{b}")
                done_dev = True
            continue
        m = re.match(r"\s*port (\S+) (\S+)(.*)$", line)
        if m:
            new = nm.get(m.group(1))
            if new and new in target["inputs"] + target["outputs"]:
                d = "in" if new in target["inputs"] else "out"
                out.append(f"  port {new} {d}{m.group(3)}")
                port_seen.add(new)
            else:
                out.append(f"  # (library port {m.group(1)} has no counterpart) {s}")
            continue

        def rn(mm):
            new = nm.get(mm.group(1))
            return f"net={new}" if new in tnets else ""
        line = re.sub(r"net=(\S+)", rn, line).rstrip()
        out.append(line)
    if port_seen != set(target["inputs"] + target["outputs"]):
        i = len(out) - 1 if out[-1].strip() == "end" else len(out)
        for p in target["inputs"] + target["outputs"]:
            if p not in port_seen:
                d = "in" if p in target["inputs"] else "out"
                out.insert(i, f"  # TODO: port {p} {d} on=<a met1 pad on {p}'s li>   (no counterpart in {lib_name})")
    return "\n".join(out) + "\n", matched
