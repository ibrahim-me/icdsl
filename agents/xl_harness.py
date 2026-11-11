#!/usr/bin/env python3
"""LLM baseline on the XL benchmark (bench/xl): the same tasks through three interfaces.

    canvas   the model writes a canvas script (CANVAS.md + the PDK rule sheet)
    raw      the model writes plain Python that builds the GDS with klayout.db (the PDK data file as
             the rule source; the canvas is not importable)
    icl      the model writes ICL (AGENTS.md); sky130A and MOS-only tasks, the reach of that language

Chat loop per case: task -> reply with one code block -> build -> bench/xl/judge.py -> feedback -> ...
The verdict is always the judge's (magic DRC + the PDK's KLayout deck + netgen LVS + pins + area).
Model-written code only ever runs inside a bubblewrap sandbox: no network, the home directory hidden,
the project read-only, one writable directory.

    python agents/xl_harness.py --iface canvas,raw,icl [--pdks sky130A,gf180mcuD,freepdk45]
                                [--tasks rca8,spiral] [--attempts 4] [--model ID:free] [--tag x]
    python agents/xl_harness.py --summary agents/xl_runs/<run>

Free OpenRouter models only (the LLM class refuses anything with a price).
"""
from __future__ import annotations

import argparse
import concurrent.futures as cf
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
import threading
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
sys.path.insert(0, ROOT)
import nemotron_stdcells as NS  # noqa: E402  (key loading, free-model check, chat with back-off)

XL = os.path.join(ROOT, "bench", "xl")
PY = os.path.join(ROOT, ".venv", "bin", "python")
LOCK = threading.Lock()
ICL_TASKS = ("rca8", "dec4to16", "shreg16", "sram16x8")
TOOL_TIMEOUT = "180"        # seconds per signoff tool run; the references need 1 to 10 s


def log(s):
    with LOCK:
        print(s, flush=True)


# ----------------------------------------------------------------------------- sandbox
def sandbox(cmd, rw, project=True, timeout=600, env=None):
    """Run cmd with no network, an empty home directory, the project read-only (or only its venv when
    project=False) and `rw` as the one writable directory. -> (returncode, output)"""
    home = os.path.expanduser("~")
    bw = ["bwrap", "--ro-bind", "/", "/", "--dev", "/dev", "--proc", "/proc", "--tmpfs", "/tmp", "--tmpfs", home]
    if project:
        bw += ["--ro-bind", ROOT, ROOT]
    else:
        bw += ["--ro-bind", os.path.join(ROOT, ".venv"), os.path.join(ROOT, ".venv")]
    bw += ["--bind", rw, rw, "--unshare-all", "--die-with-parent", "--new-session", "--chdir", rw,
           "--clearenv", "--setenv", "PATH", "/usr/local/bin:/usr/bin", "--setenv", "HOME", rw,
           "--setenv", "LANG", "C.UTF-8"]
    for k, v in (env or {}).items():
        bw += ["--setenv", k, v]
    full = ["prlimit", "--as=4000000000", "--"] + bw + cmd
    try:
        p = subprocess.run(full, capture_output=True, text=True, timeout=timeout)
        return p.returncode, p.stdout + p.stderr
    except subprocess.TimeoutExpired as e:
        return 124, f"TIMEOUT after {timeout} s\n" + ((e.stdout or b"").decode(errors="replace")[-1500:]
                                                     if isinstance(e.stdout, bytes) else (e.stdout or "")[-1500:])


# ----------------------------------------------------------------------------- prompts
def rule_sheet(pdk):
    from icdsl.canvas import tech as T
    return T.load(pdk).describe()


RAW_SKELETON = '''import klayout.db as kdb

ly = kdb.Layout()
ly.dbu = 0.001                      # database unit in um (use the PDK file's gds_dbu if it has one)
top = ly.create_cell("TOPNAME")
m1 = ly.layer(68, 20)               # (gds layer, datatype) from the PDK file
top.shapes(m1).insert(kdb.DBox(0.0, 0.0, 1.0, 0.2))                    # um
top.shapes(m1).insert(kdb.DPolygon([kdb.DPoint(0, 0), kdb.DPoint(1, 0), kdb.DPoint(1, 1)]))
lab = ly.layer(68, 5)               # the label layer of that metal (PDK file: `label`)
top.shapes(lab).insert(kdb.DText("A", kdb.DTrans(kdb.DVector(0.5, 0.1))))   # pin A
sub = ly.create_cell("unit")        # hierarchy: cells and (arrays of) instances
top.insert(kdb.DCellInstArray(sub.cell_index(), kdb.DTrans(kdb.DVector(2.0, 0.0))))
ly.write("TOPNAME.gds")
'''


