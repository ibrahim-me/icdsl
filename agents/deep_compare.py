#!/usr/bin/env python3
"""Free-model side of the hard-task comparison (agent_compare2): the same tasks, conditions and checker
as the Claude subagent runs, driven by a LangGraph deepagents loop.

conditions
  raw   raw coordinates: the agent writes /<task>.rect (rect / label / pin records, bench/rect2gds.py);
        check_layout converts it to GDS and runs the plain checker
  icl0  ICL with no techniques: AGENTS.md + one basic example, plain checker
  icl1  ICL + techniques: lessons, 2 verified similar cells, ranked checker, check_sweep, inspect_layout,
        harness keep-best
All conditions: deepagents file tools (no shell), continuation nudges (a model that stops before a clean
check is told what is still failing), budgets on model calls and checks. Scoring afterwards uses the
same agent_compare2/score.py as the Claude runs.

    python agents/deep_compare.py --cond icl1 [--tasks maj3,ha,folded_cascode,comp_latch]
"""
from __future__ import annotations

import argparse
import concurrent.futures as cf
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
sys.path.insert(0, os.path.join(ROOT, "bench"))
sys.path.insert(0, os.path.join(ROOT, "agent_compare2"))
import nemotron_stdcells as NS  # noqa: E402

LOCK = threading.Lock()
PY = os.path.join(ROOT, ".venv", "bin", "python")
TASKS = ["maj3", "ha", "folded_cascode", "comp_latch"]


def log(s):
    with LOCK:
        print(s, flush=True)


class Budget(Exception):
    pass


RECT_HELP = """Raw layout format (write it to /{task}.rect; check_layout converts it to GDS):
    rect  <layer> x0 y0 x1 y1        a drawn rectangle, coordinates in um (x0 < x1, y0 < y1)
    label <layer> x y NAME           net name (a text on that layer)
    pin   <layer> x0 y0 x1 y1 NAME   a port: pin rectangle + name (put it on top of a drawn shape)
    # comment
layers: nwell diff tap poly licon npc nsdm psdm li mcon met1 via met2
"""


def workspace_task(task, cond, ws):
    """TASK.md for the agent's virtual filesystem (workspace-relative paths, tool names)."""
    import importlib.util
    spec = importlib.util.spec_from_file_location("mt2", os.path.join(ROOT, "agent_compare2", "make_tasks.py"))
    MT = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(MT)
    txt = MT.task_md(task, cond, ws).replace(ws, "/WS")
    T = MT.AC.task_spec(task)
    ext = "rect" if cond == "raw" else "icl"
    txt = txt.replace(f"`/WS/{task}.gds`", f"`/{task}.rect`").replace(f"`/WS/{task}.icl`", f"`/{task}.icl`")
    txt = re.sub(r"(?s)## Checking.*?## Budget", "## Checking (this is also the final score)\n"
                 f"Call `check_layout('/{task}.{ext}')`: magic DRC (full), netgen LVS against the reference netlist "
                 "and the layout checks; it prints the problems. Use it as often as your budget allows.\n\n## Budget", txt)
    if cond == "raw":
        txt = re.sub(r"(?s)Write the GDS yourself.*?examples/\)\.", RECT_HELP.format(task=task) +
                     "No layout language: every shape is an explicit rectangle.", txt)
    else:
        ex = "l1_param_inv.icl" if T["level"] == "l1" else "example_pdp.icl"
        txt = re.sub(r"Reference: `[^`]*AGENTS.md`; worked example `[^`]*`",
                     f"Reference: `/AGENTS.md`; worked example `/examples/{ex}`", txt)
        txt = re.sub(r"`[^`]*bin/icl check <file>[^\n]*\n[^\n]*\n", "", txt)
        shutil.copy(os.path.join(ROOT, "AGENTS.md"), os.path.join(ws, "AGENTS.md"))
        os.makedirs(os.path.join(ws, "examples"), exist_ok=True)
        src = os.path.join(ROOT, "examples", ex) if T["level"] == "l1" else os.path.join(HERE, "l2", ex)
        shutil.copy(src, os.path.join(ws, "examples", ex))
    if cond == "icl1":
        txt = txt.replace("/WS/", "/")
        txt = re.sub(r"- Diagnosis: add `--ranked`.*?\n  measured", "- check_layout gives a ranked diagnosis: it names the statements/objects/lines behind each error,\n  measured", txt, flags=re.S)
        txt = re.sub(r"- `[^`]*bin/icl inspect[^\n]*\n", "- `inspect_layout(path)` lists every object's position and size.\n", txt)
        txt = re.sub(r"- Robustness: .*?\n  make", "- Robustness: `check_sweep(path)` checks the parameter sweep (L, widths, height);\n  make", txt, flags=re.S)
    txt = txt.replace("/WS/", "/").replace("/WS", "")
    txt = re.sub(r"(?s)Do NOT read or copy:.*?Do not launch other agents\.", "Work only in this workspace.", txt)
    return txt


