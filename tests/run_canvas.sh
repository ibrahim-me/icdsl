#!/bin/bash
# Canvas regression: every canvas test, example and XL benchmark reference on every described PDK
# (magic DRC + the foundry KLayout deck + netgen LVS), then the judge on its own references and on two wrong submissions.
#   bash tests/run_canvas.sh            exit 0 = everything as expected
cd "$(dirname "$0")/.." || exit 2
PDKS="sky130A gf180mcuD freepdk45"
# a benchmark task exists on a PDK when its task.json lists that PDK (freepdk45 has no resistor / MIM)
has() { [ ! -f "bench/xl/tasks/$1/task.json" ] || grep -q "\"$2\"" "bench/xl/tasks/$1/task.json"; }
fail=0
for f in examples/canvas/*.py tests/canvas/*.py bench/xl/ref/*.py; do
  for p in $PDKS; do
    case "$f" in bench/xl/ref/*) has "$(basename "$f" .py)" "$p" || continue ;; esac
    r=$(bin/icl check "$f" --pdk "$p" 2>&1 | grep -E "^result|^ERROR" | head -1)
    case "$r" in "result: CLEAN"*) s=ok ;; *) s=FAIL; fail=1 ;; esac
    printf "%-4s %-28s %-10s %s\n" "$s" "$f" "$p" "$(echo "$r" | cut -c1-40)"
  done
done
# asap7 (7 nm FinFET): its own cells - the device grids differ from a planar PDK, so the generic scripts
# above do not apply. Judges: the ASAP7 KLayout deck, KLayout extraction, netgen LVS. Skipped when the
# deck is not installed (pdk/asap7/asap7.lydrc).
if [ -f pdk/asap7/asap7.lydrc ]; then
  for f in tests/asap7/*.py; do
    r=$(bin/icl check "$f" --pdk asap7 2>&1 | grep -E "^result|^ERROR" | head -1)
    case "$r" in "result: CLEAN"*) s=ok ;; *) s=FAIL; fail=1 ;; esac
    printf "%-4s %-28s %-10s %s\n" "$s" "$f" asap7 "$(echo "$r" | cut -c1-40)"
  done
  # wrong layouts must be rejected: gates of n and p not joined (GATE.S.1), two actives one gate pitch too
  # close (ACTIVE.S.2A), the m2 feedback wire missing (LVS)
  tmp=$(mktemp -d)
  sed 's/^LO, HI = .*/LO, HI = 0.0, 0.0/' tests/asap7/ringosc.py > "$tmp/gates.py"
  sed 's/^(i2,), y2, x = stage(x, /(i2,), y2, x = stage(x - 0.054, /' tests/asap7/ringosc.py > "$tmp/close.py"
  sed 's/^c.rect("m2", .*$/pass/' tests/asap7/ringosc.py > "$tmp/nom2.py"
  for v in "gates GATE.S.1" "close ACTIVE.S.2A" "nom2 MISMATCH"; do
    set -- $v
    if bin/icl check "$tmp/$1.py" --pdk asap7 --out "$tmp/o_$1" 2>&1 | grep -q "$2"; then s=ok; else s=FAIL; fail=1; fi
    printf "%-4s asap7 rejects ringosc variant %-6s (%s)\n" "$s" "$1" "$2"
  done
  rm -rf "$tmp"
else
  echo "skip asap7: pdk/asap7/asap7.lydrc not installed"
fi
J=".venv/bin/python bench/xl/judge.py"
for t in bench/xl/tasks/*/; do
  t=$(basename "$t")
  for p in $PDKS; do
    has "$t" "$p" || continue
    if $J "$t" "$p" "build/$t.$p/$t.gds" > /dev/null 2>&1; then s=ok; else s=FAIL; fail=1; fi
    printf "%-4s judge %-22s %-10s (reference GDS must be accepted)\n" "$s" "$t" "$p"
  done
done
# netlist level: every task that is a netlist, straight from its task netlist (from_spice: stick cells for the
# logic tasks, device rows for the analog ones), judged like any submission
for t in rca8 dec4to16 shreg16 sram16x8 r2r8 cdac6 ota_miller; do
  for p in $PDKS; do
    has "$t" "$p" || continue
    XL_TASK=$t bin/icl build bench/xl/from_netlist.py --pdk "$p" --out "build/nl.$t.$p" > /dev/null 2>&1
    r=$($J "$t" "$p" "build/nl.$t.$p/$t.gds" --out "build/nl.$t.$p/judge" 2>&1 | tail -1)
    case "$r" in *": SOLVED"*) s=ok ;; *) s=FAIL; fail=1 ;; esac
    printf "%-4s from_spice %-17s %-10s %s\n" "$s" "$t" "$p" "$(echo "$r" | sed 's/.*SOLVED *//')"
  done
