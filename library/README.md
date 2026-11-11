# ICL reference library

A standard-cell library (GDS + SPICE, optionally LEF / Liberty) turned into verified, editable ICL, and
the tools that let an agent use it. Built here from `sky130_fd_sc_hd` (437 cells, 338 expressible at
level 1); the same pipeline takes any SKY130 library laid out in the usual two-row style.

```
bench/hd_spec.py              task specs for every cell (both conventions, see below)
icdsl/lift.py                 1. GDS + SPICE -> ICL `stdcell` (the converter)
library/build_library.py      lift + sign off every cell -> library/<variant>/<cell>.icl + index.json
agents/libsearch.py           2. search by circuit structure / name / function; start files for 3.
agents/deep_harness.py        --library hd: retrieval + search_library / get_library_cell tools
                              --task edit: 3. start from the nearest library cell
```

## 1. The converter (`icdsl/lift.py`)

    .venv/bin/python -m icdsl.lift a21oi_1 --variant hd -o a21oi_1.icl

1. Reads the cell (flattened, merged per layer) and its labels; finds transistors (poly & diff) and the
   connectivity (licon / mcon / via), and matches it to the SPICE netlist (labels fix the ports, a
   backtracking device match names the internal nets). Mismatch = not lifted.
2. Covers every polygon with a few overlapping maximal rectangles.
3. Writes every coordinate relative to the cell's structure:
   * **x** from the gate columns `x1 .. xn` (`x2 = x1 + L + 0.28`): overlapping n/p gates (jogged poly)
     share one stretch point, so a longer L widens every gate by exactly dL and moves what is right of it;
     5 nm is added beside every gate because the PDK cells use the standard-cell-area rule licon.11a
     (0.05 um) and plain ICL cells are checked with licon.11 (0.055 um).
   * **y** from the row edges: `nb` (n row bottom), `nb + WN..` (n tops), `pt - WP..` (p bottoms), `pt`,
     the rails `0` / `H`. An edge between two row edges follows one of them; the choice is made for all
     edges at once by an integer program (HiGHS via scipy, local search as fallback) that minimises the
     number of sweep points with a predicted violation (width, spacing incl. corners, enclosure, endcap,
     overlaps that carry a connection), then the number of violations.
   * contact columns become `array licon in=<diff> cx=... span=(<own li bottom>, <own li top>)`: as many
     cuts as fit where the column's own li crosses the diffusion (`span=` is a new `array` key).
4. Pins: on the labelled li (library conventions) or as an mcon + met1 pad placed legally over the whole
   sweep (benchmark conventions).

Two conventions:

| variant | cell | widths | sweep | checked with |
|---|---|---|---|---|
| `hd` (library) | tapless (`taps=no`, bodies VNB/VPB tied by the row's tap cells) | PDK | L 0.15/0.18/0.25, widths x1.25 @ H 3.26, x1.5 @ H 3.8 | tap rules LU.2/LU.3/nwell.4 waived |
| `bench` | in-cell taps (the old benchmark) | x0.75 | 6 points incl. widths x0.85 @ 2.72 | everything |

The library uses `hd`. Most PDK cells cannot keep their li routing when the rows shrink to 0.75x to make
room for in-cell taps at 2.72 um (e.g. a21oi's p row stacks a Y strip, an n2 strip and the VPWR landing
in 1.0 um; at 0.75 um that does not fit), so the `bench` variant is clean mainly for simple cells
(inv, nand2/3/4, nor2) and clean only at the taller sweep points for the rest.

## Building and checking the library

    .venv/bin/python bench/hd_spec.py                      # library/hd_specs.json + library/lib_specs.json
    .venv/bin/python library/build_library.py --variant hd --max-dev 30 --jobs 4

Each cell is signed off at every sweep point with `bench/agent_check.py --sweep` (magic DRC, netgen LVS
against the PDK netlist, the geometric judge, tiling next to copies of itself). Only cells clean at every
point are used for retrieval. Results: `library/hd/index.json` (status, sweep points, notes).

## 2. Search (`agents/libsearch.py`)

    .venv/bin/python agents/libsearch.py nand3_1           # nearest cells by structure
    .venv/bin/python agents/libsearch.py --query mux       # by name / Liberty function

The netlist becomes a graph (devices nmos/pmos, nets supply/input/output/internal, edges gate or
source/drain); three Weisfeiler-Lehman rounds give a bag of local-structure labels; similarity = cosine x
sqrt(size ratio). Pin names and widths do not matter. The target's own function family (drive
strengths and inverted-input variants: nand4, nand4b, nand4bb) is never returned, so retrieval cannot
hand the agent its own answer.

In the agent harness (`--library hd`): the K nearest cells go to `/examples/library_<cell>.icl` with a
summary (transistors, pins, Liberty function), and two tools are added:
`search_library(query)` (empty query = most similar to the task) and `get_library_cell(name)`.

