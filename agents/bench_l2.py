#!/usr/bin/env python3
"""Level-2 benchmark runner: a free model assembles analog blocks from PCells (bench/l2_cells.json).

Every cell: model writes a parametric `cell` -> magic DRC + netgen LVS against an independent
reference (matching dummies ignored) + the geometric constraint judge (bench/l2_judge.py) at the
nominal point -> feedback -> ... -> once clean, the 4-point sweep (L x2, minimum L, widths x2).

Flags as in agents/bench_harness.py: --feedback basic|ranked, --images none|full, --keep-best,
--lessons FILE, --examples K (verified reference cells, leave-one-out).
Only zero-priced OpenRouter models are accepted.
"""
from __future__ import annotations

import argparse
import concurrent.futures as cf
import datetime
import json
import os
import re
import sys
import threading

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, "bench"))
import nemotron_stdcells as NS  # noqa: E402  (LLM client, key loading)
import l2_common as C  # noqa: E402
import feedback_l2 as FB  # noqa: E402

LOCK = threading.Lock()
REFDIR = os.path.join(ROOT, "bench", "l2_ref")


def log(s):
    with LOCK:
        print(s, flush=True)


def extract_icl(text):
    blocks = re.findall(r"```(?:icl|ICL)?[^\n]*\n(.*?)```", text, re.S)
    blocks = [b for b in blocks if re.search(r"(?m)^\s*cell\s+\w+", b)]
    return blocks[-1].strip() + "\n" if blocks else None


# ----------------------------------------------------------------------------- prompts
def system_prompt(lessons=""):
    agents = open(os.path.join(ROOT, "AGENTS.md")).read()
    keep = []
    for sec in re.split(r"(?m)^## ", agents):
        head = sec.split("\n", 1)[0]
        if sec.startswith("# ICL") or head.startswith(("Common syntax", "Level 2", "Level 4", "Reading failures")):
            keep.append(sec if sec.startswith("#") else "## " + sec)
    ex = open(os.path.join(HERE, "l2", "example_pdp.icl")).read()
    s = f"""You are an expert analog layout engineer. You lay out SKY130 analog blocks in ICL, a layout
language whose level-2 library ("cell" blocks) builds transistors as parametric cells (PCells) and
lets you arrange them with placement relations and matching patterns; a router connects the nets
under the constraints you give. A tool checks the result with magic DRC, netgen LVS against an
independent reference netlist, and a judge that measures the constraints on the drawn geometry
(finger positions, wire widths and distances) - writing a pattern statement is not enough, the
geometry must satisfy it.

{chr(10).join(keep)}

## Method for analog cells
1. Keep every device line exactly as given (w is per finger, nf fingers).
2. Matching first: put matched devices into ONE pattern object (`interdigitate A B pattern=ABBA
   dummies=1 name=X`, or `common_centroid A B pattern=AB/BA dummies=1 name=X`). Devices in a pattern
   need the same type, w and l; each letter is one finger, so A must appear nf(A) times. Ratios
   (1:2) are done with more fingers, e.g. A x2, B x4: `interdigitate A B pattern=ABBBBA`.
3. Then place objects relative to each other: `place X at=(0,0)`, `place Y above=X align=center`,
   `pair A B axis=X.cx above=Y` (mirror image), `gap=min` is the default.
4. Body ties: nmos need a ptap (`tap TP kind=ptap net=VGND cols=N` + place, or a ptap guardring);
   every pmos n-well needs an ntap (tap or ntap guardring).
5. Routing intent: `route NET width=0.4`, `route NET avoid=OTHER:0.6`, `route A B symmetric axis=...`.
6. Ports: `port NAME in|out side=left|right|top|bottom` as given, `port VPWR power`, `port VGND ground`.

## Worked example (clean for every parameter value of the sweep)
```icl
{ex}```

## What to produce
Return the COMPLETE .icl file in ONE ```icl code block: the `pdk` line, the given `param` line
unchanged, one `cell` block with the given ports and device lines unchanged, your patterns,
placement, taps and routing. Use the parameters W and L only through the device lines. Do not explain
outside the code block beyond one or two sentences."""
    if lessons:
        s += "\n\n" + open(lessons).read()
    return s


