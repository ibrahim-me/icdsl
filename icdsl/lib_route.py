"""Library `route`: algorithmic + manual routing with constraints. Usable in every block.

    route  <net> ... [layers=m1,m2] [width=<um>] [space=<um>] [avoid=NET:um,NET:um]
                     [prefer=m2] [maxres=<ohm>] [shield=<net>]
    route  *  [layers=...]                       defaults for all nets not named elsewhere
    route  <netA> <netB> symmetric axis=<x um> [layers=..] [width=..]
                                                 netB is routed as the mirror image of netA
    wire   <net> layer=<m1..m4> [width=<um>] path=[<pt>, <pt>, ...]
                                                 manual wire; points are (x, y) in um or pin refs
    wire   <net> from=<pin> to=<pin> [layers=..] [width=..] [space=..] [avoid=..]
                                                 constrained point-to-point auto route
    keepout <netA> <netB> dist=<um>               pairwise minimum spacing
    limit  coupling <netA> <netB> max=<fF>       sidewall-coupling budget (router re-spaces if exceeded)
    limit  resistance <net> max=<ohm>            same as route ... maxres=
"""
from __future__ import annotations

from dataclasses import dataclass, field

from . import tech as T
from .geom import Rect
from .router import NetSpec, PinGroup, RouteError, Router
from .syntax import ICLError, Point, check_keys, did_you_mean, ident, nm

ROUTE_KEYS = {"layers", "width", "space", "avoid", "prefer", "maxres", "shield", "axis"}
WIRE_KEYS = {"layer", "layers", "width", "path", "from", "to", "space", "avoid"}


def _layers(s, line):
    out = [x.strip() for x in s.split(",") if x.strip()]
    for x in out:
        if x not in T.ROUTE_LAYERS:
            raise ICLError(f"unknown routing layer '{x}'", line, did_you_mean(x, T.ROUTE_LAYERS)
                           or f"routing layers: {', '.join(T.ROUTE_LAYERS)}")
    return out


def _avoid(s, scope, line):
    out = {}
    for part in s.split(","):
        if ":" not in part:
            raise ICLError(f"avoid= expects NET:distance pairs, got '{part}'", line, "e.g. avoid=VIN:1.0,CLK:0.5")
        n, d = part.split(":", 1)
        out[ident(n, "avoid", line)] = nm(scope.eval(d, line))
    return out


