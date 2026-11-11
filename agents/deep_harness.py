#!/usr/bin/env python3
"""Agentic benchmark harness built on LangGraph deepagents (free OpenRouter models only).

Unlike the chat-only harnesses (bench_harness.py / bench_l2.py), the model here is an agent with tools
and decides itself when to look things up, write, check and inspect:

  deepagents built-ins   ls, read_file, write_file, edit_file, glob, grep (on the cell's workspace
                         directory), write_todos (planning), task (sub-agents); the shell is disabled
  layout tools           check_layout(path)  - DRC + LVS (+ constraint judge for level 2), ranked
                                               feedback naming statements / objects / lines
                         check_sweep(path)   - the parameter sweep (L, widths, cell height)
                         inspect_layout(path)- objects, positions, routes, warnings (icl inspect)

Workspace per cell: /TASK.md (spec + skeleton), /AGENTS.md (ICL reference), /examples/*.icl,
/lessons.md; the deliverable is /<cell>.icl. Budgets: model calls and check calls per cell.
After the agent stops, the harness re-checks the deliverable at the nominal point and over the sweep
itself, and writes results.json in the same format as the chat-only runs (bench/score.py,
bench/compare.py work on it).

    python agents/deep_harness.py --level 1 [--cells nand2,inv] [--tag x]
    python agents/deep_harness.py --level 2
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
sys.path.insert(0, os.path.join(ROOT, "bench"))
import nemotron_stdcells as NS  # noqa: E402  (key loading, free-model check)

LOCK = threading.Lock()
API = "https://openrouter.ai/api/v1"
LIBRARY = {}


def log(s):
    with LOCK:
        print(s, flush=True)


class Budget(Exception):
    pass


# ----------------------------------------------------------------------------- level adapters
class L1:
    """Standard cells (bench/cells.json), checked like bench_harness.py."""
    name = "l1"

    def __init__(self):
        import bench_harness as BH
        import feedback as FB
        self.BH, self.FB = BH, FB
        self.cells = BH.BENCH["cells"]
        self.sweep_pts = BH.BENCH["sweep"]

    def nominal(self, cell):
        return self.BH.nominal(cell)

    def points(self, cell):
        return [self.BH.point_params(cell, p) for p in self.sweep_pts]

    def check(self, path, cell, pv, out):
        return self.BH.NS.run_check(path, cell["name"], pv, out, self.BH.reference_spice(cell, pv))

    def feedback(self, rep, pv, code, prev):
        return self.FB.make(rep, pv, "ranked", code, prev)

    @staticmethod
    def score(rep):
        import bench_harness as BH
        return BH.CellRun.score(rep)

    def task_md(self, cell):
        BH = self.BH
        pts = "; ".join(f"L={p['L']} widths x{p['wscale']} H={p['H']}" for p in self.sweep_pts[1:])
        return f"""# Task: standard cell `{cell['name']}`

