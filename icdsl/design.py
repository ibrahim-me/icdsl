"""Compile an ICL program: dispatch each block to its library, resolve imports and dependencies."""
from __future__ import annotations

import os

from .syntax import ICLError, did_you_mean, parse_program


class Design:
    def __init__(self, prog, overrides=None):
        from .syntax import Scope
        self.prog = prog
        self.lib = {}
        self.building = []
        overrides = dict(overrides or {})
        names = {n for (n, _, _) in prog.params}
        for k in overrides:
            if k not in names:
                raise ICLError(f"--param {k}: no such parameter", 0, did_you_mean(k, names) or
                               f"declared parameters: {', '.join(sorted(names)) or '-'}")
        sc = Scope()
        self.params = {}
        for (n, expr, line) in prog.params:
            sc.names = dict(self.params)
            self.params[n] = sc.eval(str(overrides.get(n, expr)), line)

    def build(self, name, line=0):
        if name in self.lib:
            return self.lib[name]
        if name.startswith("pdk:"):
            from .foreign import pdk_cell
            self.lib[name] = pdk_cell(name[4:], line)
            return self.lib[name]
        if name not in self.prog.blocks:
            raise ICLError(f"unknown cell '{name}'", line, did_you_mean(name, self.prog.blocks) or
                           "define it earlier in the file, import it, or use pdk:<std cell name>")
        if name in self.building:
            raise ICLError(f"cell '{name}' instantiates itself (cycle: {' -> '.join(self.building + [name])})", line)
        self.building.append(name)
        blk = self.prog.blocks[name]
        if blk.kind == "cell":
            from .lib_assembly import AssemblyBuilder as B
        elif blk.kind == "stdcell":
            from .lib_geom import GeomBuilder as B
        else:
            from .lib_floorplan import FloorplanBuilder as B
        lay = B(self, blk).build()
        self.building.pop()
        self.lib[name] = lay
        return lay


def load(path):
    base = os.path.dirname(os.path.abspath(path))
    seen = set()

    def loader(rel, prog, line):
        p = os.path.join(base, rel)
        if p in seen:
            return
        seen.add(p)
        if not os.path.exists(p):
            raise ICLError(f"import: file '{rel}' not found", line)
        parse_program(open(p).read(), p, prog, loader)

    return parse_program(open(path).read(), path, None, loader)


def compile_file(path, top=None, params=None):
    prog = load(path)
    d = Design(prog, params)
    for n in prog.blocks:
        d.build(n)
    t = top or prog.top
    if t not in d.lib:
        raise ICLError(f"no cell named '{t}'", 0, did_you_mean(t, d.lib))
    return d.lib[t], d.lib
