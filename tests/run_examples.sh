#!/usr/bin/env bash
# Regression: every example cell must be DRC + LVS clean (magic + netgen).
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0
while read -r f top lvl; do
  [[ -z "$f" || "$f" == \#* ]] && continue
  out=$("$HERE/bin/icl" check "$HERE/$f" --top "$top" --out "$HERE/build/$top" 2>&1); code=$?
  printf "%-12s %-14s " "$lvl" "$top"; echo "$out" | head -1
  [ $code -ne 0 ] && { echo "$out" | head -30; fail=1; }
done < "$HERE/tests/examples.txt"
exit $fail
