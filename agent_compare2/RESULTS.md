# Hard tasks: raw GDS vs ICL vs ICL + techniques (2026-11-06)

Tasks (each with a verified reference solution): `maj3` (14T majority, sky130_fd_sc_hd netlist),
`ha` (14T half adder, two outputs) - standard cells that must also tile; `folded_cascode` (11T, five
matched groups + output keep-out) and `comp_latch` (19T StrongARM + SR latch, 9 mirror-symmetric pairs).
Conditions: **raw** (draw GDS coordinates; rule summary + layer map), **icl0** (ICL: AGENTS.md + one basic
example, plain checker), **icl1** (ICL + techniques: lessons file, 2 verified similar cells, ranked
diagnosis, sweep command, inspect, keep-best). Same task text and the same checker (`bench/agent_check.py`:
magic DRC, netgen LVS vs. the reference, geometric judge, tiling for standard cells) for every run; final
files re-scored independently (`score.py`, `claude_scores.txt`). Sweep = ICL files only (raw is fixed).

## Claude subagents (24 runs)

| | raw GDS | ICL, no techniques | ICL + techniques |
|---|---|---|---|
| **Sonnet 5.5** clean | 4/4 | 4/4 | 4/4 |
| Sonnet sweep points clean | - | 15/20 | 18/20 |
| Sonnet tokens / minutes (4 tasks) | 393k / 27.6 | 244k / 9.0 | 266k / 14.8 |
| Sonnet maj3 / ha width (um) | 7.82 / 7.36 | 5.52 / 5.06 | 5.52 / 7.36 |
| **Haiku 5.5** clean | **2/4** (maj3: gave up after drawing the frame; ha: 191 DRC) | 4/4 | 4/4 |
| Haiku sweep points clean | - | 14/20 | **20/20** |
| Haiku tokens / minutes (4 tasks) | 670k / 63.8 | 402k / 17.6 | 344k / 15.4 |
| Haiku maj3 / ha width (um) | fail / fail | 9.66 / 6.90 | **5.06** / 5.52 |

Reading it:
* **vs raw GDS** - Sonnet can draw all four from coordinates, but needs ~3x the time and 1.6x the tokens of
  ICL and its standard cells come out wider (7.82 vs 5.52 um for maj3). Haiku fails both dense standard
  cells in raw (it ran out of routing tracks in the 2.72 um frame - one gave up, one spent its time in a
  brute-force track search) and solves all four in ICL. The language matters more the weaker the model
  and the denser the cell; analog blocks were drawable raw by both.
* **with vs without techniques** - no difference in nominal success for Claude (all 8 ICL runs clean either
  way), but a clear one in quality: parametric robustness (Haiku 14/20 -> 20/20 sweep points, Sonnet 15 ->
  18), smaller cells for Haiku (maj3 9.66 -> 5.06 um), fewer tokens for Haiku. The icl0 sweep failures
  are hard-coded geometry (clean at L=0.15, DRC at L=0.18/0.25) - exactly what the lessons + sweep tool fix.

## What limited the agents (from their logs) and what was changed
| seen in | limitation | change |
|---|---|---|
| Haiku icl1 maj3 | router left a 0.05-0.075 um met1 sliver at L=0.18/0.25 | router: sliver repair after routing (grow to min width where legal, close the notches it creates) |
| Sonnet icl0 maj3 | `enclose [gc1, gc2, gc3] poly` = one rectangle shorting all gates (silent) | compile error with hint for conductor layers |
| Haiku icl0 ha | `wire path=[...]` ending on a pin by coordinate got no via | vias added automatically at wire ends lying on a same-net shape |
| Sonnet icl0/icl1 comp_latch | latch-up (diff > 15 um from a tap) only at W x2, seen as an opaque DRC | compile-time latch-up check: error naming the device + warning near the limit |
| Sonnet raw maj3 | checker misread a 5 nm-dbu GDS | judge normalises any database unit |
| Sonnet raw folded_cascode | inputs wired only on li -> metal keep-out check vacuous | judge measures li too |
| Sonnet icl1 ha | router cannot reach pins at WN=0.42 next to a hand-placed output pad | open: pin access in dense cells is the main remaining tool limit |
| Haiku raw maj3 / ha | gave up early / spent the budget searching | harness: a model must not stop without a checked file (nudges, as for Nemotron) |