@dataclass
class RoutePlan:
    specs: dict = field(default_factory=dict)       # net -> NetSpec (explicit)
    star: dict | None = None                        # defaults for '*'
    order: list = field(default_factory=list)       # explicit nets in declaration order
    sym: list = field(default_factory=list)         # (netA, netB, axis_nm, line)
    wires: list = field(default_factory=list)       # Stmt
    keepouts: list = field(default_factory=list)    # (a, b, nm, line)
    couple: list = field(default_factory=list)      # (a, b, fF, line)
    report: dict = field(default_factory=dict)

    # ------------------------------------------------------------ statements
    def handles(self, verb):
        return verb in ("route", "wire", "keepout", "limit")

    def add(self, st, scope):
        if st.verb == "route":
            check_keys(st, ROUTE_KEYS)
            if "symmetric" in st.args:
                nets = [a for a in st.args if a != "symmetric"]
                if len(nets) != 2 or "axis" not in st.kw:
                    raise ICLError("usage: route <netA> <netB> symmetric axis=<x um>", st.line)
                a, b = (ident(n, "route", st.line) for n in nets)
                self.sym.append((a, b, st.kw["axis"], st.line))      # evaluated at routing time
                for n in (a, b):
                    self.specs[n] = self._spec(n, st, scope)
                return
            for n in st.args:
                if n == "*":
                    self.star = dict(st.kw)
                    self.star["_line"] = st.line
                    continue
                n = ident(n, "route", st.line)
                self.specs[n] = self._spec(n, st, scope)
                if n not in self.order:
                    self.order.append(n)
        elif st.verb == "wire":
            check_keys(st, WIRE_KEYS)
            if len(st.args) != 1:
                raise ICLError("usage: wire <net> layer=.. path=[..]  |  wire <net> from=<pin> to=<pin>", st.line)
            self.wires.append(st)
        elif st.verb == "keepout":
            check_keys(st, {"dist"})
            if len(st.args) != 2 or "dist" not in st.kw:
                raise ICLError("usage: keepout <netA> <netB> dist=<um>", st.line)
            self.keepouts.append((st.args[0], st.args[1], nm(scope.eval(st.kw["dist"], st.line)), st.line))
        elif st.verb == "limit":
            check_keys(st, {"max"})
            if not st.args or "max" not in st.kw:
                raise ICLError("usage: limit coupling <netA> <netB> max=<fF> | limit resistance <net> max=<ohm>", st.line)
            what = st.args[0]
            mx = float(scope.eval(st.kw["max"], st.line))
            if what == "coupling" and len(st.args) == 3:
                self.couple.append((st.args[1], st.args[2], mx, st.line))
            elif what == "resistance" and len(st.args) == 2:
                n = st.args[1]
                sp = self.specs.setdefault(n, NetSpec(n, line=st.line))
                sp.maxres = mx
                if n not in self.order:
                    self.order.append(n)
            else:
                raise ICLError(f"limit: unknown '{what}'", st.line, did_you_mean(what, ["coupling", "resistance"]))

    def _spec(self, net, st, scope, base=None):
        kw = dict(base or {})
        kw.update(st.kw if hasattr(st, "kw") else {})
        return self._spec_from(net, kw, scope, st.line)

    def _spec_from(self, net, kw, scope, line, default_layers=None):
        sp = NetSpec(net, line=line)
        sp.layers = _layers(kw["layers"], line) if "layers" in kw else list(default_layers or ["m1", "m2"])
        if "width" in kw:
            w = nm(scope.eval(kw["width"], line))
            sp.width = {l: w for l in T.ROUTE_LAYERS}
            sp.width_fixed = True
        if "space" in kw:
            sp.space = nm(scope.eval(kw["space"], line))
        if "avoid" in kw:
            sp.avoid = _avoid(kw["avoid"], scope, line)
        if "prefer" in kw:
            for l in _layers(kw["prefer"], line):
                sp.prefer[l] = 0.6
        if "maxres" in kw:
            sp.maxres = float(scope.eval(kw["maxres"], line))
        if "shield" in kw:
            sp.shield = ident(kw["shield"], "shield", line)
        return sp

    # ------------------------------------------------------------ execution
    def execute(self, router: Router, pins: dict, scope, supplies=None, default_layers=("m1", "m2"),
                route_all=True, err=None):
        """pins: net -> [PinGroup]; supplies: net -> PinGroup (rail) for straight drops."""
        supplies = supplies or {}
        err = err or (lambda m, line, hint="": ICLError(m, line, hint))
        for net, gs in list(pins.items()) + [(n, [g]) for n, g in supplies.items()]:
            for g in gs:
                if not g.access and g.shapes:
                    for sh in g.shapes:
                        g.access += router.access_for(net, sh, T.ROUTE_LAYERS)
        for (a, b, d, line) in self.keepouts:
            router.set_avoid(a, b, d)
        for sp in self.specs.values():
            for o, d in sp.avoid.items():
                router.set_avoid(sp.net, o, d)
        star = self.star or {}
        star_line = star.get("_line", 0)

        def spec_for(n):
            if n in self.specs:
                return self.specs[n]
            kw = {k: v for k, v in star.items() if k != "_line"}
            return self._spec_from(n, kw, scope, star_line, default_layers)

        done = set()
        # 1. manual wires (in order)
        for st in self.wires:
            net = ident(st.args[0], "wire", st.line)
            if net not in pins and net not in supplies:
                raise err(f"wire: unknown net '{net}'", st.line, did_you_mean(net, pins))
            self._wire(router, st, net, pins, scope, spec_for(net), err)
        # pins joined by manual wires become one group (the wire metal is a valid tap point too)
        for net, nr in router.routes.items():
            if net not in pins or not nr.shapes:
                continue
            wired = [s for s in nr.shapes]
            hit = [g for g in pins[net] if any(ps.rect.overlaps(w.rect) or ps.rect.touches(w.rect)
                                                for ps in g.shapes for w in wired)]
            if hit:
                rest = [g for g in pins[net] if g not in hit]
                merged = PinGroup(net, "+".join(g.name for g in hit) + "+wire", [],
                                  [x for g in hit for x in g.shapes] +
                                  [w for w in wired if w.layer in T.ROUTE_LAYERS])
                for sh in merged.shapes:
                    merged.access += router.access_for(net, sh, T.ROUTE_LAYERS)
                pins[net] = rest + [merged]
        # 2. symmetric pairs
        for (a, b, ax_expr, line) in self.sym:
            ax = nm(scope.eval(ax_expr, line))
            for n in (a, b):
                if n not in pins:
                    raise err(f"route symmetric: unknown net '{n}'", line, did_you_mean(n, pins))
            try:
                router.route_symmetric(a, pins[a], b, pins[b], 2 * ax, spec_for(a), spec_for(b))
            except RouteError as e:
                raise err(f"symmetric routing of {a}/{b} failed: {e}", line,
                          "check that the two nets' pins are mirror images about the axis "
                          "(use 'mirror' placement), and that the axis is on the 0.23 um half-grid")
            done |= {a, b}
        # 3. everything else
        nets = [n for n in pins if n not in done and len([g for g in pins[n] if g.access]) + (n in supplies) >= 2]
        if not route_all and not self.star:
            nets = [n for n in nets if n in self.specs]
        explicit = [n for n in self.order if n in nets]
        sup = [n for n in nets if n in supplies and n not in explicit]
        rest = sorted([n for n in nets if n not in explicit and n not in sup], key=lambda n: _hpwl(pins[n]))
        order = explicit + sup + rest
        last = None
        import time as _t
        budget = float(getattr(router, "time_budget", 60.0))
        router.deadline = _t.monotonic() + budget
        reserve = getattr(router, "reserve_pins", False)
        if reserve:
            router.reserve_access(pins, order, spec_for)
        for attempt in range(2 * len(order) + 2):
            if _t.monotonic() > router.deadline:
                break
            if reserve and attempt == len(order) + 1:
                router.release_all()        # reservations did not help: fall back to plain rip-up
                reserve = False
            routed = []
            try:
                for n in order:
                    routed.append(n)
                    self._route_one(router, n, pins, supplies, spec_for(n), err, raw=True)
                    router.release(n)       # its real landings are down now
                last = None
                break
            except RouteError as e:
                last = (e, n)
                if reserve and "no legal access point" in str(e):
                    router.release_all()    # the reservations themselves are in the way
                    reserve = False
                for m in routed:
                    router.ripup(m)
                    if reserve:
                        router.hold(m)
                if n in order:
                    order.remove(n)
                    order.insert(0, n)
        router.release_all()
        if last is not None and "time budget" in str(last[0]):
            last = (RouteError(f"gave up after {budget:.0f} s of rip-up and retry ({last[0]})", last[1]), last[1])
        if last is not None and getattr(router, "best_effort", False):
            # keep going without the nets that cannot be routed: the caller reports them and the
            # unrouted nets show up as opens in the connectivity check / LVS
            router.failed = []
            for m in list(router.routes):
                router.ripup(m)
            for n in order:
                try:
                    self._route_one(router, n, pins, supplies, spec_for(n), err, raw=True)
                except RouteError as e:
                    router.ripup(n)
                    router.failed.append((n, str(e), spec_for(n).line))
            if router.failed:
                last = None
        if last is not None:
            e, n = last
            cons = []
            sp = spec_for(n)
            if sp.width_fixed:
                cons.append(f"width {sp.w('m1')/1000:g} um (line {sp.line})")
            if sp.space:
                cons.append(f"space {sp.space/1000:g} um (line {sp.line})")
            for k, d in router.pair.items():
                if n in k:
                    other = next(iter(k - {n}), n)
                    src = next((ln for (a, b, dd, ln) in self.keepouts if {a, b} == set(k)), None) or \
                        next((q.line for q in self.specs.values() if q.net in k and any(o in k for o in q.avoid)), "?")
                    cons.append(f"keep-out {d/1000:g} um from {other} (line {src})")
            if sp.layers != ["m1", "m2"]:
                cons.append(f"layers {','.join(sp.layers)}")
            why = ("; constraints on this net: " + ", ".join(cons) + " - likely over-constrained here") if cons else ""
            hint = ("relax or drop a constraint, give the router room (place ... gap=, row ... space=1), "
                    "allow more layers (layers=m1,m2,m3), or route it by hand with 'wire'")
            if "no legal access point" in str(e):
                hint = ("the router lands on an li pin with an mcon + met1 pad (about 0.29 um square) that must stay "
                        "0.14 um from every other met1 (rails, other pins, other routes) and 0.19 um mcon-to-mcon: "
                        "give that pin room (make the li reach further from the rail / other pins), join this net "
                        "with an li strap instead of `route`, or remove a met1 pin you placed right next to it")
            raise err(f"routing failed: {e}{why}", sp.line, hint)
        # 4. coupling budgets: re-space and reroute the later net once or twice
        for (a, b, mx, line) in self.couple:
            for it in range(3):
                c = router.coupling(a, b)
                if c <= mx:
                    break
                cur = router.pair.get(frozenset((a, b)), T.rule_space("m1"))
                router.set_avoid(a, b, cur + T.GRID)
                if a in order and b in order:
                    victim = b if order.index(b) > order.index(a) else a
                else:
                    victim = b
                router.ripup(victim)
                self._route_one(router, victim, pins, supplies, spec_for(victim), err)
        router.fix_slivers()
        router.fix_min_area()
        # report
        rep = {}
        for n, nr in router.routes.items():
            sp = spec_for(n)
            r = {"length_um": round(nr.length() / 1000, 2),
                 "layers": sorted({s[0] for s in nr.segs}), "cuts": len(nr.cuts),
                 "width_um": {l: sp.w(l) / 1000 for l in sorted({s[0] for s in nr.segs})}}
            if n not in supplies:
                r["res_ohm"] = round(router.resistance(n), 2)
            if sp.maxres is not None:
                r["maxres_ok"] = r.get("res_ohm", 0) <= sp.maxres
            rep[n] = r
        cpl = []
        for (a, b, mx, line) in self.couple:
            c = router.coupling(a, b)
            cpl.append({"nets": [a, b], "fF": round(c, 3), "max_fF": mx, "ok": c <= mx})
        self.report = {"nets": rep, "coupling": cpl, "notes": router.notes}
        return self.report

    def _route_one(self, router, n, pins, supplies, sp, err, raw=False):
        try:
            if n in supplies:
                rail = supplies[n]
                for g in sorted([g for g in pins.get(n, []) if g is not rail and g.access],
                                key=lambda g: min(abs(a.r - rail.access[0].r) for a in g.access)):
                    router.route(n, [g, rail], sp)
            else:
                router.route(n, pins[n], sp)
            if sp.maxres is not None:
                for _ in range(4):
                    if router.resistance(n) <= sp.maxres:
                        break
                    router.ripup(n)
                    # fewer vias first (cuts dominate), then wider metal
                    sp.via_weight *= 4
                    if not sp.width_fixed:
                        sp.width = {l: int(max(sp.w(l), T.rule_width(l)) * 1.4) // 10 * 10 for l in T.ROUTE_LAYERS}
                    router.route(n, pins[n], sp)
            if sp.shield:
                pieces = router.shield(n, sp.shield, sp)
                base = [g for g in pins.get(sp.shield, [])]
                if sp.shield in supplies:
                    base = [supplies[sp.shield]]
                for s in pieces:
                    acc = router.access_for(sp.shield, s, [s.layer])
                    g = PinGroup(sp.shield, f"shield of {n}", acc, [s])
                    try:
                        router.route(sp.shield, base[:1] + [g] if base else [g],
                                     NetSpec(sp.shield, layers=["m1", "m2", "m3"]))
                    except RouteError:
                        router.notes.append(f"shield piece of {n} at {s.rect} could not be tied to {sp.shield}")
        except RouteError as e:
            if raw:
                raise
            raise err(f"routing failed: {e}", sp.line,
                      "give the router room (row ... space=1 / gap=1, place ... gap=), allow more layers "
                      "(layers=m1,m2,m3), relax width/space/avoid, or route it by hand with 'wire'")

    def _wire(self, router, st, net, pins, scope, sp, err):
        line = st.line
        if "width" in st.kw:
            w = nm(scope.eval(st.kw["width"], line))
            sp = NetSpec(net, layers=sp.layers, width={l: w for l in T.ROUTE_LAYERS}, space=sp.space,
                         avoid=dict(sp.avoid), line=line)
        if "space" in st.kw:
            sp.space = nm(scope.eval(st.kw["space"], line))
        if "avoid" in st.kw:
            sp.avoid.update(_avoid(st.kw["avoid"], scope, line))
            for o, d in sp.avoid.items():
                router.set_avoid(net, o, d)
        if "path" in st.kw:
            layer = st.kw.get("layer")
            if not layer or layer not in T.ROUTE_LAYERS:
                raise err("wire path=... needs layer=<m1|m2|m3|m4>", line)
            pts_raw = scope.eval(st.kw["path"], line)
            if not isinstance(pts_raw, list) or len(pts_raw) < 2:
                raise err("path= must be a list of at least two points", line)
            pts = []
            for p in pts_raw:
                xy = _point(p, line)
                pts.append((round(xy[0] * 1000 / router.G) * router.G, round(xy[1] * 1000 / router.G) * router.G))
            # insert corners for non-axis-aligned consecutive points (horizontal first)
            full = [pts[0]]
            for q in pts[1:]:
                a = full[-1]
                if a[0] != q[0] and a[1] != q[1]:
                    full.append((q[0], a[1]))
                full.append(q)
            w = sp.w(layer)
            _, prob = router.add_wire(net, layer, full, w, sp, f"wire:{net}@{line}")
            if prob:
                raise err(f"wire {net}: {prob}", line, "move the path to another track, use another layer, "
                          "or reduce width")
            # connect endpoints that sit on pins of other layers with a via stack - also when the end is
            # given as a coordinate that lies on a shape of the same net on another layer
            for p, q in ((pts_raw[0], full[0]), (pts_raw[-1], full[-1])):
                if hasattr(p, "pin_shapes"):
                    _land(router, net, p, q, layer, sp, err, line)
                    continue
                under = []
                for L2 in ("li", "m1", "m2", "m3"):
                    if L2 == layer:
                        continue
                    for sh in router.idx[L2].query(Rect(q[0] - 1, q[1] - 1, q[0] + 1, q[1] + 1)):
                        if sh.net == net and sh.rect.contains_pt(q[0], q[1]) and not sh.owner.startswith("wire:"):
                            under.append(sh)
                if under:
                    class _Pin:
                        name = under[0].owner
                        def pin_shapes(self, _u=under[:1]):
                            return _u
                    try:
                        _land(router, net, _Pin(), q, layer, sp, err, line)
                    except ICLError:
                        router.notes.append(f"wire {net} line {line}: no via could be placed at the end "
                                            f"({q[0]/1000:.3f}, {q[1]/1000:.3f}) on {under[0].owner}")
            return
        if "from" not in st.kw or "to" not in st.kw:
            raise err("wire needs either path=[...] or from=<pin> to=<pin>", line)
        a = scope.eval(st.kw["from"], line)
        b = scope.eval(st.kw["to"], line)
        if "layers" in st.kw:
            sp.layers = _layers(st.kw["layers"], line)
        elif "layer" in st.kw:
            sp.layers = _layers(st.kw["layer"], line)
        groups = []
        for ref in (a, b):
            if not hasattr(ref, "pin_shapes"):
                raise err(f"wire from=/to= must be pins (e.g. M1.d), got {ref!r}", line)
            acc = []
            for s in ref.pin_shapes():
                acc += router.access_for(net, s, sp.layers)
            groups.append(PinGroup(net, ref.name, acc, ref.pin_shapes()))
        try:
            router.route(net, groups, sp)
        except RouteError as e:
            raise err(f"wire {net}: {e}", line, "try other layers=, a smaller width, or an explicit path=[...]")


def _point(p, line):
    if isinstance(p, Point):
        return p
    if hasattr(p, "icl_xy"):
        return p.icl_xy()
    raise ICLError(f"expected a point (x, y) or a pin, got {p!r}", line)


def _land(router, net, ref, node_xy, layer, sp, err, line):
    """Drop a via stack from a pin to a manual wire end if the pin is on another layer."""
    for s in ref.pin_shapes():
        if s.layer == layer:
            return
    for s in ref.pin_shapes():
        for a in router.access_for(net, s, [layer]):
            if router.xy(a.c, a.r) == node_xy and router.stack_ok(net, a, sp):
                router._commit(router.routes[net], sp, [(a.c, a.r, a.layer)], a, None)
                return
    raise err(f"wire {net}: endpoint {node_xy[0]/1000:.3f},{node_xy[1]/1000:.3f} is not over a legal contact "
              f"point of pin {ref.name}", line, "end the path exactly on the pin (use the pin reference itself)")


def _hpwl(groups):
    xs = [a.c for g in groups for a in g.access]
    ys = [a.r for g in groups for a in g.access]
    if not xs:
        return 0
    return (max(xs) - min(xs)) + (max(ys) - min(ys))