## 3. Edit the nearest cell (`--task edit`)

The deliverable starts as the nearest library cell: the target's name, parameters, device lines and
ports are put in, the library geometry is kept, and net labels are renamed through the largest
consistent transistor correspondence between the two netlists (`libsearch.net_map`, a small
maximum-common-subgraph search that may merge several library nets into one target net, e.g. o2bb2ai's
A1_N and B1 into xnor2's A - the start file then says which pieces to join with `route`); labels without
a counterpart are removed and missing ports are left as TODO comments.

## Results

See `library/RESULTS.md` (library build statistics and the agent comparison).

---

## 4. How to learn the library's footprint and pin conventions (not built yet)

Goal: use the library to fix the three limits that remain in the language and the generator:

* rows (`cell` + `row`) give clean cells, but not in the 2.72 um standard-cell frame;
* the router cannot always reach pins in dense standard cells (maj3, one Sonnet sweep point);
* the stick generator (`agents/sticks.py`) cannot route the 18T latch (dlxtp) or the 28T full adder (fa).

Everything below reuses what 1.-3. already compute: `Extract` (devices, nets, gate columns),
`Source` (shapes per layer), `libsearch` (nearest cell, net correspondence).

### 4a. Measure the footprint (`library/footprint.py`, new)

From the LEF (`SITE unithd 0.46 x 2.72`, `PIN ... RECT`), the tech LEF (tracks: li1 0.46 x 0.34 offset
0.23 / 0.17, met1 0.34 offset 0.17, met2 0.46 offset 0.23) and the lifted geometry, collect per cell and
as distributions over the library:

| quantity | where it comes from |
|---|---|
| rail widths (met1 +-0.24, li +-0.085), n-well bottom (1.305), row edges `nb` (0.235) / `pt` (2.485) | `Source` regions |
| gate pitch, the three gap kinds between gates (shared contact, series node, diffusion break) | `Mapper.lefts`, contact groups |
| gate-contact row: y of the poly pads relative to `nb + WN` (e.g. +0.11 .. +0.44) | poly / licon cuts in the middle band |
| pin positions: on which li track crossing (x = 0.23 + 0.46k, y = 0.17 + 0.34k) each pin label sits | `Source.labels` + track grid |
| how often outputs are a vertical li strap vs a routed net, and where it sits relative to the last gate | li rects of the output net |

Check: the numbers reproduce the PDK cells (re-derive `nb`, `pt`, the n-well edge and the pin grid for
>95% of cells), and print the outliers.

### 4b. A `frame=` option for the row template (`icdsl/lib_rows.py`)

`cell X frame=sky130_hd` (or `frame=<json from 4a>`): height 2.72 (or 2 x 2.72), tapless, met1/li rails as
measured, the n row placed with its bottom at `nb` and the p row with its top at `pt`, gate contacts in
the measured band, ports snapped to li track crossings. `_place_y` takes the row edges from the frame
instead of stacking rows from y = 0; `_wells_taps_rails` draws the frame's well edge and no taps.
Acceptance: the existing row examples (inv, nand2, dff) compile inside the frame, are DRC/LVS clean with
the tap rules waived, and tile with the PDK cells (place them next to `pdk:sky130_fd_sc_hd__*` in a
floorplan and run DRC on the row).

### 4c. Pin access from the library's pin patterns (`icdsl/router.py`, `lib_geom._pin_access`)

The PDK cells put every signal pin on li at a track crossing, with met1 above it free. Use 4a's pin
statistics to (1) make the pin-access check test exactly those crossings (today it tests a 0.23 grid),
(2) reserve, in `Router.reserve_access`, the met1 segment above each pin crossing before routing
internal nets, and (3) give the agent the measured pin grid in the feedback ("put pin A at x=0.23+0.46k,
y=0.17+0.34k"). Acceptance: maj3 and the Sonnet sweep point that failed on pin access route clean, and
the 11-cell regression stays clean.

### 4d. Transistor order from the nearest library cell (`agents/sticks.py`)

`sticks.plan()` searches gate orders itself (all permutations up to 7 columns, then gives up). Instead:
take the nearest library cell (`Library.nearest`), map its gate-column order onto the target with
`libsearch.net_map`, and use that order (and its n/p diffusion sharing) as the plan; fall back to the
search when fewer than ~80% of the transistors correspond. For cells too large for the search (dlxtp 18T,
fa 28T) the library cell of the same structure gives the order directly. Acceptance: `sticks.py`
produces sweep-clean drafts for dlxtp and fa, and its drafts for the other cells are no wider than now.

### 4e. Measure

* generator coverage: cells of the library with a sweep-clean draft (now: the 14 + 2 benchmark cells);
* width of the generator's drafts vs the PDK cells (the compaction benchmark);
* the agent comparison of `library/RESULTS.md` re-run with frame-aware tasks (`--bench` with a frame).