def system_prompt(iface, pdk):
    if iface == "canvas":
        return ("You are an expert IC layout engineer. You write layouts as canvas scripts (plain Python, "
                "described below). Reply with ONE complete script in a single ```python block; no shell, no file "
                "access, no imports other than icdsl.canvas, icdsl.canvas.route and math. Keep the script compact: "
                "use loops, functions, stick cells, rows and the router instead of listing shapes.\n\n"
                "===== CANVAS.md =====\n" + open(os.path.join(ROOT, "CANVAS.md")).read() +
                "\n===== examples/canvas/inv.py =====\n" + open(os.path.join(ROOT, "examples", "canvas", "inv.py")).read() +
                "\n===== tests/canvas/pcells.py (every PCell once) =====\n"
                + open(os.path.join(ROOT, "tests", "canvas", "pcells.py")).read() +
                f"\n===== rule sheet of {pdk} (bin/icl inspect) =====\n" + rule_sheet(pdk))
    if iface == "raw":
        return ("You are an expert IC layout engineer. You write layouts as plain Python that builds the GDS "
                "directly with klayout.db (no layout library is available: only the standard library and "
                "klayout.db). Reply with ONE complete script in a single ```python block. The script runs in an "
                "empty directory, without arguments, and must write `<top cell name>.gds` there. Use loops and "
                "functions; write your own helpers for transistors, contacts and vias.\n"
                "Devices are recognised by the extraction deck from their layers (the `devices` recipes of the "
                "PDK file name the layers of each device and its SPICE model); pins are text labels on the "
                "label layer of the pin's metal.\n\n===== skeleton =====\n" + RAW_SKELETON +
                f"\n===== PDK data file of {pdk} (layers as (gds layer, datatype), rules in um) =====\n"
                + open(os.path.join(ROOT, "icdsl", "canvas", "pdks", pdk + ".py")).read())
    return ("You are an expert IC layout engineer. You write layouts in ICL (described below). Reply with ONE "
            "complete ICL file in a single ```icl block.\n\n===== AGENTS.md =====\n"
            + open(os.path.join(ROOT, "AGENTS.md")).read()
            + "\n===== examples/dff.icl =====\n" + open(os.path.join(ROOT, "examples", "dff.icl")).read())


def task_prompt(task, pdk, meta, iface="canvas"):
    tdir = os.path.join(XL, "tasks", task)
    txt = open(os.path.join(tdir, "task.md")).read()
    txt = txt.split("Any way of producing the GDS is allowed")[0].rstrip()
    out = f"Target PDK: **{pdk}**.\n\n" + txt
    nl = meta["pdks"][pdk].get("netlist")
    if nl:
        out += f"\n\n## Netlist to implement (`{nl}`)\n```spice\n" + open(os.path.join(tdir, nl)).read() + "```\n"
        if iface == "canvas":
            out += ("\nThe same netlist is the file `netlist.spice` in the directory the script runs in "
                    "(`from_spice(\"netlist.spice\")` reads it).\n")
    return out


COMPLETE = {"canvas": r"^\s*(from icdsl\.canvas import|import icdsl)", "raw": r"^\s*(import klayout|from klayout)",
            "icl": r"^\s*(cell|stdcell|floorplan)\s+\w+"}


def code_blocks(reply, iface):
    """-> (blocks of the wanted language, text of an unterminated last block or None)"""
    fence = r"```([a-zA-Z0-9_+-]*)[ \t]*\n"
    blocks, pos, tail = [], 0, None
    while True:
        m = re.search(fence, reply[pos:])
        if not m:
            break
        start = pos + m.end()
        e = reply.find("```", start)
        if e < 0:
            tail = reply[start:]
            break
        blocks.append((m.group(1).lower(), reply[start:e]))
        pos = e + 3
    want = ("icl",) if iface == "icl" else ("python", "py")
    return [b for lang, b in blocks if lang in want] or [b for _, b in blocks], tail


