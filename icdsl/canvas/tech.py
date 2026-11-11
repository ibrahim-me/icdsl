"""PDK description as data.

A `Tech` is loaded from `icdsl/canvas/pdks/<name>.py` (a dict called TECH) plus the PDK's own KLayout
layer table (`.lyp`), so every official layer of the PDK can be drawn by name. Nothing else in the canvas
package knows a PDK by name: rules, the conductor stack, device recipes and the signoff decks all come
from the Tech object.

Units: the API speaks micrometres (float); geometry is stored in integer nanometres on the PDK grid.
"""
from __future__ import annotations

import importlib
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PDK_ROOT = os.environ.get("PDK_ROOT", os.path.join(ROOT, "pdk"))


class TechError(Exception):
    pass


def _suggest(word, options, n=4):
    import difflib
    m = difflib.get_close_matches(word, list(options), n=n, cutoff=0.5)
    return ("; did you mean " + ", ".join(m) + "?") if m else ""


class Tech:
    def __init__(self, data):
        self.d = data
        self.name = data["name"]
        self.grid = int(round(data.get("grid", 0.005) * 1000))          # nm
        self.root = os.path.join(PDK_ROOT, self.name)
        self.alias = dict(data["layers"])                                  # short name -> (layer, datatype)
        self.label_layer = dict(data.get("label", {}))
        self.pin_layer = dict(data.get("pin", {}))
        self.stack = list(data["stack"])                                   # conductors, bottom-up
        self.cuts = dict(data["cuts"])                                     # cut -> dict(size, space, lower, upper)
        self.metal1 = data.get("metal1", self.stack[0])
        self.devices = dict(data.get("devices", {}))
        self.roles = dict(data.get("roles", {}))
        self._width = {k: self.nm(v) for k, v in data.get("width", {}).items()}
        self._space = {tuple(k): self.nm(v) for k, v in data.get("space", {}).items()}
        self._enc = {tuple(k): (self.nm(v[0]), self.nm(v[1])) for k, v in data.get("enc", {}).items()}
        self._area = dict(data.get("area", {}))
        self._official = None
        self._gds2name = {v: k for k, v in reversed(list(self.alias.items()))}

    # ------------------------------------------------------------------ units
    def nm(self, v_um):
        """micrometres -> integer nm on the manufacturing grid (nearest)."""
        g = self.grid
        return int(round(float(v_um) * 1000.0 / g)) * g

    def snap(self, v_um):
        """Round a micrometre value to the manufacturing grid."""
        return self.nm(v_um) / 1000.0

    # ------------------------------------------------------------------ layers
    def _load_official(self):
        if self._official is not None:
            return self._official
        self._official = {}
        lyp = self.d.get("lyp")
        path = os.path.join(self.root, lyp) if lyp else None
        if path and os.path.exists(path):
            txt = open(path, errors="replace").read()
            for blk in re.findall(r"<properties>(.*?)</properties>", txt, re.S):
                nm_ = re.search(r"<name>([^<]*)</name>", blk)
                src = re.search(r"<source>\s*([^<]*?)\s*(\d+)/(\d+)", blk)
                if not src:
                    continue
                name = nm_.group(1).split(" - ")[0].strip() if nm_ else ""
                name = re.sub(r"\s+\d+/\d+$", "", name).strip() or src.group(1).strip()
                src = re.match(r"()(\d+)/(\d+)", src.group(2) + "/" + src.group(3))
                if name:
                    self._official.setdefault(name, (int(src.group(2)), int(src.group(3))))
                    self._official.setdefault(name.lower(), (int(src.group(2)), int(src.group(3))))
        return self._official

    def layer(self, name):
        """Resolve a layer to (gds_layer, datatype). Accepts a short name of this PDK (`tech.layers()`),
        an official name from the PDK's KLayout layer table ('met5.drawing', 'poly.res', 'Metal2'), or a
        raw (layer, datatype) tuple - so nothing the foundry defines is out of reach."""
        if isinstance(name, tuple) and len(name) == 2:
            return (int(name[0]), int(name[1]))
        if name in self.alias:
            return self.alias[name]
        off = self._load_official()
        for k in (name, name + ".drawing", name.lower(), name.lower() + ".drawing"):
            if k in off:
                return off[k]
        m = re.fullmatch(r"(\d+)/(\d+)", str(name))
        if m:
            return (int(m.group(1)), int(m.group(2)))
        raise TechError(f"unknown layer {name!r} in {self.name}{_suggest(str(name), list(self.alias) + list(off))}"
                        f"  (short names: {', '.join(self.alias)}; any official PDK layer name or a "
                        f"(layer, datatype) tuple also works)")

    def layers(self):
        return list(self.alias)

    def official_layers(self):
        return dict(self._load_official())

    def lname(self, name):
        """Canonical short name for a layer if it has one (so rules can be looked up), else the name."""
        if isinstance(name, str) and name in self.alias:
            return name
        try:
            ld = self.layer(name)
        except TechError:
            return name
        return self._gds2name.get(ld, name if isinstance(name, str) else f"{ld[0]}/{ld[1]}")

    # ------------------------------------------------------------------ rules (um in, um out)
    def width(self, layer):
        """Minimum width of a layer (um). Cut layers: the exact cut size."""
        layer = self.lname(layer)
        if layer in self.cuts:
            return self.cuts[layer]["size"]
        return self._width.get(layer, 0) / 1000.0

    def space(self, a, b=None, width=None):
        """Minimum spacing between two layers (um); same layer if b is omitted. 0 if no rule is listed.
        width = width (um) of the wider of the two shapes: includes the PDK's wide-metal spacing rule."""
        a = self.lname(a)
        b = self.lname(b) if b is not None else a
        if a == b and a in self.cuts:
            return self.cuts[a]["space"]
        v = self._space.get((a, b), self._space.get((b, a), 0)) / 1000.0
        if width is not None and a == b:
            v = max([v] + [s for w, s in self.d.get("space_wide", {}).get(a, []) if width > w + 1e-9])
        return v

    def enc(self, outer, inner):
        """Enclosure of `inner` by `outer`: (all sides, the two opposite sides that need more), um."""
        o, i = self.lname(outer), self.lname(inner)
        e = self._enc.get((o, i), (0, 0))
        return (e[0] / 1000.0, e[1] / 1000.0)

    def area(self, layer):
        return self._area.get(self.lname(layer), 0.0)

    def rule(self, key):
        """Named rule from the PDK data (um), e.g. tech.rule('gate_pitch')."""
        r = self.d.get("rules", {})
        if key not in r:
            raise TechError(f"no rule {key!r} in {self.name}{_suggest(key, r)}")
        return r[key]

    # ------------------------------------------------------------------ stack
    def metal(self, k):
        """k-th routing metal by its conventional number: metal(1) is the PDK's Metal1 on every PDK
        (sky130 'm1', gf180mcu 'm1'). Portable scripts should route on tech.metal(k)."""
        i = self.stack.index(self.metal1) + (k - 1)
        if k < 1 or i >= len(self.stack):
            raise TechError(f"{self.name} has no metal {k} (metals 1..{len(self.stack) - self.stack.index(self.metal1)})")
        return self.stack[i]

    def conductor(self, i):
        """i-th conductor of the stack counted from the devices: conductor(0) = c0 (sky130 li, gf180 m1),
        conductor(1) = c1 (sky130 m1, gf180 m2), ... The portable way to name routing layers."""
        if not 0 <= i < len(self.stack):
            raise TechError(f"{self.name} has conductors 0..{len(self.stack) - 1}: {' < '.join(self.stack)}")
        return self.stack[i]

    c1 = property(lambda self: self.conductor(1))
    c2 = property(lambda self: self.conductor(2))
    c3 = property(lambda self: self.conductor(3))
    c4 = property(lambda self: self.conductor(4))

    @property
    def c0(self):
        """First conductor above the devices (sky130: li, gf180mcu: m1): device terminals land here."""
        return self.stack[0]

    def cut_between(self, lower, upper):
        for c, d in self.cuts.items():
            if d.get("lower") == lower and d.get("upper") == upper:
                return c
        return None

    def cut_stack(self, frm, to):
        """[(lower, cut, upper), ...] going from conductor `frm` up to `to` (either order)."""
        frm, to = self.lname(frm), self.lname(to)
        for l in (frm, to):
            if l not in self.stack:
                raise TechError(f"{l!r} is not a conductor of {self.name}; stack: {' < '.join(self.stack)}")
        i, j = sorted((self.stack.index(frm), self.stack.index(to)))
        return [(self.stack[k], self.cut_between(self.stack[k], self.stack[k + 1]), self.stack[k + 1])
                for k in range(i, j)]

    def device(self, kind):
        if kind not in self.devices:
            raise TechError(f"no device recipe {kind!r} in {self.name}{_suggest(kind, self.devices)}; "
                            f"recipes: {', '.join(self.devices)}. Any other device can still be drawn with "
                            f"rect/polygon on the PDK layers and declared with cell.device(...)")
        return self.devices[kind]

    # ------------------------------------------------------------------ signoff decks
    def deck(self, key):
        p = self.d["signoff"][key]
        return p if os.path.isabs(p) else os.path.join(self.root, p)

    def describe(self):
        """Rule sheet (text) for agents: layers, stack, the rules the helpers use, device recipes."""
        o = [f"PDK {self.name}   grid {self.grid} nm   (short layer names; every official layer also works)"]
        o.append("layers: " + "  ".join(f"{k}={v[0]}/{v[1]}" for k, v in self.alias.items()))
        o.append("conductor stack: " + " < ".join(self.stack) + f"    metal(1) = {self.metal1}, c0 = {self.c0}")
        o.append("cuts:")
        for c, d in self.cuts.items():
            lo = d["lower"] if isinstance(d["lower"], str) else "|".join(d["lower"])
            o.append(f"  {c:8s} {lo} -> {d['upper']}  size {d['size']}  space {d['space']}")
        o.append("min width (um): " + "  ".join(f"{k} {v / 1000:g}" for k, v in self._width.items()))
        o.append("min space (um): " + "  ".join(
            (f"{a} {v / 1000:g}" if a == b else f"{a}/{b} {v / 1000:g}") for (a, b), v in self._space.items()))
        wide = {}                                # layers that share a table on one line
        for k, tab in self.d.get("space_wide", {}).items():
            wide.setdefault(tuple(tab), []).append(k)
        for tab, names in wide.items():
            o.append(f"wide-metal space ({' '.join(names)}): " + "  ".join(f"wider than {w:g} -> {sp:g}" for w, sp in tab)
                     + "   (tech.space(layer, width=w))")
        o.append("enclosure outer>inner (all sides, two opposite sides): " + "  ".join(
            f"{a}>{b} {x / 1000:g},{y / 1000:g}" for (a, b), (x, y) in self._enc.items()))
        if self._area:
            o.append("min area (um2): " + "  ".join(f"{k} {v:g}" for k, v in self._area.items()))
        o.append("named rules: " + "  ".join(f"{k}={v:g}" for k, v in self.d.get("rules", {}).items()))
        o.append("device recipes (cell.mos / cell.resistor / cell.capacitor):")
        for k, d in self.devices.items():
            extra = "  ".join(f"{x}={d[x]}" for x in ("lmin", "wmin") if x in d)
            o.append(f"  {k:10s} {d.get('type', 'mos'):4s} model {d.get('model', '-')}  {extra}")
        return "\n".join(o)


_cache = {}
_default = [None]


def available():
    d = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pdks")
    return sorted(f[:-3] for f in os.listdir(d) if f.endswith(".py") and not f.startswith("_"))


def load(name):
    if name not in _cache:
        if name not in available():
            raise TechError(f"no PDK description {name!r}; available: {', '.join(available())} "
                            f"(add icdsl/canvas/pdks/{name}.py to port a new PDK)")
        mod = importlib.import_module(f"icdsl.canvas.pdks.{name}")
        _cache[name] = Tech(mod.TECH)
    return _cache[name]


def use(name=None):
    """Select the PDK. `use()` takes the PDK from `icl ... --pdk` / $ICL_PDK (default sky130A), so a
    script written with tech-generic names runs on every PDK; `use('gf180mcuD')` pins one."""
    name = name or os.environ.get("ICL_PDK") or "sky130A"
    _default[0] = load(name)
    return _default[0]


def current():
    return _default[0] or use()
