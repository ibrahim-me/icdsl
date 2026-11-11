```python
from icdsl.canvas import *
tech = use()
c0, c1, c2, c3, c4, c5 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4, tech.conductor(5)
top_metal = tech.stack[-1]

# ---- netlist-driven placement (64 unit MIM caps, binary-weighted bottom plates) ----
TOP = from_spice("netlist.spice")

# ---- post-route cleanup: merge same-net metal into rectangles, drop redundant vias ----
for inst in TOP.instances.values():
    cell = inst.cell
    if not hasattr(cell, "_merged"):
        cell._merged = True
        for layer in (c1, c2, c3, c4, c5):
            shapes = [s for s in cell.shapes.get(layer, []) if s.net]
            by_net = {}
            for s in shapes:
                by_net.setdefault(s.net, []).append(s)
            for net, ss in by_net.items():
                if len(ss) > 1:
                    x0 = min(s.left for s in ss); y0 = min(s.bottom for s in ss)
                    x1 = max(s.right for s in ss); y1 = max(s.top for s in ss)
                    cell.rect(layer, x0=x0, y0=y0, x1=x1, y1=y1, net=net)
                    for s in ss:
                        cell.shapes[layer].remove(s)
        for layer in (c0, c1, c2, c3, c4):
            cuts = [s for s in cell.shapes.get(layer, []) if s.net]
            by_net = {}
            for s in cuts:
                by_net.setdefault(s.net, []).append(s)
            for net, ss in by_net.items():
                kept = []
                for s in ss:
                    if not any(s != t and t.left <= s.left and t.bottom <= s.bottom and t.right >= s.right and t.top >= s.top for t in ss):
                        kept.append(s)
                for s in ss:
                    if s not in kept:
                        cell.shapes[layer].remove(s)

# ---- ensure top-level ports exist on the correct nets ----
have = {p.net for p in TOP.ports}
for net in ("TOP", "B0", "B1", "B2", "B3", "VSS", "B4", "B5"):
    if net not in have:
        shapes = [s for inst in TOP.instances.values() for s in inst.cell.all_shapes() if s.net == net]
        if shapes:
            s = max(shapes, key=lambda s: s.w * s.h)
            TOP.port(net, on=s)
``````python
from icdsl.canvas import *
tech = use()
c0, c1, c2, c3, c4, c5 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4, tech.conductor(5)

TOP = from_spice("netlist.spice")

# Merge same-net metal shapes into rectangles and drop redundant via stacks
for inst in TOP.instances.values():
    cell = inst.cell
    if getattr(cell, "_merged", False):
        continue
    cell._merged = True
    for layer in (c1, c2, c3, c4, c5):
        shapes = [s for s in cell.shapes.get(layer, []) if s.net]
        by_net = {}
        for s in shapes:
            by_net.setdefault(s.net, []).append(s)
        for net, ss in by_net.items():
            if len(ss) > 1:
                x0 = min(s.left for s in ss); y0 = min(s.bottom for s in ss)
                x1 = max(s.right for s in ss); y1 = max(s.top for s in ss)
                cell.rect(layer, x0=x0, y0=y0, x1=x1, y1=y1, net=net)
                for s in ss:
                    cell.shapes[layer].remove(s)
    for layer in (c0, c1, c2, c3, c4):
        cuts = [s for s in cell.shapes.get(layer, []) if s.net]
        by_net = {}
        for s in cuts:
            by_net.setdefault(s.net, []).append(s)
        for net, ss in by_net.items():
            kept = [s for s in ss if not any(
                s != t and t.left <= s.left and t.bottom <= s.bottom and t.right >= s.right and t.top >= s.top
                for t in ss)]
            for s in ss:
                if s not in kept:
                    cell.shapes[layer].remove(s)

have = {p.net for p in TOP.ports}
for net in ("TOP", "B0", "B1", "B2", "B3", "VSS", "B4", "B5"):
    if net not in have:
        shapes = [s for inst in TOP.instances.values() for s in inst.cell.all_shapes() if s.net == net]
        if shapes:
            TOP.port(net, on=max(shapes, key=lambda s: s.w * s.h))
```