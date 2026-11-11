// Builds icl_overview.pptx - an explanation of the ICL layout language.
// Build: cd slides && NODE_PATH=$PWD/node_modules node build_deck.js
const path = require("path");
const pptxgen = require("pptxgenjs");
const { applyTheme } = require(
  "/home/ibrahim/.claude/skills/synced/2f4bb6e2-025e-4a81-9e97-bb6345c87b16_f9f1cdff-3119-4b9a-a3cc-d1deee8c4769/pptx/scripts/apply_theme.js");

const IMG = (f) => path.join(__dirname, "img", f);
const OUT = path.join(__dirname, "icl_overview.pptx");

const THEME = {
  name: "ICL Silicon",
  headFontFace: "Calibri",
  bodyFontFace: "Calibri",
  colors: {
    dk1: "16202C", lt1: "FFFFFF", dk2: "34465E", lt2: "EEF2F6",
    accent1: "B35C1E",   // copper (interconnect) - brand accent
    accent2: "2A8A5C",   // diffusion green  - level 1
    accent3: "C23A25",   // poly red         - level 2
    accent4: "2F5FC4",   // metal blue       - level 3
    accent5: "6E4F9E",   // li purple
    accent6: "8A96A8",   // muted grey
    hlink: "2F5FC4", folHlink: "6E4F9E",
  },
};

const pres = new pptxgen();
pres.layout = "LAYOUT_WIDE";            // 13.333 x 7.5 in
pres.title = "ICL - one layout language, four levels";
pres.theme = { headFontFace: THEME.headFontFace, bodyFontFace: THEME.bodyFontFace };
const C = pres.SchemeColor;
const SH = pres.shapes;
const W = 13.333;
const LEVEL = { L1: C.accent2, L2: C.accent3, L3: C.accent4, L4: C.accent1 };
const IMGSIZE = {
  "inv_p.png": [515, 1018], "nand2_p.png": [635, 1018], "ota_matched.png": [876, 1483],
  "diff_stage.png": [977, 1281], "chip.png": [1841, 1604], "chip_blocks.png": [1022, 1029], "nemo_nor2.png": [740, 862],
};

// ------------------------------------------------------------------ layouts
pres.defineSlideMaster({
  title: "TITLE_DARK",
  background: { color: C.text1 },
  objects: [
    { placeholder: { options: { name: "title", type: "title", x: 0.6, y: 1.9, w: 7.3, h: 1.8, fontSize: 44,
      bold: true, color: C.background1, valign: "bottom", align: "left", margin: 0 }, text: "" } },
    { placeholder: { options: { name: "body", type: "body", x: 0.6, y: 3.9, w: 7.3, h: 1.3, fontSize: 20,
      color: C.background2, valign: "top", align: "left", margin: 0 }, text: "" } },
  ],
});
pres.defineSlideMaster({
  title: "CONTENT",
  background: { color: C.background1 },
  margin: [0.5, 0.6, 0.6, 0.6],
  objects: [
    { placeholder: { options: { name: "title", type: "title", x: 0.6, y: 0.35, w: 11.1, h: 0.9, fontSize: 36,
      bold: true, color: C.text1, valign: "middle", align: "left", margin: 0 }, text: "" } },
    { text: { text: "ICL · a layout language for agents · SKY130",
      options: { x: 0.6, y: 6.95, w: 7, h: 0.35, fontSize: 10, color: C.text2, margin: 0 } } },
  ],
  slideNumber: { x: 12.23, y: 6.95, w: 0.5, h: 0.35, fontSize: 10, color: C.text2, align: "right" },
});

// ------------------------------------------------------------------ helpers
function badge(slide, lvl) {
  slide.addShape(SH.ROUNDED_RECTANGLE, { x: 11.93, y: 0.5, w: 0.8, h: 0.6, rectRadius: 0.1,
    fill: { color: LEVEL[lvl] }, line: { color: LEVEL[lvl] }, objectName: `badge ${lvl}` });
  slide.addText(lvl, { x: 11.93, y: 0.5, w: 0.8, h: 0.6, fontSize: 20, bold: true, color: C.background1,
    align: "center", valign: "middle", margin: 0, isTextBox: true, objectName: `badge ${lvl} label` });
}

function nb(s) { // keep leading indentation of code lines
  const m = s.match(/^ */)[0].length;
  return "\u00A0".repeat(m) + s.slice(m);
}

function code(slide, lines, x, y, w, h, name, fs = 14) {
  slide.addShape(SH.ROUNDED_RECTANGLE, { x, y, w, h, rectRadius: 0.08, fill: { color: C.background2 },
    line: { color: C.background2 }, objectName: `${name} panel` });
  const runs = [];
  lines.forEach((ln, i) => {
    const brk = i < lines.length - 1;
    const k = ln.indexOf("#");
    if (k >= 0) {
      runs.push({ text: nb(ln.slice(0, k)), options: { color: C.text1 } });
      runs.push({ text: ln.slice(k), options: { color: C.accent1, breakLine: brk } });
    } else {
      runs.push({ text: nb(ln), options: { color: C.text1, breakLine: brk } });
    }
  });
  slide.addText(runs, { x: x + 0.25, y: y + 0.2, w: w - 0.5, h: h - 0.4, fontFace: "Courier New", fontSize: fs,
    valign: "top", margin: 0, paraSpaceAfter: 3, isTextBox: true, objectName: `${name} code` });
}