done
# wrong submissions must be rejected
tmp=$(mktemp -d)
sed 's/CIN="CIN" if i == 0 else f"k{i}"/CIN="CIN" if i == 0 else f"k{max(i - 1, 1)}"/' bench/xl/ref/rca8.py > "$tmp/rca8_bad.py"
$J rca8 sky130A "$tmp/rca8_bad.py" --out "$tmp/o1" > /dev/null 2>&1; [ $? -eq 1 ] && s=ok || { s=FAIL; fail=1; }
printf "%-4s judge rejects a mis-wired adder\n" "$s"
cat > "$tmp/meander.py" <<'PY'
from icdsl.canvas import *
tech = use()
c = Cell("spiral")
pts = []
for i in range(6):
    pts += [(i * 8.0, 0), (i * 8.0, 40)] if i % 2 == 0 else [(i * 8.0, 40), (i * 8.0, 0)]
c.port("L", on=c.path(tech.stack[-1], pts, 4.0, net="L"))
TOP = c
PY
$J spiral gf180mcuD "$tmp/meander.py" --out "$tmp/o2" > /dev/null 2>&1; [ $? -eq 1 ] && s=ok || { s=FAIL; fail=1; }
printf "%-4s judge rejects a meander as a spiral\n" "$s"
# spiral width: a via pad sticking out of the inner end is a dead end and is not counted; a 6 um long
# 1.6 um wide tail is a narrow trace
TR='coil = c.path(top_m, pts, W, net="L")'
sed "s/^$TR\$/$TR\nc.rect(top_m, x0=X0 - 1.25, x1=X0, y0=-A0 - 0.8, y1=-A0 + 0.8, net=\"L\")/" bench/xl/ref/spiral.py > "$tmp/stub.py"
sed "s/^$TR\$/$TR\nc.rect(top_m, x0=X0 - 6.0, x1=X0, y0=-A0 - 0.8, y1=-A0 + 0.8, net=\"L\")/" bench/xl/ref/spiral.py > "$tmp/tail.py"
grep -q "X0 - 1.25" "$tmp/stub.py" && $J spiral sky130A "$tmp/stub.py" --out "$tmp/o3" > /dev/null 2>&1 && s=ok || { s=FAIL; fail=1; }
printf "%-4s judge accepts a via pad sticking out of the spiral's end\n" "$s"
grep -q "X0 - 6.0" "$tmp/tail.py" && { $J spiral sky130A "$tmp/tail.py" --out "$tmp/o4" > /dev/null 2>&1; [ $? -eq 1 ]; } && s=ok || { s=FAIL; fail=1; }
printf "%-4s judge rejects a narrow tail on the spiral\n" "$s"
# a block that meets the lead only at a corner leaves a 2.83 um throat: both DRC decks pass it, the judge must not
sed "s/^TOP = c\$/c.rect(top_m, x0=x_out, x1=x_out + 6.0, y0=y_end - P - 2.0, y1=y_end - P + 2.0, net=\"L\")\nTOP = c/" bench/xl/ref/spiral.py > "$tmp/throat.py"
grep -q "x_out + 6.0" "$tmp/throat.py" && { $J spiral sky130A "$tmp/throat.py" --out "$tmp/o5" > /dev/null 2>&1; [ $? -eq 1 ]; } && s=ok || { s=FAIL; fail=1; }
printf "%-4s judge rejects spiral parts that only meet at a corner\n" "$s"
rm -rf "$tmp"
[ $fail -eq 0 ] && echo "canvas regression: all ok" || echo "canvas regression: FAILURES"
exit $fail
