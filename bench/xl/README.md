# XL benchmark: larger layouts, three PDKs

Eight layout tasks, to be solved on **sky130A** (130 nm), **gf180mcuD** (180 nm) and **freepdk45**
(45 nm): 22 cases. They replace "can the model draw a NAND" with "can the model deliver a block":
hundreds of transistors, arrays, passives, matched analog, and one shape that is not Manhattan.

| task | what | devices | why it is in the set |
|---|---|---|---|
| `rca8` | 8-bit ripple-carry adder, mirror full adders | 224 MOS | hierarchy, carry chain across rows |
| `dec4to16` | 4-to-16 decoder | 168 MOS | wide fan-out, many crossing nets |
| `shreg16` | 16-bit shift register, clocked-inverter master-slave flip-flops | 352 MOS | clock distribution, split poly gates |
| `sram16x8` | 16 x 8 6T SRAM array | 768 MOS | dense array, shared bit lines / word lines |
| `r2r8` | 8-bit R-2R ladder | 25 poly resistors | passive devices, guard ring |
| `cdac6` | 6-bit binary-weighted capacitor array | 64 MIM capacitors | unit-cell matching, upper metals |
| `ota_miller` | two-stage Miller OTA | 30 MOS fingers + R + C | mixed devices, multi-finger, guard rings |
| `spiral` | octagonal spiral inductor (3 turns or more) with underpass | none | 45 degree geometry, thick top metal |

freepdk45 has only MOS devices. `r2r8` and `cdac6` do not exist there, and its `ota_miller` uses
MOS-only compensation (a triode nmos as the zero-nulling resistor, an 8-finger MOS capacitor): 39 MOS
fingers. `task.json` lists the PDKs of each task.

The previous benchmarks in `bench/` stop at 28 transistors, use one PDK and only 1.8 V MOS.

## Files

```
tasks/<task>/task.md          the task as given to a model
tasks/<task>/task.json        machine-readable: pins, area budgets, device counts, netlist files
tasks/<task>/<pdk>.spice      the netlist to implement (per PDK: model names and sizes differ)
ref/<task>.py                 reference solution: one PDK-neutral canvas script per task
reference.json, REFERENCE.md  reference results (area, time, device and shape counts)
judge.py                      the judge
make_tasks.py                 regenerates tasks/ and the reference tables from ref/
gallery/                      GDS and PNG of the reference layouts
```

## Judging

```
.venv/bin/python bench/xl/judge.py TASK PDK SUBMISSION [--out DIR] [--json] [--detail]
     SUBMISSION = a .gds (top cell named like the task), a canvas .py script, or an .icl file (sky130A)
     --detail     also the violated rules with example boxes (um) and the LVS difference
     exit 0 solved / 1 not solved / 2 the submission could not be built or read
```

Solved means all of:

1. **DRC**: clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (two independent judges; die-level density / fill rules are waived, the judge lists them).
2. **LVS**: netgen matches the extracted layout against the task netlist (devices, W / L,
   connectivity, pin names). Hierarchy and internal net names are free.
3. **Pins**: every pin of the task exists as a label on a conductor.
4. **Area**: bounding box within 2 x the reference layout.

`spiral` has no devices, so LVS is replaced by geometry checks: one hole-free coil polygon on the top
metal, 45 degree edges and no other off-axis angle, trace width, at least 3 turns, and an underpass
on a lower metal joined to the inner end by a cut. Trace width means: shrunk by half the width, the
coil is still one piece (a neck cuts it, and so does a place where two parts only meet at a corner,
which both DRC decks accept), and what the shrinking removes for good is at most a dead end of
4 um2, such as the pad of the via at the inner end. Until 2026-11-11 every narrower spot of the
polygon counted, also such a pad; `agents/README.md` has what that changed in the stored runs.

The interface is not part of the task: raw GDS from any generator, a canvas script or ICL are all
accepted. That is deliberate, so that interfaces can be compared on the same tasks.

## Not judged

Matching quality (common centroid, interleaving), guard rings beyond what DRC / latch-up rules
require, parasitics, antenna, density, electromigration. The task texts mark such items as "good
practice, not judged".

## Reference results

See `REFERENCE.md`. All 22 cases are clean; each builds and verifies in 3.4 to 16 s (most of it is
the KLayout deck). The reference solutions were written by hand through the canvas interface. They
prove that every task is solvable on every PDK from one script; they are **not** an LLM result.

### Gallery

The reference layouts as built (`gallery/`: one PNG and one GDS per case; `make_gallery.sh` refreshes them
from `build/`). Each PDK has its own colours and its own scale.

