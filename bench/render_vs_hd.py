#!/usr/bin/env python3
"""Render one of our cells next to the sky130_fd_sc_hd original with the same KLayout layer
properties: python bench/render_vs_hd.py <our.gds> <our_top> <hd_cell> <out.png>"""
import sys
import klayout.db as db
import klayout.lay as lay

ROOT = __file__.rsplit("/bench/", 1)[0]
LYP = f"{ROOT}/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyp"
HD = f"{ROOT}/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds"


def snap(gds, top, png, px=700):
    v = lay.LayoutView()
    v.set_config("background-color", "#ffffff")
    v.set_config("grid-visible", "false")
    v.set_config("text-visible", "true")
    v.load_layout(gds, True)
    v.load_layer_props(LYP)
    cv = v.cellview(0)
    cv.cell = cv.layout().cell(top)
    v.max_hier()
    v.zoom_fit()
    v.save_image(png, px, px)


ours, top, hd, out = sys.argv[1:5]
snap(ours, top, out.replace(".png", "_ours.png"))
lib = db.Layout()
lib.read(HD)
c = lib.cell(hd)
tmp = out.replace(".png", "_hd.gds")
lib.cell(hd).write(tmp)
snap(tmp, hd, out.replace(".png", "_hd.png"))
print(out.replace(".png", "_ours.png"), out.replace(".png", "_hd.png"))
