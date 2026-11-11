// ICL canvas deck: the review against the goal, the canvas, three PDKs, the larger benchmark (bench/xl), LLM runs.
// Build: cd slides && NODE_PATH=$PWD/node_modules node build_canvas_deck.js
// Numbers come from CANVAS.md, bench/xl/README.md, bench/xl/REFERENCE.md and agents/README.md (section "XL benchmark").
const path = require("path");
const pptxgen = require("pptxgenjs");
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");
const fa = require("react-icons/fa");
const SKILL = "/home/ibrahim/.claude/skills/synced/2f4bb6e2-025e-4a81-9e97-bb6345c87b16_f9f1cdff-3119-4b9a-a3cc-d1deee8c4769/pptx";
const { applyTheme } = require(path.join(SKILL, "scripts", "apply_theme.js"));

const THEME = {
  name: "ICL Silicon",
  headFontFace: "Cambria",
  bodyFontFace: "Calibri",
  colors: {
    dk1: "1A2233", lt1: "FFFFFF", dk2: "3A4A5E", lt2: "EEF2F6",
    accent1: "D9572B", accent2: "2E9E6B", accent3: "3A6ED8", accent4: "8E5BC9",
    accent5: "E8A33A", accent6: "6B7A8F", hlink: "3A6ED8", folHlink: "8E5BC9",
  },
};
const HEX = THEME.colors;
const IMG = path.join(__dirname, "img3");
const OUT = path.join(__dirname, "icl_canvas.pptx");

async function icon(Comp, color = "FFFFFF", size = 256) {
  const svg = ReactDOMServer.renderToStaticMarkup(React.createElement(Comp, { color: "#" + color, size: String(size) }));
  const png = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + png.toString("base64");
}