Function: {cell['function']}
Inputs: {', '.join(cell['inputs'])}; output: {', '.join(cell['outputs'])}; internal nets: {', '.join(cell['internal_nets']) or 'none'}.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/{cell['name']}.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell {cell['name']}`):
```icl
{BH.skeleton(cell)}
```
Checked at the nominal parameters, then over the sweep: {pts}.
Choose `width` (columns of 0.46 um) large enough for L=0.25.
""" + ("""
Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist.
""" if BH.TAPLESS else "")

    def docs(self):
        d = {"AGENTS.md": open(os.path.join(ROOT, "AGENTS.md")).read(),
             "lessons.md": open(os.path.join(HERE, "lessons_stdcell_v3.md")).read()}
        if self.BH.TAPLESS:          # library conventions: the generic examples in the same (tapless) style
            for n in ("inv_1", "nand2_1"):
                d[f"examples/{n}.icl"] = open(os.path.join(ROOT, "library", "hd", f"{n}.icl")).read()
        else:
            d["examples/l1_param_inv.icl"] = open(os.path.join(ROOT, "examples", "l1_param_inv.icl")).read()
            d["examples/l1_param_nand2.icl"] = open(os.path.join(ROOT, "examples", "l1_param_nand2.icl")).read()
        return d

    def sweep_problem(self, rep):
        if rep.get("status") == "ERROR":
            return "compile: " + (rep.get("error") or "")[:160]
        r = rep["drc"]["by_rule"]
        return (f"DRC {r[0]['rule']} x{r[0]['count']}" if r else "") + \
            ("" if rep.get("lvs", {}).get("match", True) else " LVS mismatch")


class L2:
    """Analog assembly (bench/l2_cells.json), checked like bench_l2.py."""
    name = "l2"

    def __init__(self):
        import l2_common as C
        import feedback_l2 as FB
        import bench_l2 as B
        self.C, self.FB, self.B = C, FB, B
        self.cells = C.BENCH["cells"]

    def nominal(self, cell):
        return self.C.nominal(cell)

    def points(self, cell):
        return [self.C.point_params(cell, p) for p in self.C.BENCH["sweep"]]

    def check(self, path, cell, pv, out):
        return self.C.run_check(path, cell, pv, out)

    def feedback(self, rep, pv, code, prev):
        return self.FB.make(rep, pv, "ranked", code, prev, None)

    def score(self, rep):
        return self.B.CellRun.score(rep)

    def task_md(self, cell):
        B, C = self.B, self.C
        pts = "; ".join(", ".join(f"{k}={v}" for k, v in C.point_params(cell, p).items()) for p in C.BENCH["sweep"][1:])
        cons = "\n".join(f"  {i + 1}. {B.describe(c)}" for i, c in enumerate(cell["constraints"]))
        return f"""# Task: analog cell `{cell['name']}`

Function: {cell['function']}
Write the layout to `/{cell['name']}.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell {cell['name']}`):
```icl
{B.skeleton(cell)}
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
{cons}
Checked at the nominal parameters, then at: {pts}.
"""

    def docs(self):
        return {"AGENTS.md": open(os.path.join(ROOT, "AGENTS.md")).read(),
                "examples/example_pdp.icl": open(os.path.join(HERE, "l2", "example_pdp.icl")).read(),
                "lessons.md": open(os.path.join(HERE, "lessons_l2.md")).read()}

    def sweep_problem(self, rep):
        if rep.get("status") == "ERROR":
            return "compile: " + (rep.get("error") or "")[:160]
        r = rep["drc"]["by_rule"]
        return (f"DRC {r[0]['rule']} x{r[0]['count']}" if r else "") + \
            ("" if rep.get("lvs", {}).get("match", True) else " LVS mismatch") + \
            "".join(f"; constraint failed: {x['detail'][:120]}"
                    for x in rep.get("judge", {}).get("results", []) if not x["ok"])


SYSTEM = """You are an expert IC layout engineer working as an autonomous agent. You lay out SKY130 cells in
ICL, a layout language described in /AGENTS.md. Your workspace holds:
  /TASK.md      the cell to build: function, fixed transistor netlist, skeleton, constraints, sweep
  /AGENTS.md    the ICL language reference (read the sections you need)
  /examples/    verified example cells
  /lessons.md   notes from reviewing earlier attempts on this benchmark - follow them
Tools: read_file / write_file / edit_file / ls / grep for the workspace, write_todos to plan, and
  check_layout(path)   magic DRC + netgen LVS against the reference netlist (+ the layout-constraint judge);
                       the report names your statements, objects and lines and suggests fixes
  inspect_layout(path) positions and sizes of every object, routes, warnings
  check_sweep(path)    the same check at every sweep point (use it once check_layout is CLEAN)
  search_library / get_library_cell   (when available) find and read verified layouts of similar cells
