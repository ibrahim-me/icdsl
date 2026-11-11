"""Extra benchmark tasks built on the verified algorithmic drafts.

repair  - a clean cell with ONE realistic bug injected (the kinds of mistakes seen in model runs);
          the model gets the broken file + its check report and must make it clean again.
retrieval library - verified cells (leave-one-out) used as worked examples for a target cell.
"""
from __future__ import annotations

import re

import sticks

MUTATIONS = ["strap", "cb", "gap", "route", "ext"]


def mutate(code, kind):
    """Return (broken_code, description) or None if the mutation does not apply."""
    lines = code.splitlines()
    if kind == "strap":
        for i, l in enumerate(lines):
            if re.search(r"=\s*strap li from=\w+ to=v(gnd|pwr)_li", l):
                return "\n".join(lines[:i] + lines[i + 1:]) + "\n", "a supply strap was deleted"
    if kind == "cb":
        for i, l in enumerate(lines):
            m = re.match(r"(\s*cb = max\()(.*)$", l)
            if m:
                pd = re.search(r"\b(pd\d+)\b", code)
                if not pd:
                    return None
                lines[i] = f"{m.group(1)}{pd.group(1)}.bottom - 0.05, {m.group(2)}"
                return "\n".join(lines) + "\n", "the gate-contact height uses a p-row term"
    if kind == "gap":
        for i, l in enumerate(lines):
            if "max(0.28, 0.54 - L)" in l and "rect poly" in l:
                lines[i] = l.replace("max(0.28, 0.54 - L)", "0.2", 1)
                return "\n".join(lines) + "\n", "one gate was moved too close to its neighbour"
    if kind == "ext":
        for i, l in enumerate(lines):
            if "rect diff xspan=(" in l and ".left - 0.265" in l:
                lines[i] = l.replace(".left - 0.265", ".left - 0.18", 1)
                return "\n".join(lines) + "\n", "a diffusion end was shortened"
    if kind == "route":
        for i, l in enumerate(lines):
            if re.match(r"\s*route \w+", l) and not re.search(r"port \w+ out\s*(#.*)?$", lines[i - 1] if i else ""):
                net = l.split()[1]
                if any(re.match(rf"\s*port {net} out\s*(#.*)?$", x) for x in lines):
                    continue                     # the port relies on this route: removing it breaks compile
                return "\n".join(lines[:i] + lines[i + 1:]) + "\n", f"the route of net {net} was deleted"
    return None


def repair_case(cell, idx):
    """Pick a mutation for this cell (rotating over the kinds, skipping ones that do not apply)."""
    draft = sticks.draft_file(cell)
    for j in range(len(MUTATIONS)):
        kind = MUTATIONS[(idx + j) % len(MUTATIONS)]
        r = mutate(draft, kind)
        if r:
            return kind, r[0], r[1], draft
    return None


def library(cells):
    return {c["name"]: sticks.draft_file(c) for c in cells}


def similar(cell, cells, k):
    def feat(c):
        return (len(c["devices"]), len(c["inputs"]), bool(c["internal_nets"]), c["tier"])
    f0 = feat(cell)

    def dist(c):
        f = feat(c)
        return abs(f[0] - f0[0]) + abs(f[1] - f0[1]) + 2 * (f[2] != f0[2]) + 0.5 * abs(f[3] - f0[3])
    return sorted([c for c in cells if c["name"] != cell["name"]], key=dist)[:k]