def code_block(reply, iface, rule="last"):
    """The submission in a reply. -> (code or None, cut off?)

    rule "last" (default): the last block that is a whole file (it has the interface's import / cell line).
    A model that thinks aloud writes a draft, corrects it and ends with the file it means; the last whole
    block is its answer. With no whole block, the longest block.
    rule "longest": the longest block. The runs up to 20261111_165328_v4 used this, and so judged a draft
    wherever a shorter final file followed it (--rejudge-last RUN lists those replies and judges the final
    file)."""
    pick, tail = code_blocks(reply, iface)
    whole = [b for b in pick if re.search(COMPLETE[iface], b, flags=re.M)]
    if tail is not None and (not pick or (rule == "last" and re.search(COMPLETE[iface], tail, flags=re.M))):
        return tail, True                    # the answer itself was cut off (output limit)
    if not pick:
        return None, False
    if rule == "last" and whole:
        return whole[-1], False
    return max(pick, key=len), False


# ----------------------------------------------------------------------------- one attempt
def attempt(iface, task, pdk, meta, code, d):
    """Build + judge one submission in directory d. -> (solved, report dict or None, feedback text)"""
    top, info = meta["top"], meta["pdks"][pdk]
    netlist = os.path.join(XL, "tasks", task, info["netlist"]) if info.get("netlist") else None
    os.makedirs(d, exist_ok=True)
    detail = ""
    gds = os.path.join(d, top + ".gds")
    if iface == "canvas":
        sub = os.path.join(d, "sub.py")
        open(sub, "w").write(code)
        if netlist:
            shutil.copy(netlist, os.path.join(d, "netlist.spice"))
        cmd = [os.path.join(ROOT, "bin", "icl"), "check", sub, "--pdk", pdk, "--top", top, "--out", d]
        cmd += ["--ref", netlist] if netlist else ["--no-lvs"]
        rc, txt = sandbox(cmd, d, timeout=1500, env={"ICL_PDK": pdk, "ICL_SIGNOFF_TIMEOUT": TOOL_TIMEOUT})
        detail = txt.strip()
        if rc == 2 or not os.path.exists(gds):
            return False, None, "The script did not build:\n" + detail[-5000:]
    elif iface == "raw":
        if re.search(r"\bicdsl\b", code):
            return False, None, "The script imports icdsl: only the standard library and klayout.db are available."
        sub = os.path.join(d, "sub.py")
        open(sub, "w").write(code)
        rc, txt = sandbox([PY, "-I", sub], d, project=False, timeout=300)
        if not os.path.exists(gds):
            return False, None, (f"The script did not write {top}.gds (exit code {rc}):\n" + txt.strip()[-4000:])
    else:
        sub = os.path.join(d, "sub.icl")
        open(sub, "w").write(code)
        rc, txt = sandbox([os.path.join(ROOT, "bin", "icl"), "check", sub, "--top", top, "--out", d]
                          + (["--ref", netlist] if netlist else []), d, timeout=1500,
                          env={"ICL_SIGNOFF_TIMEOUT": TOOL_TIMEOUT})
        detail = txt.strip()
        if not os.path.exists(gds):
            return False, None, "The file did not build:\n" + detail[-5000:]
    try:
        p = subprocess.run([PY, os.path.join(XL, "judge.py"), task, pdk, gds, "--out", os.path.join(d, "judge"),
                            "--json"], capture_output=True, text=True, timeout=1500,
                           env=dict(os.environ, ICL_SIGNOFF_TIMEOUT=TOOL_TIMEOUT))
        rep = json.loads(p.stdout)
    except subprocess.TimeoutExpired:
        return False, None, ("The judge did not finish in 25 minutes on this layout (check its size and units: "
                             "coordinates are micrometres).")
    except ValueError:
        return False, None, "The judge could not read the layout:\n" + (p.stdout + p.stderr).strip()[-3000:]
    lines = [f"  {'ok  ' if c['ok'] else 'FAIL'} {c['check']:8s} {c['detail']}" for c in rep["checks"]]
    fb = "Judge:\n" + "\n".join(lines)
    if rep["solved"]:
        return True, rep, fb
    if iface == "raw" or not detail:
        detail = rep.get("detail", "")
    if detail:
        fb += "\n\nTool report:\n" + (detail if len(detail) < 7000 else detail[:4500] + "\n...\n" + detail[-2300:])
    return False, rep, fb


