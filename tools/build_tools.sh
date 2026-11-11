#!/usr/bin/env bash
# Build magic + netgen (user-local, no sudo) and fetch the PDKs: sky130A, gf180mcu, freepdk45.
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

# The second DRC judge is the PDK's KLayout deck. It needs the klayout program (0.30 was used) on PATH
# or as tools/install/bin/klayout; the pip module above is not enough. Without it that check is left
# out: only magic DRC and LVS run, and the report has no KLayout line.
command -v klayout > /dev/null || [ -x "$PREFIX/bin/klayout" ] || \
    echo "note: no klayout program found; the KLayout DRC decks will not run (install KLayout 0.30 or later)"
