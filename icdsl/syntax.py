"""ICL surface syntax shared by every library.

A file is a sequence of blocks:

    pdk sky130A
    import "other.icl"
    stdcell <name> key=value ...     # library: geom      (level 1)
    cell    <name> key=value ...     # library: assembly  (level 2)
    floorplan <name> key=value ...   # library: floorplan (level 3)
        [<target> =] <verb> <arg> <arg> ... <key>=<expr> ...
    end

Values are expressions: numbers (um; '0.2um', '200nm' allowed), names of
objects, dotted references (M1.d, nd.top, A.OUT.y), tuples (1.0, 2.0), lists
[M1, M2], strings, + - * /, and calls: grid(c, r), max(a, b), min(a, b).
The bare word `min` means "the rule minimum" and supports `min+0.1`.
A statement may continue on the next line while brackets are open or after '\\'.
"""
from __future__ import annotations

import ast
import difflib
import operator
import re
from dataclasses import dataclass, field


class ICLError(Exception):
    def __init__(self, msg, line=0, hint=""):
        self.msg, self.line, self.hint = msg, line, hint
        super().__init__(self.render())

    def render(self):
        s = f"line {self.line}: {self.msg}" if self.line else self.msg
        if self.hint:
            s += f"\n  hint: {self.hint}"
        return s


def did_you_mean(word, choices):
    m = difflib.get_close_matches(str(word), [str(c) for c in choices], n=1, cutoff=0.6)
    return f"did you mean '{m[0]}'?" if m else ""


@dataclass
class Stmt:
    line: int
    verb: str
    target: str | None = None
    args: list = field(default_factory=list)      # raw expression strings
    kw: dict = field(default_factory=dict)        # key -> raw expression string
    text: str = ""

    def where(self):
        return f"line {self.line}"


@dataclass
class Block:
    kind: str           # stdcell | cell | floorplan
    name: str
    head: Stmt
    body: list = field(default_factory=list)
    src: str = ""       # file it came from


@dataclass
class Program:
    pdk: str = "sky130A"
    blocks: dict = field(default_factory=dict)
    top: str = ""
    params: list = field(default_factory=list)     # (name, expression, line), file scope


BLOCK_KINDS = ("stdcell", "cell", "floorplan")
_ID = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
_ASSIGN = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([A-Za-z_][A-Za-z0-9_]*)(\s.*)?$")
_VERB = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)(\s.*)?$")


def _strip_comment(s):
    out, q = [], None
    for ch in s:
        if q:
            out.append(ch)
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
            out.append(ch)
        elif ch == "#":
            break
        else:
            out.append(ch)
    return "".join(out)


def _depth(s):
    d = 0
    q = None
    for ch in s:
        if q:
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
        elif ch in "([{":
            d += 1
        elif ch in ")]}":
            d -= 1
    return d


def _tokens(rest, line):
    """Split 'a b key=val key = (x, y)' into positional and keyword raw strings."""
    toks, cur, d, q = [], [], 0, None
    i = 0
    s = rest

    def flush():
        if cur:
            toks.append("".join(cur))
            cur.clear()

    while i < len(s):
        ch = s[i]
        if q:
            cur.append(ch)
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
            cur.append(ch)
        elif ch in "([{":
            d += 1
            cur.append(ch)
        elif ch in ")]}":
            d -= 1
            cur.append(ch)
        elif d == 0 and ch.isspace():
            flush()
        elif d == 0 and ch == "=" and (i + 1 >= len(s) or s[i + 1] != "=") and \
                (not cur or cur[-1] not in "<>!="):
            flush()
            toks.append("=")
        else:
            cur.append(ch)
        i += 1
    flush()
    if d != 0:
        raise ICLError("unbalanced brackets", line)
    args, kw = [], {}
    j = 0
    while j < len(toks):
        if j + 1 < len(toks) and toks[j + 1] == "=":
            key = toks[j]
            if not _ID.match(key):
                raise ICLError(f"bad keyword '{key}'", line)
            if j + 2 >= len(toks) or toks[j + 2] == "=":
                raise ICLError(f"'{key}=' has no value", line)
            if key in kw:
                raise ICLError(f"'{key}=' given twice", line)
            kw[key] = toks[j + 2]
            j += 3
        elif toks[j] == "=":
            raise ICLError("stray '='", line, "write key=value without spaces around a bare '=', or bind a value "
                                              "with 'name = <expression>' on its own line")
        else:
            args.append(toks[j])
            j += 1
    return args, kw


_BIND = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?)\s*$")