def score(rep):
    """Lower is better: (failed checks, DRC count) - used to keep the best attempt."""
    if rep is None:
        return (99, 10 ** 9)
    n = 0
    for c in rep["checks"]:
        m = re.search(r"(\d+) violation", c["detail"])
        n += int(m.group(1)) if m and not c["ok"] else 0
    return (sum(1 for c in rep["checks"] if not c["ok"]), n)


# ----------------------------------------------------------------------------- one case
def run_case(llm, iface, task, pdk, args, run_dir):
    meta = json.load(open(os.path.join(XL, "tasks", task, "task.json")))
    name = f"{iface}/{task}.{pdk}"
    out = os.path.join(run_dir, iface, f"{task}.{pdk}")
    os.makedirs(out, exist_ok=True)
    res = dict(iface=iface, task=task, pdk=pdk, solved=False, attempts=[], calls=0)
    msgs = [{"role": "system", "content": system_prompt(iface, pdk)},
            {"role": "user", "content": task_prompt(task, pdk, meta, iface)}]
    json.dump(msgs, open(os.path.join(out, "prompt.json"), "w"), indent=1)
    turns, best = [], None
    for k in range(1, args.attempts + 1):
        try:
            reply = llm.chat(msgs + [m for t in turns[-2:] for m in t], max_tokens=args.max_tokens,
                             reasoning=args.reasoning)
        except NS.Budget as e:
            res["stopped"] = str(e)[:200]
            break
        except Exception as e:                               # noqa: BLE001
            res["stopped"] = "API error: " + str(e)[:200]
            break
        res["calls"] += 1
        open(os.path.join(out, f"reply{k}.md"), "w").write(reply)
        code, cut = code_block(reply, iface)
        t0 = time.time()
        if code is None:
            ok, rep, fb = False, None, ("No code block found in the reply. There are no tools in this conversation: "
                                        "tool calls are not executed and nothing can be inspected from your side. "
                                        "Reply with the complete file in one code block; it is built and checked, "
                                        "and the report comes back to you.")
        elif cut:
            ok, rep, fb = False, None, ("The reply was cut off before the code block ended (output limit). "
                                        "Write a shorter script: loops and helper functions, no long literal lists.")
        else:
            ok, rep, fb = attempt(iface, task, pdk, meta, code, os.path.join(out, f"a{k}"))
        if (args.level_hint and not ok and iface == "canvas" and meta["pdks"][pdk].get("netlist")
                and not re.search(r"\bfrom_spice\s*\(", code or "")):
            fb += ("\n\nNote: this task comes with a netlist, and the script does not use it. "
                   "`TOP = from_spice(\"netlist.spice\")` builds the complete layout from the netlist (CANVAS.md, "
                   "sections 0 and 8). Draw devices and wires yourself only for what that level cannot express.")
        open(os.path.join(out, f"feedback{k}.md"), "w").write(fb)
        a = dict(k=k, solved=ok, lines=len(code.splitlines()) if code else 0, seconds=round(time.time() - t0, 1),
                 built=rep is not None, checks={c["check"]: c["ok"] for c in rep["checks"]} if rep else {},
                 area_vs_reference=rep.get("area_vs_reference") if rep else None, score=score(rep))
        res["attempts"].append(a)
        if best is None or a["score"] < best["score"]:
            best = a
        log(f"  {name:34s} attempt {k}: {'SOLVED' if ok else 'built, ' + str(a['score'][0]) + ' check(s) fail, ' + str(a['score'][1]) + ' DRC' if rep else 'no build'}"
            f"  ({a['lines']} lines)")
        if ok:
            res["solved"], res["solved_at"] = True, k
            break
        turns.append([{"role": "assistant", "content": "```\n" + (code or reply[-3000:]) + "\n```"},
                      {"role": "user", "content": fb + f"\n\nAttempt {k} of {args.attempts}. Fix the problems and reply "
                       "with the complete corrected file in one code block."}])
    res["best"] = best
    json.dump(res, open(os.path.join(out, "result.json"), "w"), indent=1)
    return res