def describe(c):
    t = c["type"]
    if t == "interdigitated":
        return (f"{' and '.join(c['devices'])} interdigitated: all their fingers in ONE row, alternating, with "
                f"equal centroids (ABBA-like)")
    if t == "common_centroid":
        return f"{', '.join(c['devices'])} on a common centroid: the centroids of their fingers coincide"
    if t == "mirror_symmetric":
        return ("mirror symmetry about ONE vertical axis for the pairs " +
                ", ".join(f"{a}/{b}" for a, b in c["pairs"]))
    if t == "guard_ring":
        return f"a closed {c['kind']} guard ring around {', '.join(c['devices'])}"
    if t == "route_width":
        return f"net {c['net']} routed with wires at least {c['min']} um wide (narrow necks at pins are fine)"
    if t == "spacing":
        return f"routed wires of {c['nets'][0]} and {c['nets'][1]} at least {c['min']} um apart"
    if t == "maxres":
        return f"net {c['net']}: worst pin-to-pin resistance at most {c['max']} ohm"
    if t == "area":
        mx = c["max"]
        if isinstance(mx, dict):
            return "cell area (bounding box) within the budget: " + ", ".join(f"{k}: {v} um2" for k, v in mx.items())
        return f"cell area (bounding box) at most {mx} um2"
    if t == "route_symmetric":
        return f"the routing of {c['nets'][1]} is the mirror image of the routing of {c['nets'][0]}"
    return json.dumps(c)


def skeleton(cell):
    pl = " ".join(f"{k}={v}" for k, v in cell["params"].items())
    lines = ["pdk sky130A", f"param {pl}", "", f"cell {cell['name']}"]
    for p in cell["ports"]:
        lines.append(f"  port {p['name']} {p['dir']}" + (f" side={p['side']}" if p.get("side") else ""))
    lines.append("")
    for d in cell["devices"]:
        nf = f" nf={d['nf']}" if d["nf"] > 1 else ""
        lines.append(f"  {d['kind']} {d['name']} w={d['w']} l={d['l']}{nf} d={d['d']} g={d['g']} s={d['s']}")
    lines += ["", "  <patterns, placement, taps, routing>", "end"]
    return "\n".join(lines)


def task_prompt(cell, extra=""):
    pts = "; ".join(", ".join(f"{k}={v}" for k, v in C.point_params(cell, p).items()) for p in C.BENCH["sweep"][1:])
    cons = "\n".join(f"  {i + 1}. {describe(c)}" for i, c in enumerate(cell["constraints"]))
    return f"""Lay out the analog cell `{cell['name']}`: {cell['function']}.
```icl
{skeleton(cell)}
```
Layout constraints (measured on the drawn geometry):
{cons}
It is checked at the nominal parameters and then at: {pts}.{extra}"""


def retrieved(cell, k):
    """k most similar verified reference cells, leave-one-out."""
    def feat(c):
        return (len(c["devices"]), {x["type"] for x in c["constraints"]}, c["tier"])
    f0 = feat(cell)

    def dist(c):
        f = feat(c)
        return abs(f[0] - f0[0]) + 2 * len(f[1] ^ f0[1]) + 0.5 * abs(f[2] - f0[2])
    near = sorted([c for c in C.BENCH["cells"] if c["name"] != cell["name"]], key=dist)[:k]
    out = ""
    for c in near:
        p = os.path.join(REFDIR, f"{c['name']}.icl")
        if os.path.exists(p):
            out += (f"\n\nVerified example `{c['name']}` ({c['function']}; constraints: "
                    f"{'; '.join(describe(x) for x in c['constraints'])}) - clean over the whole sweep:\n"
                    f"```icl\n{open(p).read()}```")
    return out


