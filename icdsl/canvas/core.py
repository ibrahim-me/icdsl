"""Canvas core: cells, shapes on any PDK layer, hierarchy with arrays, relative placement.

Everything is plain Python, so loops, functions and data structures are the "macro language".
Coordinates are micrometres in the API and integer nanometres inside.
"""
from __future__ import annotations

import os
import sys

from . import tech as T

_PKG = os.path.dirname(os.path.abspath(__file__))


class CanvasError(Exception):
    def __init__(self, msg, hint=None):
        self.hint = hint
        super().__init__(msg + (f"\n  hint: {hint}" if hint else ""))


def _src():
    """(file, line) of the first caller outside this package: the statement that drew the shape."""
    f = sys._getframe(1)
    while f is not None:
        fn = f.f_code.co_filename
        if not fn.startswith(_PKG):
            return (fn, f.f_lineno)
        f = f.f_back
    return ("?", 0)


# --------------------------------------------------------------------------- geometry handles
class Geo:
    """Anything with a bounding box. Edges in um: left right bottom top cx cy w h center."""
    __slots__ = ("x0", "y0", "x1", "y1")

    def __init__(self, x0, y0, x1, y1):
        self.x0, self.y0, self.x1, self.y1 = int(x0), int(y0), int(x1), int(y1)

    left = property(lambda s: s.x0 / 1000.0)
    right = property(lambda s: s.x1 / 1000.0)
    bottom = property(lambda s: s.y0 / 1000.0)
    top = property(lambda s: s.y1 / 1000.0)
    cx = property(lambda s: (s.x0 + s.x1) / 2000.0)
    cy = property(lambda s: (s.y0 + s.y1) / 2000.0)
    w = property(lambda s: (s.x1 - s.x0) / 1000.0)
    h = property(lambda s: (s.y1 - s.y0) / 1000.0)
    center = property(lambda s: (s.cx, s.cy))
    bbox = property(lambda s: (s.left, s.bottom, s.right, s.top))

    def nmbox(self):
        return (self.x0, self.y0, self.x1, self.y1)


class Rect(Geo):
    __slots__ = ("layer", "net", "src", "tag")

    def __init__(self, layer, x0, y0, x1, y1, net=None, src=None, tag=None):
        super().__init__(min(x0, x1), min(y0, y1), max(x0, x1), max(y0, y1))
        self.layer, self.net, self.src, self.tag = layer, net, src, tag

    def __repr__(self):
        n = f" net={self.net}" if self.net else ""
        return f"<{self.layer} [{self.left:g},{self.bottom:g} .. {self.right:g},{self.top:g}]{n}>"


class Poly(Geo):
    __slots__ = ("layer", "pts", "net", "src", "tag")

    def __init__(self, layer, pts, net=None, src=None, tag=None):
        xs, ys = [p[0] for p in pts], [p[1] for p in pts]
        super().__init__(min(xs), min(ys), max(xs), max(ys))
        self.layer, self.pts, self.net, self.src, self.tag = layer, [tuple(p) for p in pts], net, src, tag

    def __repr__(self):
        return f"<{self.layer} polygon {len(self.pts)} pts bbox {self.bbox}>"


class Group(Geo):
    """A bounding box around several things (device handles, via stacks ...)."""

    def __init__(self, items):
        items = [i for i in items if i is not None]
        super().__init__(min(i.x0 for i in items), min(i.y0 for i in items),
                         max(i.x1 for i in items), max(i.y1 for i in items))


_ORIENT = {  # name -> (rotation quarter turns, mirror about x axis first)
    "R0": (0, False), "R90": (1, False), "R180": (2, False), "R270": (3, False),
    "MX": (0, True), "MXR90": (1, True), "MY": (2, True), "MYR90": (3, True),
}


def _xf(orient, x, y):
    rot, mir = _ORIENT[orient]
    if mir:
        y = -y
    for _ in range(rot):
        x, y = -y, x
    return x, y


