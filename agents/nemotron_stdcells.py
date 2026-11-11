#!/usr/bin/env python3
"""Let a free LLM (default: nvidia/nemotron-3.5-super-vl:free on OpenRouter) write ICL standard cells.

For each cell:
  1. give the model the ICL level-1 reference, a worked parametric example and the transistor netlist
  2. check its file with magic DRC + netgen LVS (LVS against an independent reference netlist)
  3. feed back the report (text + rendered image) until clean or out of attempts
  4. sweep W / L / cell height locally and re-check every point
  5. optionally one robustness round: show the model its failing sweep points, re-sweep

Only zero-priced models are allowed. The API key is read from $OPENROUTER_API_KEY or ~/.bashrc
and is never written to logs.
"""
from __future__ import annotations

import argparse
import base64
import datetime
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ICL = os.path.join(ROOT, "bin", "icl")
API = "https://openrouter.ai/api/v1"

# ----------------------------------------------------------------------------- tasks
NOMINAL = {"WN": 0.52, "WP": 0.77, "L": 0.15, "H": 2.72}
SWEEP = ([{"WN": wn, "WP": wp, "L": l, "H": 2.72} for wn in (0.42, 0.52) for wp in (0.42, 0.64, 0.77)
          for l in (0.15, 0.18, 0.25)] +
         [{"WN": 0.65, "WP": 1.0, "L": 0.15, "H": 3.26}, {"WN": 0.84, "WP": 1.26, "L": 0.15, "H": 3.80},
          {"WN": 1.0, "WP": 1.5, "L": 0.15, "H": 4.08}, {"WN": 0.65, "WP": 1.0, "L": 0.25, "H": 3.26}])

CELLS = {
    "nand2": {"fn": "Y = !(A & B)", "ports": [("A", "in"), ("B", "in"), ("Y", "out")],
              "dev": [("MNA", "nmos", "n1", "A", "VGND"), ("MNB", "nmos", "Y", "B", "n1"),
                      ("MPA", "pmos", "Y", "A", "VPWR"), ("MPB", "pmos", "Y", "B", "VPWR")]},
    "nor2": {"fn": "Y = !(A | B)", "ports": [("A", "in"), ("B", "in"), ("Y", "out")],
             "dev": [("MNA", "nmos", "Y", "A", "VGND"), ("MNB", "nmos", "Y", "B", "VGND"),
                     ("MPA", "pmos", "n1", "A", "VPWR"), ("MPB", "pmos", "Y", "B", "n1")]},
    "buf": {"fn": "X = A (two inverters: n1 = !A, X = !n1)", "ports": [("A", "in"), ("X", "out")],
            "dev": [("MN1", "nmos", "n1", "A", "VGND"), ("MP1", "pmos", "n1", "A", "VPWR"),
                    ("MN2", "nmos", "X", "n1", "VGND"), ("MP2", "pmos", "X", "n1", "VPWR")]},
    "aoi21": {"fn": "Y = !((A1 & A2) | B1)", "ports": [("A1", "in"), ("A2", "in"), ("B1", "in"), ("Y", "out")],
              "dev": [("MNA1", "nmos", "Y", "A1", "n1"), ("MNA2", "nmos", "n1", "A2", "VGND"),
                      ("MNB", "nmos", "Y", "B1", "VGND"), ("MPA1", "pmos", "n2", "A1", "VPWR"),
                      ("MPA2", "pmos", "n2", "A2", "VPWR"), ("MPB", "pmos", "Y", "B1", "n2")]},
}


def skeleton(name, cell):
    lines = ["pdk sky130A", "param WN=0.52 WP=0.77 L=0.15 H=2.72", "",
             f"stdcell {name} width=<columns, your choice> height=H"]
    for (dn, kind, d, g, s) in cell["dev"]:
        lines.append(f"  device {dn} {kind} w={'WN' if kind == 'nmos' else 'WP'} l=L d={d} g={g} s={s}")
    lines.append("  <your geometry>")
    for (p, d) in cell["ports"]:
        lines.append(f"  port {p} {d} on=<a met1 shape>")
    lines.append("end")
    return "\n".join(lines)