def parse_stmt(text, line):
    b = _BIND.match(text)
    if b and "=" not in b.group(2).replace("==", "").replace("<=", "").replace(">=", ""):
        try:                                   # `name = <expression>` is a value binding
            ast.parse(_units(b.group(2)), mode="eval")
            return Stmt(line, "let", b.group(1), [b.group(2)], {}, text.strip())
        except SyntaxError:
            pass
    m = _ASSIGN.match(text)
    if m:
        target, verb, rest = m.group(1), m.group(2), m.group(3) or ""
    else:
        m = _VERB.match(text)
        if not m:
            raise ICLError(f"cannot parse '{text.strip()}'", line,
                           "statements look like: [name =] verb arg ... key=value ...")
        target, verb, rest = None, m.group(1), m.group(2) or ""
    args, kw = _tokens(rest, line)
    return Stmt(line, verb, target, args, kw, text.strip())


def logical_lines(text):
    buf, start = "", 0
    for ln, raw in enumerate(text.splitlines(), 1):
        s = _strip_comment(raw).rstrip()
        if not buf:
            start = ln
        if s.endswith("\\"):
            buf += s[:-1] + " "
            continue
        buf += s
        if _depth(buf) > 0:
            buf += " "
            continue
        if buf.strip():
            yield start, buf
        buf = ""
    if buf.strip():
        yield start, buf


def parse_program(text, filename="<icl>", prog=None, loader=None):
    prog = prog or Program()
    cur = None
    for ln, s in logical_lines(text):
        st = parse_stmt(s, ln)
        if cur is None:
            if st.verb == "pdk":
                if not st.args or st.args[0] not in ("sky130A", "sky130"):
                    raise ICLError("only 'pdk sky130A' is supported", ln)
            elif st.verb == "param":
                if st.args or not st.kw:
                    raise ICLError("usage: param NAME=<value> [NAME=<value> ...]", ln)
                for k, v in st.kw.items():
                    prog.params.append((k, v, ln))
            elif st.verb == "import":
                if not st.args or not loader:
                    raise ICLError('usage: import "file.icl"', ln)
                loader(st.args[0].strip("\"'"), prog, ln)
            elif st.verb in BLOCK_KINDS:
                if not st.args or not _ID.match(st.args[0]):
                    raise ICLError(f"usage: {st.verb} <name> [key=value ...]", ln)
                name = st.args[0]
                if name in prog.blocks:
                    raise ICLError(f"'{name}' defined twice", ln)
                cur = Block(st.verb, name, st, [], filename)
            else:
                raise ICLError(f"'{st.verb}' must be inside a block", ln,
                               did_you_mean(st.verb, ("pdk", "import", "param") + BLOCK_KINDS)
                               or "open a block with: stdcell|cell|floorplan <name>")
        elif st.verb == "end":
            prog.blocks[cur.name] = cur
            prog.top = cur.name
            cur = None
        elif st.verb in BLOCK_KINDS:
            raise ICLError(f"{cur.kind} '{cur.name}' (line {cur.head.line}) is missing 'end'", ln)
        else:
            cur.body.append(st)
    if cur is not None:
        raise ICLError(f"{cur.kind} '{cur.name}' is missing 'end'", cur.head.line)
    if not prog.blocks:
        raise ICLError("no blocks defined (stdcell / cell / floorplan)")
    return prog


# ------------------------------------------------------------------ expressions
class Min:
    """The rule minimum, optionally plus an offset (in um)."""
    def __init__(self, off=0.0):
        self.off = off

    def __add__(self, o):
        return Min(self.off + _num(o))

    __radd__ = __add__

    def __sub__(self, o):
        return Min(self.off - _num(o))

    def __repr__(self):
        return "min" if not self.off else f"min{self.off:+g}"


class Point(tuple):
    """(x, y) in um with element-wise arithmetic."""
    def __new__(cls, x, y):
        return super().__new__(cls, (float(x), float(y)))

    @property
    def x(self):
        return self[0]

    @property
    def y(self):
        return self[1]

    def __add__(self, o):
        return Point(self[0] + o[0], self[1] + o[1])

    def __sub__(self, o):
        return Point(self[0] - o[0], self[1] - o[1])


def _num(v):
    if isinstance(v, bool):
        raise TypeError
    if isinstance(v, (int, float)):
        return float(v)
    raise TypeError(f"expected a number, got {v!r}")


_UNIT = re.compile(r"(?<![A-Za-z_])(\d+(?:\.\d*)?|\.\d+)(um|u|nm)\b")
_BIN = {ast.Add: operator.add, ast.Sub: operator.sub, ast.Mult: operator.mul, ast.Div: operator.truediv}


def _units(s):
    return _UNIT.sub(lambda m: m.group(1) if m.group(2) in ("um", "u") else f"({m.group(1)}*0.001)", s)