class Ref(Geo):
    """A placed instance (or nx x ny array) of another cell."""

    def __init__(self, parent, cell, x, y, orient, nx, ny, dx, dy, name, conns, src):
        self.parent, self.cell, self.x, self.y, self.orient = parent, cell, x, y, orient
        self.nx, self.ny, self.dx, self.dy = nx, ny, dx, dy
        self.name, self.conns, self.src = name, conns, src
        b = cell.nmbbox()
        xs, ys = [], []
        for (px, py) in ((b[0], b[1]), (b[2], b[3]), (b[0], b[3]), (b[2], b[1])):
            tx, ty = _xf(orient, px, py)
            xs.append(tx)
            ys.append(ty)
        super().__init__(x + min(xs), y + min(ys), x + max(xs) + (nx - 1) * dx, y + max(ys) + (ny - 1) * dy)

    def map(self, g, ix=0, iy=0):
        """A shape of the child cell in parent coordinates (a geometric handle; nothing is drawn)."""
        ox, oy = self.x + ix * self.dx, self.y + iy * self.dy
        if isinstance(g, Poly):
            return Poly(g.layer, [(ox + a, oy + b) for a, b in (_xf(self.orient, px, py) for px, py in g.pts)],
                        g.net, g.src)
        a = _xf(self.orient, g.x0, g.y0)
        b = _xf(self.orient, g.x1, g.y1)
        r = Rect(getattr(g, "layer", None), ox + a[0], oy + a[1], ox + b[0], oy + b[1],
                 getattr(g, "net", None), getattr(g, "src", None))
        return r

    def pin(self, port, ix=0, iy=0, n=0):
        """Rect of a port of the child (first shape of that port; n selects another) in parent
        coordinates; for arrays ix, iy select the element."""
        ps = self.cell.ports.get(port)
        if not ps:
            raise CanvasError(f"cell {self.cell.name} has no port {port!r}",
                              f"ports: {', '.join(self.cell.ports) or '(none)'}")
        r = self.map(ps[min(n, len(ps) - 1)], ix, iy)
        r.net = self.net_of(port, ix, iy)
        return r

    def net_of(self, port, ix=0, iy=0):
        """Parent net a port of this instance connects to (conns=, default: the net of the same name)."""
        v = (self.conns or {}).get(port, port)
        n = iy * self.nx + ix
        if isinstance(v, (list, tuple)):
            v = v[n]
        elif callable(v):
            v = v(ix, iy)
        return str(v).replace("{i}", str(n)).replace("{x}", str(ix)).replace("{y}", str(iy))

    def pins(self, port, ix=0, iy=0):
        return [self.pin(port, ix, iy, n) for n in range(len(self.cell.ports.get(port, [])))]

    def __getitem__(self, port):
        return self.pin(port)


# --------------------------------------------------------------------------- the cell
def _odd_edges(P, closed):
    """Edges of a point list (nm) that are neither Manhattan nor at 45 degrees."""
    out = []
    for i in range(len(P) if closed else len(P) - 1):
        a, b = P[i], P[(i + 1) % len(P)]
        dx, dy = b[0] - a[0], b[1] - a[1]
        if dx and dy and abs(dx) != abs(dy):
            out.append((a, b))
    return out


