# spiral - octagonal spiral inductor

A planar octagonal spiral inductor on the top metal of the stack.
* at least 3 full turns, every edge horizontal, vertical or at 45 degrees (and some at 45 degrees);
* trace width at least 4.0 um everywhere (only a dead end of at most 4 um2 that sticks out of the
  trace, such as the pad of the via at the inner end, may be narrower);
* the inner end is brought out underneath the turns on the metal below the top metal (via + underpass)
  to outside the coil;
* all the metal is one net; label it `L`.
There is no netlist: the judge checks DRC and the geometry (one open coil without closed loops, the
number of turns counted from the centre, the width, the underpass).

**Top cell name:** `spiral`
**PDKs:** sky130A, gf180mcuD, freepdk45. A solution must be made per PDK.

| PDK | netlist | area budget (bounding box) | reference area |
|---|---|---|---|
| sky130A | - | 10465 um2 | 66.4 x 78.8 um |
| gf180mcuD | - | 10465 um2 | 66.4 x 78.8 um |
| freepdk45 | - | 10465 um2 | 66.4 x 78.8 um |

## What counts as solved
1. The GDS is clean under the PDK's magic `drc(full)` deck and under the PDK's own KLayout DRC deck
   (die-level rules such as density are waived).
2. The geometry checks listed above pass.
3. The bounding box of the top cell is within the area budget (2 x the reference layout).

Any way of producing the GDS is allowed (raw GDS, a canvas script, ICL, another generator). Top-level
pins are text labels on the pin metal. Judge a submission with

    .venv/bin/python bench/xl/judge.py spiral <pdk> <submission.gds | script.py | file.icl>