function picture(slide, file, bx, by, bw, bh, alt) {
  const [iw, ih] = IMGSIZE[file];
  const pad = 0.12;
  let w = bw - 2 * pad, h = (w * ih) / iw;
  if (h > bh - 2 * pad) { h = bh - 2 * pad; w = (h * iw) / ih; }
  const cx = bx + bw / 2, cy = by + bh / 2;
  slide.addShape(SH.ROUNDED_RECTANGLE, { x: cx - w / 2 - pad, y: cy - h / 2 - pad, w: w + 2 * pad, h: h + 2 * pad,
    rectRadius: 0.08, fill: { color: C.background2 }, line: { color: C.background2 }, objectName: `${file} frame` });
  slide.addImage({ path: IMG(file), x: cx - w / 2, y: cy - h / 2, w, h, altText: alt, objectName: file });
  return { x: cx - w / 2 - pad, y: cy - h / 2 - pad, w: w + 2 * pad, h: h + 2 * pad };
}

function bullets(slide, items, x, y, w, h, name, fs = 16) {
  const runs = [];
  items.forEach((it, i) => {
    const brk = i < items.length - 1;
    if (Array.isArray(it)) {
      runs.push({ text: it[0], options: { bold: true, color: C.text1 } });
      runs.push({ text: " " + it[1], options: { color: C.text1, breakLine: brk } });
    } else {
      runs.push({ text: it, options: { color: C.text1, bullet: true, breakLine: brk } });
    }
  });
  slide.addText(runs, { x, y, w, h, fontSize: fs, valign: "top", margin: 0, paraSpaceAfter: 8, isTextBox: true,
    objectName: name });
}

function stat(slide, big, label, x, y, w, color, name) {
  slide.addText(big, { x, y, w, h: 0.9, fontSize: 44, bold: true, color, margin: 0, valign: "bottom",
    isTextBox: true, objectName: `${name} value` });
  slide.addText(label, { x, y: y + 0.95, w, h: 0.75, fontSize: 14, color: C.text2, margin: 0, valign: "top",
    isTextBox: true, objectName: `${name} label` });
}

function card(slide, x, y, w, h, num, color, head, body, name) {
  slide.addShape(SH.ROUNDED_RECTANGLE, { x, y, w, h, rectRadius: 0.1, fill: { color: C.background2 },
    line: { color: C.background2 }, objectName: `${name} card` });
  slide.addShape(SH.OVAL, { x: x + 0.3, y: y + 0.3, w: 0.6, h: 0.6, fill: { color }, line: { color },
    objectName: `${name} marker` });
  slide.addText(String(num), { x: x + 0.3, y: y + 0.3, w: 0.6, h: 0.6, fontSize: 20, bold: true,
    color: C.background1, align: "center", valign: "middle", margin: 0, isTextBox: true, objectName: `${name} number` });
  slide.addText(head, { x: x + 0.3, y: y + 1.1, w: w - 0.6, h: 0.85, fontSize: 20, bold: true, color: C.text1,
    margin: 0, valign: "top", isTextBox: true, objectName: `${name} heading` });
  slide.addText(body, { x: x + 0.3, y: y + 2.1, w: w - 0.6, h: h - 2.3, fontSize: 15, color: C.text1,
    margin: 0, valign: "top", isTextBox: true, objectName: `${name} text` });
}

// ================================================================== slides
pres.addSection({ title: "Overview" });

// 1 ---------------------------------------------------------------- title
{
  const s = pres.addSlide({ masterName: "TITLE_DARK", sectionTitle: "Overview" });
  s.addText("ICL: one layout language, four levels", { placeholder: "title" });
  s.addText("SKY130 layout that AI agents can drive to DRC- and LVS-clean results", { placeholder: "body" });
  s.addText("Magic DRC · Netgen LVS · sky130A", { x: 0.6, y: 5.35, w: 7.3, h: 0.4, fontSize: 16,
    color: C.accent1, bold: true, margin: 0, isTextBox: true, objectName: "tools line" });
  picture(s, "diff_stage.png", 8.6, 0.6, 4.13, 6.3,
    "Rendered layout of the diff_stage cell: mirrored transistor pairs inside two guard rings");
  s.addNotes("ICL is a layout language for SKY130. One syntax, four libraries: hand-drawn standard cells, " +
    "circuits from transistor PCells, floorplans of finished blocks, and routing control everywhere. " +
    "Every result goes through Magic DRC and Netgen LVS. The picture is a real generated cell.");
}