class Run:
    def __init__(self, task, args, key, stats):
        self.task, self.args, self.key, self.stats = task, args, key, stats
        self.dir = os.path.join(ROOT, "agent_compare2", f"nemotron-{args.cond}-{task}")
        self.mcond = "icl1" if args.cond == "icl2" else args.cond      # icl2 = icl1 + preloaded docs
        if os.path.exists(self.dir):
            shutil.rmtree(self.dir)
        os.makedirs(self.dir)
        self.res = {"run": os.path.basename(self.dir), "model_calls": 0, "checks": 0, "sweeps": 0, "nudges": 0}
        self.ext = "rect" if args.cond == "raw" else "icl"
        self.last = None
        self.best_clean = None

    def _p(self, path):
        p = os.path.normpath(os.path.join(self.dir, path.lstrip("/")))
        if not p.startswith(self.dir):
            raise ValueError("path outside the workspace")
        return p

    def _checker(self, path, extra=()):
        cmd = [PY, os.path.join(ROOT, "bench", "agent_check.py"), path, self.task, "--log", self.dir, *extra]
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=900)
        return r.returncode, "\n".join(l for l in (r.stdout + r.stderr).splitlines() if "RuntimeWarning" not in l)

    def tool_check(self, path: str) -> str:
        """Check the layout: magic DRC + netgen LVS against the reference netlist + layout checks."""
        if self.res["checks"] >= self.args.max_checks:
            return "CHECK BUDGET EXHAUSTED - stop now; your current file is your result."
        try:
            p = self._p(path)
        except ValueError as e:
            return str(e)
        if not os.path.exists(p):
            return f"no such file {path} - write it first"
        self.res["checks"] += 1
        k = self.res["checks"]
        if self.args.cond == "raw":
            import rect2gds
            gds = os.path.join(self.dir, f"{self.task}.gds")
            errs = rect2gds.convert(p, gds, self.task)
            if errs:
                return "the .rect file has errors (fix them first):\n" + "\n".join(errs[:20])
            target = gds
        else:
            target = p
        rc, out = self._checker(target, ("--ranked",) if self.mcond == "icl1" else ())
        shutil.copy(p, os.path.join(self.dir, f"attempt{k}.{self.ext}"))
        self.last = "CLEAN" if rc == 0 else "NOT CLEAN"
        if rc == 0:
            self.best_clean = k
            out += "\nCLEAN." + (" Now call check_sweep on the same file." if self.mcond == "icl1" else
                                 " You are done - stop and give your final summary.")
        log(f"  {self.res['run']:32s} check {k}: {self.last}")
        out = re.sub(r"reports in \S+", "", out)
        return out[:7000] + f"\n[check_layout calls used: {k}/{self.args.max_checks}]"

    def tool_sweep(self, path: str) -> str:
        """Check the parameter sweep (L, widths, cell height) - use it once check_layout is CLEAN."""
        if self.res["sweeps"] >= 3:
            return "SWEEP BUDGET EXHAUSTED - stop now."
        self.res["sweeps"] += 1
        rc, out = self._checker(self._p(path), ("--sweep",))
        self.res["sweep_ok"] = rc == 0
        log(f"  {self.res['run']:32s} sweep {self.res['sweeps']}: {'all clean' if rc == 0 else 'failures'}")
        return out[:5000] + ("\nEvery point is clean - you are done." if rc == 0 else "")

    def tool_inspect(self, path: str) -> str:
        """Positions and sizes of every object, routes and warnings (no DRC/LVS)."""
        import agent_check as AC
        T = AC.task_spec(self.task)
        cmd = [os.path.join(ROOT, "bin", "icl"), "inspect", self._p(path), "--top", self.task]
        for k, v in T["pv"].items():
            cmd += ["--param", f"{k}={v}"]
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
        return (r.stdout + r.stderr)[:6000]

    def unfinished(self):
        a = self.args
        if self.res["checks"] >= a.max_checks or self.res["model_calls"] >= a.max_calls - 2:
            return ""
        if not os.path.exists(os.path.join(self.dir, f"{self.task}.{self.ext}")):
            return f"/{self.task}.{self.ext} does not exist yet - write it and call check_layout."
        if self.last is None:
            return "you never called check_layout on your file."
        if self.last != "CLEAN":
            return "the last check_layout was NOT CLEAN - fix the reported problems and check again."
        if self.mcond == "icl1" and not self.res.get("sweep_ok"):
            return "check_layout is CLEAN but the sweep has not been clean yet - call check_sweep."
        return ""

    def run(self):
        from deepagents import create_deep_agent
        from deepagents.backends.filesystem import FilesystemBackend
        from langchain_core.callbacks import BaseCallbackHandler
        from langchain_core.tools import StructuredTool
        from langchain_openai import ChatOpenAI
        a = self.args
        open(os.path.join(self.dir, "TASK.md"), "w").write(workspace_task(self.task, self.mcond, self.dir))
        model = ChatOpenAI(model=a.model, base_url="https://openrouter.ai/api/v1", api_key=self.key,
                           temperature=0.2, max_tokens=16000, max_retries=6, timeout=600,
                           extra_body={"reasoning": {"max_tokens": a.reasoning}})
        me = self

        class Counter(BaseCallbackHandler):
            raise_error = True

            def on_chat_model_start(self, serialized, messages, **kw):
                with LOCK:
                    me.res["model_calls"] += 1
                    me.stats["calls"] += 1
                    if me.res["model_calls"] > a.max_calls or me.stats["calls"] > a.max_total_calls:
                        raise Budget("call budget used up")
        tools = [StructuredTool.from_function(self.tool_check, name="check_layout")]
        if self.mcond == "icl1":
            tools += [StructuredTool.from_function(self.tool_sweep, name="check_sweep"),
                      StructuredTool.from_function(self.tool_inspect, name="inspect_layout")]
        system = (f"You are an expert IC layout engineer working as an autonomous agent with tools. Your task is in "
                  f"/TASK.md. Read it first, then work: write /{self.task}.{self.ext}, call check_layout, fix what it "
                  f"reports (edit_file for small changes), repeat until CLEAN. You have at most {a.max_checks} "
                  "check_layout calls. Always act with tool calls; finish with one short summary only when done.")
        if a.cond == "icl2":                # supply the knowledge up front instead of spending calls reading it
            ag = open(os.path.join(ROOT, "AGENTS.md")).read()
            keep = [sec for sec in re.split(r"(?m)^## ", ag) if sec.startswith(("Common syntax", "Level 1", "Level 2",
                                                                                "Level 4", "Reading failures"))]
            system += ("\n\nTASK:\n" + open(os.path.join(self.dir, "TASK.md")).read() +
                       "\n\nLANGUAGE REFERENCE (also in /AGENTS.md):\n## " + "\n## ".join(keep) +
                       "\n\nLESSONS (also in /lessons.md):\n" + open(os.path.join(self.dir, "lessons.md")).read() +
                       "\n\nYou already have the task, the reference and the lessons above - do not re-read them; "
                       "look at the verified examples, then write the file and check it early.")
        agent = create_deep_agent(model=model, tools=tools, system_prompt=system,
                                  backend=FilesystemBackend(root_dir=self.dir, virtual_mode=True))
        msgs = [{"role": "user", "content": f"Do the task in /TASK.md (cell `{self.task}`)."}]
        t0 = time.time()
        try:
            while True:
                st = agent.invoke({"messages": msgs}, config={"recursion_limit": 4 * a.max_calls + 20,
                                                              "callbacks": [Counter()]})
                msgs = st["messages"]
                todo = self.unfinished()
                if not todo or self.res["nudges"] >= a.nudges:
                    self.res["stop"] = "finished" if not todo else "unfinished: " + todo[:80]
                    break
                self.res["nudges"] += 1
                log(f"  {self.res['run']:32s} nudge {self.res['nudges']}: {todo[:70]}")
                msgs = list(msgs) + [{"role": "user", "content": f"You stopped, but the task is not finished: {todo} "
                                      f"Continue with the tools (check_layout calls left: {a.max_checks - self.res['checks']})."}]
        except Budget as e:
            self.res["stop"] = f"budget: {e}"
        except Exception as e:
            self.res["stop"] = f"error: {repr(e)[:200]}"
        self.res["minutes"] = round((time.time() - t0) / 60, 1)
        if self.mcond == "icl1" and self.best_clean and self.last != "CLEAN":     # harness keep-best
            shutil.copy(os.path.join(self.dir, f"attempt{self.best_clean}.{self.ext}"),
                        os.path.join(self.dir, f"{self.task}.{self.ext}"))
            self.res["restored_attempt"] = self.best_clean
        if a.cond == "raw" and os.path.exists(os.path.join(self.dir, f"{self.task}.rect")):
            import rect2gds
            rect2gds.convert(os.path.join(self.dir, f"{self.task}.rect"), os.path.join(self.dir, f"{self.task}.gds"),
                             self.task)
        json.dump(self.res, open(os.path.join(self.dir, "run.json"), "w"), indent=1)
        log(f"  {self.res['run']:32s} done: {self.res}")
        return self.res


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--cond", required=True, choices=["raw", "icl0", "icl1", "icl2"])
    ap.add_argument("--tasks", default=",".join(TASKS))
    ap.add_argument("--model", default="nvidia/nemotron-3.5-super-vl:free")
    ap.add_argument("--max-calls", type=int, default=35)
    ap.add_argument("--max-checks", type=int, default=12)
    ap.add_argument("--max-total-calls", type=int, default=300)
    ap.add_argument("--nudges", type=int, default=3)
    ap.add_argument("--reasoning", type=int, default=4000)
    ap.add_argument("--workers", type=int, default=2)
    args = ap.parse_args()
    key = NS.load_key()
    NS.LLM(key, args.model, 1, lambda r: None)                # refuses non-free models
    stats = {"calls": 0}
    with cf.ThreadPoolExecutor(args.workers) as ex:
        list(ex.map(lambda t: Run(t, args, key, stats).run(), args.tasks.split(",")))
    log(f"done: {stats['calls']} model calls")


if __name__ == "__main__":
    from deepagents import register_harness_profile
    from deepagents.profiles.harness.harness_profiles import HarnessProfile
    register_harness_profile("openai", HarnessProfile(excluded_tools=frozenset({"execute"})))
    main()
