"""ICL canvas: unrestricted, PDK-generic layout from plain Python.

    from icdsl.canvas import *
    tech = use()                    # PDK from `icl check f.py --pdk ...` / $ICL_PDK (default sky130A)
    c = Cell("inv")
    n = c.mos("nmos", w=0.5, gates="A", sd=("VSS", "Y"), at=(0, 0))
    ...
    check(c)                        # magic DRC + netgen LVS, violations mapped to script lines

Any layer of the PDK, any polygon, any hierarchy: see CANVAS.md.
"""
from .tech import use, current, load, available, Tech, TechError
from .core import Cell, Rect, Poly, Group, Geo, Ref, CanvasError
from . import pcells as _pcells            # attaches via / mos / tap / guard_ring / resistor / capacitor
from .pcells import Via, Mos
from .gds import write_gds, import_gds, pdk_cell
from .check import check, render_png
from . import conn
from .stick import stick, rows
from .route import Router
from .synth import stick_auto, from_spice
from .analog import mos_strip

__all__ = ["use", "current", "load", "available", "Tech", "TechError", "Cell", "Rect", "Poly", "Group", "Geo",
           "Ref", "CanvasError", "Via", "Mos", "write_gds", "import_gds", "pdk_cell", "check", "render_png",
           "conn", "stick", "rows", "Router", "stick_auto", "from_spice", "mos_strip"]