// 2 ---------------------------------------------------------------- why
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Overview" });
  s.addText("Why a layout language for agents", { placeholder: "title" });
  const y = 1.6, h = 3.75, w = 3.85;
  card(s, 0.6, y, w, h, 1, C.accent2, "Relationships, not coordinates",
    "Agents are poor at geometry. Shapes and devices are placed relative to each other: above=ptap, " +
    "right_of=M1, enclose nd nsdm.", "why 1");
  card(s, 4.74, y, w, h, 2, C.accent3, "The rules live in the tool",
    "min resolves to the SKY130 rule for the layers involved. Device generators and the router are " +
    "correct by construction.", "why 2");
  card(s, 8.88, y, w, h, 3, C.accent4, "Every result is signed off",
    "Magic DRC and Netgen LVS run on each check, and errors come back against your statements and net names.",
    "why 3");
  s.addText("Intent in the file, rule numbers in the tool.", { x: 0.6, y: 5.65, w: 12.1, h: 0.5, fontSize: 18,
    italic: true, color: C.accent1, margin: 0, isTextBox: true, objectName: "tagline" });
  s.addNotes("Three design choices. Positions are relationships, so an agent never computes coordinates. " +
    "Rule numbers live in the tool behind the word min. And nothing is trusted until Magic and Netgen agree.");
}

// 3 ---------------------------------------------------------------- levels
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Overview" });
  s.addText("Four levels, one grammar", { placeholder: "title" });
  const rows = [
    ["L3", "floorplan", "places finished blocks (your cells or PDK std cells) with DRC-aware spacing"],
    ["L2", "cell", "builds circuits from transistor PCells: placement, symmetry, matching patterns"],
    ["L1", "stdcell", "hand-draws shapes, each defined relative to other shapes"],
  ];
  rows.forEach(([lvl, name, desc], i) => {
    const y = 1.55 + i * 1.3;
    s.addShape(SH.ROUNDED_RECTANGLE, { x: 0.6, y, w: 8.3, h: 1.1, rectRadius: 0.1, fill: { color: C.background2 },
      line: { color: C.background2 }, objectName: `${lvl} row` });
    s.addShape(SH.ROUNDED_RECTANGLE, { x: 0.8, y: y + 0.2, w: 0.9, h: 0.7, rectRadius: 0.1, fill: { color: LEVEL[lvl] },
      line: { color: LEVEL[lvl] }, objectName: `${lvl} chip` });
    s.addText(lvl, { x: 0.8, y: y + 0.2, w: 0.9, h: 0.7, fontSize: 22, bold: true, color: C.background1,
      align: "center", valign: "middle", margin: 0, isTextBox: true, objectName: `${lvl} chip label` });
    s.addText([{ text: name, options: { bold: true, fontSize: 20, breakLine: true } },
               { text: desc, options: { fontSize: 15 } }],
      { x: 1.95, y: y + 0.1, w: 6.8, h: 0.9, color: C.text1, valign: "middle", margin: 0, isTextBox: true,
        objectName: `${lvl} text` });
  });
  s.addShape(SH.ROUNDED_RECTANGLE, { x: 9.2, y: 1.55, w: 3.53, h: 3.7, rectRadius: 0.1, fill: { color: C.accent1 },
    line: { color: C.accent1 }, objectName: "L4 block" });
  s.addText([{ text: "L4  route", options: { bold: true, fontSize: 22, breakLine: true } },
             { text: "routing control inside every block: width, keep-out, symmetry, shields, resistance, coupling",
               options: { fontSize: 15 } }],
    { x: 9.45, y: 1.75, w: 3.03, h: 3.3, color: C.background1, valign: "top", margin: 0, isTextBox: true,
      objectName: "L4 text" });
  code(s, ["[name =] verb  arg  arg ...  key=value ...     # every statement, every level"],
    0.6, 5.55, 12.13, 0.85, "grammar");
  s.addNotes("Three block types nested by abstraction, plus routing statements usable inside all of them. " +
    "A stdcell is instantiated in a cell, a cell in a floorplan, with inst. Same statement shape everywhere.");
}

// 4 ---------------------------------------------------------------- grammar
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Overview" });
  s.addText("The shared grammar", { placeholder: "title" });
  code(s, [
    "param WN=0.52 L=0.15 H=2.72      # file level",
    "",
    "stdcell inv_p width=3 height=H",
    "  dw = 2*L + 0.53                # value binding",
    "  nd = rect diff w=dw h=WN cx=cell.cx above=ptap",
    "  g  = cross [nd, pd] poly w=L   # endcaps = min",
    "  sn = array licon in=nd left_of=g",
    "end",
    "",
    "$ bin/icl check f.icl --param L=0.25",
  ], 0.6, 1.55, 7.2, 3.95, "grammar example");
  const items = [
    ["min", "the rule minimum for the layers involved; min+0.1 also works"],
    ["References", "attributes of things already made: nd.top, M1.d, AMP.OUT, MT.cx"],
    ["Parameters", "param at file level; sweeps override it with \u2011\u2011param"],
    ["Bindings", "name = expression, reused in later statements"],
  ];
  items.forEach(([h, t], i) => {
    const y = 1.6 + i * 1.2;
    s.addShape(SH.ROUNDED_RECTANGLE, { x: 8.2, y: y + 0.08, w: 0.28, h: 0.28, rectRadius: 0.05,
      fill: { color: [C.accent2, C.accent3, C.accent4, C.accent1][i] }, line: { color: [C.accent2, C.accent3, C.accent4, C.accent1][i] },
      objectName: `grammar marker ${i}` });
    s.addText([{ text: h, options: { bold: true, fontSize: 18, breakLine: true } }, { text: t, options: { fontSize: 15 } }],
      { x: 8.65, y, w: 4.08, h: 1.05, color: C.text1, margin: 0, valign: "top", isTextBox: true,
        objectName: `grammar item ${i}` });
  });
  s.addNotes("Values are expressions in micrometres. min is the key word: it becomes the right rule for each " +
    "layer pair. Parameters make whole cells parametric, so a sweep is just --param on the command line.");
}

