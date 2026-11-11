#!/usr/bin/env python3
"""Benchmark runner: a free model writes the level-1 standard cells in bench/cells.json.

Every cell: model writes a parametric stdcell -> magic DRC + netgen LVS against the benchmark
netlist at the nominal point -> feedback -> ... -> once clean, the 6-point sweep (L, width scale,
cell height) is checked locally; optional robustness rounds.

Techniques are switched with flags so their effect can be measured:
  --feedback basic|ranked     ranked = root causes grouped by statement + numeric fix hints
  --images none|full|crop     crop = zoomed, labelled crops around the first errors
  --keep-best                 continue from the best attempt so far, report regressions
  --lessons FILE              extra guidance written by a coach (appended to the system prompt)
  --draft                     give the model an algorithmic first draft to iterate on
  --examples K                retrieve the K closest verified cells as extra examples
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
import nemotron_stdcells as NS  # noqa: E402  (LLM client, key loading, checks, helpers)

BENCH = json.load(open(os.environ.get("ICL_BENCH") or os.path.join(ROOT, "bench", "cells.json")))
TAPLESS = BENCH.get("taps") is False          # library conventions: tapless cells, bodies VNB / VPB
if BENCH.get("waive"):
    os.environ.setdefault("ICL_WAIVE", BENCH["waive"])
LOCK = threading.Lock()


# ----------------------------------------------------------------------------- spec helpers
def point_params(cell, pt):
    pv = {"L": pt["L"], "H": pt["H"]}
    for k, w in cell["params"].items():
        pv[k] = max(0.42, round(w * pt["wscale"] * 100) / 100)
    return pv


def nominal(cell):
    return point_params(cell, BENCH["sweep"][0])


def reference_spice(cell, pv):
    ports = cell["inputs"] + cell["outputs"] + ["VPWR", "VGND"]
    out = [f"* benchmark reference for {cell['name']} ({cell['hd_cell']})", f".subckt {cell['name']} " + " ".join(ports)]
    for d in cell["devices"]:
        b = ("VNB" if d["kind"] == "nmos" else "VPB") if TAPLESS else ("VGND" if d["kind"] == "nmos" else "VPWR")
        model = "sky130_fd_pr__nfet_01v8" if d["kind"] == "nmos" else "sky130_fd_pr__pfet_01v8"
        out.append(f"X{d['name']} {d['d']} {d['g']} {d['s']} {b} {model} w={pv[d['wparam']]:g} l={pv['L']:g}")
    return "\n".join(out + [".ends", ".end", ""])


def skeleton(cell):
    pl = " ".join(f"{k}={v}" for k, v in cell["params"].items())
    taps = " taps=no" if TAPLESS else ""
    lines = ["pdk sky130A", f"param {pl} L=0.15 H=2.72", "",
             f"stdcell {cell['name']} width=<columns, your choice> height=H{taps}"]
    for d in cell["devices"]:
        b = (" b=VNB" if d["kind"] == "nmos" else " b=VPB") if TAPLESS else ""
        lines.append(f"  device {d['name']} {d['kind']} w={d['wparam']} l=L d={d['d']} g={d['g']} s={d['s']}{b}")
    lines.append("  <your geometry>")
    for p in cell["inputs"]:
        lines.append(f"  port {p} in on=<a met1 shape>")
    for p in cell["outputs"]:
        lines.append(f"  port {p} out on=<a met1 shape>")
    lines.append("end")
    return "\n".join(lines)


def task_prompt(cell, extra=""):
    pts = "; ".join(f"L={p['L']} widths x{p['wscale']} H={p['H']}" for p in BENCH["sweep"][1:])
    nets = ", ".join(cell["internal_nets"]) or "none"
    return f"""Design the standard cell `{cell['name']}`: {cell['function']}.