Work like this: read /TASK.md and /lessons.md, read the parts of /AGENTS.md and the examples you need,
write /{cell}.icl, call check_layout, fix what it reports (edit_file for small changes), repeat until
CLEAN, then call check_sweep and fix sweep failures (positions must follow the parameters).
You have at most {checks} check_layout calls - think before each one. Stop when check_sweep reports every
point clean, or when the budget runs out (keep your best version in /{cell}.icl). Finish with one short
paragraph: final status and what was hard."""


# ----------------------------------------------------------------------------- one cell
class CellAgent:
    def __init__(self, lv, cell, args, run_dir, key, stats):
        self.lv, self.cell, self.args, self.key = lv, cell, args, key
        self.out = os.path.join(run_dir, cell["name"])
        self.ws = os.path.join(self.out, "workspace")
        os.makedirs(self.ws, exist_ok=True)
        self.res = {"cell": cell["name"], "tier": cell["tier"], "attempts": [], "nominal_clean": False}
        self.n_checks = 0
        self.n_sweeps = 0
        self.prev_code = None
        self.best = (None, None)
        self.stats = stats
        self.library = LIBRARY.get("lib")

    # --- tools -------------------------------------------------------------------
    def _path(self, path):
        p = os.path.normpath(os.path.join(self.ws, path.lstrip("/")))
        if not p.startswith(self.ws):
            raise ValueError("path outside the workspace")
        return p

    def tool_check(self, path: str) -> str:
        """Check a layout file: magic DRC + netgen LVS against the reference netlist (+ layout constraints).
        Returns the report with the statements/objects to fix. `path` is a workspace path like /nand2.icl."""
        if self.n_checks >= self.args.max_checks:
            return "CHECK BUDGET EXHAUSTED - stop now; your current file is your result."
        try:
            p = self._path(path)
        except ValueError as e:
            return str(e)
        if not os.path.exists(p):
            return f"no such file {path} - write it first"
        self.n_checks += 1
        k = self.n_checks
        code = open(p).read()
        shutil.copy(p, os.path.join(self.out, f"attempt{k}.icl"))
        pv = self.lv.nominal(self.cell)
        rep = self.lv.check(p, self.cell, pv, os.path.join(self.out, f"check{k}"))
        json.dump(rep, open(os.path.join(self.out, f"check{k}.json"), "w"), indent=1, default=str)
        sc = self.lv.score(rep)
        att = {"k": k, "status": rep.get("status"), "drc": rep.get("drc", {}).get("violations"),
               "lvs": rep.get("lvs", {}).get("match"), "score": sc, "error": (rep.get("error") or "")[:160],
               "t": time.time()}
        if self.lv.name == "l2":
            att["constraints_failed"] = sum(1 for r in rep.get("judge", {}).get("results", []) if not r["ok"])
        self.res["attempts"].append(att)
        if self.best[0] is None or sc <= self.best[0]:
            self.best = (sc, code)
        log(f"  {self.cell['name']:10s} check {k}: {rep.get('status')} drc={att['drc']} lvs={att['lvs']} "
            f"{att.get('error', '')[:70]}")
        if rep.get("status") == "CLEAN":
            fb = (f"CLEAN at the nominal point {pv}: DRC 0, LVS match" +
                  (", all layout constraints met" if self.lv.name == "l2" else "") +
                  ". Now call check_sweep on the same file.")
        else:
            fb = self.lv.feedback(rep, pv, code, self.prev_code)
            fb = fb.replace("(the attached image is your layout, DRC errors boxed in red) ", "")
            fb = fb.replace(" (the attached image is your layout)", "")
            if self.best[0] is not None and sc > self.best[0]:
                fb += (f"\nNOTE: this version scores worse ({sc}) than your best so far ({self.best[0]}); "
                       f"your best version is saved as /best.icl.")
                open(os.path.join(self.ws, "best.icl"), "w").write(self.best[1])
        self.prev_code = code
        open(os.path.join(self.out, f"feedback{k}.md"), "w").write(fb)
        return fb + f"\n[check_layout calls used: {self.n_checks}/{self.args.max_checks}]"

    def tool_sweep(self, path: str) -> str:
        """Run the check at every sweep point (L, widths, cell height). Call it after check_layout is CLEAN."""
        if self.n_sweeps >= 3:
            return "SWEEP BUDGET EXHAUSTED (3 calls) - stop now."
        try:
            p = self._path(path)
        except ValueError as e:
            return str(e)
        if not os.path.exists(p):
            return f"no such file {path}"
        self.n_sweeps += 1
        out = []
        for i, pv in enumerate(self.lv.points(self.cell)):
            rep = self.lv.check(p, self.cell, pv, os.path.join(self.out, f"agentsweep{self.n_sweeps}", f"p{i}"))
            out.append((pv, rep.get("status") == "CLEAN", "" if rep.get("status") == "CLEAN" else self.lv.sweep_problem(rep)))
        n = sum(1 for o in out if o[1])
        log(f"  {self.cell['name']:10s} agent sweep {self.n_sweeps}: {n}/{len(out)}")
        lines = [f"sweep: {n}/{len(out)} points clean"]
        lines += [f"  {pv}: {'CLEAN' if ok else prob}" for pv, ok, prob in out]
        self.sweep_ok = n == len(out)
        if n == len(out):
            lines.append("Every point is clean - you are done. Stop and give your final summary.")
        return "\n".join(lines)

    def tool_inspect(self, path: str) -> str:
        """Positions and sizes of every object in the layout, routes and warnings (no DRC/LVS)."""
        try:
            p = self._path(path)
        except ValueError as e:
            return str(e)
        cmd = [os.path.join(ROOT, "bin", "icl"), "inspect", p, "--top", self.cell["name"]]
        for k, v in self.lv.nominal(self.cell).items():
            cmd += ["--param", f"{k}={v}"]
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
        txt = (r.stdout + r.stderr).strip()
        return txt[:6000] + ("\n... (truncated)" if len(txt) > 6000 else "")

    def tool_search(self, query: str = "") -> str:
        """Search the reference library of verified cells. Empty query: the cells most similar to this task's
        transistor netlist. Otherwise a name or function fragment, e.g. 'nand3', 'mux', 'A1&A2'."""
        lib = self.library
        self.res["library_calls"] = self.res.get("library_calls", 0) + 1
        fam = self.cell.get("family")
        if not query.strip():
            hits = [(sc, n) for sc, n in lib.nearest(self.cell, 6)]
        else:
            hits = [(None, n) for n in lib.query(query, 10) if lib.cells[n]["spec"].get("family") != fam]
        if not hits:
            return "no library cell matches"
        return "\n".join(lib.summary(n, sc) for sc, n in hits) + \
            "\nget_library_cell(name) copies a cell's verified ICL into /library/<name>.icl."

    def tool_get(self, name: str) -> str:
        """Copy the verified ICL of library cell `name` into /library/<name>.icl and summarise it."""
        lib = self.library
        name = name.strip().removeprefix("/library/").removesuffix(".icl")
        if name not in lib.cells or lib.cells[name]["spec"].get("family") == self.cell.get("family"):
            return f"no library cell '{name}' (use search_library)"
        os.makedirs(os.path.join(self.ws, "library"), exist_ok=True)
        open(os.path.join(self.ws, "library", f"{name}.icl"), "w").write(lib.text(name))
        self.res.setdefault("library_cells_read", []).append(name)
        return f"/library/{name}.icl written. {lib.summary(name)}"

    # --- run ---------------------------------------------------------------------
    def run(self):
        from deepagents import create_deep_agent
        from deepagents.backends.filesystem import FilesystemBackend
        from langchain_core.callbacks import BaseCallbackHandler
        from langchain_core.tools import StructuredTool
        from langchain_openai import ChatOpenAI
        cell, args = self.cell, self.args
        for rel, txt in self.lv.docs().items():
            p = os.path.join(self.ws, rel)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            open(p, "w").write(txt)
        task_md = self.lv.task_md(cell)
        lib = self.library
        if lib is not None:
            near = lib.nearest(cell, max(args.examples, 1))
            self.res["library_nearest"] = [(n, round(sc, 3)) for sc, n in near]
            for sc, n in near[:args.examples]:
                open(os.path.join(self.ws, "examples", f"library_{n}.icl"), "w").write(lib.text(n))
            if args.examples:
                task_md += ("\n## Reference library\nVerified layouts of the most similar library cells (by transistor "
                            "structure; clean over the whole sweep) are in /examples/:\n" +
                            "".join(f"  /examples/library_{n}.icl  {lib.summary(n, sc)}\n" for sc, n in near[:args.examples]))
            task_md += ("search_library(query) finds more library cells: an empty query lists the cells most similar "
                        "to this task's netlist; a name or function fragment (e.g. 'nand', 'mux', 'A1&A2') searches by "
                        "name/function. get_library_cell(name) copies one into /library/<name>.icl.\n")
            if args.task == "edit":
                import libsearch
                sc, n = near[0]
                start, matched = libsearch.start_file(cell, n, lib)
                open(os.path.join(self.ws, f"{cell['name']}.icl"), "w").write(start)
                open(os.path.join(self.out, "start.icl"), "w").write(start)
                self.res["start_from"] = n
                self.res["start_matched"] = matched
                task_md += (f"\n## Start from the nearest library cell\n`/{cell['name']}.icl` already exists: the verified "
                            f"layout of library cell `{n}` ({lib.summary(n)}), with {cell['name']}'s device lines, "
                            f"parameters and ports put in. {matched} of its {len(lib.cells[n]['spec']['devices'])} "
                            "transistors correspond to transistors of this cell (net labels were renamed to match). "
                            "Edit it into the layout of this cell: add/remove gate columns, contact columns and li "
                            "connections so that the drawn transistors match the device lines, then check.\n")
        if args.examples and self.lv.name == "l1" and lib is None:
            import sticks
            import tasks
            near = tasks.similar(cell, self.lv.cells, args.examples)
            for c in near:
                open(os.path.join(self.ws, "examples", f"verified_{c['name']}.icl"), "w").write(sticks.draft_file(c))
            task_md += ("\nVerified layouts of similar cells (clean over the whole sweep) are in "
                        + ", ".join(f"/examples/verified_{c['name']}.icl" for c in near) + ".\n")
        elif args.examples and self.lv.name == "l2":
            import bench_l2 as B
            txt = B.retrieved(cell, args.examples)
            for m in re.finditer(r"Verified example `(\w+)`", txt):
                src = os.path.join(ROOT, "bench", "l2_ref", f"{m.group(1)}.icl")
                shutil.copy(src, os.path.join(self.ws, "examples", f"verified_{m.group(1)}.icl"))
            task_md += "\nVerified layouts of similar cells are in /examples/verified_*.icl.\n"
        if args.task == "repair":
            import tasks
            idx = [c["name"] for c in self.lv.cells].index(cell["name"])
            kind, broken, desc, _ = tasks.repair_case(cell, idx)
            self.res["mutation"] = kind
            open(os.path.join(self.ws, f"{cell['name']}.icl"), "w").write(broken)
            task_md += (f"\n## This is a REPAIR task\n`/{cell['name']}.icl` already exists: it was DRC and LVS clean "
                        "over the whole sweep until ONE edit broke it. Find the problem with check_layout and fix it, "
                        "keeping everything else.\n")
        elif args.task == "compact":
            import sticks
            draft = sticks.draft_file(cell)
            open(os.path.join(self.ws, f"{cell['name']}.icl"), "w").write(draft)
            d0 = os.path.join(self.out, "draft.icl")
            open(d0, "w").write(draft)
            r0 = self.lv.check(d0, cell, self.lv.nominal(cell), os.path.join(self.out, "draft_check"))
            self.res["draft_width"] = (r0.get("size_um") or [None])[0]
            self.res["hd_width"] = cell["hd_size_um"][0]
            task_md += (f"\n## This is a COMPACTION task\n`/{cell['name']}.icl` already exists: an automatic generator's "
                        f"layout, clean at every sweep point, {self.res['draft_width']} um wide. The SkyWater hd version of "
                        f"this cell is {cell['hd_size_um'][0]} um wide (without in-cell taps). Make the cell as NARROW as you "
                        "can (fewer `width` columns) while it stays clean over the whole sweep (check_sweep). If you "
                        "cannot get it clean narrower, restore a clean version before you stop.\n")
        open(os.path.join(self.ws, "TASK.md"), "w").write(task_md)
        model = ChatOpenAI(model=args.model, base_url=API, api_key=self.key, temperature=args.temperature,
                           max_tokens=16000, max_retries=6, timeout=600,
                           extra_body={"reasoning": {"max_tokens": args.reasoning}})
        agent_self = self

        class Counter(BaseCallbackHandler):
            raise_error = True                     # let the budget exception stop the agent

            def on_chat_model_start(self, serialized, messages, **kw):
                with LOCK:
                    agent_self.stats["calls"] += 1
                    agent_self.res["model_calls"] = agent_self.res.get("model_calls", 0) + 1
                    if agent_self.res["model_calls"] > args.max_calls:
                        raise Budget(f"model-call budget ({args.max_calls}) used up")
                    if agent_self.stats["calls"] > args.max_total_calls:
                        raise Budget("run-wide call budget used up")

            def on_llm_end(self, response, **kw):
                try:
                    u = response.llm_output.get("token_usage", {}) if response.llm_output else {}
                    with LOCK:
                        agent_self.res["tokens"] = agent_self.res.get("tokens", 0) + int(u.get("total_tokens", 0))
                except Exception:
                    pass
        tools = [StructuredTool.from_function(self.tool_check, name="check_layout"),
                 StructuredTool.from_function(self.tool_sweep, name="check_sweep"),
                 StructuredTool.from_function(self.tool_inspect, name="inspect_layout")]
        if self.library is not None:
            tools += [StructuredTool.from_function(self.tool_search, name="search_library"),
                      StructuredTool.from_function(self.tool_get, name="get_library_cell")]
        agent = create_deep_agent(model=model, tools=tools,
                                  system_prompt=SYSTEM.format(cell=cell["name"], checks=args.max_checks),
                                  backend=FilesystemBackend(root_dir=self.ws, virtual_mode=True))
        msg = (f"{'Repair' if args.task == 'repair' else 'Compact' if args.task == 'compact' else 'Build'} the cell "
               f"described in /TASK.md (`{cell['name']}`). Deliverable: /{cell['name']}.icl. "
               "Start by reading /TASK.md and /lessons.md.")
        t0 = time.time()
        final_text = ""
        messages = [{"role": "user", "content": msg}]
        self.res["nudges"] = 0
        try:
            while True:
                st = agent.invoke({"messages": messages},
                                  config={"recursion_limit": 4 * args.max_calls + 20, "callbacks": [Counter()]})
                messages = st["messages"]
                final_text = str(messages[-1].content)[:2000]
                self._dump_transcript(messages)
                todo = self._unfinished()
                if not todo or self.res["nudges"] >= args.nudges:
                    self.res["stop"] = "agent finished" if not todo else f"agent finished unfinished ({todo[:80]})"
                    break
                self.res["nudges"] += 1
                log(f"  {cell['name']:10s} nudge {self.res['nudges']}: {todo[:90]}")
                messages = list(messages) + [{"role": "user", "content":
                    f"You stopped, but the task is not finished: {todo} Continue working with the tools "
                    f"(budget left: {args.max_checks - self.n_checks} check_layout calls, "
                    f"{args.max_calls - self.res.get('model_calls', 0)} model calls). Do not stop until "
                    "check_sweep reports every point clean or the budget is used up."}]
        except Budget as e:
            self.res["stop"] = f"budget: {e}"
        except Exception as e:  # recursion limit, API errors ...
            self.res["stop"] = f"error: {repr(e)[:300]}"
        self.res["seconds"] = round(time.time() - t0)
        self.res["final_message"] = final_text
        return self.finish()

    def _unfinished(self):
        """What is still missing, from the harness's own records ('' when done or out of budget)."""
        if self.n_checks >= self.args.max_checks or self.res.get("model_calls", 0) >= self.args.max_calls - 2:
            return ""
        p = os.path.join(self.ws, f"{self.cell['name']}.icl")
        if not os.path.exists(p):
            return f"/{self.cell['name']}.icl does not exist yet - write it and call check_layout."
        last = self.res["attempts"][-1] if self.res["attempts"] else None
        if last is None:
            return "you never called check_layout on your file."
        if last["status"] != "CLEAN":
            return (f"the last check_layout reported {last['status']} (DRC {last.get('drc')}, LVS "
                    f"{'match' if last.get('lvs') else 'mismatch'}) - fix it and check again.")
        if not getattr(self, "sweep_ok", False):
            return "check_layout is CLEAN but check_sweep has not reported every point clean yet."
        return ""

    def _dump_transcript(self, messages):
        out = []
        for m in messages:
            d = {"type": m.type, "content": str(m.content)[:3000]}
            if getattr(m, "tool_calls", None):
                d["tool_calls"] = [{"name": c["name"], "args": {k: str(v)[:300] for k, v in c["args"].items()}}
                                   for c in m.tool_calls]
            out.append(d)
        json.dump(out, open(os.path.join(self.out, "transcript.json"), "w"), indent=1)

    def finish(self):
        """Harness-side verdict on the deliverable: nominal + sweep (independent of what the agent claims)."""
        cell = self.cell
        p = os.path.join(self.ws, f"{cell['name']}.icl")
        self.res["calls"] = self.res.get("model_calls", 0)
        self.res["checks"] = self.n_checks
        if not os.path.exists(p):
            self.res["final_status"] = "no file"
            return self.res
        final = os.path.join(self.out, f"{cell['name']}_final.icl")
        shutil.copy(p, final)
        rep = self.lv.check(final, cell, self.lv.nominal(cell), os.path.join(self.out, "final_nominal"))
        self.res["final_status"] = rep.get("status")
        if rep.get("status") != "CLEAN":
            # harness-side keep-best: fall back to the best version the agent itself checked clean
            clean = [a for a in self.res["attempts"] if a.get("status") == "CLEAN"]
            if not clean:
                return self.res
            k = clean[-1]["k"]
            shutil.copy(os.path.join(self.out, f"attempt{k}.icl"), final)
            rep = self.lv.check(final, cell, self.lv.nominal(cell), os.path.join(self.out, "final_nominal_best"))
            self.res["final_from_attempt"] = k
            if rep.get("status") != "CLEAN":
                return self.res
        self.res["nominal_clean"] = True
        ks = [a["k"] for a in self.res["attempts"] if a.get("status") == "CLEAN"]
        self.res["clean_at"] = ks[0] if ks else self.n_checks
        sw = []
        for i, pv in enumerate(self.lv.points(cell)):
            r = rep if i == 0 else self.lv.check(final, cell, pv, os.path.join(self.out, "final_sweep", f"p{i}"))
            sw.append({"params": pv, "clean": r.get("status") == "CLEAN",
                       "problem": "" if r.get("status") == "CLEAN" else self.lv.sweep_problem(r),
                       "size_um": r.get("size_um")})
        self.res["sweep"] = [sw]
        self.res["sweep_best"] = sum(x["clean"] for x in sw)
        self.res["final"] = final
        if self.args.task == "compact":
            w = (rep.get("size_um") or [None])[0]
            ok = self.res["sweep_best"] == len(sw)
            self.res["best_width"] = w if ok else self.res.get("draft_width")
            self.res["improved"] = bool(ok and w is not None and self.res.get("draft_width") and
                                        w < self.res["draft_width"] - 1e-6)
        log(f"  {cell['name']:10s} FINAL: nominal clean, sweep {self.res['sweep_best']}/{len(sw)} "
            f"({self.res['calls']} model calls, {self.n_checks} checks)")
        return self.res


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--level", type=int, default=1, choices=[1, 2])
    ap.add_argument("--task", default="scratch", choices=["scratch", "repair", "compact", "edit"],
                    help="level 1 only; edit = start from the nearest library cell (needs --library)")
    ap.add_argument("--bench", default="", help="spec file (default bench/cells.json), e.g. library/eval_specs.json")
    ap.add_argument("--library", default="", help="reference library variant (library/<variant>/), e.g. hd")
    ap.add_argument("--model", default="nvidia/nemotron-3.5-super-vl:free")
    ap.add_argument("--cells", default="")
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--max-calls", type=int, default=30, help="model calls per cell")
    ap.add_argument("--max-checks", type=int, default=10, help="check_layout calls per cell")
    ap.add_argument("--max-total-calls", type=int, default=450, help="model calls for the whole run")
    ap.add_argument("--reasoning", type=int, default=4000)
    ap.add_argument("--temperature", type=float, default=0.2)
    ap.add_argument("--examples", type=int, default=0, help="verified similar cells put into /examples")
    ap.add_argument("--nudges", type=int, default=3, help="continue an agent that stops before it is done")
    ap.add_argument("--tag", default="")
    args = ap.parse_args()
    if args.bench:
        os.environ["ICL_BENCH"] = os.path.abspath(args.bench)
    if args.task == "edit" and not args.library:
        sys.exit("--task edit needs --library")
    key = NS.load_key()
    llm = NS.LLM(key, args.model, 1, lambda r: None)          # refuses non-free models
    lv = L1() if args.level == 1 else L2()
    if args.library:
        import libsearch
        LIBRARY["lib"] = libsearch.Library(args.library)
    cells = [c for c in lv.cells if not args.cells or c["name"] in args.cells.split(",")]
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S") + f"-deep-L{args.level}" + \
        (f"-{args.task}" if args.task != "scratch" else "") + (f"-{args.tag}" if args.tag else "")
    run_dir = os.path.join(ROOT, "agents", "bench_runs", stamp)
    os.makedirs(run_dir, exist_ok=True)
    cfg = dict(vars(args), task=args.task if args.level == 1 else "l2", harness="deepagents",
               feedback="ranked", images="none", keep_best=True,
               lessons="lessons_stdcell_v3.md" if args.level == 1 else "lessons_l2.md")
    json.dump(cfg, open(os.path.join(run_dir, "config.json"), "w"), indent=1)
    log(f"run {stamp}: {len(cells)} cells, model {llm.info['id']} (deepagents), budgets {args.max_calls} calls / "
        f"{args.max_checks} checks per cell")
    stats = {"calls": 0}
    results = []
    with cf.ThreadPoolExecutor(max_workers=args.workers) as ex:
        futs = {ex.submit(CellAgent(lv, c, args, run_dir, key, stats).run): c for c in cells}
        for f in cf.as_completed(futs):
            c = futs[f]
            try:
                r = f.result()
            except Exception as e:
                r = {"cell": c["name"], "tier": c["tier"], "error": repr(e)[:300], "nominal_clean": False, "attempts": []}
                log(f"  {c['name']} crashed: {e!r}")
            results.append(r)
            json.dump({"config": cfg, "results": results, "api_calls": stats["calls"]},
                      open(os.path.join(run_dir, "results.json"), "w"), indent=1, default=str)
    log(f"done: {stats['calls']} model calls -> {run_dir}/results.json")


if __name__ == "__main__":
    from deepagents import register_harness_profile
    from deepagents.profiles.harness.harness_profiles import HarnessProfile
    register_harness_profile("openai", HarnessProfile(excluded_tools=frozenset({"execute"})))
    main()