pres.addSection({ title: "The four levels" });

// 5 ---------------------------------------------------------------- L1
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The four levels" });
  s.addText("Level 1 · stdcell: relative shapes", { placeholder: "title" });
  badge(s, "L1");
  code(s, [
    "stdcell inv_p width=3 height=H",
    "  device MN nmos w=WN l=L d=Y g=A s=VGND",
    "  nd  = rect diff w=(L+0.53) h=WN above=ptap",
    "  nim = enclose nd nsdm        # rule enclosure",
    "  g   = cross [nd, pd] poly w=L",
    "  sn  = array licon in=nd left_of=g",
    "  gnd = strap li from=snl to=vgnd_li",
    "  gc  = contact licon bottom=max(...)",
    "  well y=((nd.top + 0.34 + pd.bottom - 0.18)/2)",
    "  port A in on=ap",
  ], 0.6, 1.55, 7.0, 3.75, "L1");
  s.addText("The template supplies rails, taps and the n-well. A fast pre-check reports rule issues by statement line.",
    { x: 0.6, y: 5.5, w: 7.0, h: 0.75, fontSize: 15, color: C.text2, margin: 0, isTextBox: true, objectName: "L1 caption" });
  picture(s, "inv_p.png", 7.9, 1.55, 2.6, 5.3, "Rendered parametric inverter standard cell, 1.38 by 2.72 micrometres");
  stat(s, "22/22", "parameter sweep points DRC + LVS clean (W, L, cell height)", 10.75, 2.3, 1.98, C.accent2, "L1 stat");
  s.addNotes("Every shape has a name and a relationship. Because positions are derived, changing W, L or height " +
    "keeps the cell legal: this inverter passes all 22 sweep points with full Magic and Netgen checks.");
}

// 6 ---------------------------------------------------------------- L2 matching
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The four levels" });
  s.addText("Level 2 · cell: devices + matching", { placeholder: "title" });
  badge(s, "L2");
  code(s, [
    "nmos M1 w=1.0 l=0.5 nf=2 d=x   g=INP s=tail",
    "nmos M2 w=1.0 l=0.5 nf=2 d=OUT g=INN s=tail",
    "interdigitate M1 M2 pattern=ABBA dummies=1",
    "common_centroid M3 M4 pattern=AB/BA",
    "place MT   above=TP align=center",
    "place DP   above=MT align=center",
    "place LOAD above=DP gap=0.8",
    "route tail width=0.4 maxres=10",
  ], 0.6, 1.55, 7.6, 2.95, "L2");
  bullets(s, [
    ["gap=min", "slides an object until every layer pair sits at its rule"],
    ["Patterns", "source/drain columns and gate-strap sides are solved for you"],
  ], 0.6, 4.75, 7.6, 1.4, "L2 notes", 16);
  picture(s, "ota_matched.png", 8.6, 1.4, 4.13, 5.5, "Rendered 5-transistor OTA with interdigitated pair and common-centroid load");
  s.addNotes("Here you declare transistors and say how they relate. The OTA has an ABBA input pair with dummies, " +
    "a 2x2 common-centroid load, and a 0.4 micrometre tail with a resistance limit.");
}

// 7 ---------------------------------------------------------------- L2 symmetry
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The four levels" });
  s.addText("Level 2 · symmetry and guard rings", { placeholder: "title" });
  badge(s, "L2");
  picture(s, "diff_stage.png", 0.6, 1.4, 4.3, 5.5, "Rendered differential stage with mirrored pairs and guard rings");
  code(s, [
    "place MT at=(0, 0)",
    "pair  M1 M2 axis=MT.cx above=MT",
    "pair  M3 M4 axis=MT.cx above=M1 vgap=2.0",
    "guardring GN around=[MT, M1, M2] kind=ptap",
    "guardring GP around=[M3, M4] kind=ntap",
    "route OUTN OUTP symmetric axis=MT.cx",
  ], 5.3, 1.55, 7.43, 2.35, "L2 symmetry");
  bullets(s, [
    ["pair", "M2 is the mirror image of M1, at the minimum legal distance"],
    ["guardring", "checks its own clearance and says how much room it needs"],
    ["symmetric", "OUTP is routed as the exact mirror of OUTN"],
  ], 5.3, 4.2, 7.43, 2.2, "L2 symmetry notes", 16);
  s.addNotes("Analog intent is first-class: mirrored placement, guard rings that check their own fit, and " +
    "symmetric routing. The outputs on the picture are exact mirror images.");
}