Inputs: {', '.join(cell['inputs'])}; output: {', '.join(cell['outputs'])}; internal nets: {nets}.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
{skeleton(cell)}
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
{pts}. Choose `width` (0.46 um columns) large enough for L=0.25.{extra}"""


# ----------------------------------------------------------------------------- one cell
class CellRun:
    def __init__(self, cell, args, llm, run_dir, library):
        self.cell, self.args, self.llm = cell, args, llm
        self.out = os.path.join(run_dir, cell["name"])
        os.makedirs(self.out, exist_ok=True)
        self.library = library
        self.res = {"cell": cell["name"], "tier": cell["tier"], "attempts": [], "nominal_clean": False}

    def check(self, path, pv, sub):
        rep = NS.run_check(path, self.cell["name"], pv, os.path.join(self.out, sub), reference_spice(self.cell, pv))
        return rep

    @staticmethod
    def score(rep):
        """Lower is better: compile error > LVS fail > DRC count."""
        if rep.get("status") == "CLEAN":
            return 0
        if rep.get("status") == "ERROR":
            return 10 ** 6
        drc = rep.get("drc", {}).get("violations", 999)
        lvs = rep.get("lvs", {}).get("match", False)
        return drc + (0 if lvs else 5000)

    def system(self):
        s = NS.system_prompt()
        if self.args.lessons:
            s += "\n\n" + open(self.args.lessons).read()
        return s

    def run(self):
        import feedback as FB
        cell, args = self.cell, self.args
        extra = ""
        if args.examples and self.library:
            extra += FB.retrieved_examples(cell, self.library, args.examples)
        draft = None
        if args.draft:
            import sticks
            draft = sticks.draft_file(cell)
            extra += ("\n\nAn automatic generator produced this first draft (it may be imperfect - check, keep "
                      "what works, change what does not):\n```icl\n" + draft + "```")
        first = task_prompt(cell, extra)
        first_imgs = []
        if args.task == "repair":
            import tasks
            idx = [c["name"] for c in BENCH["cells"]].index(cell["name"])
            kind, broken, desc, _ = tasks.repair_case(cell, idx)
            self.res["mutation"] = kind
            bp = os.path.join(self.out, "broken.icl")
            open(bp, "w").write(broken)
            rep0 = self.check(bp, nominal(cell), "check0")
            self.res["broken_status"] = rep0.get("status")
            first += ("\n\nThis layout of the cell was DRC and LVS clean over the whole sweep until ONE edit broke it. "
                      "Find the problem and fix it (keep everything else):\n```icl\n" + broken + "```\n"
                      "Its check report:\n" + FB.make(rep0, nominal(cell), args.feedback, broken))
            first_imgs = FB.images(rep0, args.images, self.out, 0)
        if args.resume:
            prev = self.previous_best(args.resume)
            if prev is None:
                self.res.update({"skipped": "clean in the resumed run", "nominal_clean": True})
                return self.res
            pcode, prep = prev
            note = ""
            cf_ = os.path.join(args.coach_dir, cell["name"] + ".md") if args.coach_dir else ""
            if cf_ and os.path.exists(cf_):
                note = open(cf_).read().strip()
                self.res["coached"] = True
            first += ("\n\nYour best attempt so far:\n```icl\n" + pcode + "```\nIts check report:\n" +
                      FB.make(prep, nominal(cell), "ranked", pcode))
            if note:
                first += "\n\nNOTES FROM A SENIOR LAYOUT ENGINEER WHO REVIEWED THIS ATTEMPT (follow them):\n" + note
            first_imgs = FB.images(prep, args.images, self.out, 0)
        msgs = [{"role": "system", "content": self.system()},
                {"role": "user", "content": ([{"type": "text", "text": first}] + first_imgs) if first_imgs else first}]
        open(os.path.join(self.out, "prompt.md"), "w").write(first)
        best = (None, None, None)          # (score, code, report)
        path = os.path.join(self.out, f"{cell['name']}.icl")
        prev_code = None
        for k in range(1, args.attempts + 1):
            reply = self.llm.chat(msgs)
            open(os.path.join(self.out, f"reply{k}.md"), "w").write(reply)
            msgs.append({"role": "assistant", "content": reply})
            code = NS.extract_icl(reply)
            if code is None:
                self.res["attempts"].append({"k": k, "status": "NO_CODE"})
                msgs.append({"role": "user", "content": "No ```icl block with a stdcell found. Return the complete file."})
                continue
            open(os.path.join(self.out, f"attempt{k}.icl"), "w").write(code)
            open(path, "w").write(code)
            rep = self.check(path, nominal(cell), f"check{k}")
            json.dump(rep, open(os.path.join(self.out, f"check{k}.json"), "w"), indent=1, default=str)
            sc = self.score(rep)
            self.res["attempts"].append({"k": k, "status": rep.get("status"), "drc": rep.get("drc", {}).get("violations"),
                                         "lvs": rep.get("lvs", {}).get("match"), "score": sc,
                                         "error": (rep.get("error") or "")[:160]})
            log(f"  {cell['name']:7s} attempt {k}: {rep.get('status')} drc={rep.get('drc', {}).get('violations')} "
                f"lvs={rep.get('lvs', {}).get('match')} {(rep.get('error') or '')[:90]}")
            regressed = best[0] is not None and sc > best[0]
            if best[0] is None or sc <= best[0]:
                best = (sc, code, rep)
            if sc == 0:
                self.res["nominal_clean"] = True
                self.res["clean_at"] = k
                break
            fb = FB.make(rep, nominal(cell), args.feedback, code, prev_code)
            prev_code = code
            if args.keep_best and regressed:
                fb = (f"Your last change made things worse (score {sc} vs best {best[0]}). Here is your BEST version "
                      f"so far - continue from it, not from the last one:\n```icl\n{best[1]}```\nIts check result:\n"
                      + FB.make(best[2], nominal(cell), args.feedback, best[1]))
                prev_code = best[1]
            open(os.path.join(self.out, f"feedback{k}.md"), "w").write(fb)
            parts = [{"type": "text", "text": fb}]
            imgs = FB.images(best[2] if (args.keep_best and regressed) else rep, args.images, self.out, k)
            parts += imgs
            msgs.append({"role": "user", "content": parts if imgs else fb})
        self.res["calls"] = sum(1 for a in self.res["attempts"])
        if not self.res["nominal_clean"]:
            return self.res
        final = os.path.join(self.out, f"{cell['name']}_final.icl")
        open(final, "w").write(best[1])
        sw = self.sweep(final, "sweep0")
        self.res["sweep"] = [sw]
        log(f"  {cell['name']:7s} sweep: {sum(r['clean'] for r in sw)}/{len(sw)}")
        for rr in range(1, args.robust_rounds + 1):
            bad = [r for r in sw if not r["clean"]]
            if not bad:
                break
            txt = ["Clean at the nominal point, but these sweep points fail:"]
            txt += [f"  {r['params']}: {r['problem']}" for r in bad]
            txt.append("Make positions follow the parameters (derive from other shapes, max(...) where two rules "
                       "compete, `well y=` between the diffusions, enough width). Return the complete file.")
            msgs.append({"role": "user", "content": "\n".join(txt)})
            reply = self.llm.chat(msgs)
            msgs.append({"role": "assistant", "content": reply})
            code = NS.extract_icl(reply)
            if not code:
                break
            p2 = os.path.join(self.out, f"{cell['name']}_r{rr}.icl")
            open(p2, "w").write(code)
            rep2 = self.check(p2, nominal(cell), f"robust{rr}")
            if rep2.get("status") != "CLEAN":
                log(f"  {cell['name']:7s} robust round {rr}: nominal broke ({rep2.get('status')})")
                break
            sw2 = self.sweep(p2, f"sweep{rr}")
            log(f"  {cell['name']:7s} robust round {rr} sweep: {sum(r['clean'] for r in sw2)}/{len(sw2)}")
            if sum(r["clean"] for r in sw2) >= sum(r["clean"] for r in sw):
                sw, final = sw2, p2
            self.res["sweep"].append(sw2)
        self.res["final"] = final
        self.res["sweep_best"] = sum(r["clean"] for r in sw)
        return self.res

    def previous_best(self, run_dir):
        """(code, report) of the best attempt of this cell in an earlier run (re-checked with the current
        tools), or None if it was clean."""
        d = os.path.join(run_dir, self.cell["name"])
        best = None
        k = 1
        while os.path.exists(os.path.join(d, f"attempt{k}.icl")):
            old = os.path.join(d, f"check{k}.json")
            if os.path.exists(old) and self.score(json.load(open(old))) == 0:
                return None
            p = os.path.join(self.out, f"prev{k}.icl")
            open(p, "w").write(open(os.path.join(d, f"attempt{k}.icl")).read())
            rep = self.check(p, nominal(self.cell), f"prevcheck{k}")
            sc = self.score(rep)
            if sc == 0:
                return None
            if best is None or sc <= best[0]:
                best = (sc, open(p).read(), rep, k)
            k += 1
        if best:
            self.res["resumed_from"] = {"attempt": best[3], "score": best[0]}
        return (best[1], best[2]) if best else None

    def run_compact(self):
        """Start from the verified generator draft and make the cell as narrow as possible while it
        stays clean over the whole sweep."""
        import feedback as FB
        import sticks
        cell, args = self.cell, self.args
        draft = sticks.draft_file(cell)
        d0 = os.path.join(self.out, "draft.icl")
        open(d0, "w").write(draft)
        sw0 = self.sweep(d0, "sweep_draft")
        w0 = sw0[0]["size_um"][0] if sw0 and sw0[0]["size_um"] else None
        self.res.update({"draft_width": w0, "draft_sweep": sum(r["clean"] for r in sw0), "hd_width": cell["hd_size_um"][0]})
        best_w, best_code = (w0, draft) if all(r["clean"] for r in sw0) else (None, None)
        prompt = (task_prompt(cell) + f"\n\nAn automatic generator produced the layout below. It is DRC and LVS clean at "
                  f"every sweep point, {w0} um wide. The SKY130 hd library version of this cell is "
                  f"{cell['hd_size_um'][0]} um wide (it has no taps inside; ours keep the taps). Make the cell as NARROW as "
                  "you can (fewer `width` columns of 0.46 um) while it stays clean over the whole sweep: tighten "
                  "margins, share diffusion, reorder gates, move gate contacts - anything a layout designer would do."
                  f"\n```icl\n{draft}```")
        msgs = [{"role": "system", "content": self.system()}, {"role": "user", "content": prompt}]
        prev_code = None
        for k in range(1, args.attempts + 1):
            reply = self.llm.chat(msgs)
            open(os.path.join(self.out, f"reply{k}.md"), "w").write(reply)
            msgs.append({"role": "assistant", "content": reply})
            code = NS.extract_icl(reply)
            if code is None:
                self.res["attempts"].append({"k": k, "status": "NO_CODE"})
                msgs.append({"role": "user", "content": "No ```icl block with a stdcell found. Return the complete file."})
                continue
            p = os.path.join(self.out, f"attempt{k}.icl")
            open(p, "w").write(code)
            rep = self.check(p, nominal(cell), f"check{k}")
            att = {"k": k, "status": rep.get("status"), "width": (rep.get("size_um") or [None])[0]}
            if rep.get("status") != "CLEAN":
                fb = FB.make(rep, nominal(cell), args.feedback, code, prev_code)
            else:
                sw = self.sweep(p, f"sweep{k}")
                n_ok = sum(r["clean"] for r in sw)
                att["sweep"] = n_ok
                w = sw[0]["size_um"][0]
                if n_ok == len(sw) and (best_w is None or w < best_w - 1e-6):
                    best_w, best_code = w, code
                    fb = (f"Clean at every sweep point and {w} um wide - new best. Can you make it narrower still? "
                          "If not, return the same file.")
                elif n_ok == len(sw):
                    fb = (f"Clean over the sweep but {w} um wide - not narrower than the best so far ({best_w} um). "
                          "Try another idea, or return your best file.")
                else:
                    bad = [r for r in sw if not r["clean"]]
                    fb = "Clean at the nominal point, but these sweep points fail:\n" + "\n".join(
                        f"  {r['params']}: {r['problem']}" for r in bad) + \
                        "\nPositions must follow the parameters (L, WN.., WP.., H). Fix and return the complete file."
            prev_code = code
            self.res["attempts"].append(att)
            log(f"  {cell['name']:7s} compact attempt {k}: {att}")
            imgs = FB.images(rep, args.images, self.out, k) if rep.get("status") != "CLEAN" else []
            msgs.append({"role": "user", "content": ([{"type": "text", "text": fb}] + imgs) if imgs else fb})
        self.res["best_width"] = best_w
        self.res["improved"] = best_w is not None and w0 is not None and best_w < w0 - 1e-6
        self.res["calls"] = len(self.res["attempts"])
        if best_code:
            open(os.path.join(self.out, f"{cell['name']}_best.icl"), "w").write(best_code)
        return self.res

    def sweep(self, path, sub):
        out = []
        for i, pt in enumerate(BENCH["sweep"]):
            pv = point_params(self.cell, pt)
            rep = self.check(path, pv, f"{sub}/p{i}")
            prob = ""
            if rep.get("status") == "ERROR":
                prob = "compile: " + (rep.get("error") or "")[:140]
            elif rep.get("status") != "CLEAN":
                r = rep["drc"]["by_rule"]
                prob = (f"DRC {r[0]['rule']} x{r[0]['count']}" if r else "") + \
                       ("" if rep.get("lvs", {}).get("match", True) else " LVS mismatch")
            out.append({"params": pv, "clean": rep.get("status") == "CLEAN", "problem": prob,
                        "size_um": rep.get("size_um")})
        return out


def log(s):
    with LOCK:
        print(s, flush=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", default="nvidia/nemotron-3.5-super-vl:free")
    ap.add_argument("--cells", default="")
    ap.add_argument("--tiers", default="1,2,3,4")
    ap.add_argument("--attempts", type=int, default=5)
    ap.add_argument("--robust-rounds", type=int, default=1)
    ap.add_argument("--max-calls", type=int, default=150)
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--feedback", default="basic", choices=["basic", "ranked"])
    ap.add_argument("--images", default="full", choices=["none", "full", "crop"])
    ap.add_argument("--keep-best", action="store_true")
    ap.add_argument("--lessons", default="")
    ap.add_argument("--draft", action="store_true")
    ap.add_argument("--examples", type=int, default=0)
    ap.add_argument("--task", default="scratch", choices=["scratch", "repair", "compact"])
    ap.add_argument("--resume", default="", help="continue from the best attempts of an earlier run")
    ap.add_argument("--coach-dir", default="", help="per-cell coach notes (<cell>.md) for --resume")
    ap.add_argument("--tag", default="")
    ap.add_argument("--temperature", type=float, default=0.2)
    args = ap.parse_args()
    NS.PROMPT_V = 2
    tiers = {int(t) for t in args.tiers.split(",")}
    cells = [c for c in BENCH["cells"] if c["tier"] in tiers and (not args.cells or c["name"] in args.cells.split(","))]
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S") + (f"-{args.tag}" if args.tag else "")
    run_dir = os.path.join(ROOT, "agents", "bench_runs", stamp)
    os.makedirs(run_dir, exist_ok=True)
    logf = open(os.path.join(run_dir, "api_log.jsonl"), "a")

    def apilog(rec):
        with LOCK:
            logf.write(json.dumps(rec) + "\n")
            logf.flush()
    llm = NS.LLM(NS.load_key(), args.model, args.max_calls, apilog)
    llm.temperature = args.temperature
    library = None
    if args.examples:
        import tasks
        library = tasks.library(BENCH["cells"])     # verified generator cells, used leave-one-out
    json.dump(vars(args), open(os.path.join(run_dir, "config.json"), "w"), indent=1)
    log(f"run {stamp}: {len(cells)} cells, model {llm.info['id']}, config {vars(args)}")
    results = []
    with cf.ThreadPoolExecutor(max_workers=args.workers) as ex:
        def job(c):
            r = CellRun(c, args, llm, run_dir, library)
            return r.run_compact() if args.task == "compact" else r.run()
        futs = {ex.submit(job, c): c for c in sorted(cells, key=lambda c: c["tier"])}
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
            json.dump({"config": vars(args), "results": results, "api_calls": llm.calls},
                      open(os.path.join(run_dir, "results.json"), "w"), indent=1, default=str)
    log(f"done: {llm.calls} calls -> {run_dir}/results.json")


if __name__ == "__main__":
    main()
