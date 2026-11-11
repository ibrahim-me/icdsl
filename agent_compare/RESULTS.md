# ICL vs raw GDS, drawn by Claude subagents (2026-11-06)

12 runs = {Sonnet 5.5, Haiku 5.5} x {ICL language + tools, raw GDS via Python/KLayout} x
{nand3, a21oi (standard cells), ota5t_small (5T OTA, interdigitated pairs, area <= 70 um2)}.
Same task brief and the same checker (`bench/agent_check.py`: magic DRC, netgen LVS against the
reference netlist, geometric judge) in both conditions; the raw runs also got a rule summary and the
GDS layer map. Final files re-scored independently (`agent_compare/score.py`); every final LVS has
equivalent pin lists.

| task | Sonnet + ICL | Sonnet raw | Haiku + ICL | Haiku raw |
|---|---|---|---|---|
| nand3 | clean, 5 checks, 12 tools, 61k tok, 2.6 min, 2.30 um, tiles OK | clean, 5 checks, 17 tools, 72k, 4.2 min, 2.30 um, tiles OK | clean, 2 checks, 22 tools, 126k, 6.5 min, 2.76 um, tiles OK | clean, 3 checks, 11 tools, 114k, 5.3 min, 2.30 um, **tiling: 11 DRC** |
| a21oi | clean, 1 check, 8 tools, 67k, 3.3 min, 2.30 um, tiles OK | clean, 3 checks, 7 tools, 79k, 5.1 min, **1.84 um**, **tiling: 8 DRC** | clean, 4 checks, 16 tools, 207k, 12.7 min, 3.68 um, tiles OK | clean, 1 check, 6 tools, 137k, 7.0 min, 2.76 um, **tiling: 2 DRC** |
| ota5t_small | clean, 1 check, 6 tools, 45k, 0.7 min, 45.4 um2 | clean, 4 checks, 10 tools, 75k, 4.3 min, **22.8 um2** | clean, 1 check, 7 tools, 48k, 0.5 min, 60.9 um2 | clean, 2 checks, 4 tools, 125k, 6.2 min, 40.0 um2 |
| total | 3/3, 173k tokens, 6.6 min | 3/3, 226k, 13.6 min | 3/3, 381k, 19.7 min | 3/3, 376k, 18.5 min |

(minutes = agent wall time; "checks" = runs of the shared checker - the ICL runs also used `bin/icl
check` for feedback; tiling = the cell placed next to a copy and a mirrored copy, magic DRC on the row.)

Parameter sweep (only possible for the ICL files - raw GDS is fixed geometry; the agents were not
asked to be parametric): OTA 4/4 for both models; standard cells nand3 4/6 and 4/6, a21oi 1/6 (Sonnet)
and 3/6 (Haiku).

Findings
* Both models produced clean layouts for every task in both conditions: for small cells, a strong model
  does not need the language to get DRC/LVS clean (unlike the free models, where the language + feedback
  is what made it work at all).
* ICL saved effort for Sonnet: about half the time and 25% fewer tokens; for Haiku the cost was about
  equal (one long ICL a21oi run).
* Raw layouts were smaller (OTA 23-40 vs 45-61 um2, Sonnet's a21oi 1.84 vs 2.30 um) - hand-placed
  coordinates are tighter than the generators' margins.
* But 3 of the 4 raw standard cells break when tiled with their neighbours (n-well / implants
  overhanging the cell edge, edge spacing), all ICL cells tile cleanly - the template enforces a proper
  cell frame. Raw cells also cannot follow W/L changes.
* Raw drawing needed knowledge the ICL tools hide: magic only extracts ports from the pin datatype
  (68/16), not from 68/5 labels. My brief was wrong about this; Sonnet found it alone twice, the other
  raw runs got a correction mid-run.

Caveats: one run per cell (no variance estimate); small cells; Haiku ICL OTA printed a forbidden example
file once (says unused); concurrent ICL runs shared the default `build/` directory (one crashed
`bin/icl check`, scoring unaffected).
Language issues the ICL runs reported: `xspace=` silently ignored on `cross`; arithmetic after
`max(...)` needs parentheses; `bin/icl check` default output dir collides between parallel runs.