def reference_spice(name, cell, pv):
    ports = [p for p, _ in cell["ports"]] + ["VPWR", "VGND"]
    out = [f"* independent reference for {name}", f".subckt {name} " + " ".join(ports)]
    for (dn, kind, d, g, s) in cell["dev"]:
        b = "VGND" if kind == "nmos" else "VPWR"
        model = "sky130_fd_pr__nfet_01v8" if kind == "nmos" else "sky130_fd_pr__pfet_01v8"
        w = pv["WN"] if kind == "nmos" else pv["WP"]
        out.append(f"X{dn} {d} {g} {s} {b} {model} w={w:g} l={pv['L']:g}")
    out += [".ends", ".end", ""]
    return "\n".join(out)


# ----------------------------------------------------------------------------- prompt
def system_prompt():
    agents = open(os.path.join(ROOT, "AGENTS.md")).read()
    keep = []
    for sec in re.split(r"(?m)^## ", agents):
        head = sec.split("\n", 1)[0]
        if head.startswith(("ICL", "The loop", "Common syntax", "Level 1", "Reading failures")) or sec.startswith("# ICL"):
            keep.append(sec if sec.startswith("#") else "## " + sec)
    example = open(os.path.join(ROOT, "examples", "l1_param_inv.icl")).read()
    example2 = open(os.path.join(ROOT, "examples", "l1_param_nand2.icl")).read() if PROMPT_V >= 2 else ""
    return f"""You are an expert full-custom layout engineer. You write SKY130 standard cells in ICL,
a layout language whose level-1 library ("stdcell" blocks) defines every shape relative to
other shapes. A tool checks your cell with magic DRC and netgen LVS and reports problems back.

{chr(10).join(keep)}

## Rules you will need (um)
poly width = L (gate length), poly spacing 0.21, poly endcap past diff 0.13 (cross ... ext=min);
diff extension past gate 0.25; licon 0.17 square, licon spacing 0.17, licon to gate 0.055;
diff enclosure of licon 0.04 (0.06 on one axis); poly enclosure of a poly contact 0.05 (0.08 one axis);
poly contact to diffusion 0.19; poly contact to psdm 0.11 (so >= 0.235 from p-diff);
npc encloses poly contacts by 0.1; li width/spacing 0.17, li encloses licon by 0.08 on one axis;
mcon 0.17, met1 encloses mcon by 0.03 (0.06 one axis), met1 min area 0.083 um2 (use by=0.06);
diff spacing 0.27 (also to the template taps); implant (nsdm/psdm) encloses diff by 0.125 and
nsdm/psdm must not overlap; n-well encloses p-diff by 0.18, n-diff stays 0.34 from n-well.
A diffusion region with two series gates and no contact between them needs only 0.21 (poly spacing)
between the gates; a contact between two gates needs L-to-L distance 0.055+0.17+0.055 = 0.28.

{METHOD if PROMPT_V >= 2 else ""}
## Worked example (clean for every parameter value in the sweep below)
```icl
{example}
```
{("## Second worked example (series stack + parallel devices, also clean over the whole sweep)" + chr(10) + "```icl" + chr(10) + example2 + "```") if example2 else ""}
{MISTAKES if PROMPT_V >= 2 else ""}

## What to produce
Return the COMPLETE .icl file in ONE ```icl code block: the `pdk` line, the given `param` line
unchanged, one `stdcell` block with the given `device` lines unchanged, your geometry, and
`port` statements putting every signal pin on a met1 shape. Use the parameters WN, WP, L, H in your
geometry so the cell stays DRC/LVS clean when they change. Keep comments short. Do not explain
outside the code block beyond one or two sentences."""