# ----------------------------------------------------------------------------- summary
def summary(run_dir):
    rs = []
    for iface in sorted(os.listdir(run_dir)):
        d = os.path.join(run_dir, iface)
        if os.path.isdir(d):
            for c in sorted(os.listdir(d)):
                f = os.path.join(d, c, "result.json")
                if os.path.exists(f):
                    rs.append(json.load(open(f)))
    ifaces = sorted({r["iface"] for r in rs})
    cases = sorted({(r["task"], r["pdk"]) for r in rs})
    cell = {(r["iface"], r["task"], r["pdk"]): r for r in rs}
    out = ["| task | PDK | " + " | ".join(ifaces) + " |", "|---|---|" + "---|" * len(ifaces)]
    for t, p in cases:
        row = []
        for i in ifaces:
            r = cell.get((i, t, p))
            if r is None:
                row.append("-")
            elif r["solved"]:
                row.append(f"**solved** (attempt {r['solved_at']})")
            else:
                b = r.get("best")
                if not b or not b["built"]:
                    row.append("no build" + (" (" + r["stopped"][:30] + ")" if r.get("stopped") and not r["attempts"] else ""))
                else:
                    bad = [c for c, ok in b["checks"].items() if not ok]
                    row.append("built; fails " + ", ".join(bad) + (f" ({b['score'][1]} DRC)" if b["score"][1] else ""))
            row[-1] = row[-1].replace("|", "/")
        out.append(f"| {t} | {p} | " + " | ".join(row) + " |")
    out.append("")
    for i in ifaces:
        mine = [r for r in rs if r["iface"] == i]
        out.append(f"{i}: solved {sum(r['solved'] for r in mine)}/{len(mine)}, built "
                   f"{sum(1 for r in mine if r.get('best') and r['best']['built'])}/{len(mine)}, "
                   f"model calls {sum(r['calls'] for r in mine)}")
    return "\n".join(out)