# ----------------------------------------------------------------------------- one cell
class CellRun:
    def __init__(self, cell, args, llm, run_dir):
        self.cell, self.args, self.llm = cell, args, llm
        self.out = os.path.join(run_dir, cell["name"])
        os.makedirs(self.out, exist_ok=True)
        self.res = {"cell": cell["name"], "tier": cell["tier"], "attempts": [], "nominal_clean": False}

    @staticmethod
    def score(rep):
        if rep.get("status") == "CLEAN":
            return 0
        if rep.get("status") == "ERROR":
            return 10 ** 6
        drc = rep.get("drc", {}).get("violations", 999)
        lvs = rep.get("lvs", {}).get("match", False)
        bad = sum(1 for r in rep.get("judge", {}).get("results", []) if not r["ok"])
        return drc + (0 if lvs else 5000) + 300 * bad

    def check(self, path, pv, sub):
        return C.run_check(path, self.cell, pv, os.path.join(self.out, sub))

    def run(self):
        cell, args = self.cell, self.args
        extra = retrieved(cell, args.examples) if args.examples else ""
        first = task_prompt(cell, extra)
        msgs = [{"role": "system", "content": system_prompt(args.lessons)}, {"role": "user", "content": first}]
        open(os.path.join(self.out, "prompt.md"), "w").write(first)
        best = (None, None, None)
        prev_code = None
        nom = C.nominal(cell)
        for k in range(1, args.attempts + 1):
            reply = self.llm.chat(msgs)
            open(os.path.join(self.out, f"reply{k}.md"), "w").write(reply)
            msgs.append({"role": "assistant", "content": reply})
            code = extract_icl(reply)
            if code is None:
                self.res["attempts"].append({"k": k, "status": "NO_CODE"})
                msgs.append({"role": "user", "content": "No ```icl block with a `cell` found. Return the complete file."})
                continue
            path = os.path.join(self.out, f"attempt{k}.icl")
            open(path, "w").write(code)
            rep = self.check(path, nom, f"check{k}")
            json.dump(rep, open(os.path.join(self.out, f"check{k}.json"), "w"), indent=1, default=str)
            sc = self.score(rep)
            nbad = sum(1 for r in rep.get("judge", {}).get("results", []) if not r["ok"])
            self.res["attempts"].append({"k": k, "status": rep.get("status"), "drc": rep.get("drc", {}).get("violations"),
                                         "lvs": rep.get("lvs", {}).get("match"), "constraints_failed": nbad,
                                         "score": sc, "error": (rep.get("error") or "")[:160]})
            log(f"  {cell['name']:10s} attempt {k}: {rep.get('status')} drc={rep.get('drc', {}).get('violations')} "
                f"lvs={rep.get('lvs', {}).get('match')} cons_failed={nbad} {(rep.get('error') or '')[:80]}")
            regressed = best[0] is not None and sc > best[0]
            if best[0] is None or sc <= best[0]:
                best = (sc, code, rep)
            if sc == 0:
                self.res["nominal_clean"] = True
                self.res["clean_at"] = k
                break
            fb = FB.make(rep, nom, args.feedback, code, prev_code, cell)
            prev_code = code
            if args.keep_best and regressed:
                fb = (f"Your last change made things worse (score {sc} vs best {best[0]}). Here is your BEST version "
                      f"so far - continue from it:\n```icl\n{best[1]}```\nIts check result:\n"
                      + FB.make(best[2], nom, args.feedback, best[1], None, cell))
                prev_code = best[1]
            open(os.path.join(self.out, f"feedback{k}.md"), "w").write(fb)
            imgs = []
            if args.images == "full":
                p = NS.image_part((best[2] if (args.keep_best and regressed) else rep).get("image"))
                imgs = [p] if p else []
            msgs.append({"role": "user", "content": ([{"type": "text", "text": fb}] + imgs) if imgs else fb})
        self.res["calls"] = len(self.res["attempts"])
        if not self.res["nominal_clean"]:
            return self.res
        final = os.path.join(self.out, f"{cell['name']}_final.icl")
        open(final, "w").write(best[1])
        sw = self.sweep(final, "sweep0", first_rep=best[2])
        self.res["sweep"] = [sw]
        log(f"  {cell['name']:10s} sweep: {sum(r['clean'] for r in sw)}/{len(sw)}")
        for rr in range(1, args.robust_rounds + 1):
            bad = [r for r in sw if not r["clean"]]
            if not bad:
                break
            txt = ["Clean at the nominal point, but these sweep points fail:"]
            txt += [f"  {r['params']}: {r['problem']}" for r in bad]
            txt.append("Make the layout follow the parameters (relative placement, gap=min, taps sized for the "
                       "widest case). Return the complete file.")
            msgs.append({"role": "user", "content": "\n".join(txt)})
            reply = self.llm.chat(msgs)
            msgs.append({"role": "assistant", "content": reply})
            code = extract_icl(reply)
            if not code:
                break
            p2 = os.path.join(self.out, f"{cell['name']}_r{rr}.icl")
            open(p2, "w").write(code)
            rep2 = self.check(p2, nom, f"robust{rr}")
            if rep2.get("status") != "CLEAN":
                log(f"  {cell['name']:10s} robust round {rr}: nominal broke ({rep2.get('status')})")
                break
            sw2 = self.sweep(p2, f"sweep{rr}", first_rep=rep2)
            log(f"  {cell['name']:10s} robust round {rr} sweep: {sum(r['clean'] for r in sw2)}/{len(sw2)}")
            if sum(r["clean"] for r in sw2) >= sum(r["clean"] for r in sw):
                sw, final = sw2, p2
            self.res["sweep"].append(sw2)
        self.res["final"] = final
        self.res["sweep_best"] = sum(r["clean"] for r in sw)
        return self.res

    def sweep(self, path, sub, first_rep=None):
        out = []
        for i, pt in enumerate(C.BENCH["sweep"]):
            pv = C.point_params(self.cell, pt)
            rep = first_rep if (i == 0 and first_rep is not None) else self.check(path, pv, f"{sub}/p{i}")
            prob = ""
            if rep.get("status") == "ERROR":
                prob = "compile: " + (rep.get("error") or "")[:160]
            elif rep.get("status") != "CLEAN":
                r = rep["drc"]["by_rule"]
                prob = (f"DRC {r[0]['rule']} x{r[0]['count']}" if r else "") + \
                       ("" if rep.get("lvs", {}).get("match", True) else " LVS mismatch") + \
                       "".join(f"; constraint failed: {x['detail'][:120]}"
                               for x in rep.get("judge", {}).get("results", []) if not x["ok"])
            out.append({"params": pv, "clean": rep.get("status") == "CLEAN", "problem": prob,
                        "size_um": rep.get("size_um")})
        return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", default="nvidia/nemotron-3.5-super-vl:free")
    ap.add_argument("--cells", default="")
    ap.add_argument("--tiers", default="1,2,3,4")
    ap.add_argument("--attempts", type=int, default=5)
    ap.add_argument("--robust-rounds", type=int, default=1)
    ap.add_argument("--max-calls", type=int, default=150)
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--feedback", default="ranked", choices=["basic", "ranked"])
    ap.add_argument("--images", default="full", choices=["none", "full"])
    ap.add_argument("--keep-best", action="store_true")
    ap.add_argument("--lessons", default="")
    ap.add_argument("--examples", type=int, default=0)
    ap.add_argument("--tag", default="")
    ap.add_argument("--temperature", type=float, default=0.2)
    args = ap.parse_args()
    tiers = {int(t) for t in args.tiers.split(",")}
    cells = [c for c in C.BENCH["cells"] if c["tier"] in tiers and (not args.cells or c["name"] in args.cells.split(","))]
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S") + "-L2" + (f"-{args.tag}" if args.tag else "")
    run_dir = os.path.join(ROOT, "agents", "bench_runs", stamp)
    os.makedirs(run_dir, exist_ok=True)
    logf = open(os.path.join(run_dir, "api_log.jsonl"), "a")

    def apilog(rec):
        with LOCK:
            logf.write(json.dumps(rec) + "\n")
            logf.flush()
    llm = NS.LLM(NS.load_key(), args.model, args.max_calls, apilog)
    llm.temperature = args.temperature
    cfg = dict(vars(args), task="l2")
    json.dump(cfg, open(os.path.join(run_dir, "config.json"), "w"), indent=1)
    log(f"run {stamp}: {len(cells)} cells, model {llm.info['id']}, config {cfg}")
    results = []
    with cf.ThreadPoolExecutor(max_workers=args.workers) as ex:
        futs = {ex.submit(CellRun(c, args, llm, run_dir).run): c for c in sorted(cells, key=lambda c: c["tier"])}
        for f in cf.as_completed(futs):
            c = futs[f]
            try:
                r = f.result()
            except NS.Budget as e:
                r = {"cell": c["name"], "tier": c["tier"], "error": f"budget: {e}", "nominal_clean": False, "attempts": []}
            except Exception as e:  # keep the run going
                r = {"cell": c["name"], "tier": c["tier"], "error": repr(e)[:300], "nominal_clean": False, "attempts": []}
                log(f"  {c['name']} crashed: {e!r}")
            results.append(r)
            json.dump({"config": cfg, "results": results, "api_calls": llm.calls},
                      open(os.path.join(run_dir, "results.json"), "w"), indent=1, default=str)
    log(f"done: {llm.calls} calls -> {run_dir}/results.json")


if __name__ == "__main__":
    main()