PROMPT_V = 1
METHOD = """## Standard-cell method (follow it)
1. One n-diffusion row just above the p-tap (`rect diff ... above=ptap`) and one p-diffusion row just
   below the n-tap (`below=ntap`), both centred in the cell. Each row is ONE rectangle holding all
   devices of that type side by side; neighbouring devices share a source/drain column.
2. Every gate is ONE vertical poly line crossing BOTH rows: `g = cross [nd, pd] poly w=L left=...`.
   Order the gates left to right so shared nodes sit between them. Two gates with a contact column
   between them need L-to-L spacing 0.28; with no contact between them (series node) 0.21 is enough.
3. Contact columns: `array licon in=nd left_of=g` / `right_of=g`, then `enclose ... li`.
   Source columns get `strap li from=<li> to=vgnd_li` (n row) or `to=vpwr_li` (p row).
4. Gate contacts sit in the gap between the rows, directly on their own gate line
   (`cx=g.cx`, or shifted by at most ~0.1 so neighbouring pads clear each other); the poly pad
   `enclose gc poly by=minx` MUST overlap its gate. Bottom = max(nd.top + 0.19, <n contact li>.top + 0.25).
5. Join drain columns of the same net with li straps when they line up vertically; otherwise give
   both strips the same `net=` and add `route <net> layers=m1`.
6. Every signal port: `contact mcon in=<li>` + `enclose ... m1 by=0.06 net=<name>` + `port ... on=`.
7. The template already has the n-well: only move its bottom edge with
   `well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)`. Never draw your own nwell, nsdm or psdm
   other than `enclose nd nsdm` / `enclose pd psdm`.
8. Internal nets (n1, n2...) that are not ports need no met1 pin.
"""
MISTAKES = """## Mistakes seen from other designers (avoid)
- Unknown keywords: rect/cross take left/right/cx/right_of/left_of/xspan and bottom/top/cy/above/below/yspan
  (no x=, y=, pos=). `strap` takes exactly one from= and one to=.
- A gate contact placed `left_of=<its own gate>` does not touch the gate -> floating gate, LVS mismatch.
- Diffusion rows placed side by side (`right_of=nd`) instead of the n row above the p-tap and the p row
  below the n-tap.
- Names must be defined before they are used.
"""


def task_prompt(name, cell):
    pts = "; ".join(f"WN={p['WN']} WP={p['WP']} L={p['L']} H={p['H']}" for p in SWEEP[-4:])
    return f"""Design the standard cell `{name}`: {cell['fn']}.
Ports: {', '.join(f'{p} ({d})' for p, d in cell['ports'])}; supplies VPWR/VGND come from the template rails.
Start from this skeleton (keep the param and device lines exactly):
```icl
{skeleton(name, cell)}
```
It will be checked at the nominal values and then swept over: WN in {{0.42, 0.52}}, WP in
{{0.42, 0.64, 0.77}}, L in {{0.15, 0.18, 0.25}} at H=2.72, plus taller cells: {pts}.
Pick `width` (in 0.46 um columns) large enough for L=0.25."""


def feedback(rep, pv):
    if rep.get("status") == "ERROR":
        return (f"The file did not compile (params {pv}):\nline {rep.get('line')}: {rep.get('error')}\n"
                f"hint: {rep.get('hint', '')}\nFix it and return the complete corrected file.")
    lines = [f"Check result at {pv}: {rep['status']}"]
    for w in rep.get("warnings", [])[:6]:
        if "fast pre-check" not in w:
            lines.append("WARNING " + w[:400])
    pre = rep.get("precheck", [])
    if pre:
        lines.append(f"fast rule pre-check ({len(pre)} issues, with the statements involved):")
        for v in pre[:12]:
            lines.append(f"  {v['rule']}: {v['msg']} at {v['box_um']} near {', '.join(v['objects'][:4])}")
    d = rep["drc"]
    lines.append(f"magic DRC: {d['violations']} violation(s)")
    for g in d["by_rule"][:8]:
        lines.append(f"  [{g['count']}x] {g['rule']}")
        for ex in g["examples"][:2]:
            objs = "; ".join(f"{k}:{'/'.join(v)}" for k, v in ex["objects"].items())
            lines.append(f"      at {ex['box_um']} near {objs}")
    if "lvs" in rep:
        l = rep["lvs"]
        lines.append(f"LVS vs reference: {'MATCH' if l['match'] else 'MISMATCH'} {l.get('result', '')} "
                     f"devices {l.get('devices_layout_vs_ref')} nets {l.get('nets_layout_vs_ref')}")
        nets = l.get("nets_layout_vs_ref") or [0, 0]
        if not l["match"] and nets[0] > nets[1]:
            lines.append(f"  -> the layout has {nets[0]} nets but the schematic {nets[1]}: some shapes that should "
                         "touch do not (gate pads not overlapping their gate, straps not reaching the strip, "
                         "a drain column not joined to its net).")
        if not l["match"] and nets[0] < nets[1]:
            lines.append("  -> fewer nets than the schematic: two different nets are shorted somewhere.")
        det = l.get("details", [])
        for i, x in enumerate(det):
            m = re.match(r"\s*Net: (a_\d+_\d+#)\s+\|\(no matching net\)", x)
            if m:
                fan = " ".join(det[i + 1:i + 3])
                lines.append(f"  -> unnamed layout node {m.group(1)} at ({int(m.group(1).split('_')[1]) / 200:.2f}, "
                             f"{int(m.group(1).split('_')[2].rstrip('#')) / 200:.2f}) um joins transistors "
                             f"({fan.split('|')[0].strip()}): a source/drain region between two gates has NO contact, "
                             "so those devices are in series. If they should not be in series (e.g. two inverters "
                             "sharing a supply column), put a contact column there and strap it to its net.")
                break
        lines += ["   | " + x for x in l.get("details", [])[:30]]
    lines.append("The attached image is your layout (DRC errors boxed in red). Return the complete corrected file.")
    return "\n".join(lines)