class Scope:
    """Name resolution for expressions. Subclassed by each library."""
    def __init__(self):
        self.names = {}

    def lookup(self, name, line):
        if name in self.names:
            return self.names[name]
        raise ICLError(f"unknown name '{name}'", line, did_you_mean(name, self.names))

    def call(self, fn, args, line):
        if fn in ("max", "min") and args:
            vals = [_num(a) for a in args]
            return max(vals) if fn == "max" else min(vals)
        if fn == "abs" and len(args) == 1:
            return abs(_num(args[0]))
        if fn == "pt" and len(args) == 2:
            return Point(args[0], args[1])
        raise ICLError(f"unknown function '{fn}'", line, did_you_mean(fn, ["max", "min", "abs", "pt", "grid"]))

    def attr(self, obj, name, line):
        if hasattr(obj, "icl_attr"):
            return obj.icl_attr(name, line)
        if isinstance(obj, Point) and name in ("x", "y"):
            return getattr(obj, name)
        raise ICLError(f"'{name}' is not an attribute of {obj!r}", line)

    def eval(self, src, line):
        try:
            tree = ast.parse(_units(src.strip()), mode="eval")
        except SyntaxError:
            raise ICLError(f"cannot parse expression '{src}'", line)
        try:
            return self._ev(tree.body, line)
        except ICLError:
            raise
        except (TypeError, ZeroDivisionError) as e:
            raise ICLError(f"bad expression '{src}': {e}", line)

    def _ev(self, n, line):
        if isinstance(n, ast.Constant):
            if isinstance(n.value, (int, float, str)):
                return n.value
            raise ICLError(f"unsupported constant {n.value!r}", line)
        if isinstance(n, ast.Name):
            if n.id == "min":
                return Min()
            if n.id in ("true", "True"):
                return True
            if n.id in ("false", "False"):
                return False
            return self.lookup(n.id, line)
        if isinstance(n, ast.Attribute):
            return self.attr(self._ev(n.value, line), n.attr, line)
        if isinstance(n, ast.Tuple):
            vals = [self._ev(e, line) for e in n.elts]
            if len(vals) == 2 and all(isinstance(v, (int, float)) for v in vals):
                return Point(*vals)
            return tuple(vals)
        if isinstance(n, ast.List):
            return [self._ev(e, line) for e in n.elts]
        if isinstance(n, ast.UnaryOp) and isinstance(n.op, ast.USub):
            v = self._ev(n.operand, line)
            return Point(-v[0], -v[1]) if isinstance(v, Point) else -_num(v)
        if isinstance(n, ast.BinOp) and type(n.op) in _BIN:
            a, b = self._ev(n.left, line), self._ev(n.right, line)
            if isinstance(a, Min) or isinstance(b, Min):
                if isinstance(n.op, ast.Add):
                    return (a if isinstance(a, Min) else b) + (b if isinstance(a, Min) else a)
                if isinstance(n.op, ast.Sub) and isinstance(a, Min):
                    return a - b
                raise ICLError("only 'min + x' / 'min - x' arithmetic is allowed", line)
            if isinstance(a, Point) and isinstance(b, Point) and type(n.op) in (ast.Add, ast.Sub):
                return a + b if isinstance(n.op, ast.Add) else a - b
            if isinstance(a, Point) and isinstance(n.op, (ast.Mult, ast.Div)):
                return Point(_BIN[type(n.op)](a[0], _num(b)), _BIN[type(n.op)](a[1], _num(b)))
            return _BIN[type(n.op)](_num(a), _num(b))
        if isinstance(n, ast.Call) and isinstance(n.func, ast.Name) and not n.keywords:
            return self.call(n.func.id, [self._ev(a, line) for a in n.args], line)
        if isinstance(n, ast.Subscript):
            obj = self._ev(n.value, line)
            idx = self._ev(n.slice, line)
            try:
                return obj[int(idx)]
            except Exception:
                raise ICLError(f"bad index [{idx}]", line)
        raise ICLError(f"unsupported expression syntax: {ast.dump(n)[:60]}", line)


def ident(s, what, line):
    s = s.strip()
    if not _ID.match(s):
        raise ICLError(f"{what}: '{s}' is not a valid name", line)
    return s


def check_keys(st, allowed, verb=None):
    for k in st.kw:
        if k not in allowed:
            raise ICLError(f"{verb or st.verb}: unknown parameter '{k}'", st.line,
                           did_you_mean(k, allowed) or f"allowed: {', '.join(sorted(allowed))}")


def nm(v_um):
    """um (float) -> nm int snapped to the 5 nm manufacturing grid."""
    return int(round(float(v_um) * 1000 / 5.0)) * 5
