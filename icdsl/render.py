"""Render a layout to SVG (and PNG via chromium if available) for visual feedback."""
from __future__ import annotations

import html
import os
import shutil
import subprocess
import tempfile

from . import tech as T


def to_svg(L, path, scale=120, markers=(), show_grid=True, labels=None):
    """scale = pixels per um. markers: list of (Rect, text) to highlight (e.g. DRC errors)."""
    shapes = L.all_shapes(True)
    xs = [s.rect.x0 for s in shapes] + [s.rect.x1 for s in shapes]
    ys = [s.rect.y0 for s in shapes] + [s.rect.y1 for s in shapes]
    x0, x1, y0, y1 = min(xs) - 300, max(xs) + 300, min(ys) - 300, max(ys) + 300
    k = scale / 1000.0
    W, H = (x1 - x0) * k, (y1 - y0) * k

    def X(x):
        return (x - x0) * k

    def Y(y):
        return (y1 - y) * k

    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W:.0f}" height="{H:.0f}" '
           f'viewBox="0 0 {W:.1f} {H:.1f}" font-family="monospace">',
           '<rect width="100%" height="100%" fill="#fcfcfa"/>']
    if show_grid:
        G = T.GRID
        for c in range(0, L.width // G + 1):
            out.append(f'<line x1="{X(c*G):.1f}" y1="{Y(0):.1f}" x2="{X(c*G):.1f}" y2="{Y(L.height):.1f}" '
                       f'stroke="#ddd" stroke-width="0.6"/>')
            out.append(f'<text x="{X(c*G):.1f}" y="{Y(0)+14:.1f}" font-size="9" fill="#999" text-anchor="middle">{c}</text>')
        for r in range(0, L.height // G + 1):
            out.append(f'<line x1="{X(0):.1f}" y1="{Y(r*G):.1f}" x2="{X(L.width):.1f}" y2="{Y(r*G):.1f}" '
                       f'stroke="#ddd" stroke-width="0.6"/>')
            out.append(f'<text x="{X(0)-8:.1f}" y="{Y(r*G)+3:.1f}" font-size="9" fill="#999" text-anchor="end">{r}</text>')
    for lay, col, a in T.RENDER:
        for s in shapes:
            if s.layer != lay:
                continue
            r = s.rect
            stroke = col if lay not in ("licon", "mcon", "via") else "#000"
            out.append(f'<rect x="{X(r.x0):.2f}" y="{Y(r.y1):.2f}" width="{r.w*k:.2f}" height="{r.h*k:.2f}" '
                       f'fill="{col}" fill-opacity="{a}" stroke="{stroke}" stroke-width="0.5"/>')
    # boundary
    out.append(f'<rect x="{X(0):.1f}" y="{Y(L.height):.1f}" width="{L.width*k:.1f}" height="{L.height*k:.1f}" '
               f'fill="none" stroke="#444" stroke-dasharray="4 3" stroke-width="1"/>')
    # device names
    for s in shapes:
        if s.layer == "diff" and s.owner:
            r = s.rect
            out.append(f'<text x="{X(r.cx):.1f}" y="{Y(r.cy)+4:.1f}" font-size="12" font-weight="bold" '
                       f'fill="#063" text-anchor="middle">{html.escape(s.owner)}</text>')
    for (net, d, s) in L.ports:
        r = s.rect
        out.append(f'<text x="{X(r.cx):.1f}" y="{Y(r.cy)+4:.1f}" font-size="12" font-weight="bold" '
                   f'fill="#a00" text-anchor="middle" stroke="#fff" stroke-width="3" paint-order="stroke">{html.escape(net)}</text>')
    if labels:                      # object names (the agent's own statements) at their shapes
        colour = {l: c for l, c, _ in T.RENDER}
        for name, (r, lay) in labels.items():
            out.append(f'<text x="{X(r.cx):.1f}" y="{Y(r.cy)+4:.1f}" font-size="11" fill="{colour.get(lay, "#333")}" '
                       f'text-anchor="middle" stroke="#fff" stroke-width="2.5" paint-order="stroke">'
                       f'{html.escape(name)}</text>')
        leg = "  ".join(f"{l}" for l, _, _ in T.RENDER if l in {s.layer for s in shapes})
        x = 4
        for l, c, _ in T.RENDER:
            if l in {s.layer for s in shapes}:
                out.append(f'<rect x="{x}" y="4" width="10" height="10" fill="{c}" fill-opacity="0.8"/>'
                           f'<text x="{x+13}" y="13" font-size="10" fill="#333">{l}</text>')
                x += 16 + 7 * len(l)
    for (r, txt) in markers:
        out.append(f'<rect x="{X(r.x0)-3:.1f}" y="{Y(r.y1)-3:.1f}" width="{r.w*k+6:.1f}" height="{r.h*k+6:.1f}" '
                   f'fill="none" stroke="#f00" stroke-width="2.5"/>')
        out.append(f'<text x="{X(r.x1)+5:.1f}" y="{Y(r.y1):.1f}" font-size="10" fill="#f00">{html.escape(txt)}</text>')
    out.append("</svg>")
    with open(path, "w") as f:
        f.write("\n".join(out))
    return path, (W, H)


def to_png(L, path, scale=120, markers=(), labels=None):
    svg = os.path.splitext(path)[0] + ".svg"
    _, (W, H) = to_svg(L, svg, scale, markers, labels=labels)
    browser = shutil.which("chromium") or shutil.which("chromium-browser") or shutil.which("google-chrome")
    if not browser:
        return svg
    with tempfile.TemporaryDirectory() as td:
        try:
            subprocess.run([browser, "--headless", "--no-sandbox", "--disable-gpu", "--hide-scrollbars",
                            f"--user-data-dir={td}",
                            f"--screenshot={os.path.abspath(path)}", f"--window-size={int(W)+1},{int(H)+1}",
                            "file://" + os.path.abspath(svg)],
                           check=True, capture_output=True, timeout=60)
        except Exception:
            return svg
    return path