// 8 ---------------------------------------------------------------- L3
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The four levels" });
  s.addText("Level 3 · DRC-aware floorplans", { placeholder: "title" });
  badge(s, "L3");
  const cf = picture(s, "chip_blocks.png", 0.6, 1.45, 5.8, 4.95, "Rendered chip floorplan, cropped to the placed blocks");
  s.addText("Floorplan render, cropped to the placed blocks", { x: cf.x, y: cf.y + cf.h + 0.08, w: cf.w, h: 0.35,
    fontSize: 12, color: C.text2, margin: 0, isTextBox: true, objectName: "L3 caption" });
  code(s, [
    "inst AMP ota_matched INP=dp INN=dn",
    "inst BUF pdk:sky130_fd_sc_hd__inv_2",
    "place AMP right_of=DIF align=bottom",
    "place BUF right_of=TAP",
    "proximity NAND TAP",
  ], 6.8, 1.55, 5.93, 2.0, "L3");
  const rows = [
    [C.accent2, "AMP abutted DIF: facing layers merge legally"],
    [C.accent1, "TAP cannot abut NAND: nsdm 0.24 < 0.38 µm, moved to the 1.84 µm minimum"],
    [C.accent2, "BUF abutted TAP: wells merge, the buffer is tapped"],
  ];
  s.addText("What the tool decided", { x: 6.8, y: 3.85, w: 5.93, h: 0.45, fontSize: 18, bold: true, color: C.text1,
    margin: 0, isTextBox: true, objectName: "L3 decided heading" });
  rows.forEach(([col, txt], i) => {
    const y = 4.45 + i * 0.85;
    s.addShape(SH.OVAL, { x: 6.8, y: y + 0.08, w: 0.26, h: 0.26, fill: { color: col }, line: { color: col },
      objectName: `L3 status ${i}` });
    s.addText(txt, { x: 7.2, y, w: 5.53, h: 0.8, fontSize: 15, color: C.text1, margin: 0, valign: "top",
      isTextBox: true, objectName: `L3 decision ${i}` });
  });
  s.addNotes("Blocks can be your cells or real PDK standard cells. The placer abuts blocks only when every facing " +
    "layer merges legally; otherwise it moves to the smallest legal gap and records the binding rule.");
}

// 9 ---------------------------------------------------------------- L4
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The four levels" });
  s.addText("Level 4 · routing intent, verified", { placeholder: "title" });
  badge(s, "L4");
  code(s, [
    "route VBN  width=0.2 avoid=OUTN:1.0",
    "route OUTN OUTP symmetric axis=MT.cx",
    "route VBN  shield=VGND",
    "route tail width=0.4 maxres=10",
    "limit coupling OUT INN max=0.05",
    "wire  VBP layer=m2 width=0.2 from=M3.g to=M4.g",
    "wire  Y   layer=m2 path=[N1.d, (N1.d.x, 1.84)]",
    "keepout aout INP dist=1.0",
  ], 0.6, 1.55, 7.6, 3.4, "L4");
  s.addText("The router checks every wire, via and pad against real shapes with the spacing for that pair of nets, " +
    "so constraints cannot create DRC errors.", { x: 0.6, y: 5.25, w: 7.6, h: 0.9, fontSize: 15, color: C.text2,
    margin: 0, isTextBox: true, objectName: "L4 caption" });
  stat(s, "0.20 µm", "VBN width as drawn (asked 0.2)", 8.75, 1.4, 3.98, C.accent1, "L4 width");
  stat(s, "1.06 µm", "closest VBN to OUTN approach (asked at least 1.0)", 8.75, 3.15, 3.98, C.accent1, "L4 keepout");
  stat(s, "3.2 Ω", "tail resistance (limit 10 Ω, width kept at 0.4)", 8.75, 4.9, 3.98, C.accent1, "L4 res");
  s.addNotes("Auto routing by default; constraints only where they matter. The numbers on the right were measured " +
    "from the generated geometry, not taken from the request.");
}

pres.addSection({ title: "How it works" });

