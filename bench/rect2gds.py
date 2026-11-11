#!/usr/bin/env python3
"""Raw-coordinate layout format -> GDS (no layout language, no code execution).

    rect  <layer> x0 y0 x1 y1             drawn rectangle, um
    label <layer> x y NAME                net name (text on the layer's label datatype)
    pin   <layer> x0 y0 x1 y1 NAME        port: pin rectangle + text on the pin datatype (+ label)
    # comment

layers: nwell diff tap poly licon npc nsdm psdm li mcon met1 via met2 (met1 = m1, met2 = m2)
    python bench/rect2gds.py cell.rect cell.gds TOPNAME
"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)
import klayout.db as kdb  # noqa: E402

from icdsl import tech as T  # noqa: E402

ALIAS = {"met1": "m1", "met2": "m2", "met3": "m3"}


def convert(src, dst, top):
    ly = kdb.Layout()
    ly.dbu = 0.001
    c = ly.create_cell(top)
    errors = []
    for n, line in enumerate(open(src), 1):
        t = line.split("#")[0].split()
        if not t:
            continue
        try:
            kind, lay = t[0], ALIAS.get(t[1], t[1])
            if lay not in T.GDS:
                raise ValueError(f"unknown layer '{t[1]}'")
            L, D = T.GDS[lay]
            if kind == "rect":
                x0, y0, x1, y1 = (round(float(v) * 1000) for v in t[2:6])
                if x1 <= x0 or y1 <= y0:
                    raise ValueError("empty rectangle (need x0 < x1, y0 < y1)")
                c.shapes(ly.layer(L, D)).insert(kdb.Box(x0, y0, x1, y1))
            elif kind == "label":
                x, y = (round(float(v) * 1000) for v in t[2:4])
                c.shapes(ly.layer(L, 5)).insert(kdb.Text(t[4], kdb.Trans(x, y)))
            elif kind == "pin":
                x0, y0, x1, y1 = (round(float(v) * 1000) for v in t[2:6])
                c.shapes(ly.layer(L, 16)).insert(kdb.Box(x0, y0, x1, y1))
                tx = kdb.Text(t[6], kdb.Trans((x0 + x1) // 2, (y0 + y1) // 2))
                c.shapes(ly.layer(L, 16)).insert(tx)
                c.shapes(ly.layer(L, 5)).insert(tx)
            else:
                raise ValueError(f"unknown record '{kind}' (rect / label / pin)")
        except (ValueError, IndexError) as e:
            errors.append(f"line {n}: {e}: {line.strip()}")
    ly.write(dst)
    return errors


if __name__ == "__main__":
    errs = convert(sys.argv[1], sys.argv[2], sys.argv[3])
    print("\n".join(errs) if errs else f"wrote {sys.argv[2]}")
