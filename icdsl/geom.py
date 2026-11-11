"""Tiny geometry kernel: integer rectangles tagged with layer / net / owner."""
from __future__ import annotations

from dataclasses import dataclass, field, replace


@dataclass(frozen=True)
class Rect:
    x0: int
    y0: int
    x1: int
    y1: int

    def __post_init__(self):
        if self.x1 < self.x0 or self.y1 < self.y0:
            raise ValueError(f"degenerate rect {self}")

    @property
    def w(self):
        return self.x1 - self.x0

    @property
    def h(self):
        return self.y1 - self.y0

    @property
    def cx(self):
        return (self.x0 + self.x1) // 2

    @property
    def cy(self):
        return (self.y0 + self.y1) // 2

    def moved(self, dx, dy):
        return Rect(self.x0 + dx, self.y0 + dy, self.x1 + dx, self.y1 + dy)

    def mirrored_y(self):
        return Rect(self.x0, -self.y1, self.x1, -self.y0)

    def mirrored_x(self):
        return Rect(-self.x1, self.y0, -self.x0, self.y1)

    def bloat(self, d, dy=None):
        dy = d if dy is None else dy
        return Rect(self.x0 - d, self.y0 - dy, self.x1 + d, self.y1 + dy)

    def union(self, o):
        return Rect(min(self.x0, o.x0), min(self.y0, o.y0), max(self.x1, o.x1), max(self.y1, o.y1))

    def overlaps(self, o):
        """Strict overlap (shared area > 0)."""
        return self.x0 < o.x1 and o.x0 < self.x1 and self.y0 < o.y1 and o.y0 < self.y1

    def touches(self, o):
        """Overlap or abut (closed intervals)."""
        return self.x0 <= o.x1 and o.x0 <= self.x1 and self.y0 <= o.y1 and o.y0 <= self.y1

    def contains(self, o):
        return self.x0 <= o.x0 and self.y0 <= o.y0 and o.x1 <= self.x1 and o.y1 <= self.y1

    def contains_pt(self, x, y):
        return self.x0 <= x <= self.x1 and self.y0 <= y <= self.y1

    def gap(self, o):
        """(dx, dy) separation; negative/zero means projections overlap."""
        dx = max(o.x0 - self.x1, self.x0 - o.x1)
        dy = max(o.y0 - self.y1, self.y0 - o.y1)
        return dx, dy

    def um(self):
        return (self.x0 / 1000, self.y0 / 1000, self.x1 / 1000, self.y1 / 1000)

    def __str__(self):
        a = self.um()
        return f"({a[0]:.3f},{a[1]:.3f})-({a[2]:.3f},{a[3]:.3f})"


def rect_c(cx, cy, w, h):
    """Rectangle from centre and size (sizes must keep the 5 nm grid)."""
    return Rect(cx - w // 2, cy - h // 2, cx - w // 2 + w, cy - h // 2 + h)


@dataclass
class Shape:
    layer: str                  # GDS layer key from tech.GDS
    rect: Rect
    net: str | None = None      # electrical net (None = not a conductor / don't care)
    owner: str = ""             # provenance, e.g. "MN1", "route:A", "rail:VGND"
    kinds: tuple = ()           # extra compaction classes (e.g. "diff_n", "pcon")

    def moved(self, dx, dy):
        return replace(self, rect=self.rect.moved(dx, dy))

    def mirrored_y(self):
        return replace(self, rect=self.rect.mirrored_y())

    def classes(self):
        return (self.layer,) + tuple(self.kinds)


@dataclass
class Pin:
    """A connectable terminal of a device / instance.

    access: list of (x, y, layer, cut) grid points where the router may land.
    cut is the cut layer needed to reach the routing layer ('mcon' when the
    pin is on li, None when the pin already is on the routing layer).
    """
    net: str
    shape: Shape
    access: list = field(default_factory=list)
    name: str = ""


def bbox(shapes, layers=None):
    r = None
    for s in shapes:
        if layers and s.layer not in layers:
            continue
        r = s.rect if r is None else r.union(s.rect)
    return r