// 10 --------------------------------------------------------------- loop
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "How it works" });
  s.addText("One command, feedback in your terms", { placeholder: "title" });
  const steps = [["Write", ".icl file"], ["Compile", "line + hint on error"], ["Build", "GDS + reference netlist"],
    ["Magic", "full DRC deck"], ["Netgen", "LVS vs netlist"]];
  steps.forEach(([h, sub], i) => {
    const x = 0.6 + i * 2.5;
    const col = i === steps.length - 1 ? C.accent1 : C.text2;
    s.addShape(SH.ROUNDED_RECTANGLE, { x, y: 1.6, w: 2.05, h: 0.95, rectRadius: 0.1, fill: { color: col },
      line: { color: col }, objectName: `step ${i}` });
    s.addText(h, { x, y: 1.6, w: 2.05, h: 0.95, fontSize: 20, bold: true, color: C.background1, align: "center",
      valign: "middle", margin: 0, isTextBox: true, objectName: `step ${i} label` });
    s.addText(sub, { x, y: 2.65, w: 2.05, h: 0.6, fontSize: 14, color: C.text2, align: "center", margin: 0,
      valign: "top", isTextBox: true, objectName: `step ${i} detail` });
    if (i < steps.length - 1) {
      s.addShape(SH.RIGHT_ARROW, { x: x + 2.12, y: 1.92, w: 0.32, h: 0.32, fill: { color: C.accent6 },
        line: { color: C.accent6 }, objectName: `arrow ${i}` });
    }
  });
  code(s, [
    "$ bin/icl check examples/l3_chip.icl --top chip",
    "== chip  30.00 x 26.00 um  ->  CLEAN  (9.4s)",
    "DRC (magic drc(full) sky130A): 0 violation(s)",
    "LVS (netgen): MATCH  devices [5, 5]  nets [13, 13]",
  ], 0.6, 3.6, 7.3, 1.85, "loop output");
  bullets(s, [
    ["Compile errors:", "line number and a suggested fix"],
    ["DRC:", "the DSL objects under each error box"],
    ["LVS:", "reported with your net names"],
    ["Warnings:", "dangling nets, unreachable pins"],
  ], 8.3, 3.6, 4.43, 2.4, "loop feedback", 15);
  s.addText("Exit code 0 means clean · --json for machine-readable reports · PNG with errors boxed in red",
    { x: 0.6, y: 5.8, w: 12.13, h: 0.45, fontSize: 15, color: C.text2, margin: 0, isTextBox: true,
      objectName: "loop footer" });
  s.addNotes("bin/icl check does everything in a few seconds. The point is the feedback: every error is " +
    "translated back to the statement or net the agent wrote, so the next attempt knows what to change.");
}

// 11 --------------------------------------------------------------- why clean
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "How it works" });
  s.addText("Why the layouts stay DRC-clean", { placeholder: "title" });
  const items = [
    [C.accent2, "Rule-aware compaction", "gap=min slides objects until every layer pair (diffusion, poly, implants, wells, metals) sits at its rule."],
    [C.accent3, "Correct-by-construction PCells", "MOS arrays, taps, guard rings; patterns solve source/drain columns and gate-strap sides."],
    [C.accent4, "Geometric router", "pair-specific spacing, notch fills for wide wires, off-grid pin stubs, min-area repair, rip-up and retry."],
    [C.accent1, "Automatic wells and implants", "merged across devices, narrow necks repaired, missing body ties reported as errors."],
  ];
  items.forEach(([col, h, t], i) => {
    const x = 0.6 + (i % 2) * 6.17, y = 1.55 + Math.floor(i / 2) * 2.6;
    s.addShape(SH.ROUNDED_RECTANGLE, { x, y, w: 5.96, h: 2.35, rectRadius: 0.1, fill: { color: C.background2 },
      line: { color: C.background2 }, objectName: `clean card ${i}` });
    s.addShape(SH.OVAL, { x: x + 0.3, y: y + 0.3, w: 0.5, h: 0.5, fill: { color: col }, line: { color: col },
      objectName: `clean marker ${i}` });
    s.addText(h, { x: x + 1.0, y: y + 0.28, w: 4.7, h: 0.55, fontSize: 20, bold: true, color: C.text1, margin: 0,
      valign: "middle", isTextBox: true, objectName: `clean heading ${i}` });
    s.addText(t, { x: x + 0.3, y: y + 1.0, w: 5.36, h: 1.2, fontSize: 15, color: C.text1, margin: 0, valign: "top",
      isTextBox: true, objectName: `clean text ${i}` });
  });
  s.addNotes("Four mechanisms carry the rule knowledge. The result: routing can fail with a clear message, but it " +
    "does not produce spacing errors.");
}

pres.addSection({ title: "Results" });

// 12 --------------------------------------------------------------- results
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Results" });
  s.addText("Results so far", { placeholder: "title" });
  stat(s, "11/11", "example cells across all four levels pass DRC and LVS", 0.6, 1.7, 3.7, C.accent2, "res cells");
  stat(s, "79/79", "random designs that compiled came out DRC + LVS clean (geometric router)", 4.75, 1.7, 3.7, C.accent4, "res fuzz");
  stat(s, "22/22", "sweep points for each hand-written parametric cell", 8.9, 1.7, 3.83, C.accent1, "res sweep");
  const groups = [
    ["L1", "inv1 · nand2 (hand-drawn, hd footprints)"],
    ["L2", "inv · nand2 · ota5t · strongarm · dff · ring5 · ota_matched · diff_stage"],
    ["L3", "chip: diff stage → OTA → inverter → NAND → PDK inv_2, 30 × 26 µm"],
  ];
  groups.forEach(([lvl, txt], i) => {
    const y = 4.2 + i * 0.8;
    s.addShape(SH.ROUNDED_RECTANGLE, { x: 0.6, y, w: 0.7, h: 0.5, rectRadius: 0.08, fill: { color: LEVEL[lvl] },
      line: { color: LEVEL[lvl] }, objectName: `res ${lvl} chip` });
    s.addText(lvl, { x: 0.6, y, w: 0.7, h: 0.5, fontSize: 16, bold: true, color: C.background1, align: "center",
      valign: "middle", margin: 0, isTextBox: true, objectName: `res ${lvl} chip label` });
    s.addText(txt, { x: 1.5, y, w: 11.23, h: 0.5, fontSize: 16, color: C.text1, valign: "middle", margin: 0,
      isTextBox: true, objectName: `res ${lvl} cells` });
  });
  s.addNotes("All example cells pass signoff. Random designs exercise the generators and router: every one that " +
    "compiled was clean; the rest were refused up front with an explanation.");
}

