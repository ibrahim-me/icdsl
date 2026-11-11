# Reference library: results (2026-11-07)

## 1. Conversion (icdsl/lift.py, library conventions)

Every `sky130_fd_sc_hd` cell expressible at level 1 with up to 30 transistors (282 of 338), converted and
signed off at 5 sweep points (L 0.15 / 0.18 / 0.25, widths x1.25 @ H 3.26, x1.5 @ H 3.8) with magic DRC,
netgen LVS against the PDK netlist, the geometric judge and tiling (tap rules waived: tapless cells).

| result | cells |
|---|---|
| clean at every sweep point (used as the library) | **211 (75%)** |
| clean at some points | 31 |
| fails (mostly contacts at the step of a stepped diffusion) | 15 |
| not converted: KAPWR (lpflow) pins 8, row edges reorder over the sweep 8, own taps 7, other 2 | 25 |

By size: <= 8 transistors 50/60 clean, 9-14: 94/116, 15-22: 40/71, 23-30: 27/35. 76 of the 89 function
families have at least one clean member. The converted cells are a median 2 columns (0.92 um) wider than
the PDK cells: room reserved for L = 0.25 at every gate column. Median time per cell 27 s (4 in parallel).

Benchmark conventions (in-cell taps, widths x0.75, H 2.72), same 24 common cells: 5 clean at all 6 points
(inv, nand2, nand3, nand4, nor2), 16 clean only at the taller points, 1 fail, 2 not converted. The PDK cells'
li routing inside the diffusion rows needs the full PDK row height; at 0.75x it does not fit (exact
optimum of the anchor model, not a search failure).

## 2. Search

Structural nearest neighbours (own function family excluded), e.g. nand3 -> o211ai, nand4, nand2b;
mux2i -> o32ai, a32oi, xor2; maj3 -> ha; xnor2 -> o2bb2ai, xor2.

## 3. Agent comparison: does the library help?

Ten held-out cells (`library/eval_specs.json`, 6-14 transistors), library conventions. The task's own
function family is removed from the library for that task. Three conditions, everything else identical
(AGENTS.md, lessons, the two generic tapless examples inv_1 / nand2_1, ranked feedback, sweep tool):

* **A** no library
* **B** + the 2 structurally nearest library cells + search tools (whole library minus the family)
* **C** B + the deliverable starts as the nearest library cell (`libsearch.start_file`)

### Free model: nvidia/nemotron-3.5-super-vl:free (deepagents harness, 20 model calls / 8 checks per cell)

| | A | B | C |
|---|---|---|---|
| clean over the sweep | 0/10 | 0/10 | 0/10 |
| nominal clean | 0/10 | 0/10 | 0/10 |
| model calls | 182 | 183 | 183 |
| check_layout calls | 31 | 27 | 21 |

Closest attempt per cell (best LVS / DRC state reached):

| cell | A | B | C |
|---|---|---|---|
| a21oi | LVS x, DRC 34 | LVS x, DRC 110 | LVS x, DRC 26 |
| a31oi | no compile | LVS x, DRC 91 | no compile |
| o211ai | LVS ok, DRC 51 | LVS x, DRC 20 | LVS x, **DRC 0** |
| a22oi | LVS ok, DRC 64 | LVS x, DRC 145 | no compile |
| nor4 | LVS ok, DRC 212 | LVS ok, DRC 54 | LVS ok, DRC 107 |
| a2bb2oi | no compile | LVS x, DRC 32 | LVS x, DRC 32 |
| xnor2 | no compile | no compile | LVS x, DRC 123 |
| mux2i | LVS x, DRC 170 | LVS ok, DRC 222 | no compile |
| ha | (run cap) | no compile | no compile |
| maj3 | (run cap) | LVS x, DRC 136 | no compile |

The free model solves none of these tasks within 20 calls in any condition, so the library cannot show an
effect on success here. (In the earlier benchmark it reached 12/14 with 30 calls, tapped cells and
generator-style examples.) Its logs show why: the converted cells are written as explicit rectangles
anchored to `x1..` / `nb` / `pt`, while the lessons teach the generator's `cross` / `array ... left_of=`
style; the model mixes the two, and edits of a 60-line converted cell (C) often fail to compile. ha and maj3
in A got only 6 / 8 calls (the run-wide cap of 180 calls was reached).

### Claude Haiku 5.5 (subagents, ranked checker + sweep, same three conditions, 4 cells, one run each)

| cell | A | B | C |
|---|---|---|---|
| a21oi (6T) | clean 5/5, 6 runs, 5.0 min, 5 cols | clean, 5 runs, 5.0 min, 6 cols | clean, **4 runs, 3.2 min**, 5 cols (edited a211oi) |
| nor4 (8T) | clean, 6 runs, 4.8 min, 7 cols | clean, **3 runs, 3.8 min**, 6 cols | clean, 4 runs, 4.8 min, 8 cols (rewrote) |
| xnor2 (10T) | clean, 4 runs, 7.5 min, 9 cols | clean, 2 runs, 6.1 min, 10 cols | clean, **3 runs, 3.3 min**, 9 cols (edited o2bb2ai) |
| maj3 (14T) | clean, 14 runs, 9.9 min, 10 cols | clean, 10 runs, 11.7 min, 11 cols | clean, **5 runs, 7.5 min**, 18 cols (rewrote) |
| **total** | 4/4 clean, 30 checker runs, 27 min, 520k tokens | 4/4, 20 runs, 27 min, 550k tokens | 4/4, **16 runs, 19 min, 469k tokens** |

(checker runs = nominal checks + sweep runs; PDK widths 4 / 5 / 7 / 8 columns, converted references 5 / 6 / 9 / 10.)

* Haiku builds all four cells in every condition, so the library does not change success for it; it
  changes effort: checker runs 30 -> 20 (B) -> 16 (C), wall time 27 -> 19 minutes and tokens -10% with C.
* Editing the nearest cell pays off when it is a close relative: a21oi from a211oi (drop one input) and
  xnor2 from o2bb2ai (relabel two pairs of inputs, add two routes) were done in 3-4 checker runs. When the
  nearest cell is structurally further away (nor4 from a2111oi, maj3 from ha), the agent discarded the
  start file and wrote the cell from scratch; for maj3 that gave a much wider cell (18 columns).
* In B the agents mostly used the library cells for conventions (sizes, row heights, contact patterns);
  one (a21oi) used a211oi as a structural template. None ran the search script (one said it imports code
  outside its directory, which its rules discouraged).
* Rule deviations: haiku-A-maj3 wrote build output to the shared build/ directory, haiku-C-xnor2 copied a
  file to /tmp and removed it; neither read a solution.

Sample size: 4 cells x 1 run per condition - indicative, not significant.

### Changes made from these logs

* `libsearch.net_map` now allows several library nets to map to one target net (o2bb2ai's A1_N and B1 both
  become xnor2's A): o2bb2ai -> xnor2 is now a 10/10 correspondence (was 6/10), a211oi -> a21oi 6/8
  (was 5/8), and the start file lists which pieces must be joined by a route. (The C runs above used the
  old one-to-one version.)

### What would help next

1. Convert into the generator's dialect (`cross [nd, pd] poly`, `array licon in=nd left_of=g1`, `strap`)
   where the geometry allows, so library cells, lessons and examples speak one style (the free model's
   main confusion).
2. Only start from the nearest cell when the correspondence covers most of the target (e.g. >= 80% of the
   transistors); otherwise give it as an example only (nor4 / maj3 above).
3. Re-run the free model with 30 calls per cell and no run-wide cap (the daily free quota allowed 3 x 180).