# ----------------------------------------------------------------------------- tools
def run_check(path, name, pv, out, ref_text):
    os.makedirs(out, exist_ok=True)
    ref = os.path.join(out, f"{name}.reference.spice")
    open(ref, "w").write(ref_text)
    cmd = [ICL, "check", path, "--top", name, "--json", "--out", out, "--ref", ref]
    if os.environ.get("ICL_WAIVE"):                 # tapless library cells: the row's tap cells meet the tap rules
        cmd += ["--waive", os.environ["ICL_WAIVE"]]
    for k, v in pv.items():
        cmd += ["--param", f"{k}={v}"]
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
    try:
        return json.loads(p.stdout)
    except json.JSONDecodeError:
        return {"status": "ERROR", "error": "tool crashed: " + (p.stderr[-800:] or p.stdout[-800:]), "line": 0}


def extract_icl(text):
    blocks = re.findall(r"```(?:icl|ICL)?[^\n]*\n(.*?)```", text, re.S)
    blocks = [b for b in blocks if "stdcell" in b]
    return blocks[-1].strip() + "\n" if blocks else None


def image_part(path):
    if not path or not path.endswith(".png") or not os.path.exists(path):
        return None
    b64 = base64.b64encode(open(path, "rb").read()).decode()
    return {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{b64}"}}


def load_key():
    k = os.environ.get("OPENROUTER_API_KEY")
    if not k:
        for line in open(os.path.expanduser("~/.bashrc")):
            m = re.match(r"\s*export\s+OPENROUTER_API_KEY=[\"']?([^\"'\s]+)", line)
            if m:
                k = m.group(1)
    if not k:
        sys.exit("no OPENROUTER_API_KEY")
    return k


class Budget(Exception):
    pass


class LLM:
    def __init__(self, key, model, cap, log):
        self.key, self.model, self.cap, self.log = key, model, cap, log
        self.calls = 0
        self.check_free()

    def check_free(self):
        data = json.load(urllib.request.urlopen(f"{API}/models", timeout=60))["data"]
        m = next((x for x in data if x["id"] == self.model), None)
        if m is None:
            sys.exit(f"model {self.model} not found on OpenRouter")
        price = {k: float(v) for k, v in m["pricing"].items() if re.match(r"^[0-9.eE+-]+$", str(v))}
        if not self.model.endswith(":free") or any(v != 0 for v in price.values()):
            sys.exit(f"refusing to use {self.model}: it is not a free model ({price})")
        self.info = {"id": m["id"], "context": m.get("context_length"),
                     "inputs": m.get("architecture", {}).get("input_modalities")}

    def chat(self, messages, max_tokens=16000, reasoning=6000, _retry=True):
        if self.calls >= self.cap:
            raise Budget(f"call cap {self.cap} reached")
        body = json.dumps({"model": self.model, "messages": messages, "temperature": getattr(self, "temperature", 0.2),
                           "max_tokens": max_tokens, "reasoning": {"max_tokens": reasoning}}).encode()
        waits = [15, 45, 90, 180]
        for attempt in range(len(waits) + 1):
            req = urllib.request.Request(f"{API}/chat/completions", data=body, headers={
                "Authorization": f"Bearer {self.key}", "Content-Type": "application/json",
                "X-Title": "icl-stdcell-experiment"})
            t0 = time.time()
            try:
                resp = json.load(urllib.request.urlopen(req, timeout=600))
                self.calls += 1
                if "error" in resp:
                    raise RuntimeError(str(resp["error"])[:300])
                ch = resp["choices"][0]
                txt = ch["message"].get("content") or ""
                self.log({"call": self.calls, "seconds": round(time.time() - t0, 1), "usage": resp.get("usage"),
                          "provider": resp.get("provider"), "finish": ch.get("finish_reason"), "chars": len(txt)})
                if not txt.strip() and _retry:
                    # the model spent its budget thinking: ask again with a smaller reasoning budget
                    return self.chat(messages, max_tokens, reasoning // 2, _retry=False)
                return txt
            except urllib.error.HTTPError as e:
                detail = e.read().decode(errors="replace")[:400]
                if e.code == 429 and ("per-day" in detail or "per day" in detail):
                    raise Budget("free-model daily limit reached: " + detail)
                if e.code in (429, 500, 502, 503, 504) and attempt < len(waits):
                    self.log({"retry": attempt, "http": e.code, "detail": detail[:200]})
                    time.sleep(waits[attempt])
                    continue
                raise RuntimeError(f"HTTP {e.code}: {detail}")
            except (urllib.error.URLError, TimeoutError, RuntimeError) as e:
                if attempt < len(waits):
                    self.log({"retry": attempt, "error": str(e)[:200]})
                    time.sleep(waits[attempt])
                    continue
                raise


# ----------------------------------------------------------------------------- experiment
def sweep(path, name, cell, out):
    res = []
    for i, pv in enumerate(SWEEP):
        rep = run_check(path, name, pv, os.path.join(out, f"sweep{i:02d}"), reference_spice(name, cell, pv))
        first = ""
        if rep.get("status") == "ERROR":
            first = f"compile: {rep.get('error', '')[:160]}"
        elif rep.get("status") != "CLEAN":
            r = rep["drc"]["by_rule"]
            first = (f"DRC {r[0]['rule']} x{r[0]['count']}" if r else "") + \
                    ("" if rep.get("lvs", {}).get("match", True) else " LVS mismatch")
        res.append({"params": pv, "status": rep.get("status"), "first_problem": first,
                    "drc": rep.get("drc", {}).get("violations"), "lvs": rep.get("lvs", {}).get("match")})
    return res


def design_cell(llm, name, cell, run_dir, attempts, robust_rounds, use_images):
    out = os.path.join(run_dir, name)
    os.makedirs(out, exist_ok=True)
    msgs = [{"role": "system", "content": system_prompt()}, {"role": "user", "content": task_prompt(name, cell)}]
    hist = []
    path = os.path.join(out, f"{name}.icl")
    clean, rep = False, {}
    for k in range(1, attempts + 1):
        reply = llm.chat(msgs)
        open(os.path.join(out, f"reply{k}.md"), "w").write(reply)
        code = extract_icl(reply)
        msgs.append({"role": "assistant", "content": reply})
        if code is None:
            hist.append({"attempt": k, "status": "NO_CODE"})
            msgs.append({"role": "user", "content": "I could not find an ```icl code block with a stdcell. "
                                                    "Return the complete file in one ```icl block."})
            continue
        open(os.path.join(out, f"attempt{k}.icl"), "w").write(code)
        open(path, "w").write(code)
        rep = run_check(path, name, NOMINAL, os.path.join(out, f"check{k}"), reference_spice(name, cell, NOMINAL))
        json.dump(rep, open(os.path.join(out, f"check{k}.json"), "w"), indent=1, default=str)
        hist.append({"attempt": k, "status": rep.get("status"), "drc": rep.get("drc", {}).get("violations"),
                     "lvs": rep.get("lvs", {}).get("match"), "error": rep.get("error")})
        print(f"  {name} attempt {k}: {rep.get('status')} drc={rep.get('drc', {}).get('violations')} "
              f"lvs={rep.get('lvs', {}).get('match')} {('- ' + rep['error'][:100]) if rep.get('error') else ''}", flush=True)
        if rep.get("status") == "CLEAN":
            clean = True
            break
        content = [{"type": "text", "text": feedback(rep, NOMINAL)}]
        img = image_part(rep.get("image")) if use_images else None
        if img:
            content.append(img)
        msgs.append({"role": "user", "content": content if img else content[0]["text"]})
    result = {"cell": name, "attempts": hist, "nominal_clean": clean, "calls_so_far": llm.calls}
    if not clean:
        return result
    sw = sweep(path, name, cell, os.path.join(out, "sweep_r0"))
    result["sweep"] = [sw]
    print(f"  {name} sweep: {sum(r['status'] == 'CLEAN' for r in sw)}/{len(sw)} clean", flush=True)
    for rr in range(1, robust_rounds + 1):
        bad = [r for r in sw if r["status"] != "CLEAN"]
        if not bad:
            break
        txt = ["Your cell is clean at the nominal parameters but fails at these sweep points:"]
        for r in bad[:14]:
            txt.append(f"  {r['params']}: {r['status']} {r['first_problem']}")
        txt.append("Make the geometry follow the parameters (positions derived from other shapes, max(...) "
                   "where two rules compete, `well y=` between the diffusions, enough `width`). If a point "
                   "cannot fit in that height with single-finger devices you may fold devices, but keep the "
                   "device lines unchanged. Return the complete corrected file.")
        msgs.append({"role": "user", "content": "\n".join(txt)})
        reply = llm.chat(msgs)
        open(os.path.join(out, f"robust{rr}.md"), "w").write(reply)
        msgs.append({"role": "assistant", "content": reply})
        code = extract_icl(reply)
        if code is None:
            break
        p2 = os.path.join(out, f"{name}_r{rr}.icl")
        open(p2, "w").write(code)
        rep2 = run_check(p2, name, NOMINAL, os.path.join(out, f"robust{rr}_check"), reference_spice(name, cell, NOMINAL))
        if rep2.get("status") != "CLEAN":
            print(f"  {name} robustness round {rr}: revised cell not clean at nominal ({rep2.get('status')})", flush=True)
            result.setdefault("robust_rounds", []).append({"round": rr, "nominal": rep2.get("status")})
            break
        sw = sweep(p2, name, cell, os.path.join(out, f"sweep_r{rr}"))
        result["sweep"].append(sw)
        result.setdefault("robust_rounds", []).append({"round": rr, "nominal": "CLEAN",
                                                       "sweep_clean": sum(r["status"] == "CLEAN" for r in sw)})
        print(f"  {name} robustness round {rr} sweep: {sum(r['status'] == 'CLEAN' for r in sw)}/{len(sw)} clean", flush=True)
    result["calls_so_far"] = llm.calls
    return result


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", default="nvidia/nemotron-3.5-super-vl:free")
    ap.add_argument("--cells", default="nand2,nor2,buf,aoi21")
    ap.add_argument("--attempts", type=int, default=4)
    ap.add_argument("--robust-rounds", type=int, default=1)
    ap.add_argument("--max-calls", type=int, default=30)
    ap.add_argument("--no-images", action="store_true")
    ap.add_argument("--prompt", type=int, default=2, help="1 = reference + one example; 2 = + method, 2nd example, mistakes")
    args = ap.parse_args()
    global PROMPT_V
    PROMPT_V = args.prompt
    run_dir = os.path.join(ROOT, "agents", "runs", datetime.datetime.now().strftime("%Y%m%d-%H%M%S"))
    os.makedirs(run_dir, exist_ok=True)
    logf = open(os.path.join(run_dir, "api_log.jsonl"), "a")

    def log(rec):
        logf.write(json.dumps(rec) + "\n")
        logf.flush()
    llm = LLM(load_key(), args.model, args.max_calls, log)
    print(f"model {llm.info} -> {run_dir}", flush=True)
    summary = {"model": llm.info, "prompt_version": PROMPT_V, "nominal": NOMINAL, "sweep_points": SWEEP, "cells": []}
    for name in args.cells.split(","):
        print(f"== {name}", flush=True)
        try:
            r = design_cell(llm, name, CELLS[name], run_dir, args.attempts, args.robust_rounds, not args.no_images)
        except Budget as e:
            print(f"  stopped: {e}", flush=True)
            summary["stopped"] = str(e)
            break
        summary["cells"].append(r)
        json.dump(summary, open(os.path.join(run_dir, "summary.json"), "w"), indent=1, default=str)
    summary["api_calls"] = llm.calls
    json.dump(summary, open(os.path.join(run_dir, "summary.json"), "w"), indent=1, default=str)
    print(f"done: {llm.calls} API calls; {run_dir}/summary.json", flush=True)


if __name__ == "__main__":
    main()