(async () => {
  const pres = new pptxgen();
  pres.layout = "LAYOUT_WIDE"; // 13.33 x 7.5
  pres.theme = { headFontFace: THEME.headFontFace, bodyFontFace: THEME.bodyFontFace };
  pres.title = "ICL canvas: any shape, three PDKs, larger layouts";
  pres.author = "icdsl";
  const C = pres.SchemeColor;

  // ------------------------------------------------------------------ layouts
  pres.defineSlideMaster({
    title: "TITLE_DARK",
    background: { color: HEX.dk1 },
    objects: [
      { placeholder: { options: { name: "title", type: "title", x: 0.6, y: 2.0, w: 7.4, h: 1.9, fontSize: 40, bold: true,
        color: C.background1, valign: "bottom", align: "left", margin: 0 }, text: "" } },
      { placeholder: { options: { name: "body", type: "body", x: 0.6, y: 4.1, w: 7.2, h: 1.5, fontSize: 18,
        color: "C9D3E0", valign: "top", align: "left", margin: 0 }, text: "" } },
    ],
  });
  pres.defineSlideMaster({
    title: "CLOSING_DARK",
    background: { color: HEX.dk1 },
    objects: [
      { placeholder: { options: { name: "title", type: "title", x: 0.6, y: 0.55, w: 7.6, h: 0.9, fontSize: 36, bold: true,
        color: C.background1, valign: "middle", align: "left", margin: 0 }, text: "" } },
      { placeholder: { options: { name: "body", type: "body", x: 0.6, y: 1.75, w: 7.6, h: 4.6, fontSize: 20,
        color: "DDE4EE", valign: "top", align: "left", margin: 0, paraSpaceAfter: 14 }, text: "" } },
    ],
  });
  pres.defineSlideMaster({
    title: "CONTENT",
    background: { color: HEX.lt1 },
    margin: [0.5, 0.5, 0.6, 0.5],
    objects: [
      { placeholder: { options: { name: "title", type: "title", x: 0.55, y: 0.32, w: 12.2, h: 0.85, fontSize: 30, bold: true,
        color: C.text1, valign: "middle", align: "left", margin: 0 }, text: "" } },
      { text: { text: "ICL canvas  |  layout agents on three PDKs", options: { x: 0.55, y: 7.05, w: 6, h: 0.3, fontSize: 10, color: C.accent6, margin: 0 } } },
    ],
    slideNumber: { x: 12.3, y: 7.05, w: 0.5, h: 0.3, fontSize: 10, color: HEX.accent6 },
  });

  // ------------------------------------------------------------------ helpers
  const icons = {
    layers: await icon(fa.FaLayerGroup), chip: await icon(fa.FaMicrochip), route: await icon(fa.FaRoute),
    grid: await icon(fa.FaThLarge), check: await icon(fa.FaCheck), book: await icon(fa.FaBook),
    tools: await icon(fa.FaTools), project: await icon(fa.FaProjectDiagram), ruler: await icon(fa.FaRulerCombined),
    robot: await icon(fa.FaRobot), pen: await icon(fa.FaPen), warn: await icon(fa.FaExclamationTriangle),
    shapes: await icon(fa.FaShapes), polygon: await icon(fa.FaDrawPolygon), database: await icon(fa.FaDatabase),
    random: await icon(fa.FaRandom), comment: await icon(fa.FaCommentDots), cubes: await icon(fa.FaCubes),
    lock: await icon(fa.FaLock), flask: await icon(fa.FaFlask), sync: await icon(fa.FaSyncAlt),
    list: await icon(fa.FaListOl), code: await icon(fa.FaCode),
    arrow: await icon(fa.FaArrowRight, HEX.accent6),
  };
  function iconCircle(slide, key, x, y, d, fill, name) {
    slide.addShape(pres.ShapeType.ellipse, { x, y, w: d, h: d, fill: { color: fill }, line: { color: fill }, objectName: name + "-circle" });
    const p = d * 0.26;
    slide.addImage({ data: icons[key], x: x + p, y: y + p, w: d - 2 * p, h: d - 2 * p, objectName: name + "-icon" });
  }
  function card(slide, x, y, w, h, name, fill = C.background2) {
    slide.addShape(pres.ShapeType.roundRect, { x, y, w, h, rectRadius: 0.12, fill: { color: fill }, line: { color: fill }, objectName: name });
  }
  function frameImage(slide, file, x, y, w, h, name, alt) {
    slide.addShape(pres.ShapeType.roundRect, { x: x - 0.08, y: y - 0.08, w: w + 0.16, h: h + 0.16, rectRadius: 0.1,
      fill: { color: C.background1 }, line: { color: HEX.lt2, width: 1.5 }, objectName: name + "-frame" });
    slide.addImage({ path: path.join(IMG, file), x, y, w, h, altText: alt || name, objectName: name });
  }
  function text(slide, t, opts) {
    slide.addText(t, Object.assign({ isTextBox: true, margin: 0, color: C.text1, fontSize: 15, valign: "top" }, opts));
  }
  function bullets(slide, items, opts) {
    text(slide, items.map((t, k) => ({ text: t, options: { bullet: true, breakLine: k < items.length - 1 } })), opts);
  }
  const chartText = { catAxisLabelFontFace: "+mn-lt", valAxisLabelFontFace: "+mn-lt", dataLabelFontFace: "+mn-lt",
    legendFontFace: "+mn-lt", titleFontFace: "+mn-lt" };
  const hdr = (extra = {}) => Object.assign({ bold: true, color: "FFFFFF", fill: { color: HEX.dk1 }, fontSize: 14, valign: "middle" }, extra);
  const cell = (t, extra = {}) => ({ text: t, options: Object.assign({ fontSize: 13, color: HEX.dk1, valign: "middle" }, extra) });
  const border = () => ({ type: "solid", color: "D5DCE4", pt: 1 });

  // ================================================================== 1. title
  pres.addSection({ title: "Overview" });
  let s = pres.addSlide({ masterName: "TITLE_DARK", sectionTitle: "Overview" });
  s.addText("The canvas: any shape, three PDKs", { placeholder: "title" });
  s.addText("The project reviewed against its goal, layout creation with LLMs with no limit on what they can draw: "
    + "a free Python canvas, a larger benchmark on 130, 180 and 45 nm, and what a free model does with them. "
    + "Status 2026-11-11.", { placeholder: "body" });
  frameImage(s, "ref_spiral_sky130A.png", 8.9, 0.85, 3.67, 4.31, "title-layout",
    "Octagonal spiral inductor with underpass, reference layout on sky130A");
  text(s, "octagonal spiral inductor with underpass on sky130A: 45 degree edges on the top metal, drawn from one "
    + "PDK-neutral canvas script",
    { x: 8.82, y: 5.4, w: 3.9, h: 0.75, fontSize: 11, color: "C9D3E0", italic: true, objectName: "title-caption" });
  s.addNotes("This deck continues icl_overview.pptx and icl_results.pptx. Those describe the ICL language on SKY130. This one "
    + "covers what followed from reviewing the project against its goal: a second interface with no fixed vocabulary (the "
    + "canvas), two more PDKs including a 45 nm one, a benchmark with larger layouts, and the runs of a free model on it.");

  // ================================================================== 2. summary
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Overview" });
  s.addText("What we found", { placeholder: "title" });
  const stats = [
    ["3 PDKs", "130, 180 and 45 nm from the same scripts. A PDK is one data file of 100 to 115 lines.", HEX.accent3],
    ["22 / 22", "reference layouts clean under two DRC decks and LVS, up to 768 transistors", HEX.accent2],
    ["19 / 22", "cases solved by three lines, TOP = from_spice(netlist), at 0.55 to 1.36 times the reference area", HEX.accent4],
    ["1 to 20", "of 22 cases solved by the free model, first to sixth run, as a netlist level and better feedback were added", HEX.accent1],
  ];
  stats.forEach(([big, small, col], i) => {
    const x = 0.55 + i * 3.1;
    card(s, x, 1.45, 2.85, 3.0, "stat-card-" + i);
    text(s, big, { x: x + 0.2, y: 1.7, w: 2.45, h: 1.0, fontSize: 32, bold: true, color: col, fontFace: THEME.headFontFace, valign: "middle", objectName: "stat-big-" + i });
    text(s, small, { x: x + 0.2, y: 2.8, w: 2.45, h: 1.5, fontSize: 14, color: C.text2, objectName: "stat-small-" + i });
  });
  text(s, [
    { text: "The level the model works at decides, not the freedom of the interface. ", options: { bold: true } },
    { text: "A free canvas removes the ceiling. The model still needs the high levels on it, and feedback that points to them." },
  ], { x: 0.55, y: 4.85, w: 12.2, h: 1.0, fontSize: 18, objectName: "summary-line" });
  text(s, "Model: nvidia/nemotron-3.5-super-vl (free, OpenRouter), 4 attempts per case, $0. Two runs of the same setup differ by "
    + "2 to 3 cases, and two corrections were made after results were seen (slide 13).",
    { x: 0.55, y: 6.15, w: 12.2, h: 0.6, fontSize: 12, color: C.accent6, objectName: "summary-note" });
  s.addNotes("Four headline numbers. The canvas runs on three PDKs from the same scripts. All 22 reference layouts of the larger "
    + "benchmark are clean. 19 of the 22 cases can be built from their netlist with a three-line script. And the free model "
    + "went from 1 to 20 of 22 over six runs. The last number has caveats, which slide 13 lists.");

  // ================================================================== 3. review
  pres.addSection({ title: "Review and canvas" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Review and canvas" });
  s.addText("The review: where ICL stopped short of the goal", { placeholder: "title" });
  text(s, "Found in the review", { x: 0.55, y: 1.4, w: 5.7, h: 0.35, fontSize: 14, bold: true, color: C.accent1, objectName: "review-col-a" });
  text(s, "Response", { x: 7.05, y: 1.4, w: 5.7, h: 0.35, fontSize: 14, bold: true, color: C.accent2, objectName: "review-col-b" });
  const rev = [
    ["lock", "A closed language", "17 layers, rectangles only, 1.8 V transistors only. No resistor, capacitor, polygon or 45 degree edge could be written.",
      "polygon", "A free canvas", "Plain Python scripts: any layer of the PDK, any polygon or path, any declared device."],
    ["chip", "One PDK, hard-wired", "The SKY130 layers and rules live in the code. Nothing ran on another process.",
      "database", "The PDK as a data file", "sky130A, gf180mcuD and freepdk45: layers, rules, devices and signoff decks in 100 to 115 lines each."],
    ["ruler", "Benchmarks at the ceiling", "The largest task had 28 transistors, on one PDK. Strong models already passed everything.",
      "cubes", "A larger benchmark", "bench/xl: 8 tasks on 3 PDKs, up to 768 transistors, passives, analog and one shape that is not Manhattan."],
  ];
  rev.forEach(([ia, ha, ta, ib, hb, tb], i) => {
    const y = 1.9 + i * 1.55;
    card(s, 0.55, y, 5.7, 1.38, "review-a-card-" + i);
    iconCircle(s, ia, 0.8, y + 0.34, 0.7, HEX.accent1, "review-a-" + i);
    text(s, ha, { x: 1.75, y: y + 0.14, w: 4.3, h: 0.4, fontSize: 17, bold: true, objectName: "review-a-head-" + i });
    text(s, ta, { x: 1.75, y: y + 0.56, w: 4.3, h: 0.75, fontSize: 13, color: C.text2, objectName: "review-a-text-" + i });
    s.addImage({ data: icons.arrow, x: 6.43, y: y + 0.47, w: 0.44, h: 0.44, objectName: "review-arrow-" + i });
    card(s, 7.05, y, 5.7, 1.38, "review-b-card-" + i);
    iconCircle(s, ib, 7.3, y + 0.34, 0.7, HEX.accent2, "review-b-" + i);
    text(s, hb, { x: 8.25, y: y + 0.14, w: 4.3, h: 0.4, fontSize: 17, bold: true, objectName: "review-b-head-" + i });
    text(s, tb, { x: 8.25, y: y + 0.56, w: 4.3, h: 0.75, fontSize: 13, color: C.text2, objectName: "review-b-text-" + i });
  });
  text(s, "The goal as stated: layout creation using LLMs, not limited in terms of what the LLMs can draw. "
    + "What worked in ICL (PCells, relative placement, a router, feedback in the script's terms) stays, as optional helpers.",
    { x: 0.55, y: 6.5, w: 12.2, h: 0.45, fontSize: 12, color: C.accent6, objectName: "review-note" });
  s.addNotes("The review compared the project with its one constraint: no limit on what the model can draw. ICL is a language "
    + "with a fixed vocabulary, so anything outside it (a resistor, a spiral, another PDK) could not be written at all. The "
    + "existing benchmarks were also too small to tell methods apart. The response keeps ICL and adds a second interface.");

  // ================================================================== 4. the canvas
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Review and canvas" });
  s.addText("The canvas: plain Python, every level optional", { placeholder: "title" });
  card(s, 0.55, 1.45, 6.4, 4.95, "canvas-code-card", C.text1);
  text(s, [
    "from icdsl.canvas import *",
    "tech = use()                  # the PDK comes from --pdk",
    "c = Cell(\"demo\")",
    "",
    "# 1 shapes: any layer, any polygon",
    "c.rect(\"m1\", x0=0, y0=0, x1=2, y1=0.3, net=\"A\")",
    "c.polygon(\"m3\", [(0, 0), (4, 0), (2, 3)], net=\"X\")",
    "c.path(tech.stack[-1], pts, 4.0, net=\"L\")",
    "",
    "# 2 PCells: correct by construction",
    "m = c.mos(\"nmos\", w=2.0, l=0.5, nf=4, gates=\"G\",",
    "          sd=(\"S\", \"D\"), at=(0, 0))",
    "c.guard_ring(\"ptap\", around=[m], net=\"VSS\", space=1.0)",
    "c.resistor(\"res_poly\", w=1.0, l=8.0, at=(9, 0),",
    "           nets=(\"a\", \"b\"))",
    "",
    "# 3 cells from net strings, 4 router",
    "nand = stick(\"nand2\", n=\"VSS A x B Y\",",
    "             p=\"VDD A Y B VDD\", ports=\"A B Y\")",
    "r = Router(top); r.auto(); r.run()",
    "",
    "# 5 the whole netlist",
    "TOP = from_spice(\"netlist.spice\")",
  ].join("\n"), { x: 0.8, y: 1.65, w: 5.95, h: 4.6, fontSize: 11, fontFace: "Courier New", color: "D8E2EE", objectName: "canvas-code" });
  const ladder = [
    ["Shapes", "rect, polygon, path and wire on any layer of the PDK, at 45 degrees or any angle", HEX.accent1],
    ["PCells", "via, mos, resistor, capacitor, guard_ring: sized from the rule table of the PDK", HEX.accent5],
    ["Cells and rows", "stick() builds a cell from two net strings; mos_strip() and rows() place devices", HEX.accent2],
    ["Router", "Router(top).auto() wires the nets on the metal stack of the PDK", HEX.accent3],
    ["Netlist", "from_spice() turns a SPICE hierarchy into cells, rows and routed nets", HEX.accent4],
  ];
  ladder.forEach(([head, desc, col], i) => {
    const y = 1.45 + i * 0.85;
    s.addShape(pres.ShapeType.ellipse, { x: 7.3, y: y + 0.08, w: 0.62, h: 0.62, fill: { color: col }, line: { color: col }, objectName: "ladder-circle-" + i });
    text(s, String(i + 1), { x: 7.3, y: y + 0.08, w: 0.62, h: 0.62, fontSize: 18, bold: true, color: "FFFFFF", align: "center", valign: "middle", objectName: "ladder-num-" + i });
    text(s, head, { x: 8.15, y: y, w: 4.6, h: 0.36, fontSize: 16, bold: true, objectName: "ladder-head-" + i });
    text(s, desc, { x: 8.15, y: y + 0.36, w: 4.6, h: 0.5, fontSize: 13, color: C.text2, objectName: "ladder-desc-" + i });
  });
  card(s, 7.3, 5.78, 5.45, 0.62, "ladder-note-card");
  text(s, [{ text: "No helper is a ceiling. ", options: { bold: true } },
    { text: "Every level returns ordinary shapes that a script can add to, move or replace." }],
    { x: 7.5, y: 5.78, w: 5.05, h: 0.62, fontSize: 13, valign: "middle", objectName: "ladder-note" });
  s.addNotes("A canvas script is ordinary Python. At the bottom it draws shapes on any layer. Above that are parametric devices, "
    + "then cells built from a net string, a router, and at the top a call that lays out a whole netlist. A script can mix "
    + "the levels freely: take the netlist level for the logic and draw an inductor next to it by hand.");

  // ================================================================== 5. three PDKs
  pres.addSection({ title: "Three PDKs" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Three PDKs" });
  s.addText("One script, three PDKs", { placeholder: "title" });
  const dec = [
    ["ref_dec4to16_sky130A.png", 0.63, 3.30, "sky130A, 130 nm: 407.56 µm²"],
    ["ref_dec4to16_gf180mcuD.png", 4.33, 3.91, "gf180mcuD, 180 nm: 698.53 µm²"],
    ["ref_dec4to16_freepdk45.png", 8.64, 4.12, "freepdk45, 45 nm: 63.17 µm²"],
  ];
  dec.forEach(([file, x, w, cap], i) => {
    frameImage(s, file, x, 1.55, w, 2.9, "dec-" + i, "4-to-16 decoder reference layout, " + cap);
    text(s, cap, { x: x, y: 4.62, w: w, h: 0.35, fontSize: 14, bold: true, objectName: "dec-cap-" + i });
  });
  text(s, "bench/xl/ref/dec4to16.py: a 4-to-16 decoder, 168 transistors, built three times without a change. "
    + "Each image has its own scale.",
    { x: 0.55, y: 5.0, w: 12.2, h: 0.35, fontSize: 13, color: C.text2, objectName: "dec-note" });
  const sign = [
    ["magic DRC", "drc(full) with the PDK's tech file"],
    ["KLayout DRC", "the PDK's own deck, a second independent judge"],
    ["netgen LVS", "extracted layout against the netlist"],
  ];
  sign.forEach(([h, t], i) => {
    const x = 0.55 + i * 4.15;
    card(s, x, 5.55, 3.9, 1.1, "sign-card-" + i);
    iconCircle(s, "check", x + 0.22, 5.8, 0.6, HEX.accent2, "sign-" + i);
    text(s, h, { x: x + 1.0, y: 5.67, w: 2.75, h: 0.36, fontSize: 16, bold: true, objectName: "sign-head-" + i });
    text(s, t, { x: x + 1.0, y: 6.04, w: 2.75, h: 0.5, fontSize: 12.5, color: C.text2, objectName: "sign-text-" + i });
  });
  s.addNotes("The same reference script builds the decoder on a 130 nm, a 180 nm and a 45 nm process. Scripts use portable "
    + "names (tech.c0 for the first contact, tech.stack for the metals) and take every dimension from the rule table. "
    + "Each result is checked by three tools; both DRC judges must be clean.");

  // ================================================================== 6. the 45 nm port
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Three PDKs" });
  s.addText("What the 45 nm port cost", { placeholder: "title" });
  const port = [
    ["1", "data file", "freepdk45.py, 114 lines: layers, rules, device recipes, metals m1 to m10, signoff decks", HEX.accent3],
    ["4", "canvas fixes", "all general: odd-grid cuts and wires, minimum guard-ring width, rail contacts of mirrored rows, a router retry", HEX.accent1],
    ["0", "scripts per PDK", "every PCell test and benchmark reference is one script that builds on all three", HEX.accent2],
  ];
  port.forEach(([big, head, desc, col], i) => {
    const x = 0.55 + i * 4.15;
    card(s, x, 1.45, 3.9, 1.85, "port-card-" + i);
    text(s, big, { x: x + 0.2, y: 1.6, w: 0.95, h: 1.55, fontSize: 54, bold: true, color: col, fontFace: THEME.headFontFace, align: "center", valign: "middle", objectName: "port-big-" + i });
    text(s, head, { x: x + 1.3, y: 1.62, w: 2.45, h: 0.36, fontSize: 16, bold: true, objectName: "port-head-" + i });
    text(s, desc, { x: x + 1.3, y: 2.0, w: 2.45, h: 1.2, fontSize: 12.5, color: C.text2, objectName: "port-desc-" + i });
  });
  const pdkRows = [
    ["Node", "130 nm", "180 nm", "45 nm (predictive PDK)"],
    ["Metal stack", "li, m1 to m5", "m1 to m5", "m1 to m10"],
    ["Minimum poly / metal 1 width", "0.15 / 0.14 µm", "0.18 / 0.23 µm", "0.05 / 0.065 µm"],
    ["Devices with a recipe", "1.8 V MOS, poly resistor, MIM capacitor", "3.3 V MOS, poly resistor, MIM capacitor", "1.1 V MOS only"],
    ["PDK data file", "110 lines", "101 lines", "114 lines"],
  ];
  s.addTable([[{ text: "", options: hdr() }, { text: "sky130A", options: hdr() }, { text: "gf180mcuD", options: hdr() }, { text: "freepdk45", options: hdr() }]].concat(
    pdkRows.map((r) => r.map((t, k) => cell(t, k === 0 ? { bold: true } : { color: HEX.dk2 })))),
  { x: 0.55, y: 3.55, w: 12.2, colW: [3.2, 3.0, 3.0, 3.0], rowH: 0.44, border: border(), fill: { color: HEX.lt1 }, objectName: "pdk-table" });
  text(s, "Not supported: FinFET processes. ASAP7 (7 nm) was assessed; it needs a gridded device recipe (fins, gate cuts) and "
    + "coordinates finer than 1 nm, and its open package has no LVS deck.",
    { x: 0.55, y: 6.42, w: 12.2, h: 0.5, fontSize: 12, color: C.accent6, objectName: "pdk-note" });
  s.addNotes("The cost of the third PDK is the measure of how far the method scales. It took one data file and four fixes that "
    + "are general, not specific to 45 nm. freepdk45 is a predictive academic kit with MOS devices only, so the two passive "
    + "tasks do not exist there and the OTA uses MOS-only compensation. FinFET kits are outside what the data file describes.");

  // ================================================================== 7. the benchmark
  pres.addSection({ title: "Benchmark" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Benchmark" });
  s.addText("bench/xl: eight tasks that ask for a block, not a gate", { placeholder: "title" });
  const tasks = [
    ["rca8", "8-bit ripple-carry adder, mirror full adders", "224 MOS"],
    ["dec4to16", "4-to-16 decoder", "168 MOS"],
    ["shreg16", "16-bit shift register, master-slave flip-flops", "352 MOS"],
    ["sram16x8", "16 x 8 array of 6T SRAM cells", "768 MOS"],
    ["r2r8", "8-bit R-2R ladder", "25 poly resistors"],
    ["cdac6", "6-bit binary-weighted capacitor array", "64 MIM capacitors"],
    ["ota_miller", "two-stage Miller OTA", "30 MOS fingers + R + C"],
    ["spiral", "octagonal spiral inductor, 3 turns, underpass", "none (45 degree geometry)"],
  ];
  s.addTable([[{ text: "Task", options: hdr() }, { text: "What", options: hdr() }, { text: "Devices", options: hdr() }]].concat(
    tasks.map(([a, b, c]) => [cell(a, { bold: true, fontFace: "Courier New", fontSize: 12.5 }), cell(b), cell(c, { color: HEX.dk2 })])),
  { x: 0.55, y: 1.4, w: 8.3, colW: [1.55, 4.15, 2.6], rowH: 0.49, border: border(), fill: { color: HEX.lt1 }, objectName: "task-table" });
  card(s, 9.15, 1.4, 3.6, 4.42, "judge-card");
  iconCircle(s, "check", 9.38, 1.6, 0.6, HEX.accent2, "judge");
  text(s, "Solved means all of", { x: 10.15, y: 1.6, w: 2.45, h: 0.6, fontSize: 17, bold: true, valign: "middle", objectName: "judge-head" });
  bullets(s, [
    "DRC clean in magic and in the PDK's KLayout deck",
    "LVS match against the task netlist",
    "every pin is a label on a conductor",
    "area within 2 times the reference",
    "spiral: geometry checks instead of LVS (one coil, 45 degree edges, width, turns, underpass)",
  ], { x: 9.38, y: 2.4, w: 3.2, h: 3.3, fontSize: 13.5, color: C.text2, paraSpaceAfter: 6, objectName: "judge-list" });
  text(s, "22 cases on sky130A, gf180mcuD and freepdk45. r2r8 and cdac6 do not exist on freepdk45 (MOS only), and its ota_miller "
    + "uses MOS-only compensation (39 fingers). Any interface may answer: raw GDS, a canvas script or ICL. "
    + "The earlier benchmarks stop at 28 transistors on one PDK.",
    { x: 0.55, y: 6.05, w: 12.2, h: 0.75, fontSize: 13, color: C.text2, objectName: "task-note" });
  s.addNotes("The benchmark replaces 'can the model draw a NAND' with 'can the model deliver a block': hundreds of transistors, "
    + "arrays, passives, a mixed analog block and one shape that is not Manhattan. The judge works on the GDS, so every "
    + "interface is scored the same way. Matching quality and parasitics are not judged yet.");

  // ================================================================== 8. gallery
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Benchmark" });
  s.addText("Reference layouts: all 22 clean, one script per task", { placeholder: "title" });
  const cap = (t, x, y, w, name) => text(s, t, { x, y, w, h: 0.3, fontSize: 10.5, color: C.text2, objectName: name });
  frameImage(s, "ref_sram16x8_freepdk45.png", 0.63, 1.53, 2.64, 4.85, "gal-sram", "16 x 8 SRAM array reference layout on freepdk45");
  cap("sram16x8, freepdk45: 768 MOS", 0.55, 6.52, 2.8, "gal-sram-cap");
  const rowA = [
    ["ref_cdac6_sky130A.png", 3.68, 2.68, "cdac6, sky130A: 64 MIM capacitors"],
    ["ref_spiral_gf180mcuD.png", 6.8, 2.21, "spiral, gf180mcuD"],
    ["ref_ota_miller_freepdk45.png", 9.45, 3.02, "ota_miller, freepdk45: 39 MOS fingers"],
  ];
  rowA.forEach(([file, x, w, c], i) => {
    frameImage(s, file, x, 1.53, w, 2.6, "gal-a-" + i, c + ", reference layout");
    cap(c, x - 0.08, 4.25, w + 0.3, "gal-a-cap-" + i);
  });
  frameImage(s, "ref_shreg16_sky130A.png", 3.68, 4.85, 2.08, 1.3, "gal-shreg", "16-bit shift register reference layout on sky130A");
  cap("shreg16, sky130A: 352 MOS", 3.6, 6.27, 2.4, "gal-shreg-cap");
  frameImage(s, "ref_ota_miller_sky130A.png", 6.15, 4.85, 3.29, 1.3, "gal-ota", "Miller OTA reference layout on sky130A");
  cap("ota_miller, sky130A: resistor and MIM capacitor", 6.07, 6.27, 3.5, "gal-ota-cap");
  frameImage(s, "ref_rca8_gf180mcuD.png", 9.83, 4.85, 2.64, 0.77, "gal-rca", "8-bit adder reference layout on gf180mcuD");
  cap("rca8, gf180mcuD: 224 MOS", 9.75, 5.72, 2.9, "gal-rca-cap");
  frameImage(s, "ref_r2r8_gf180mcuD.png", 9.83, 6.14, 2.64, 0.51, "gal-r2r", "R-2R ladder reference layout on gf180mcuD");
  cap("r2r8, gf180mcuD: 25 poly resistors", 9.75, 6.74, 2.9, "gal-r2r-cap");
  s.addNotes("Eight of the 22 reference layouts. They were written by hand through the canvas interface, one PDK-neutral script per "
    + "task, and each builds and verifies in 3.4 to 16 seconds. They prove that every task is solvable on every PDK; they are "
    + "not an LLM result. The repository has all 22 as PNG and GDS in bench/xl/gallery.");

  // ================================================================== 9. netlist level
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Benchmark" });
  s.addText("A netlist becomes a layout in three lines", { placeholder: "title" });
  card(s, 0.55, 1.45, 5.1, 1.5, "nl-code-card", C.text1);
  text(s, ["from icdsl.canvas import *", "tech = use()", "TOP = from_spice(\"netlist.spice\")"].join("\n"),
    { x: 0.8, y: 1.68, w: 4.6, h: 1.05, fontSize: 14, fontFace: "Courier New", color: "D8E2EE", objectName: "nl-code" });
  const styles = [
    ["grid", "Style \"cells\": CMOS logic", "Stick cells from the transistors (n / p pairing, column order for the fewest diffusion breaks), placed in rows and routed.", HEX.accent3],
    ["layers", "Style \"rows\": everything else", "Multi-finger strips inside guard rings, resistors beside them, MIM capacitors in a grid with its own router. No matching yet.", HEX.accent4],
  ];
  styles.forEach(([ic, head, desc, col], i) => {
    const y = 3.15 + i * 1.7;
    card(s, 0.55, y, 5.1, 1.5, "nl-style-card-" + i);
    iconCircle(s, ic, 0.75, y + 0.2, 0.6, col, "nl-style-" + i);
    text(s, head, { x: 1.55, y: y + 0.17, w: 3.95, h: 0.36, fontSize: 16, bold: true, objectName: "nl-style-head-" + i });
    text(s, desc, { x: 1.55, y: y + 0.55, w: 3.95, h: 0.9, fontSize: 12.5, color: C.text2, objectName: "nl-style-text-" + i });
  });
  const ratios = [
    ["rca8", "1.02", "1.03", "1.06", "cells"], ["dec4to16", "1.01", "1.01", "0.93", "cells"],
    ["shreg16", "1.30", "1.33", "1.36", "cells"], ["sram16x8", "1.00", "1.00", "1.00", "cells"],
    ["r2r8", "0.55", "0.86", "-", "rows"], ["cdac6", "1.02", "1.02", "-", "rows"],
    ["ota_miller", "1.28", "1.27", "1.17", "rows"],
  ];
  s.addTable([["Task", "sky130A", "gf180mcuD", "freepdk45", "Style"].map((t, k) => ({ text: t, options: hdr(k > 0 ? { align: "center" } : {}) }))].concat(
    ratios.map((r) => r.map((t, k) => cell(t, k === 0 ? { bold: true, fontFace: "Courier New", fontSize: 12.5 }
      : k === 4 ? { align: "center", color: HEX.dk2 } : { align: "center" })))),
  { x: 5.95, y: 1.45, w: 6.8, colW: [1.9, 1.3, 1.3, 1.3, 1.0], rowH: 0.48, border: border(), fill: { color: HEX.lt1 }, objectName: "nl-table" });
  text(s, [{ text: "19 of 22 cases are judged solved with no task-specific code. ", options: { bold: true } },
    { text: "The numbers are the area as a multiple of the hand-written reference. spiral has no netlist. "
      + "tests/run_canvas.sh checks all 19." }],
    { x: 5.95, y: 5.5, w: 6.8, h: 1.0, fontSize: 14, objectName: "nl-note" });
  s.addNotes("The netlist level was added after the baseline run showed that the model draws transistors one by one when nothing "
    + "higher is offered. from_spice picks the style by itself: stick cells for CMOS logic, device rows for everything else. "
    + "The rows style places devices in netlist order and does no matching, which is one of the open items.");

  // ================================================================== 10. baseline
  pres.addSection({ title: "LLM runs" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "LLM runs" });
  s.addText("Baseline: one free model, three interfaces", { placeholder: "title" });
  const base = [
    ["1 / 22", "Canvas script", "18 built a GDS, 87 model calls", HEX.accent3],
    ["0 / 22", "Raw Python with klayout.db", "21 built a GDS, 88 model calls", HEX.dk2],
    ["2 / 4", "ICL, the sky130A logic tasks", "2 built, 13 model calls", HEX.accent2],
  ];
  base.forEach(([big, head, small, col], i) => {
    const x = 0.55 + i * 4.15;
    card(s, x, 1.45, 3.9, 1.95, "base-card-" + i);
    text(s, big, { x: x + 0.25, y: 1.55, w: 3.4, h: 0.85, fontSize: 36, bold: true, color: col, fontFace: THEME.headFontFace, valign: "middle", objectName: "base-big-" + i });
    text(s, head, { x: x + 0.25, y: 2.42, w: 3.4, h: 0.38, fontSize: 16, bold: true, objectName: "base-head-" + i });
    text(s, small, { x: x + 0.25, y: 2.82, w: 3.4, h: 0.4, fontSize: 13, color: C.text2, objectName: "base-small-" + i });
  });
  const lessons = [
    ["warn", "Raw GDS runs, and is nowhere near. ", "Almost every script produced a GDS, with hundreds to tens of thousands of DRC errors and no LVS match.", HEX.accent6],
    ["check", "ICL solved logic tasks ", "because there the model writes only the device list and row. Placement and wiring are the tool's work.", HEX.accent2],
    ["pen", "On the canvas the model drew by hand. ", "60 of 87 replies did not build, most on a guessed API detail. The prompt's only example was a hand-drawn inverter.", HEX.accent3],
  ];
  lessons.forEach(([ic, head, t, col], i) => {
    const y = 3.68 + i * 0.84;
    iconCircle(s, ic, 0.55, y, 0.6, col, "base-lesson-" + i);
    text(s, [{ text: head, options: { bold: true } }, { text: t }],
      { x: 1.4, y: y - 0.04, w: 11.35, h: 0.68, fontSize: 15, valign: "middle", objectName: "base-lesson-text-" + i });
  });
  text(s, "The level of the interface decides, not its freedom. A free canvas needs the high level too.",
    { x: 0.55, y: 6.3, w: 12.2, h: 0.45, fontSize: 18, bold: true, color: C.accent1, objectName: "base-line" });
  s.addNotes("Same model, same loop, same judge, three ways to write the layout. Each case is one conversation with up to four "
    + "replies; every reply is built and judged, and the judge table goes back to the model. Raw coordinates fail completely "
    + "at this size. ICL did best because it left the least to the model, but it can express only 4 of the 22 cases.");

  // ================================================================== 11. the runs
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "LLM runs" });
  s.addText("From 1 to 20 of 22 with the same free model", { placeholder: "title" });
  const cats = ["baseline (87 calls)", "v2 (54 calls)", "v4 (44 calls)", "v5 (46 calls)", "v6 (33 calls)"];
  s.addChart(pres.charts.BAR, [
    { name: "Solved as run", labels: cats, values: [1, 12, 16, 15, 20] },
    { name: "Added when a later correction is applied", labels: cats, values: [1, 0, 2, 1, 0] },
  ], Object.assign({
    x: 0.55, y: 1.35, w: 7.75, h: 5.4, barDir: "bar", barGrouping: "stacked",
    chartColors: [HEX.accent2, HEX.accent6], showValue: true, dataLabelPosition: "inEnd", dataLabelFormatCode: "0;;;",
    dataLabelColor: "FFFFFF", dataLabelFontSize: 14, dataLabelFontBold: true,
    catAxisLabelColor: HEX.dk2, catAxisLabelFontSize: 13, catAxisOrientation: "maxMin",
    valAxisMaxVal: 22, valAxisMinVal: 0, valAxisMajorUnit: 2, valAxisLabelColor: HEX.accent6, valAxisLabelFontSize: 11,
    valGridLine: { color: "E3E8EE", size: 0.75 }, catGridLine: { style: "none" },
    showLegend: true, legendPos: "b", legendFontSize: 12, legendColor: HEX.dk2,
    showTitle: true, title: "Cases solved of 22, canvas interface, 4 attempts per case", titleFontSize: 14, titleColor: HEX.dk1,
  }, chartText));
  const prog = [
    ["v2: a netlist level", "from_spice for logic and clearer script errors: 1 to 12", HEX.accent2],
    ["v4: rows, and a first sentence", "Device rows for analog and passives; CANVAS.md opens with \"Choose the level first\"", HEX.accent3],
    ["v5: the same again", "v4 repeated with the corrected harness. Two runs of one setup differ by 2 to 3 cases", HEX.accent6],
    ["v6: feedback names the level", "plus an answer to replies without code and a note on off-angle edges: 20, in 33 calls", HEX.accent1],
  ];
  prog.forEach(([h, t, col], i) => {
    const y = 1.45 + i * 1.3;
    card(s, 8.55, y, 4.2, 1.16, "prog-card-" + i);
    text(s, h, { x: 8.75, y: y + 0.1, w: 3.85, h: 0.36, fontSize: 15.5, bold: true, color: col, objectName: "prog-head-" + i });
    text(s, t, { x: 8.75, y: y + 0.48, w: 3.85, h: 0.62, fontSize: 12.5, color: C.text2, objectName: "prog-text-" + i });
  });
  s.addNotes("Each bar is a full run of the 22 cases through the canvas interface. The grey part is what a later correction adds: "
    + "judging the final file of a reply instead of the longest code block (v4, 16 to 18), and the revised spiral width rule "
    + "(baseline 1 to 2, v5 15 to 16). v3 is not shown: it reran only the 10 cases of the four tasks v2 had failed, and "
    + "solved 4. The number of model calls fell from 87 to 33 because most cases are now solved at the first attempt.");

  // ================================================================== 12. what moved the number
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "LLM runs" });
  s.addText("What moved the number", { placeholder: "title" });
  const moved = [
    ["project", "A netlist level in the canvas", "from_spice turns a SPICE hierarchy into cells, rows and routed nets on any described PDK.", HEX.accent2],
    ["book", "\"Choose the level first\" at the top of the reference", "Netlist: from_spice. Schematic: stick cells, strips, router. Shape: polygons.", HEX.accent3],
    ["tools", "Script errors in the script's own terms", "Only the script's lines, and for a wrong keyword or attribute the ones that exist.", HEX.accent4],
    ["comment", "Feedback that names the level", "After a hand-drawn attempt at a netlist task: \"this task comes with a netlist\". Sent 3 times in v6; both cases switched and were solved.", HEX.accent1],
    ["robot", "An answer to replies without code", "\"There are no tools in this conversation; reply with the complete file.\"", HEX.accent6],
  ];
  moved.forEach(([ic, head, t, col], i) => {
    const y = 1.45 + i * 1.02;
    iconCircle(s, ic, 0.55, y + 0.05, 0.66, col, "moved-" + i);
    text(s, head, { x: 1.45, y: y, w: 6.0, h: 0.36, fontSize: 16, bold: true, objectName: "moved-head-" + i });
    text(s, t, { x: 1.45, y: y + 0.37, w: 6.0, h: 0.6, fontSize: 12.5, color: C.text2, objectName: "moved-text-" + i });
  });
  const ev = [
    ["29 / 31", "solved when the first submission called from_spice", HEX.accent2],
    ["1 / 17", "solved when it drew by hand or sent no code", HEX.accent1],
  ];
  ev.forEach(([big, small, col], i) => {
    const x = 7.85 + i * 2.5;
    card(s, x, 1.45, 2.4, 1.75, "ev-card-" + i);
    text(s, big, { x: x + 0.15, y: 1.52, w: 2.1, h: 0.7, fontSize: 28, bold: true, color: col, fontFace: THEME.headFontFace, valign: "middle", objectName: "ev-big-" + i });
    text(s, small, { x: x + 0.15, y: 2.24, w: 2.1, h: 0.9, fontSize: 12, color: C.text2, objectName: "ev-small-" + i });
  });
  frameImage(s, "llm_ota_miller_sky130A.png", 8.35, 3.5, 3.9, 2.67, "moved-image",
    "Miller OTA on sky130A built by the model's 12-line script in run v6");
  text(s, "The model's ota_miller on sky130A (v6, attempt 1, a 12-line script), 1.28 times the reference area. "
    + "The two numbers count the netlist cases of runs v2 to v4.",
    { x: 7.85, y: 6.33, w: 4.9, h: 0.5, fontSize: 11, color: C.accent6, italic: true, objectName: "moved-cap" });
  s.addNotes("The solved count follows the level the model picks. In the netlist cases of runs v2 to v4, a first submission that "
    + "called from_spice was solved 29 times out of 31; a first submission drawn by hand, or a reply without code, led to a "
    + "solution once in 17. The pick is not stable from run to run, and saying it in the feedback worked better than saying "
    + "it in the document.");

  // ================================================================== 13. how to read
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "LLM runs" });
  s.addText("How to read these numbers", { placeholder: "title" });
  const cave = [
    ["random", "Run-to-run variance: 2 to 3 cases", "v4 and v5 are the same setup and end at 16 to 18 and at 15 to 16 of 22. A difference of that size is not evidence for or against a change.", HEX.accent1, false],
    ["sync", "Two corrections after seeing results", "Which code block of a reply is judged (29 of 316 replies affected), and the spiral width rule, which counted via pads (28 of 45 stored spirals failed it, 9 after the revision).", HEX.accent1, false],
    ["list", "v6 changed five things at once", "The level note, the no-tools answer, the off-angle note, a router message and the spiral rule. The 20 is not the measured effect of any one of them.", HEX.accent1, false],
    ["code", "The library changed while v2 ran", "Shorter script errors went live after the first cdac6 attempt, and device rows near the end of the run.", HEX.accent6, false],
    ["robot", "One free model, one run per setup", "nvidia/nemotron-3.5-super-vl:free with 4 attempts per case. No other model has been measured on bench/xl.", HEX.accent6, false],
    ["check", "What does hold", "The steps from 1 to 12, to about 16 and to 20 are larger than the variance. The transcripts show the mechanism: both netlist cases that began by hand in v6 switched after the note.", HEX.accent2, true],
  ];
  cave.forEach(([ic, head, t, col, strong], i) => {
    const x = 0.55 + (i % 3) * 4.15, y = 1.45 + Math.floor(i / 3) * 2.6;
    card(s, x, y, 3.9, 2.4, "cave-card-" + i);
    iconCircle(s, ic, x + 0.22, y + 0.22, 0.58, col, "cave-" + i);
    text(s, head, { x: x + 0.98, y: y + 0.2, w: 2.75, h: 0.62, fontSize: 15, bold: true, valign: "middle",
      color: strong ? C.accent2 : C.text1, objectName: "cave-head-" + i });
    text(s, t, { x: x + 0.25, y: y + 0.98, w: 3.42, h: 1.35, fontSize: 12.5, color: C.text2, objectName: "cave-text-" + i });
  });
  s.addNotes("The run table gives the as-run and the corrected number for each run, and agents/README.md describes both "
    + "corrections in full. The honest reading: the large steps are real, single-case differences are noise, and v6 does not "
    + "isolate which of its changes mattered.");

  // ================================================================== 14. free drawing
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "LLM runs" });
  s.addText("Free drawing is still the weak spot", { placeholder: "title" });
  const spirals = [
    ["llm_spiral_gf180mcuD.png", 0.63, 5.45, "gf180mcuD: solved at attempt 3", HEX.accent2,
      "Three turns, 45 degree edges, an underpass on the metal below, clean in both DRC decks. Before it: a wrong keyword, then 10 edges off the 45 degree grid, which the report named."],
    ["llm_spiral_sky130A.png", 6.5, 2.84, "sky130A: not solved", HEX.accent1,
      "Attempt 4: shape and underpass are right; 13 metal5 spacing errors and necks narrower than 4 µm at the bends."],
    ["llm_spiral_freepdk45.png", 9.76, 2.94, "freepdk45: not solved", HEX.accent1,
      "Attempt 3: clean in both DRC decks, but the turns touch and close four loops, and there is no underpass."],
  ];
  spirals.forEach(([file, x, w, verdict, col, desc], i) => {
    frameImage(s, file, x, 1.55, w, 2.9, "spiral-" + i, "Spiral inductor drawn by the model, " + verdict);
    text(s, verdict, { x: x - 0.08, y: 4.65, w: w + 0.16, h: 0.36, fontSize: 15, bold: true, color: col, objectName: "spiral-verdict-" + i });
    text(s, desc, { x: x - 0.08, y: 5.02, w: w + 0.16, h: 0.9, fontSize: 12, color: C.text2, objectName: "spiral-desc-" + i });
  });
  text(s, [{ text: "spiral is the one task without a netlist, and the one that still tests drawing. ", options: { bold: true } },
    { text: "It was solved on at most one of the three PDKs per run, and never on freepdk45." }],
    { x: 0.55, y: 6.2, w: 12.2, h: 0.6, fontSize: 15, objectName: "spiral-line" });
  s.addNotes("These are the model's own drawings from run v6, as images of the stored GDS. The gf180mcuD spiral passed every "
    + "check. The sky130A one has the right shape but breaks the top-metal spacing rule and is too narrow at its bends. The "
    + "freepdk45 one is closer to nested rings than to a spiral. With the netlist level in place, 19 of the 22 cases test "
    + "whether the model takes the three-line path; only this task tests free drawing.");

  // ================================================================== 15. open issues
  pres.addSection({ title: "Next" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Next" });
  s.addText("Open issues and next steps", { placeholder: "title" });
  card(s, 0.55, 1.45, 5.95, 4.9, "open-card");
  iconCircle(s, "warn", 0.8, 1.7, 0.7, HEX.accent1, "open");
  text(s, "Open", { x: 1.7, y: 1.78, w: 4.5, h: 0.5, fontSize: 19, bold: true, objectName: "open-head" });
  bullets(s, [
    "19 of 22 cases now test one decision: take the netlist level or draw by hand",
    "Free drawing: spiral solved on at most 1 of 3 PDKs per run",
    "The rows style places devices in netlist order, with no matching",
    "The ICL language still targets SKY130 only; it has not been moved onto the canvas",
    "One free model measured; no FinFET process",
  ], { x: 0.8, y: 2.6, w: 5.45, h: 3.6, fontSize: 14.5, paraSpaceAfter: 9, color: C.text2, objectName: "open-list" });
  card(s, 6.8, 1.45, 5.95, 4.9, "next-card");
  iconCircle(s, "route", 7.05, 1.7, 0.7, HEX.accent2, "next");
  text(s, "Next", { x: 7.95, y: 1.78, w: 4.5, h: 0.5, fontSize: 19, bold: true, objectName: "next-head" });
  bullets(s, [
    "A constraint tier for bench/xl: pin sides and order, judged symmetry and common centroid, area near 1.2 times",
    "Shapes without a netlist: pad ring, seal ring, shielded line, comb capacitor, each with a geometric check",
    "Matching in the rows style (interdigitation, common centroid)",
    "An ICL front end that emits canvas code, so .icl files run on all three PDKs",
    "Other models, and repeated runs to measure the variance",
  ], { x: 7.05, y: 2.6, w: 5.45, h: 3.6, fontSize: 14.5, paraSpaceAfter: 9, color: C.text2, objectName: "next-list" });
  s.addNotes("The benchmark was built to be hard, and the netlist level made most of it easy. That is the point of the tool, but "
    + "it means the benchmark needs a second tier that asks for what a netlist does not say: where the pins are, what is "
    + "matched to what, how tight the area is, and shapes that have no netlist at all. None of that exists yet.");

  // ================================================================== 16. takeaways
  s = pres.addSlide({ masterName: "CLOSING_DARK", sectionTitle: "Next" });
  s.addText("Takeaways", { placeholder: "title" });
  s.addText([
    { text: "No ceiling: the canvas draws any layer, polygon and declared device, and no helper is mandatory.", options: { bullet: true, breakLine: true } },
    { text: "The method carries across PDKs: 130, 180 and 45 nm from the same scripts, with two DRC decks and LVS.", options: { bullet: true, breakLine: true } },
    { text: "The level decides: one free model went from 1 to 20 of 22 once a netlist level existed and the feedback pointed to it.", options: { bullet: true, breakLine: true } },
    { text: "Free drawing and judged constraints are open. The benchmark needs a tier that asks for them.", options: { bullet: true } },
  ], { placeholder: "body" });
  frameImage(s, "ref_ota_miller_freepdk45.png", 8.95, 1.75, 3.75, 3.23, "closing-image", "Miller OTA reference layout on freepdk45");
  text(s, "Miller OTA on freepdk45 (45 nm), reference layout", { x: 8.87, y: 5.18, w: 3.9, h: 0.4, fontSize: 11, color: "C9D3E0", italic: true, objectName: "closing-caption" });
  text(s, "Code and results: github.com/ibrahim-me/icdsl (private).  CANVAS.md, bench/xl/README.md, agents/README.md",
    { x: 0.6, y: 6.6, w: 12, h: 0.4, fontSize: 12, color: "9FB0C4", objectName: "closing-paths" });
  s.addNotes("Four takeaways, and where to find the code, the benchmark and the run records.");

  await pres.writeFile({ fileName: OUT });
  await applyTheme(OUT, THEME);
  console.log("wrote", OUT);
})();