## All three models (12 runs each)

| tasks clean (of 4) | raw GDS | ICL, no techniques | ICL + techniques |
|---|---|---|---|
| Sonnet 5.5 | 4 | 4 | 4 |
| Haiku 5.5 | 2 (both dense std cells fail) | 4 | 4 |
| Nemotron 3.5 super VL (free) | **0** | 2 (analog only) | 2 (analog only); **3** with docs preloaded (icl2) |

| ICL sweep points clean (clean files only) | no techniques | + techniques |
|---|---|---|
| Sonnet | 15/20 | 18/20 |
| Haiku | 14/20 | 20/20 |
| Nemotron | 7/8 | 8/8 |

Nemotron details (deepagents harness `agents/deep_compare.py`, budget 35 model calls / 12 checks per task;
raw uses the rect/label/pin text format of `bench/rect2gds.py`; scores in `nemotron_scores.txt`):
* raw: 0/4 - hundreds of DRC errors and LVS failures at the end of every budget (e.g. maj3 631 DRC).
* ICL: both analog blocks clean with and without techniques; with techniques both also sweep-clean and the
  folded cascode 2.7x smaller (196 vs 533 um2). Dense standard cells (14T) fail in both ICL conditions:
  with techniques ha reached DRC 0 / LVS mismatch, maj3 ended on a compile error.
* Limits seen in the logs: most of the call budget went into reading the reference / lessons / examples
  and planning (icl1 ha: 36 calls, only 2 checks); single-strip outputs (`port X out` with nothing to
  route); `row ... gap=min` crashed the tool (now fixed); strap alignment and inverted-coordinate
  errors. The model also tried building the half adder from `row`s (higher abstraction) and got it
  DRC/LVS clean once the crash was fixed - but rows do not produce the 2.72 um standard-cell frame.

## Supplementing what limited Nemotron (icl2)
The logs showed the call budget going into reading files. **icl2** = icl1 + the task, the language
reference (levels 1/2/4 + failure table) and the lessons put straight into the system prompt (no reading
calls needed), 60 calls / 15 checks, plus the tool fixes from the logs (row `gap=min` crash, an exact fix
in the "no routed metal" port error). Re-run on the two standard cells Nemotron had failed:

| Nemotron | icl0 | icl1 | **icl2** |
|---|---|---|---|
| ha (14T half adder) | fail (334 DRC) | fail (DRC 0, LVS mismatch) | **CLEAN, sweep 6/6**, 5.52 um, 46 calls |
| maj3 (14T majority) | fail | fail (compile error) | fail (DRC 0 / LVS mismatch at best; 2 nets the router could not reach) |

First dense 14-transistor standard cell completed by the free model. maj3's remaining problem is the one
also seen for Sonnet: router pin access in a dense cell (an output route blocking two gate contacts) - the
main open tool limit.

## Do the changes help?
* The language vs raw coordinates: yes, and the weaker the model the more - Sonnet 4/4 either way (ICL ~3x
  faster, cheaper, narrower cells), Haiku 2/4 -> 4/4, Nemotron 0/4 -> 2/4.
* Techniques on top of the language: not in nominal pass rate on these tasks (Claude is at the ceiling,
  Nemotron fails the same two dense cells), but clearly in quality: parametric robustness (Haiku 14 -> 20
  of 20 sweep points), smaller cells, fewer tokens for Haiku. On the 14-cell L1 suite earlier, techniques
  were what took Nemotron from 3/14 to 11-12/14.