// 13 --------------------------------------------------------------- nemotron
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Results" });
  s.addText("A free model driving ICL", { placeholder: "title" });
  s.addText("nvidia/nemotron-3.5-super-vl:free · 41 calls · $0 · LVS against an independent netlist",
    { x: 0.6, y: 1.2, w: 12.13, h: 0.4, fontSize: 15, color: C.text2, margin: 0, isTextBox: true, objectName: "nemo sub" });
  const cols = ["nand2", "nor2", "buf", "aoi21"];
  const runs = [
    ["Run 1 · reference + 1 example", [["fail", 3], ["fail", 3], ["fail", 3], ["fail", 3]]],
    ["Run 2 · + method, 2nd example", [["example", 0], ["clean 22/22", 2], ["26 DRC, LVS ok", 1], ["fail", 3]]],
    ["Run 3 · 5 attempts", [["", 0], ["", 0], ["DRC 0, LVS fail", 1], ["fail", 3]]],
    ["Run 4 · + series-node hint", [["", 0], ["", 0], ["fail", 3], ["", 0]]],
  ];
  const fill = [C.background2, C.accent1, C.accent2, C.accent3];
  const tx0 = 3.55, cw = 1.32, gx = 0.12, ty0 = 1.95, rh = 0.62, gy = 0.14;
  cols.forEach((c, j) => s.addText(c, { x: tx0 + j * (cw + gx), y: ty0, w: cw, h: 0.4, fontSize: 15, bold: true,
    color: C.text1, align: "center", margin: 0, isTextBox: true, objectName: `nemo col ${c}` }));
  runs.forEach(([label, cells], i) => {
    const y = ty0 + 0.5 + i * (rh + gy);
    s.addText(label, { x: 0.6, y, w: 2.85, h: rh, fontSize: 14, color: C.text1, valign: "middle", margin: 0,
      isTextBox: true, objectName: `nemo row ${i}` });
    cells.forEach(([t, k], j) => {
      const x = tx0 + j * (cw + gx);
      s.addShape(SH.ROUNDED_RECTANGLE, { x, y, w: cw, h: rh, rectRadius: 0.08, fill: { color: fill[k] },
        line: { color: fill[k] }, objectName: `nemo cell ${i}-${j}` });
      if (t) s.addText(t, { x, y, w: cw, h: rh, fontSize: 12, bold: k > 0, color: k > 0 ? C.background1 : C.text2,
        align: "center", valign: "middle", margin: 0.03, isTextBox: true, objectName: `nemo cell ${i}-${j} label` });
    });
  });
  s.addText("The biggest gain came from the prompt (method + second example), not from more attempts.",
    { x: 0.6, y: 5.75, w: 8.1, h: 0.9, fontSize: 16, italic: true, color: C.accent1, margin: 0, isTextBox: true,
      objectName: "nemo takeaway" });
  const f = picture(s, "nemo_nor2.png", 9.4, 1.85, 3.33, 3.9, "Nemotron's NOR2 standard cell layout, DRC and LVS clean");
  s.addText("Nemotron's NOR2: clean on the first try, clean at all 22 sweep points", { x: f.x, y: f.y + f.h + 0.15,
    w: f.w, h: 0.75, fontSize: 14, color: C.text2, margin: 0, isTextBox: true, objectName: "nemo caption" });
  s.addNotes("The model wrote parametric cells; the harness checked each with an independent reference netlist and " +
    "swept W, L and height. NOR2 succeeded; BUF got close; AOI21 did not converge. Results vary between runs.");
}