def _path45(P, w, g, ends="flush"):
    """Outline (nm points) of a path whose segments are all Manhattan or 45 degrees, with every edge
    Manhattan or exactly 45 degrees and every vertex on the grid g. None if a segment has another angle."""
    import math
    pts = [P[0]]
    for q in P[1:]:
        if q != pts[-1]:
            pts.append(q)
    if len(pts) < 2:
        raise CanvasError("path needs two different points")
    sg = lambda v: (v > 0) - (v < 0)
    dirs = []
    for a, b in zip(pts, pts[1:]):
        dx, dy = b[0] - a[0], b[1] - a[1]
        if dx and dy and abs(dx) != abs(dy):
            return None
        dirs.append((sg(dx), sg(dy)))
    i = 1                                                   # merge collinear segments
    while i < len(dirs):
        if dirs[i] == dirs[i - 1]:
            del dirs[i], pts[i]
        else:
            i += 1
    hl = (w // 2) // g * g                                   # Manhattan half widths (left, right)
    kt = math.ceil(w / math.sqrt(2) / g - 1e-9) * g          # diagonal: offsets along (1, 1), width >= w
    kl = (kt // 2) // g * g
    half = {0: (hl, w - hl), 1: (kl, kt - kl)}
    if ends == "ext":
        (dx, dy), e = dirs[0], half[1 if dirs[0][0] and dirs[0][1] else 0][0]
        pts[0] = (pts[0][0] - dx * e, pts[0][1] - dy * e)
        (dx, dy), e = dirs[-1], half[1 if dirs[-1][0] and dirs[-1][1] else 0][0]
        pts[-1] = (pts[-1][0] + dx * e, pts[-1][1] + dy * e)

    def off(i, side):                                       # offset vector of segment i (side +1 left, -1 right)
        dx, dy = dirs[i]
        l, r = half[1 if dx and dy else 0]
        m = l if side > 0 else -r
        return (-dy * m, dx * m)

    def meet(i, side):                                      # offset lines of segments i-1 and i
        (ax, ay), (bx, by) = dirs[i - 1], dirs[i]
        o1, o2 = off(i - 1, side), off(i, side)
        p1 = (pts[i][0] + o1[0], pts[i][1] + o1[1])
        p2 = (pts[i][0] + o2[0], pts[i][1] + o2[1])
        cr = ax * by - ay * bx
        if cr == 0:
            raise CanvasError("path folds back on itself", "remove the 180 degree turn")
        t = ((p2[0] - p1[0]) * by - (p2[1] - p1[1]) * bx) / cr
        return (int(round((p1[0] + t * ax) / g)) * g, int(round((p1[1] + t * ay) / g)) * g)

    n = len(dirs)
    side = lambda s: ([(pts[0][0] + off(0, s)[0], pts[0][1] + off(0, s)[1])] + [meet(i, s) for i in range(1, n)]
                      + [(pts[n][0] + off(n - 1, s)[0], pts[n][1] + off(n - 1, s)[1])])
    return side(1) + side(-1)[::-1]


class Cell:
    registry = {}

    def __init__(self, name, tech=None):
        self.name = name
        self.tech = tech or T.current()
        self.shapes = []          # Rect | Poly
        self.labels = []          # (text, layer, x, y)
        self.refs = []
        self.ports = {}           # name -> [Rect]
        self.port_dir = {}
        self.port_order = []
        self.devices = []         # dict(name, model, nodes, params, prefix)
        self.foreign = None       # (gds_path, cellname) for imported cells
        self.spice_text = None    # imported subckt text
        self.boundary = None      # optional (x0, y0, x1, y1) nm used for placement instead of the bbox
        self.src = _src()
        self.notes = []           # remarks for the check report (not errors)
        Cell.registry[name] = self

    # ------------------------------------------------------------------ helpers
    def _nm(self, v):
        return self.tech.nm(v)

    def _angle_note(self, what, layer, P, closed, src):
        """Edges that are neither Manhattan nor at 45 degrees can end on off-grid vertices or make acute
        angles, which many DRC decks reject. The shape is drawn as asked; the check report names the statement."""
        odd = _odd_edges(P, closed)
        if odd:
            import math
            (ax, ay), (bx, by) = odd[0]
            ang = math.degrees(math.atan2(abs(by - ay), abs(bx - ax)))
            self.__dict__.setdefault("notes", []).append(
                f"{what} on {layer} ({os.path.basename(src[0])}:{src[1]}): {len(odd)} segment(s) neither Manhattan "
                f"nor at 45 degrees, the first from ({ax / 1000:g}, {ay / 1000:g}) to ({bx / 1000:g}, {by / 1000:g}) "
                f"at {ang:.1f} degrees. A 45-degree segment has |dx| == |dy|; other angles can give off-grid "
                f"vertices and acute angles (DRC errors on many decks).")

    def _pt(self, p):
        if isinstance(p, Geo):
            return ((p.x0 + p.x1) // 2 // self.tech.grid * self.tech.grid,
                    (p.y0 + p.y1) // 2 // self.tech.grid * self.tech.grid)
        if hasattr(p, "x0") and hasattr(p, "y1"):           # an instance or a device: its centre
            return ((p.x0 + p.x1) // 2 // self.tech.grid * self.tech.grid,
                    (p.y0 + p.y1) // 2 // self.tech.grid * self.tech.grid)
        try:
            x, y = p
            return (self._nm(x), self._nm(y))
        except (TypeError, ValueError):
            raise CanvasError(f"a point must be (x, y) in um or a shape (its centre is used); got {p!r}",
                              "shape.right / .cx / .top are single numbers: write (shape.right, shape.cy)") from None

    def nmbbox(self):
        if self.boundary:
            return self.boundary
        xs = [(s.x0, s.y0, s.x1, s.y1) for s in self.shapes] + [(r.x0, r.y0, r.x1, r.y1) for r in self.refs]
        if not xs:
            return (0, 0, 0, 0)
        return (min(b[0] for b in xs), min(b[1] for b in xs), max(b[2] for b in xs), max(b[3] for b in xs))

    @property
    def bbox(self):
        b = self.nmbbox()
        return tuple(v / 1000.0 for v in b)

    left = property(lambda s: s.bbox[0])
    bottom = property(lambda s: s.bbox[1])
    right = property(lambda s: s.bbox[2])
    top = property(lambda s: s.bbox[3])
    w = property(lambda s: s.bbox[2] - s.bbox[0])
    h = property(lambda s: s.bbox[3] - s.bbox[1])

    def set_boundary(self, x0, y0, x1, y1, layer=None):
        """Declare the cell's abutment box (used when the cell is placed / tiled). If the PDK data
        names a boundary layer (or `layer` is given) the box is drawn there too."""
        self.boundary = (self._nm(x0), self._nm(y0), self._nm(x1), self._nm(y1))
        lay = layer or self.tech.roles.get("boundary")
        if lay:
            self.shapes.append(Rect(lay, *self.boundary, src=_src()))

    # ------------------------------------------------------------------ relative placement solver
    def _space(self, layer, other, explicit):
        if explicit is not None:
            return self._nm(explicit)
        ol = getattr(other, "layer", None)
        if ol is None:
            return 0
        return self._nm(self.tech.space(layer, ol))

    def _solve(self, layer, w, h, kw):
        t = self.tech
        g = lambda k: kw.pop(k, None)
        x0 = x1 = y0 = y1 = None
        W = self._nm(w) if w is not None else None
        H = self._nm(h) if h is not None else None
        inside = g("inside")
        if inside is None:
            inside = g("in_")
        align = g("align") or "center"
        space, xspace, yspace = g("space"), g("xspace"), g("yspace")
        xspace = space if xspace is None else xspace
        yspace = space if yspace is None else yspace
        xref = yref = None
        # ---- x
        if "x0" in kw or "x1" in kw:
            a, b = g("x0"), g("x1")
            x0 = self._nm(a) if a is not None else None
            x1 = self._nm(b) if b is not None else None
        if (v := g("xspan")) is not None:
            x0, x1 = self._nm(v[0]), self._nm(v[1])
        if (v := g("left")) is not None:
            x0 = self._nm(v)
        if (v := g("right")) is not None:
            x1 = self._nm(v)
        if (v := g("cx")) is not None:
            c = self._nm(v * 2)
            ww = W if W is not None else self._nm(t.width(layer))
            x0 = (c - ww) // 2 // t.grid * t.grid
            x1 = x0 + ww
        if (o := g("right_of")) is not None:
            x0 = o.x1 + self._space(layer, o, xspace)
            xref = o
        if (o := g("left_of")) is not None:
            x1 = o.x0 - self._space(layer, o, xspace)
            xref = o
        # ---- y
        if "y0" in kw or "y1" in kw:
            a, b = g("y0"), g("y1")
            y0 = self._nm(a) if a is not None else None
            y1 = self._nm(b) if b is not None else None
        if (v := g("yspan")) is not None:
            y0, y1 = self._nm(v[0]), self._nm(v[1])
        if (v := g("bottom")) is not None:
            y0 = self._nm(v)
        if (v := g("top")) is not None:
            y1 = self._nm(v)
        if (v := g("cy")) is not None:
            c = self._nm(v * 2)
            hh = H if H is not None else self._nm(t.width(layer))
            y0 = (c - hh) // 2 // t.grid * t.grid
            y1 = y0 + hh
        if (o := g("above")) is not None:
            y0 = o.y1 + self._space(layer, o, yspace)
            yref = o
        if (o := g("below")) is not None:
            y1 = o.y0 - self._space(layer, o, yspace)
            yref = o
        if kw:
            bad = next(iter(kw))
            raise CanvasError(f"unknown placement keyword {bad!r}",
                              "x: x0 x1 left right cx xspan right_of left_of | y: y0 y1 bottom top cy yspan "
                              "above below | inside= align= space= xspace= yspace= w= h=")

        def finish(lo, hi, size, ref_lo, ref_hi, other, mode_lo, mode_hi):
            if lo is not None and hi is not None:
                return lo, hi
            if lo is None and hi is None:
                src = inside if inside is not None else other
                if src is None:
                    raise CanvasError("position not determined on one axis",
                                      "give e.g. left=/cx=/right_of= for x and bottom=/cy=/above= for y, "
                                      "or inside=<shape>")
                a, b = ref_lo(src), ref_hi(src)
                if size is None:
                    return a, b
                if inside is None and align in mode_lo:
                    return a, a + size
                if inside is None and align in mode_hi:
                    return b - size, b
                lo = (a + b - size) // 2 // t.grid * t.grid
                return lo, lo + size
            if size is None:
                size = self._nm(t.width(layer))
                if size == 0:
                    raise CanvasError(f"size needed: layer {layer!r} has no minimum width in the PDK data",
                                      "give w= / h= or both edges")
            return (lo, lo + size) if lo is not None else (hi - size, hi)

        x0, x1 = finish(x0, x1, W, lambda o: o.x0, lambda o: o.x1, yref, ("left",), ("right",))
        y0, y1 = finish(y0, y1, H, lambda o: o.y0, lambda o: o.y1, xref, ("bottom",), ("top",))
        return x0, y0, x1, y1

    # ------------------------------------------------------------------ drawing primitives
    def rect(self, layer, w=None, h=None, net=None, **kw):
        """Rectangle on any layer.
        absolute: rect('m1', x0=0, y0=0, x1=1, y1=0.2)
        relative: rect('m1', w=0.2, h=1, right_of=a, bottom=a.bottom)   (space= defaults to the rule)
        x: x0 x1 | left right cx | xspan=(a,b) | right_of=obj left_of=obj     + w=
        y: y0 y1 | bottom top cy | yspan=(a,b) | above=obj below=obj          + h=
        inside=obj centres on (or, without w/h, fills) obj on an undetermined axis."""
        self.tech.layer(layer)
        x0, y0, x1, y1 = self._solve(layer, w, h, kw)
        if x1 <= x0 or y1 <= y0:
            axis = " and ".join(a for a, lo, hi in (("x", x0, x1), ("y", y0, y1)) if hi <= lo)
            raise CanvasError(f"empty rectangle on {layer}: x {x0 / 1000} .. {x1 / 1000}, y {y0 / 1000} .. {y1 / 1000}",
                              f"the upper edge is not above the lower edge in {axis}: x0 < x1 and y0 < y1 (or "
                              "left < right, bottom < top) are needed; swap them or check the shapes they come from")
        r = Rect(self.tech.lname(layer), x0, y0, x1, y1, net, _src())
        self.shapes.append(r)
        return r

    def box(self, layer, b, net=None):
        """Rectangle from an (x0, y0, x1, y1) tuple in um (e.g. another object's .bbox)."""
        return self.rect(layer, x0=b[0], y0=b[1], x1=b[2], y1=b[3], net=net)

    def polygon(self, layer, pts, net=None):
        """Arbitrary polygon (any angles) on any layer; points in um, snapped to the grid."""
        self.tech.layer(layer)
        if len(pts) < 3:
            raise CanvasError("polygon needs at least 3 points")
        p = Poly(self.tech.lname(layer), [self._pt(q) for q in pts], net, _src())
        self._angle_note("polygon", layer, p.pts, True, p.src)
        self.shapes.append(p)
        return p

    def path(self, layer, pts, width, net=None, ends="flush"):
        """Any-angle path of the given width (um) -> polygon. ends: flush | ext (half a width) | round.
        When every segment is Manhattan or 45 degrees the outline is built exactly: all its edges are
        again Manhattan or 45 degrees with on-grid vertices (diagonal legs come out up to 1.5 grids
        wider than `width`, never narrower). Other angles: the hull is snapped to the grid."""
        self.tech.layer(layer)
        w, g = self._nm(width), self.tech.grid
        P = [self._pt(q) for q in pts]
        out = _path45(P, w, g, ends) if ends != "round" else None
        self._angle_note("path", layer, P, False, _src())
        if out is None:
            import klayout.db as kdb
            e = w // 2 if ends in ("ext", "round") else 0
            hull = kdb.Path([kdb.Point(*q) for q in P], w, e, e, ends == "round").polygon()
            out = [(int(round(q.x / g)) * g, int(round(q.y / g)) * g) for q in hull.each_point_hull()]
        p = Poly(self.tech.lname(layer), out, net, _src())
        self.shapes.append(p)
        return p

    def wire(self, layer, pts, width=None, net=None, first="h", ends="flush"):
        """Manhattan wire through the points (um tuples or shapes -> their centres). Where two points
        are not axis-aligned a corner is inserted (first='h': horizontal leg first, 'v': vertical).
        Returns the list of rectangles. ends='ext' extends both ends by half the width."""
        t = self.tech
        t.layer(layer)
        w = self._nm(width if width is not None else t.width(layer))
        if w <= 0:
            raise CanvasError(f"wire on {layer}: width needed (no minimum width in the PDK data)")
        raw = [self._pt(p) for p in pts]
        P = [raw[0]]
        for i, q in enumerate(raw[1:]):
            a = P[-1]
            if a[0] != q[0] and a[1] != q[1]:
                f = first if isinstance(first, str) else first[min(i, len(first) - 1)]
                P.append((q[0], a[1]) if f == "h" else (a[0], q[1]))
            if q != P[-1]:
                P.append(q)
        if len(P) < 2:
            raise CanvasError("wire needs two different points")
        g = t.grid
        lo = -((-(w // 2)) // g * g)        # both edges on the grid, also when the width is an odd
        src, out, hi = _src(), [], w - lo   # number of grids (centre line then half a grid off centre)
        for i in range(len(P) - 1):
            (ax, ay), (bx, by) = P[i], P[i + 1]
            e0 = lo if (i > 0 or ends == "ext") else 0
            e1 = hi if (i < len(P) - 2 or ends == "ext") else 0
            if ay == by:
                s, e = (ax, bx) if ax < bx else (bx, ax)
                s0, s1 = (e0, e1) if ax < bx else (e1, e0)
                r = Rect(t.lname(layer), s - s0, ay - lo, e + s1, ay + hi, net, src)
            else:
                s, e = (ay, by) if ay < by else (by, ay)
                s0, s1 = (e0, e1) if ay < by else (e1, e0)
                r = Rect(t.lname(layer), ax - lo, s - s0, ax + hi, e + s1, net, src)
            self.shapes.append(r)
            out.append(r)
        return out

    def label(self, text, layer, at):
        """Net-name text on a conductor layer (LVS net naming). at = (x, y) or a shape (its centre)."""
        x, y = self._pt(at)
        self.labels.append((text, self.tech.lname(layer), x, y))

    def port(self, name, on, dir="inout"):
        """Declare a pin: `on` is a shape of this cell on a conductor layer. The port appears in the
        subcircuit pin list (in declaration order) and can be reached from a parent with inst.pin(name)."""
        if not isinstance(on, Geo) or getattr(on, "layer", None) is None:
            raise CanvasError(f"port {name!r}: on= must be a shape on a conductor layer",
                              "e.g. p = c.rect('m1', ...); c.port('A', on=p)")
        if isinstance(on, Poly):
            on = Rect(on.layer, on.x0, on.y0, on.x1, on.y1, on.net, on.src)
        if name not in self.ports:
            self.ports[name] = []
            self.port_order.append(name)
        self.port_dir[name] = dir
        r = Rect(on.layer, on.x0, on.y0, on.x1, on.y1, name, _src())
        if on.net is None:
            on.net = name
        self.ports[name].append(r)
        return r

    # ------------------------------------------------------------------ hierarchy
    def place(self, cell, at=(0, 0), orient="R0", nx=1, ny=1, dx=None, dy=None, name=None, conns=None,
              **kw):
        """Instantiate `cell` (or an nx x ny array with pitches dx, dy; default pitch = the child's
        abutment box). at = position of the child's origin, or use relative keywords on the child's
        bounding box: right_of= left_of= above= below= left= bottom= ... (space= default 0).
        conns={'A': 'net1', ...} names the parent net of each port for the reference netlist (LVS) and the
        connectivity check; a port that is not listed connects to the parent net of the same name.
        Arrays: a list per element, a function (ix, iy) -> net, or '{i}' / '{x}' / '{y}' in the name."""
        if orient not in _ORIENT:
            raise CanvasError(f"orient {orient!r}", "one of " + ", ".join(_ORIENT))
        if cell is self:
            raise CanvasError("a cell cannot contain itself")
        b = cell.nmbbox()
        probe = Ref(self, cell, 0, 0, orient, 1, 1, 0, 0, None, None, None)
        pw, ph = probe.x1 - probe.x0, probe.y1 - probe.y0
        ddx = self._nm(dx) if dx is not None else pw
        ddy = self._nm(dy) if dy is not None else ph
        if kw:
            kw.setdefault("space", 0)
            tw, th = pw + (nx - 1) * ddx, ph + (ny - 1) * ddy
            x0, y0, _, _ = self._solve(None, tw / 1000.0, th / 1000.0, kw)
            x, y = x0 - probe.x0, y0 - probe.y0
        else:
            x, y = self._pt(at)
        name = name or f"X{len(self.refs)}"
        r = Ref(self, cell, x, y, orient, nx, ny, ddx, ddy, name, dict(conns) if conns else None, _src())
        self.refs.append(r)
        return r

    # ------------------------------------------------------------------ netlist
    def device(self, name, model, nodes, prefix="X", **params):
        """Reference-netlist device line for LVS: any model the PDK's extraction deck knows.
        c.device('R1', 'sky130_fd_pr__res_high_po_0p35', ['a', 'b', 'VSS'], l=2.0)
        (cell.mos / resistor / capacitor record their devices themselves.)"""
        self.devices.append(dict(name=name, model=model, nodes=list(nodes), params=params, prefix=prefix))

    def all_cells(self, seen=None, out=None):
        """This cell and every cell below it, children first."""
        seen = set() if seen is None else seen
        out = [] if out is None else out
        if self.name in seen:
            return out
        seen.add(self.name)
        for r in self.refs:
            r.cell.all_cells(seen, out)
        out.append(self)
        return out

    def has_netlist(self):
        return any(c.devices or c.spice_text or any(r.conns for r in c.refs) for c in self.all_cells())

    def subckt(self):
        if self.spice_text:
            return self.spice_text.rstrip() + "\n"
        o = [f".subckt {self.name} {' '.join(self.port_order)}"]
        for d in self.devices:
            u = self.tech.d.get("spice_unit", "")          # length suffix the PDK's extraction writes
            p = " ".join(f"{k}={v:g}{u}" if isinstance(v, (int, float)) else f"{k}={v}" for k, v in d["params"].items())
            nm_ = d["name"] if d["name"][:1].upper() == d["prefix"] else d["prefix"] + d["name"]
            o.append(f"{nm_} {' '.join(d['nodes'])} {d['model']} {p}".rstrip())
        for r in self.refs:
            if not r.cell.port_order:
                continue
            n = 0
            for iy in range(r.ny):
                for ix in range(r.nx):
                    nets = [r.net_of(p, ix, iy) for p in r.cell.port_order]
                    suffix = f"_{n}" if r.nx * r.ny > 1 else ""
                    o.append(f"X{r.name}{suffix} {' '.join(nets)} {r.cell.name}")
                    n += 1
        o.append(".ends")
        return "\n".join(o) + "\n"

    def netlist(self):
        """Hierarchical SPICE reference netlist of this cell (children first)."""
        return f"* reference netlist written by icl canvas for {self.name} ({self.tech.name})\n" + \
            "\n".join(c.subckt() for c in self.all_cells()) + ".end\n"

    # ------------------------------------------------------------------ flatten (for checks)
    def flat(self, depth=99, _xf_chain=None):
        """Yield every shape of the hierarchy in this cell's coordinates: (shape, path)."""
        for s in self.shapes:
            yield s, ""
        if depth <= 0:
            return
        for r in self.refs:
            for iy in range(r.ny):
                for ix in range(r.nx):
                    tag = r.name + (f"[{ix},{iy}]" if r.nx * r.ny > 1 else "")
                    for s, p in r.cell.flat(depth - 1):
                        yield r.map(s, ix, iy), (tag + "/" + p if p else tag)

    def count(self):
        """(shapes, devices) of the whole hierarchy, flattened."""
        memo = {}

        def rec(c):
            if c.name not in memo:
                s, d = len(c.shapes), len(c.devices)
                for r in c.refs:
                    a, b = rec(r.cell)
                    s += a * r.nx * r.ny
                    d += b * r.nx * r.ny
                memo[c.name] = (s, d)
            return memo[c.name]
        return rec(self)
