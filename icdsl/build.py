"""Shared elaboration machinery: Layout result, references used in expressions, transforms."""
from __future__ import annotations

from dataclasses import dataclass, field, replace

from . import tech as T
from .geom import Rect, Shape
from .syntax import ICLError, Point, Scope, did_you_mean

G = T.GRID

ORIENTS = ("R0", "MX", "MY", "R180")


def xform_rect(r: Rect, orient, dx, dy):
    if orient == "R0":
        q = r
    elif orient == "MX":      # mirror about the x axis (y -> -y)
        q = Rect(r.x0, -r.y1, r.x1, -r.y0)
    elif orient == "MY":      # mirror about the y axis (x -> -x)
        q = Rect(-r.x1, r.y0, -r.x0, r.y1)
    elif orient == "R180":
        q = Rect(-r.x1, -r.y1, -r.x0, -r.y0)
    else:
        raise ValueError(orient)
    return q.moved(dx, dy)


def xform_shape(s: Shape, orient, dx, dy, net=None, owner=None):
    return replace(s, rect=xform_rect(s.rect, orient, dx, dy),
                   net=s.net if net is None else net, owner=s.owner if owner is None else owner)


@dataclass
class Inst:
    name: str
    cell: "Layout"
    x: int = 0
    y: int = 0
    orient: str = "R0"
    conns: dict = field(default_factory=dict)     # child port -> parent net
    line: int = 0

    def map_net(self, n):
        if n is None:
            return None
        if n in self.conns:
            return self.conns[n]
        return f"{self.name}/{n}"

    def shapes(self):
        return [xform_shape(s, self.orient, self.x, self.y, net=self.map_net(s.net) if s.net else None,
                            owner=f"{self.name}/{s.owner}") for s in self.cell.all_shapes(True)]

    def port_shapes(self, port):
        return [xform_shape(s, self.orient, self.x, self.y, net=self.map_net(port)) for (n, d, s) in self.cell.ports
                if n == port]

    def bbox(self):
        return xform_rect(Rect(0, 0, self.cell.width, self.cell.height), self.orient, self.x, self.y)


@dataclass
class Layout:
    name: str
    kind: str = "cell"
    width: int = 0
    height: int = 0
    shapes: list = field(default_factory=list)
    ports: list = field(default_factory=list)       # (net, dir, Shape)
    labels: list = field(default_factory=list)      # (net, layer, x, y)
    insts: list = field(default_factory=list)       # Inst
    routes: dict = field(default_factory=dict)
    spice: str = ""
    subckts: list = field(default_factory=list)     # (name, text) of children, dependency order
    port_order: list = field(default_factory=list)
    power: str = ""
    ground: str = ""
    warnings: list = field(default_factory=list)
    grid: tuple = (0, 0)
    route_report: dict = field(default_factory=dict)
    info: dict = field(default_factory=dict)        # level-specific summary for `inspect`
    gds_path: str = ""                              # imported (foreign) blocks
    gds_cell: str = ""

    def all_shapes(self, flatten=True):
        out = list(self.shapes)
        if flatten:
            for ins in self.insts:
                out += ins.shapes()
        return out

    def bbox(self):
        return Rect(0, 0, self.width, self.height)


# ------------------------------------------------------------------ references
def _um(v):
    return round(v / 1000.0, 4)


class PinRef:
    def __init__(self, name, shapes, net=None):
        self.name, self.shapes, self.net = name, list(shapes), net

    def pin_shapes(self):
        return self.shapes

    def icl_xy(self):
        r = self.shapes[0].rect
        return Point(r.cx / 1000, r.cy / 1000)

    def icl_attr(self, a, line):
        if not self.shapes:
            raise ICLError(f"pin {self.name} has no geometry", line)
        r = self.shapes[0].rect
        bb = r
        for s in self.shapes[1:]:
            bb = bb.union(s.rect)
        m = {"x": _um(r.cx), "y": _um(r.cy), "left": _um(bb.x0), "right": _um(bb.x1), "bottom": _um(bb.y0),
             "top": _um(bb.y1), "cx": _um(bb.cx), "cy": _um(bb.cy), "net": self.net}
        if a in m:
            return m[a]
        raise ICLError(f"pin {self.name} has no attribute '{a}'", line, did_you_mean(a, m))

    def __repr__(self):
        return f"<pin {self.name}>"


class ObjRef:
    """A named thing that can be referenced: device array, instance, tap, block, shape."""
    def __init__(self, name, kind, getbbox, pins=None, extra=None):
        self.name, self.kind, self._bbox = name, kind, getbbox
        self.pins = pins or (lambda: {})
        self.extra = extra or {}

    def bbox(self):
        return self._bbox()

    def icl_attr(self, a, line):
        bb = self.bbox()
        geo = {"left": bb.x0, "right": bb.x1, "bottom": bb.y0, "top": bb.y1, "cx": bb.cx, "cy": bb.cy,
               "w": bb.w, "h": bb.h}
        if a in geo:
            return _um(geo[a])
        if a in self.extra:
            v = self.extra[a]
            return v() if callable(v) else v
        pins = self.pins()
        if a in pins:
            return pins[a]
        raise ICLError(f"{self.kind} '{self.name}' has no attribute or pin '{a}'", line,
                       did_you_mean(a, list(geo) + list(pins) + list(self.extra)) or
                       f"pins: {', '.join(pins) or '-'}")

    def icl_xy(self):
        bb = self.bbox()
        return Point(bb.cx / 1000, bb.cy / 1000)

    def __repr__(self):
        return f"<{self.kind} {self.name}>"


class BuildScope(Scope):
    def __init__(self, grid=G):
        super().__init__()
        self.grid = grid

    def call(self, fn, args, line):
        if fn == "grid":
            if len(args) != 2:
                raise ICLError("grid(c, r) takes two numbers", line)
            return Point(args[0] * self.grid / 1000, args[1] * self.grid / 1000)
        return super().call(fn, args, line)


def subckt_texts(lay):
    """All subcircuit definitions needed by `lay`, children first, then lay itself."""
    out = []
    for (n, txt) in lay.subckts:
        if all(n != m for m, _ in out):
            out.append((n, txt))
    out.append((lay.name, lay.spice))
    return out
