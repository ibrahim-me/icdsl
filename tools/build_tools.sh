#!/usr/bin/env bash
# Build magic + netgen (user-local, no sudo) and fetch the PDKs: sky130A, gf180mcu, freepdk45, asap7.
# GCC >= 15 defaults to C23, which rejects these code bases' old-style prototypes -> force gnu17.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFIX="$HERE/tools/install"
mkdir -p "$HERE/tools/src" && cd "$HERE/tools/src"
[ -d magic ]  || git clone --depth 1 https://github.com/RTimothyEdwards/magic.git
[ -d netgen ] || git clone --depth 1 https://github.com/RTimothyEdwards/netgen.git
(cd magic  && CFLAGS="-O2 -std=gnu17" ./configure --prefix="$PREFIX" --disable-opengl && make -j4 && make install)
(cd netgen && CFLAGS="-O2 -std=gnu17 -Wno-incompatible-pointer-types" ./configure --prefix="$PREFIX" && make -j4 && make install)
cd "$HERE"
[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -q klayout ciel
.venv/bin/ciel enable --pdk-root "$HERE/pdk" --pdk-family sky130 -l sky130_fd_pr -l sky130_fd_sc_hd \
    792ef67037d74c8c51811eab3ce23cf793491296

# The two other PDKs of the canvas (CANVAS.md). Skip them if only sky130A is wanted.
.venv/bin/ciel enable --pdk-root "$HERE/pdk" --pdk-family gf180mcu -l gf180mcu_fd_pr -l gf180mcu_fd_sc_mcu7t5v0 \
    792ef67037d74c8c51811eab3ce23cf793491296
FP45=784b1a483a5f4de362d6f3629378de1199453f3c
.venv/bin/ciel fetch --pdk-root "$HERE/pdk" --pdk-family freepdk45 "$FP45"
ln -sfn "ciel/freepdk45/versions/$FP45/freepdk45" "$HERE/pdk/freepdk45"

# ASAP7 (7 nm FinFET): three files of the asap7 platform of OpenROAD-flow-scripts at a pinned commit -
# the KLayout DRC deck (BSD 2-Clause), the layer properties and the standard-cell GDS. No magic tech and
# no LVS deck exist for it; the canvas uses the deck, KLayout extraction and netgen (pdks/asap7.py).
A7=92833249ee88a3381523ede3f8573db798e3c32a
A7URL="https://raw.githubusercontent.com/The-OpenROAD-Project/OpenROAD-flow-scripts/$A7/flow/platforms/asap7"
mkdir -p "$HERE/pdk/asap7"
while read -r sum path; do
    f="$HERE/pdk/asap7/$(basename "$path")"
    [ -f "$f" ] || curl -fsSL -o "$f" "$A7URL/$path"
    echo "$sum  $f" | sha256sum -c --quiet -
done <<'EOF'
03e5360a65e9eab38225306c2249cc3103c34fb55960ae9973252f9c4a6fb97f drc/asap7.lydrc
17c77abf34dc2b186d22dc84e5e0dc3810909137a553a85dd6aaddb77922bb04 KLayout/asap7.lyp
f43d5b33df635cf9e66cbca66b6bdd05364f824d8040cd21528b9e12808b9263 gds/asap7sc7p5t_28_R_220121a.gds
EOF

# The second DRC judge is the PDK's KLayout deck. It needs the klayout program (0.30 was used) on PATH
# or as tools/install/bin/klayout; the pip module above is not enough. Without it that check is left
# out: only magic DRC and LVS run, and the report has no KLayout line.
command -v klayout > /dev/null || [ -x "$PREFIX/bin/klayout" ] || \
    echo "note: no klayout program found; the KLayout DRC decks will not run (install KLayout 0.30 or later)"