def rejudge_last(run_dir, workers=3):
    """Replies in which the old rule (longest block) and the current rule (last whole block) pick different
    code: judge the current pick in <case>/a<k>.last and list the outcome. result.json files stay as run."""
    import concurrent.futures as cf
    jobs = []
    for iface in sorted(os.listdir(run_dir)):
        d = os.path.join(run_dir, iface)
        if not os.path.isdir(d) or iface not in COMPLETE:
            continue
        for case in sorted(os.listdir(d)):
            rj = os.path.join(d, case, "result.json")
            if not os.path.exists(rj):
                continue
            res = json.load(open(rj))
            for a in res["attempts"]:
                f = os.path.join(d, case, f"reply{a['k']}.md")
                reply = open(f).read()
                old, new = code_block(reply, iface, "longest"), code_block(reply, iface, "last")
                if old[0] != new[0] and new[0] is not None and not new[1]:
                    jobs.append((iface, res["task"], res["pdk"], a, res, new[0], os.path.join(d, case, f"a{a['k']}.last")))

    def one(j):
        iface, task, pdk, a, res, code, out = j
        meta = json.load(open(os.path.join(XL, "tasks", task, "task.json")))
        ok, rep, fb = attempt(iface, task, pdk, meta, code, out)
        open(out + ".feedback.md", "w").write(fb)
        return j, ok, rep
    rows, gained = [], set()
    with cf.ThreadPoolExecutor(workers) as ex:
        for (iface, task, pdk, a, res, code, out), ok, rep in ex.map(one, jobs):
            bad = [c["check"] for c in rep["checks"] if not c["ok"]] if rep else None
            verdict = "**solved**" if ok else "no build" if rep is None else "fails " + ", ".join(bad)
            was = "solved" if a["solved"] else "no build" if not a["built"] else "fails " + ", ".join(c for c, v in a["checks"].items() if not v)
            rows.append(f"| {iface} | {task} | {pdk} | {a['k']} | {a['lines']} lines: {was} | {len(code.splitlines())} lines: {verdict} | "
                        f"{'solved' if res['solved'] else 'not solved'} |")
            if ok and not res["solved"]:
                gained.add((iface, task, pdk))
            log(rows[-1])
    txt = ["Replies with more than one code block where the run judged the longest block and the model's last",
           "whole file is a different one. The last file was judged afterwards (same sandbox, same judge).", "",
           "| interface | task | PDK | attempt | judged in the run (longest block) | the reply's last whole file | case as run |",
           "|---|---|---|---|---|---|---|"] + sorted(rows)
    txt += ["", f"{len(rows)} replies. Cases not solved in the run whose last file is judged solved: {len(gained)}"
            + (" (" + ", ".join(f"{i}/{t}.{p}" for i, t, p in sorted(gained)) + ")" if gained else "")]
    open(os.path.join(run_dir, "REJUDGE.md"), "w").write("\n".join(txt) + "\n")
    print("\n".join(txt))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--iface", default="canvas,raw,icl")
    ap.add_argument("--pdks", default="sky130A,gf180mcuD,freepdk45")
    ap.add_argument("--tasks", default="")
    ap.add_argument("--model", default="nvidia/nemotron-3.5-super-vl:free")
    ap.add_argument("--attempts", type=int, default=4)
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--max-total-calls", type=int, default=250)
    ap.add_argument("--max-tokens", type=int, default=24000)
    ap.add_argument("--reasoning", type=int, default=8000)
    ap.add_argument("--temperature", type=float, default=0.2)
    ap.add_argument("--tag", default="")
    ap.add_argument("--summary", default="", help="print the table of an existing run directory and exit")
    ap.add_argument("--resume", default="", help="continue this run directory: cases with a result.json are kept")
    ap.add_argument("--level-hint", action="store_true", help="canvas, tasks with a netlist: when a failed attempt did "
                    "not call from_spice, the feedback says that the netlist level exists")
    ap.add_argument("--rejudge-last", default="", help="run directory: judge the last whole code block of every reply "
                    "in which the longest block (the rule of the runs up to v4) is a different one; writes REJUDGE.md")
    args = ap.parse_args()
    if args.summary:
        print(summary(args.summary))
        return
    if args.rejudge_last:
        rejudge_last(os.path.abspath(args.rejudge_last), args.workers)
        return
    tasks = [t for t in sorted(os.listdir(os.path.join(XL, "tasks")))
             if not args.tasks or t in args.tasks.split(",")]
    cases = []
    for iface in args.iface.split(","):
        for t in tasks:
            meta = json.load(open(os.path.join(XL, "tasks", t, "task.json")))
            for p in args.pdks.split(","):
                if p not in meta["pdks"] or (iface == "icl" and (p != "sky130A" or t not in ICL_TASKS)):
                    continue
                cases.append((iface, t, p))
    stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + (("_" + args.tag) if args.tag else "")
    run_dir = os.path.abspath(args.resume) if args.resume else os.path.join(HERE, "xl_runs", stamp)
    os.makedirs(run_dir, exist_ok=True)
    done = [c for c in cases if os.path.exists(os.path.join(run_dir, c[0], f"{c[1]}.{c[2]}", "result.json"))]
    cases = [c for c in cases if c not in done]
    calls = open(os.path.join(run_dir, "calls.jsonl"), "a")

    def clog(d):
        with LOCK:
            calls.write(json.dumps(d) + "\n")
            calls.flush()
    llm = NS.LLM(NS.load_key(), args.model, args.max_total_calls, clog)
    llm.temperature = args.temperature
    json.dump(dict(vars(args), cases=cases, model_info=llm.info),
              open(os.path.join(run_dir, "run.json" if not args.resume else f"run_resume_{stamp}.json"), "w"), indent=1)
    log(f"run {run_dir}: {len(cases)} cases ({len(done)} already done), model {args.model}, {args.attempts} attempts each")
    order = sorted(cases, key=lambda c: (c[1], c[2], c[0]))          # interleave the interfaces
    with cf.ThreadPoolExecutor(args.workers) as ex:
        list(ex.map(lambda c: run_case(llm, c[0], c[1], c[2], args, run_dir), order))
    txt = summary(run_dir)
    open(os.path.join(run_dir, "SUMMARY.md"), "w").write(f"model {args.model}, up to {args.attempts} attempts per case\n\n"
                                                         + txt + "\n")
    log(txt)


if __name__ == "__main__":
    sys.exit(main())