// 14 --------------------------------------------------------------- lessons
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Results" });
  s.addText("What the experiment changed", { placeholder: "title" });
  const colw = 5.96;
  [[0.6, C.accent3, "Model mistakes → language fixes", [
      ["nd_w = 2*L + 0.72", "now a supported value binding"],
      ["gap= in stdcells", "accepted as an alias of space="],
      ["cross ... yspan=", "was silently ignored, now an explained error"],
      ["Uncontacted shared column", "LVS feedback names the series node"],
    ]],
   [6.77, C.accent2, "Bugs the sweeps found → fixed", [
      ["n-well split fixed at 1.305 µm", "now scales with height, plus well y="],
      ["met1 pin overhang of 0.04 µm", "pin access needs a full wire width"],
      ["Gate-contact li spacing at W=0.42", "max() rule in the worked example"],
    ]]].forEach(([x, col, head, items], k) => {
    s.addShape(SH.ROUNDED_RECTANGLE, { x, y: 1.55, w: colw, h: 4.2, rectRadius: 0.1, fill: { color: C.background2 },
      line: { color: C.background2 }, objectName: `lesson card ${k}` });
    s.addShape(SH.OVAL, { x: x + 0.3, y: 1.8, w: 0.45, h: 0.45, fill: { color: col }, line: { color: col },
      objectName: `lesson marker ${k}` });
    s.addText(head, { x: x + 0.95, y: 1.75, w: colw - 1.2, h: 0.55, fontSize: 20, bold: true, color: C.text1,
      margin: 0, valign: "middle", isTextBox: true, objectName: `lesson heading ${k}` });
    bullets(s, items, x + 0.3, 2.6, colw - 0.6, 3.0, `lesson list ${k}`, 16);
  });
  s.addNotes("The experiment improved the language: agent mistakes became features or clearer errors, and the " +
    "parameter sweeps found three real bugs in the generators and router.");
}

pres.addSection({ title: "Wrap-up" });

// 15 --------------------------------------------------------------- limits
{
  const s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Wrap-up" });
  s.addText("Limits, and what came next", { placeholder: "title" });
  [[0.6, C.accent6, "Limits of the ICL language", [
      "1.8 V transistors only; no resistors or capacitors",
      "Routing on met1 to met4",
      "Resistance and coupling are estimates",
      "SKY130 only; magic is the only DRC judge",
      "No antenna or density checks; nothing simulated",
    ]],
   [6.77, C.accent1, "What came next: the canvas", [
      "Plain Python scripts: any layer, any polygon, resistors and MIM capacitors",
      "Three PDKs from one script: sky130A, gf180mcuD and freepdk45 (45 nm)",
      "The PDK's own KLayout deck as a second DRC judge",
      "A larger benchmark: 8 tasks, up to 768 transistors",
      "See icl_canvas.pptx and CANVAS.md (status 2026-11-11)",
    ]]].forEach(([x, col, head, items], k) => {
    s.addShape(SH.ROUNDED_RECTANGLE, { x, y: 1.55, w: 5.96, h: 4.6, rectRadius: 0.1, fill: { color: C.background2 },
      line: { color: C.background2 }, objectName: `wrap card ${k}` });
    s.addShape(SH.OVAL, { x: x + 0.3, y: 1.8, w: 0.45, h: 0.45, fill: { color: col }, line: { color: col },
      objectName: `wrap marker ${k}` });
    s.addText(head, { x: x + 0.95, y: 1.75, w: 4.7, h: 0.55, fontSize: 20, bold: true, color: C.text1, margin: 0,
      valign: "middle", isTextBox: true, objectName: `wrap heading ${k}` });
    bullets(s, items, x + 0.3, 2.6, 5.36, 3.4, `wrap list ${k}`, 16);
  });
  s.addNotes("The limits on the left are those of the ICL language: MOS only, SKY130 only, estimates for R and C, and no " +
    "simulation. The right side is what was added later as a second interface, the canvas. It lifts the first, second " +
    "and fourth limit; the deck icl_canvas.pptx describes it.");
}

// 16 --------------------------------------------------------------- closing
{
  const s = pres.addSlide({ masterName: "TITLE_DARK", sectionTitle: "Wrap-up" });
  s.addText("Try it", { placeholder: "title" });
  s.addText("Reference: AGENTS.md · CANVAS.md · examples/ · agents/README.md", { placeholder: "body" });
  s.addShape(SH.ROUNDED_RECTANGLE, { x: 0.6, y: 5.2, w: 12.13, h: 1.6, rectRadius: 0.08, fill: { color: C.text2 },
    line: { color: C.text2 }, objectName: "closing code panel" });
  s.addText([
    { text: "bin/icl check   examples/l2_analog.icl --top diff_stage", options: { breakLine: true } },
    { text: "bin/icl inspect examples/l3_chip.icl --top chip", options: { breakLine: true } },
    { text: "bin/icl check   tests/canvas/strip.py --pdk freepdk45" },
  ], { x: 0.85, y: 5.32, w: 11.63, h: 1.36, fontFace: "Courier New", fontSize: 18, color: C.background1, margin: 0,
    valign: "middle", isTextBox: true, objectName: "closing code" });
  picture(s, "nand2_p.png", 9.6, 0.6, 3.13, 4.4, "Rendered parametric NAND2 standard cell");
  s.addNotes("Three commands to start: two on ICL files, one on a canvas script with another PDK. AGENTS.md is the reference " +
    "of the ICL language and CANVAS.md that of the canvas; the examples go level by level.");
}

(async () => {
  await pres.writeFile({ fileName: OUT });
  await applyTheme(OUT, THEME);
  console.log("wrote", OUT);
})();