| task | sky130A | gf180mcuD | freepdk45 |
|---|---|---|---|
| `rca8` | <a href="gallery/rca8.sky130A.png"><img src="gallery/rca8.sky130A.png" width="230"></a> | <a href="gallery/rca8.gf180mcuD.png"><img src="gallery/rca8.gf180mcuD.png" width="230"></a> | <a href="gallery/rca8.freepdk45.png"><img src="gallery/rca8.freepdk45.png" width="230"></a> |
| `dec4to16` | <a href="gallery/dec4to16.sky130A.png"><img src="gallery/dec4to16.sky130A.png" width="230"></a> | <a href="gallery/dec4to16.gf180mcuD.png"><img src="gallery/dec4to16.gf180mcuD.png" width="230"></a> | <a href="gallery/dec4to16.freepdk45.png"><img src="gallery/dec4to16.freepdk45.png" width="230"></a> |
| `shreg16` | <a href="gallery/shreg16.sky130A.png"><img src="gallery/shreg16.sky130A.png" width="230"></a> | <a href="gallery/shreg16.gf180mcuD.png"><img src="gallery/shreg16.gf180mcuD.png" width="230"></a> | <a href="gallery/shreg16.freepdk45.png"><img src="gallery/shreg16.freepdk45.png" width="230"></a> |
| `sram16x8` | <a href="gallery/sram16x8.sky130A.png"><img src="gallery/sram16x8.sky130A.png" width="230"></a> | <a href="gallery/sram16x8.gf180mcuD.png"><img src="gallery/sram16x8.gf180mcuD.png" width="230"></a> | <a href="gallery/sram16x8.freepdk45.png"><img src="gallery/sram16x8.freepdk45.png" width="230"></a> |
| `r2r8` | <a href="gallery/r2r8.sky130A.png"><img src="gallery/r2r8.sky130A.png" width="230"></a> | <a href="gallery/r2r8.gf180mcuD.png"><img src="gallery/r2r8.gf180mcuD.png" width="230"></a> | - |
| `cdac6` | <a href="gallery/cdac6.sky130A.png"><img src="gallery/cdac6.sky130A.png" width="230"></a> | <a href="gallery/cdac6.gf180mcuD.png"><img src="gallery/cdac6.gf180mcuD.png" width="230"></a> | - |
| `ota_miller` | <a href="gallery/ota_miller.sky130A.png"><img src="gallery/ota_miller.sky130A.png" width="230"></a> | <a href="gallery/ota_miller.gf180mcuD.png"><img src="gallery/ota_miller.gf180mcuD.png" width="230"></a> | <a href="gallery/ota_miller.freepdk45.png"><img src="gallery/ota_miller.freepdk45.png" width="230"></a> |
| `spiral` | <a href="gallery/spiral.sky130A.png"><img src="gallery/spiral.sky130A.png" width="230"></a> | <a href="gallery/spiral.gf180mcuD.png"><img src="gallery/spiral.gf180mcuD.png" width="230"></a> | <a href="gallery/spiral.freepdk45.png"><img src="gallery/spiral.freepdk45.png" width="230"></a> |

## The netlist tasks without drawing (`from_netlist.py`)

Seven of the eight tasks come with a netlist, and the canvas has a netlist level
(`from_spice`, CANVAS.md section 8). `from_netlist.py` is three lines, `TOP = from_spice(<task netlist>)`,
with nothing task-specific, and it is judged solved in all 19 netlist cases:

| task | sky130A | gf180mcuD | freepdk45 | style |
|---|---|---|---|---|
| rca8 | 1.02 | 1.03 | 1.06 | cells |
| dec4to16 | 1.01 | 1.01 | 0.93 | cells |
| shreg16 | 1.30 | 1.33 | 1.36 | cells |
| sram16x8 | 1.00 | 1.00 | 1.00 | cells |
| r2r8 | 0.55 | 0.86 | - | rows |
| cdac6 | 1.02 | 1.02 | - | rows |
| ota_miller | 1.28 | 1.27 | 1.17 | rows |

(area as a multiple of the hand-written reference; `tests/run_canvas.sh` checks all 19.)

```
XL_TASK=rca8 bin/icl build bench/xl/from_netlist.py --pdk sky130A --out build/nl
.venv/bin/python bench/xl/judge.py rca8 sky130A build/nl/rca8.gds
```

## LLM results

`agents/README.md`, section "XL benchmark", has the runs (one free model, 4 attempts per case,
`agents/xl_harness.py`):

| state | canvas | raw `klayout.db` | ICL (sky130A, 4 cases it can express) |
|---|---|---|---|
| before the netlist level existed | 1 / 22 | 0 / 22 | 2 / 4 |
| netlist level for logic (v2) | 12 / 22 | | |
| plus device rows and "choose the level first" (v4, v5) | 15 to 18 / 22 | | |
| plus feedback that names the netlist level (v6) | 20 / 22 | | |

Two runs of the same setup differ by two or three cases, and two corrections were made after
results were seen (which code block of a reply is judged; the spiral width rule). That file gives
the as-run and the corrected number for each.

## What this benchmark no longer measures, and the next tier

With `from_spice`, a model that answers a netlist task with three lines is done. That is the point
of the tool, but it means 19 of the 22 cases now measure one decision (take the netlist level or
draw by hand), not layout skill. Free drawing is measured by `spiral` only.

A second tier should ask for what the netlist does not say, judged on the GDS like everything else:

- pin sides and pin order on the outline (labels on a named edge, in a given order),
- a fixed outline or aspect ratio and an area budget near 1.2 x instead of 2 x,
- matching that is checked: mirror symmetry of two named devices about an axis, common centroid of
  the unit capacitors of `cdac6`, interdigitation of the input pair of `ota_miller`,
- shapes without a netlist: pad ring, seal ring, a transmission line with ground shields, a
  comb capacitor, each with a geometric check like the one `spiral` has.

None of this exists yet. The rows style of `from_spice` places devices in netlist order with no
matching, so these tasks would need work on top of it (`mos_strip`, `guard_ring`, `place`).

## Regenerate / verify

```
.venv/bin/python bench/xl/make_tasks.py [task ...]    # rebuild references, netlists, budgets, task files
bash tests/run_canvas.sh                              # references + judge accept / reject checks
```
