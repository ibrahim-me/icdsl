// ICL results deck: language, benchmarks, techniques, harnesses, three-model comparison, log-driven fixes.
// Build: cd slides && NODE_PATH=$PWD/node_modules node build_results_deck.js
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
const IMG = path.join(__dirname, "img2");
const OUT = path.join(__dirname, "icl_results.pptx");

async function icon(Comp, color = "FFFFFF", size = 256) {
  const svg = ReactDOMServer.renderToStaticMarkup(React.createElement(Comp, { color: "#" + color, size: String(size) }));
  const png = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + png.toString("base64");
}

(async () => {
  const pres = new pptxgen();
  pres.layout = "LAYOUT_WIDE"; // 13.33 x 7.5
  pres.theme = { headFontFace: THEME.headFontFace, bodyFontFace: THEME.bodyFontFace };
  pres.title = "ICL: a layout language for AI agents - results";
  pres.author = "icdsl";
  const C = pres.SchemeColor;

  // ------------------------------------------------------------------ layouts
  pres.defineSlideMaster({
    title: "TITLE_DARK",
    background: { color: HEX.dk1 },
    objects: [
      { placeholder: { options: { name: "title", type: "title", x: 0.6, y: 2.0, w: 7.4, h: 1.9, fontSize: 40, bold: true,
        color: C.background1, valign: "bottom", align: "left", margin: 0 }, text: "" } },
      { placeholder: { options: { name: "body", type: "body", x: 0.6, y: 4.1, w: 7.2, h: 1.4, fontSize: 18,
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
      { text: { text: "ICL  |  SKY130 layout agents", options: { x: 0.55, y: 7.05, w: 6, h: 0.3, fontSize: 10, color: C.accent6, margin: 0 } } },
    ],
    slideNumber: { x: 12.3, y: 7.05, w: 0.5, h: 0.3, fontSize: 10, color: HEX.accent6 },
  });

  // ------------------------------------------------------------------ helpers
  const icons = {
    layers: await icon(fa.FaLayerGroup), chip: await icon(fa.FaMicrochip), route: await icon(fa.FaRoute),
    grid: await icon(fa.FaThLarge), check: await icon(fa.FaCheck), search: await icon(fa.FaSearchPlus),
    book: await icon(fa.FaBook), clone: await icon(fa.FaClone), undo: await icon(fa.FaUndo),
    redo: await icon(fa.FaRedo), tools: await icon(fa.FaTools), bolt: await icon(fa.FaBolt),
    project: await icon(fa.FaProjectDiagram), ruler: await icon(fa.FaRulerCombined), robot: await icon(fa.FaRobot),
    pen: await icon(fa.FaPen), eye: await icon(fa.FaEye), warn: await icon(fa.FaExclamationTriangle),
  };
  function iconCircle(slide, key, x, y, d, fill, name) {
    slide.addShape(pres.ShapeType.ellipse, { x, y, w: d, h: d, fill: { color: fill }, line: { color: fill }, objectName: name + "-circle" });
    const p = d * 0.26;
    slide.addImage({ data: icons[key], x: x + p, y: y + p, w: d - 2 * p, h: d - 2 * p, objectName: name + "-icon" });
  }
  function card(slide, x, y, w, h, name, fill = C.background2) {
    slide.addShape(pres.ShapeType.roundRect, { x, y, w, h, rectRadius: 0.12, fill: { color: fill }, line: { color: fill }, objectName: name });
  }
  function frameImage(slide, file, x, y, w, h, name) {
    slide.addShape(pres.ShapeType.roundRect, { x: x - 0.08, y: y - 0.08, w: w + 0.16, h: h + 0.16, rectRadius: 0.1,
      fill: { color: C.background1 }, line: { color: HEX.lt2, width: 1.5 }, objectName: name + "-frame" });
    slide.addImage({ path: path.join(IMG, file), x, y, w, h, objectName: name });
  }
  function text(slide, t, opts) {
    slide.addText(t, Object.assign({ isTextBox: true, margin: 0, color: C.text1, fontSize: 15, valign: "top" }, opts));
  }
  const chartText = { catAxisLabelFontFace: "+mn-lt", valAxisLabelFontFace: "+mn-lt", dataLabelFontFace: "+mn-lt",
    legendFontFace: "+mn-lt", titleFontFace: "+mn-lt" };

  // ================================================================== 1. title
  pres.addSection({ title: "Overview" });
  let s = pres.addSlide({ masterName: "TITLE_DARK", sectionTitle: "Overview" });
  s.addText("ICL: a layout language for AI agents", { placeholder: "title" });
  s.addText("Benchmarks, harnesses and what actually helps: SKY130 standard cells and analog blocks, "
    + "built by Nemotron (free), Haiku and Sonnet", { placeholder: "body" });
  frameImage(s, "comp_latch.png", 8.75, 0.85, 3.85, 4.31, "title-layout");
  text(s, "comparator + SR latch, 19 transistors, 9 mirror-symmetric pairs (drawn in ICL by Haiku)",
    { x: 8.65, y: 5.4, w: 4.05, h: 0.6, fontSize: 11, color: "C9D3E0", italic: true });
  s.addNotes("ICL is a layout language that lets AI agents draw SKY130 layouts at the level of abstraction the task needs, with "
    + "every result signed off by magic DRC and netgen LVS. This deck covers the language, the benchmarks built to test it, "
    + "the techniques and harnesses that made a free model work, the three-model comparison against raw GDS, and the tool "
    + "fixes that came from reading the agents' logs.");

  // ================================================================== 2. summary
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Overview" });
  s.addText("What we found", { placeholder: "title" });
  const stats = [
    ["3 → 12/14", "standard cells built from scratch by the free model, as feedback, lessons, examples and an agent loop were added", HEX.accent1],
    ["0 → 3/4", "hard tasks for the free model: raw coordinates vs ICL with its docs preloaded (Haiku 2 → 4/4)", HEX.accent3],
    ["14 → 20/20", "parameter-sweep points Haiku keeps clean when the techniques are added", HEX.accent2],
    ["20+", "language and tool fixes found by reading the agents' logs", HEX.accent4],
  ];
  stats.forEach(([big, small, col], i) => {
    const x = 0.55 + i * 3.1;
    card(s, x, 1.45, 2.85, 3.0, "stat-card-" + i);
    text(s, big, { x: x + 0.2, y: 1.7, w: 2.45, h: 1.0, fontSize: 32, bold: true, color: col, fontFace: THEME.headFontFace, valign: "middle", objectName: "stat-big-" + i });
    text(s, small, { x: x + 0.2, y: 2.8, w: 2.45, h: 1.5, fontSize: 14, color: C.text2, objectName: "stat-small-" + i });
  });
  text(s, [
    { text: "Strong models can draw small cells from raw coordinates; ", options: { bold: true } },
    { text: "the language matters more as the model gets weaker and the cell gets denser. The techniques mostly buy "
      + "robustness, size and cost for Claude, and decide success for the free model." },
  ], { x: 0.55, y: 4.85, w: 12.2, h: 1.0, fontSize: 18, objectName: "summary-line" });
  text(s, "Models: nvidia/nemotron-3.5-super-vl (free, OpenRouter), Claude Haiku 5.5 and Sonnet 5.5 (as subagents). All results re-checked by an independent checker.",
    { x: 0.55, y: 6.2, w: 12.2, h: 0.5, fontSize: 12, color: C.accent6, objectName: "summary-note" });
  s.addNotes("Four headline numbers. The free model's progress on the 14-cell standard-cell benchmark; the hard-task comparison where "
    + "raw coordinates fail for weaker models; the robustness gain from the techniques; and the number of fixes that reading "
    + "the agents' logs produced.");

  // ================================================================== 3. language levels
  pres.addSection({ title: "The language" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The language" });
  s.addText("One syntax, four levels of abstraction", { placeholder: "title" });
  const levels = [
    ["layers", "Level 1  stdcell", "Shapes defined relative to shapes: enclose, cross, right_of, min (the rule minimum)", "gc = contact licon cx=g.cx bottom=cb", HEX.accent1],
    ["grid", "Level 2  cell", "PCells + placement + matching patterns: interdigitate, common centroid, pair, guard rings", "interdigitate M1 M2 pattern=ABBA", HEX.accent2],
    ["chip", "Level 3  floorplan", "Finished blocks and PDK cells, DRC-aware abutment and spacing", "place AMP right_of=DIF gap=min", HEX.accent3],
    ["route", "Level 4  route", "Router under constraints: width, keep-out, symmetry, shielding, resistance, coupling", "route OUT width=0.3 avoid=INN:0.6", HEX.accent4],
  ];
  levels.forEach(([ic, head, desc, code, col], i) => {
    const x = 0.55 + i * 3.1;
    card(s, x, 1.45, 2.85, 4.5, "level-card-" + i);
    iconCircle(s, ic, x + 0.25, 1.7, 0.75, col, "level-" + i);
    text(s, head, { x: x + 0.25, y: 2.6, w: 2.4, h: 0.45, fontSize: 18, bold: true, objectName: "level-head-" + i });
    text(s, desc, { x: x + 0.25, y: 3.1, w: 2.4, h: 1.6, fontSize: 14, color: C.text2, objectName: "level-desc-" + i });
    text(s, code, { x: x + 0.25, y: 4.85, w: 2.45, h: 0.9, fontSize: 12, fontFace: "Courier New", color: col, objectName: "level-code-" + i });
  });
  text(s, "A cell built at one level is instantiated by the next. Every result is signed off by magic DRC (full) and netgen LVS.",
    { x: 0.55, y: 6.25, w: 12.2, h: 0.5, fontSize: 15, color: C.text2, objectName: "levels-note" });
  s.addNotes("ICL is one language with four libraries. Level 1 is geometric but relative - no raw coordinates. Level 2 assembles "
    + "parametric transistors with placement relations and matching patterns. Level 3 places finished blocks with DRC-aware spacing. "
    + "Level 4 is the router, which any block can use with constraints such as width, keep-out distance and symmetry.");

  // ================================================================== 4. write check fix
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "The language" });
  s.addText("Write, check, fix: the loop every agent runs", { placeholder: "title" });
  card(s, 0.55, 1.45, 5.3, 4.65, "code-card", C.text1);
  text(s, [
    "stdcell nand2_p width=4 height=H",
    "  device MNA nmos w=WN l=L d=n1 g=A s=VGND",
    "  ...",
    "  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap",
    "  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)",
    "  sn  = array licon in=nd left_of=ga",
    "  snl = enclose sn li",
    "  gnd = strap li from=snl to=vgnd_li",
    "  cb  = max(nd.top + 0.19, snl.top + 0.25)",
    "  gca = contact licon cx=(ga.cx - 0.1) bottom=cb",
    "  route Y layers=m1",
    "  port A in on=ap",
    "end",
  ].join("\n"), { x: 0.75, y: 1.7, w: 5.0, h: 4.2, fontSize: 11, fontFace: "Courier New", color: "D8E2EE", objectName: "code-text" });
  frameImage(s, "nand2_l1.png", 6.25, 1.45, 2.58, 4.65, "nand2-render");
  const steps = [["pen", "Write the cell in ICL", HEX.accent1], ["check", "bin/icl check: magic DRC + netgen LVS (+ the judge)", HEX.accent2],
    ["search", "Diagnosis names the statement, line and the fix", HEX.accent3], ["redo", "Edit and check again until clean, then sweep W / L / H", HEX.accent4]];
  steps.forEach(([ic, t, col], i) => {
    const y = 1.5 + i * 1.15;
    iconCircle(s, ic, 9.25, y, 0.7, col, "loop-" + i);
    text(s, t, { x: 10.1, y: y + 0.05, w: 2.7, h: 0.9, fontSize: 15, objectName: "loop-text-" + i, valign: "middle" });
  });
  text(s, "Positions derive from the parameters, so one file stays clean across the sweep (this NAND2: 22 of 22 points).",
    { x: 0.55, y: 6.3, w: 12.2, h: 0.45, fontSize: 14, color: C.text2, objectName: "loop-note" });
  s.addNotes("A level-1 cell is written relative to other shapes and parameters (WN, WP, L, H), so the same file is checked "
    + "at the nominal point and across a sweep. The check returns magic DRC, netgen LVS and - in the benchmark - geometric "
    + "constraint checks; the diagnosis is written in terms of the agent's own statements.");

  // ================================================================== 5. benchmarks
  pres.addSection({ title: "Benchmarks" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Benchmarks" });
  s.addText("Benchmarks: SkyWater cells and analog blocks", { placeholder: "title" });
  const bcols = [
    ["layers", "Level 1: standard cells", HEX.accent1, [
      "14 cells with sky130_fd_sc_hd netlists: inv … xor2, mux2i",
      "4 harder cells: maj3, ha (14T), dlxtp (18T), fa (28T)",
      "Sweep: 6 points of L, W and cell height; cells must tile",
      "Tasks: from scratch, repair one injected bug, compact"]],
    ["grid", "Level 2: analog assembly", HEX.accent2, [
      "13 blocks: mirrors, diff pair, 5T / 2-stage / folded-cascode OTAs, StrongARM, comparator + latch",
      "Matching, symmetry, guard-ring, spacing, width and area constraints",
      "Sweep: 4 points of L and W"]],
    ["check", "Ground truth", HEX.accent3, [
      "Every task has a verified reference (generator or hand-written)",
      "LVS against an independent netlist; matching dummies ignored",
      "Same checker for every model and condition"]],
  ];
  bcols.forEach(([ic, head, col, items], i) => {
    const x = 0.55 + i * 4.15;
    card(s, x, 1.45, 3.9, 4.75, "bench-card-" + i);
    iconCircle(s, ic, x + 0.25, 1.7, 0.7, col, "bench-" + i);
    text(s, head, { x: x + 1.1, y: 1.75, w: 2.65, h: 0.6, fontSize: 18, bold: true, valign: "middle", objectName: "bench-head-" + i });
    text(s, items.map((t, k) => ({ text: t, options: { bullet: true, breakLine: k < items.length - 1 } })),
      { x: x + 0.25, y: 2.6, w: 3.45, h: 3.4, fontSize: 15, color: C.text2, paraSpaceAfter: 6, objectName: "bench-list-" + i });
  });
  text(s, "dlxtp and fa are left out of the comparisons: no verified reference yet (the generator cannot route them).",
    { x: 0.55, y: 6.4, w: 12.2, h: 0.4, fontSize: 12, color: C.accent6, objectName: "bench-note" });
  s.addNotes("Level-1 tasks reuse the real SkyWater hd netlists, scaled for cells that carry their own taps. Level-2 tasks are textbook "
    + "analog blocks with explicit layout constraints. Each task has a verified reference, and LVS always compares against an "
    + "independent netlist so a model cannot pass by changing the circuit.");

  // ================================================================== 6. judge
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Benchmarks" });
  s.addText("The judge measures the geometry, not the statements", { placeholder: "title" });
  frameImage(s, "comp_latch.png", 0.75, 1.5, 4.3, 4.82, "judge-image");
  const checks = [
    "Every transistor finger found as poly crossing diffusion, assigned to a device by its nets",
    "Interdigitation and common centroid from finger positions",
    "Mirror symmetry of every pair about one shared axis",
    "Closed guard rings, wire spacing outside pin escape zones, area budget",
    "Standard cells: rails, and a row of copies must stay DRC clean (tiling)",
  ];
  text(s, checks.map((t, k) => ({ text: t, options: { bullet: true, breakLine: k < checks.length - 1 } })),
    { x: 5.6, y: 1.55, w: 7.1, h: 3.4, fontSize: 16, paraSpaceAfter: 8, objectName: "judge-list" });
  card(s, 5.6, 5.1, 7.1, 1.25, "judge-neg-card");
  text(s, [{ text: "Negative tests pass: ", options: { bold: true } },
    { text: "an AABB 'interdigitation' and the old row-based StrongARM (pairs on different axes) are rejected." }],
    { x: 5.85, y: 5.25, w: 6.6, h: 0.95, fontSize: 15, valign: "middle", objectName: "judge-neg" });
  s.addNotes("Writing 'interdigitate' is not enough - the judge recomputes everything from the drawn shapes. The same judge scores raw GDS, "
    + "so ICL and raw layouts are compared on identical terms.");

  // ================================================================== 7. free model progression
  pres.addSection({ title: "Free model" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Free model" });
  s.addText("The free model went from 3 to 12 of 14 standard cells", { placeholder: "title" });
  const cats = ["Basic feedback", "+ ranked diagnosis, lessons v1", "+ lessons v2", "+ lessons v3, 2 examples",
    "Agent loop, tools only", "Agent + nudges + examples"];
  s.addChart(pres.charts.BAR, [
    { name: "Chat-only harness", labels: cats, values: [3, 5, 10, 11, 0, 0] },
    { name: "Agentic harness (deepagents)", labels: cats, values: [0, 0, 0, 0, 6, 12] },
  ], Object.assign({
    x: 0.55, y: 1.35, w: 8.2, h: 5.3, barDir: "bar", barGrouping: "stacked",
    chartColors: [HEX.dk2, HEX.accent1], showValue: true, dataLabelPosition: "inEnd", dataLabelFormatCode: "0;;;",
    dataLabelColor: "FFFFFF", dataLabelFontSize: 14, dataLabelFontBold: true,
    catAxisLabelColor: HEX.dk2, catAxisLabelFontSize: 13, catAxisOrientation: "maxMin",
    valAxisMaxVal: 14, valAxisMinVal: 0, valAxisMajorUnit: 2, valAxisLabelColor: HEX.accent6, valAxisLabelFontSize: 11,
    valGridLine: { color: "E3E8EE", size: 0.75 }, catGridLine: { style: "none" },
    showLegend: true, legendPos: "b", legendFontSize: 12, legendColor: HEX.dk2,
    showTitle: true, title: "Cells clean over the whole sweep (of 14), Nemotron 3.5 super VL", titleFontSize: 14, titleColor: HEX.dk1,
  }, chartText));
  const prog = [
    ["Lessons", "My reviews of failed attempts, written as general rules: 5 → 10", HEX.dk2],
    ["Agent loop", "Tools alone were worse (6): weak models stop early. Nudges + examples: 12", HEX.accent1],
    ["Level 2", "12 / 12 analog blocks, sweep-clean, mostly at the first attempt", HEX.accent2],
  ];
  prog.forEach(([h, t, col], i) => {
    const y = 1.5 + i * 1.7;
    card(s, 9.1, y, 3.65, 1.5, "prog-card-" + i);
    text(s, h, { x: 9.3, y: y + 0.12, w: 3.3, h: 0.4, fontSize: 17, bold: true, color: col, objectName: "prog-head-" + i });
    text(s, t, { x: 9.3, y: y + 0.55, w: 3.3, h: 0.9, fontSize: 14, color: C.text2, objectName: "prog-text-" + i });
  });
  s.addNotes("Each bar adds one technique. The biggest single jump came from distilling the reviewer's observations into general "
    + "lessons. Moving to an agentic harness first made things worse - the model ended its turn without calling a tool - until "
    + "the harness nudged it to continue and gave it two verified similar cells. Level 2 analog assembly was much easier: the "
    + "PCells, patterns and router carry the design rules.");

  // ================================================================== 8. techniques
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Free model" });
  s.addText("Techniques that made the difference", { placeholder: "title" });
  const techs = [
    ["search", "Ranked diagnosis", "Names the statement and line, the measured gap vs the rule, and a concrete edit", HEX.accent1],
    ["project", "Connectivity in object names", "SHORT / OPEN by object, 'the column labelled n3 should be n5'", HEX.accent3],
    ["book", "Lessons", "Reviewer notes rewritten as general rules; per-cell notes did not beat a control", HEX.accent2],
    ["clone", "Retrieved examples", "Two verified layouts of similar cells", HEX.accent4],
    ["undo", "Keep-best", "Continue from, and finally keep, the best verified version", HEX.accent5],
    ["redo", "Continuation nudges", "A model that stops before a clean check is told what still fails", HEX.dk2],
  ];
  techs.forEach(([ic, h, t, col], i) => {
    const colx = i < 3 ? 0.55 : 6.75, y = 1.5 + (i % 3) * 1.6;
    iconCircle(s, ic, colx, y, 0.85, col, "tech-" + i);
    text(s, h, { x: colx + 1.1, y: y, w: 4.9, h: 0.45, fontSize: 18, bold: true, objectName: "tech-head-" + i });
    text(s, t, { x: colx + 1.1, y: y + 0.48, w: 4.9, h: 0.9, fontSize: 15, color: C.text2, objectName: "tech-text-" + i });
  });
  text(s, "Images of the layout were about neutral (10/14 with, 9/14 without): the text diagnosis carries the information.",
    { x: 0.55, y: 6.3, w: 12.2, h: 0.45, fontSize: 14, color: C.accent6, objectName: "tech-note" });
  s.addNotes("These are the techniques that measurably helped the free model. The control experiment matters: per-cell coaching notes "
    + "were no better than simply more attempts, but the same insights written as general lessons doubled the score.");

  // ================================================================== 9. chat vs agentic
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Free model" });
  s.addText("Chat vs agentic harness: same success, better compaction", { placeholder: "title" });
  card(s, 0.55, 1.45, 5.0, 2.15, "chat-card");
  iconCircle(s, "robot", 0.8, 1.7, 0.7, HEX.dk2, "chat");
  text(s, "Chat-only", { x: 1.7, y: 1.72, w: 3.6, h: 0.45, fontSize: 18, bold: true, objectName: "chat-head" });
  text(s, "One model call per attempt: return a file, the harness checks it and replies with the report.",
    { x: 1.7, y: 2.2, w: 3.65, h: 1.2, fontSize: 14, color: C.text2, objectName: "chat-text" });
  card(s, 0.55, 3.85, 5.0, 2.35, "agent-card");
  iconCircle(s, "tools", 0.8, 4.1, 0.7, HEX.accent1, "agent");
  text(s, "Agentic (deepagents)", { x: 1.7, y: 4.12, w: 3.7, h: 0.45, fontSize: 18, bold: true, objectName: "agent-head" });
  text(s, "LangGraph deepagents: file tools, planning, check_layout, check_sweep, inspect_layout; the model decides when to read, check and stop.",
    { x: 1.7, y: 4.6, w: 3.65, h: 1.45, fontSize: 14, color: C.text2, objectName: "agent-text" });
  const hdr = { bold: true, color: "FFFFFF", fill: { color: HEX.dk1 }, fontSize: 15, valign: "middle" };
  const cell = (t, extra = {}) => ({ text: t, options: Object.assign({ fontSize: 15, color: HEX.dk1, valign: "middle" }, extra) });
  s.addTable([
    [{ text: "Benchmark", options: hdr }, { text: "Chat-only", options: hdr }, { text: "Agentic", options: hdr }, { text: "Model calls", options: hdr }],
    [cell("L1 from scratch (14)"), cell("11"), cell("12", { bold: true }), cell("38 / 241")],
    [cell("L1 repair (14)"), cell("12"), cell("12"), cell("23 / 182")],
    [cell("L1 compact (8)"), cell("3 narrower"), cell("6 narrower", { bold: true, color: HEX.accent1 }), cell("24 / 154")],
    [cell("L2 analog (12)"), cell("12"), cell("12"), cell("19 / 122")],
  ], { x: 6.0, y: 1.45, w: 6.75, colW: [2.45, 1.4, 1.5, 1.4], rowH: 0.62, border: { type: "solid", color: "D5DCE4", pt: 1 },
    fill: { color: HEX.lt1 }, objectName: "harness-table" });
  text(s, [{ text: "About 6× the requests ", options: { bold: true } },
    { text: "(reading docs, self-checks, sweeps). Compaction gains most: the agent can try a narrower version, sweep it and back off. "
      + "The harness also keeps the agent's best verified version, since its last file is not always its best." }],
    { x: 6.0, y: 4.85, w: 6.75, h: 1.4, fontSize: 15, color: C.text2, objectName: "harness-note" });
  s.addNotes("Same pass rates within run-to-run variance on scratch, repair and level 2, a clear win on compaction, at roughly six "
    + "times the requests - which matters with a 1000-requests-per-day free quota.");

  // ================================================================== 10. hard task setup
  pres.addSection({ title: "Three models" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Three models" });
  s.addText("Hard tasks: three models, three conditions, one checker", { placeholder: "title" });
  const tasksH = [["maj3", "14T majority gate, standard cell"], ["ha", "14T half adder, two outputs"],
    ["folded cascode", "11T OTA, five matched groups + keep-out"], ["comp + latch", "19T StrongARM + SR latch, 9 symmetric pairs"]];
  tasksH.forEach(([h, t], i) => {
    const x = 0.55 + i * 3.1;
    card(s, x, 1.45, 2.85, 1.45, "task-card-" + i);
    text(s, h, { x: x + 0.2, y: 1.58, w: 2.5, h: 0.42, fontSize: 18, bold: true, color: i < 2 ? HEX.accent1 : HEX.accent2, objectName: "task-head-" + i });
    text(s, t, { x: x + 0.2, y: 2.02, w: 2.5, h: 0.8, fontSize: 14, color: C.text2, objectName: "task-text-" + i });
  });
  const conds = [["ruler", "Raw GDS", "Draw coordinates (Python + KLayout, or a rectangle list for the free model); rule summary and layer map", HEX.accent6],
    ["layers", "ICL", "The language reference, one basic example, the plain checker", HEX.accent3],
    ["bolt", "ICL + techniques", "Lessons, 2 verified similar cells, ranked diagnosis, sweep and inspect tools, keep-best", HEX.accent1]];
  conds.forEach(([ic, h, t, col], i) => {
    const x = 0.55 + i * 4.15;
    iconCircle(s, ic, x, 3.35, 0.8, col, "cond-" + i);
    text(s, h, { x: x + 1.0, y: 3.38, w: 2.95, h: 0.45, fontSize: 18, bold: true, objectName: "cond-head-" + i });
    text(s, t, { x: x + 1.0, y: 3.85, w: 2.95, h: 1.5, fontSize: 14, color: C.text2, objectName: "cond-text-" + i });
  });
  card(s, 0.55, 5.55, 12.2, 0.95, "same-card");
  text(s, "Same task text and the same checker for everyone: magic DRC, netgen LVS vs the reference, the geometric judge, tiling. "
    + "Claude ran as subagents; Nemotron in the deepagents harness. Final files re-scored independently.",
    { x: 0.8, y: 5.62, w: 11.7, h: 0.8, fontSize: 14, valign: "middle", objectName: "same-text" });
  s.addNotes("Two dense standard cells and two complex analog blocks, each with a verified reference. 36 runs in total: 3 models x 3 "
    + "conditions x 4 tasks.");

  // ================================================================== 11. results chart
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Three models" });
  s.addText("The language matters more the weaker the model", { placeholder: "title" });
  s.addChart(pres.charts.BAR, [
    { name: "Raw GDS", labels: ["Sonnet 5.5", "Haiku 5.5", "Nemotron (free)"], values: [4, 2, 0] },
    { name: "ICL", labels: ["Sonnet 5.5", "Haiku 5.5", "Nemotron (free)"], values: [4, 4, 2] },
    { name: "ICL + techniques", labels: ["Sonnet 5.5", "Haiku 5.5", "Nemotron (free)"], values: [4, 4, 2] },
  ], Object.assign({
    x: 0.55, y: 1.35, w: 7.6, h: 5.3, barDir: "col", barGrouping: "clustered", barGapWidthPct: 60,
    chartColors: [HEX.accent6, HEX.accent3, HEX.accent1], showValue: true, dataLabelPosition: "outEnd",
    dataLabelColor: HEX.dk1, dataLabelFontSize: 14, dataLabelFontBold: true,
    catAxisLabelColor: HEX.dk2, catAxisLabelFontSize: 14, valAxisMaxVal: 4, valAxisMinVal: 0, valAxisMajorUnit: 1,
    valAxisLabelColor: HEX.accent6, valAxisLabelFontSize: 11, valGridLine: { color: "E3E8EE", size: 0.75 }, catGridLine: { style: "none" },
    showLegend: true, legendPos: "b", legendFontSize: 12, legendColor: HEX.dk2,
    showTitle: true, title: "Hard tasks clean (of 4)", titleFontSize: 14, titleColor: HEX.dk1,
  }, chartText));
  const res = [
    ["Sonnet", "Clean in every condition. Raw GDS took ~3x the time of ICL and gave wider standard cells", HEX.dk2],
    ["Haiku", "Raw: both dense standard cells failed; one gave up after drawing the frame. ICL: 4/4", HEX.accent3],
    ["Nemotron", "Raw: hundreds of DRC errors in every run. ICL: both analog blocks; with its docs preloaded also the half adder (3/4)", HEX.accent1],
  ];
  res.forEach(([h, t, col], i) => {
    const y = 1.45 + i * 1.75;
    card(s, 8.5, y, 4.25, 1.55, "res-card-" + i);
    text(s, h, { x: 8.7, y: y + 0.12, w: 3.9, h: 0.4, fontSize: 17, bold: true, color: col, objectName: "res-head-" + i });
    text(s, t, { x: 8.7, y: y + 0.52, w: 3.9, h: 0.98, fontSize: 14, color: C.text2, objectName: "res-text-" + i });
  });
  s.addNotes("Sonnet draws everything even from raw coordinates. Haiku needs the language for dense standard cells. The free model "
    + "cannot draw any of them from raw coordinates and solves the analog blocks only with the language; once the documentation "
    + "was put into its prompt it also solved the half adder.");

  // ================================================================== 12. quality
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Three models" });
  s.addText("Techniques buy robustness, size and cost", { placeholder: "title" });
  s.addChart(pres.charts.BAR, [
    { name: "ICL", labels: ["Sonnet 5.5", "Haiku 5.5", "Nemotron (free)"], values: [75, 70, 88] },
    { name: "ICL + techniques", labels: ["Sonnet 5.5", "Haiku 5.5", "Nemotron (free)"], values: [90, 100, 100] },
  ], Object.assign({
    x: 0.55, y: 1.35, w: 6.9, h: 5.3, barDir: "col", barGrouping: "clustered", barGapWidthPct: 70,
    chartColors: [HEX.accent3, HEX.accent1], showValue: true, dataLabelPosition: "outEnd", dataLabelFormatCode: "0\"%\"",
    dataLabelColor: HEX.dk1, dataLabelFontSize: 14, dataLabelFontBold: true,
    catAxisLabelColor: HEX.dk2, catAxisLabelFontSize: 14, valAxisMaxVal: 100, valAxisMinVal: 0, valAxisMajorUnit: 25,
    valAxisLabelColor: HEX.accent6, valAxisLabelFontSize: 11, valGridLine: { color: "E3E8EE", size: 0.75 }, catGridLine: { style: "none" },
    showLegend: true, legendPos: "b", legendFontSize: 12, legendColor: HEX.dk2,
    showTitle: true, title: "Sweep points still clean (W / L / height variations)", titleFontSize: 14, titleColor: HEX.dk1,
  }, chartText));
  const q = [
    ["9.66 → 5.06 µm", "Haiku's maj3 cell width", HEX.accent2],
    ["533 → 196 µm²", "Nemotron's folded cascode area", HEX.accent4],
    ["402k → 344k", "Haiku tokens for the 4 tasks", HEX.accent1],
  ];
  q.forEach(([big, small, col], i) => {
    const y = 1.45 + i * 1.75;
    card(s, 7.85, y, 4.9, 1.55, "q-card-" + i);
    text(s, big, { x: 8.1, y: y + 0.15, w: 4.5, h: 0.75, fontSize: 30, bold: true, color: col, fontFace: THEME.headFontFace, objectName: "q-big-" + i });
    text(s, small, { x: 8.1, y: y + 0.95, w: 4.5, h: 0.45, fontSize: 15, color: C.text2, objectName: "q-small-" + i });
  });
  s.addNotes("For Claude the techniques do not change the nominal pass rate - it is already at the ceiling - but layouts follow the "
    + "parameters (without them, cells were clean at L = 0.15 and broke at 0.18 and 0.25), come out smaller and cost fewer tokens.");

  // ================================================================== 13. raw gds
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Three models" });
  s.addText("Raw GDS can be tight, but it is fragile", { placeholder: "title" });
  frameImage(s, "sonnet_raw_ota.png", 0.75, 1.5, 2.6, 4.82, "raw-ota");
  text(s, "Sonnet, raw coordinates: 5T OTA in 22.8 µm² (ICL runs: 45–61 µm²)",
    { x: 0.6, y: 6.42, w: 3.0, h: 0.5, fontSize: 11, color: C.accent6, italic: true, objectName: "raw-ota-cap" });
  frameImage(s, "haiku_raw_comp.png", 3.95, 1.5, 3.9, 3.08, "raw-comp");
  text(s, "Haiku, raw coordinates: comparator, clean but 372 µm² (ICL: 118 µm²)",
    { x: 3.85, y: 4.7, w: 4.1, h: 0.5, fontSize: 11, color: C.accent6, italic: true, objectName: "raw-comp-cap" });
  const pitfalls = [
    "3 of 4 raw standard cells broke when tiled next to copies of themselves; every ICL cell tiled",
    "Raw cells are fixed geometry: no parameter sweep",
    "Hidden conventions cost iterations: ports need pin-datatype shapes, GDS database units",
    "Dense 14T cells: Haiku ran out of routing tracks; the free model never got close",
  ];
  text(s, pitfalls.map((t, k) => ({ text: t, options: { bullet: true, breakLine: k < pitfalls.length - 1 } })),
    { x: 8.3, y: 1.5, w: 4.45, h: 4.9, fontSize: 15, paraSpaceAfter: 10, objectName: "raw-list" });
  s.addNotes("Hand-placed coordinates can beat the language's generators on area, as Sonnet's 22.8 µm² OTA shows, but raw layouts "
    + "broke when tiled, cannot follow parameter changes, and depend on conventions the language handles automatically.");

  // ================================================================== 14. fixes from logs
  pres.addSection({ title: "Learning from logs" });
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Learning from logs" });
  s.addText("Reading the agents' logs fixed the tools", { placeholder: "title" });
  const fx = [
    ["Router took the only landing spot of another pin", "Pin access reserved first; unroutable nets reported, cell still built"],
    ["Notch fills exploded to 35,000 shapes; met1 slivers below min width", "Fill frontier + dedupe; sliver repair after routing"],
    ["Devices with no common net could not be interdigitated", "Automatic diffusion breaks in patterns"],
    ["Guard rings did not fit; wide wires could not land on columns", "Rings push dependent placements; wires neck down at pins"],
    ["enclose [list] poly silently shorted gates; wire ends got no via", "Compile error with hint; vias added automatically"],
    ["Latch-up only seen as an opaque DRC at double width", "Compile-time latch-up check naming the device"],
    ["row gap=min crashed; vague 'no routed metal' port error", "Accepted; error now gives the exact three lines"],
  ];
  s.addTable([[{ text: "Seen in an agent's log", options: hdr }, { text: "Change", options: hdr }]].concat(
    fx.map(([a, b]) => [cell(a, { fontSize: 14 }), cell(b, { fontSize: 14, color: HEX.dk2 })])),
  { x: 0.55, y: 1.4, w: 12.2, colW: [6.1, 6.1], rowH: 0.62, border: { type: "solid", color: "D5DCE4", pt: 1 },
    fill: { color: HEX.lt1 }, objectName: "fix-table" });
  text(s, "Plus checker fixes: GDS database units, li wiring in spacing checks, a tiling check. All regressions stay clean (11/11).",
    { x: 0.55, y: 6.5, w: 12.2, h: 0.45, fontSize: 14, color: C.accent6, objectName: "fix-note" });
  s.addNotes("Every row came from an agent hitting a wall: a router that took another pin's only landing spot, a geometry engine "
    + "that produced slivers, language constructs that silently did the wrong thing. Fixing the tool helps every model at once.");

  // ================================================================== 15. supplementing nemotron
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Learning from logs" });
  s.addText("Knowledge up front: the free model solves a 14T cell", { placeholder: "title" });
  frameImage(s, "nemo_ha.png", 0.75, 1.55, 6.3, 3.78, "nemo-ha");
  text(s, "Half adder by Nemotron: 5.52 µm wide, clean at all 6 sweep points",
    { x: 0.6, y: 5.5, w: 6.6, h: 0.4, fontSize: 12, color: C.accent6, italic: true, objectName: "nemo-cap" });
  const steps2 = [
    ["eye", "Log: 36 model calls, only 2 checks", "Most of the budget went into reading the reference, lessons and examples", HEX.accent6],
    ["book", "Change: put them in the prompt", "Task, language reference and lessons preloaded; 60 calls; tool fixes from the logs", HEX.accent3],
    ["check", "Result", "ha clean and sweep-clean: the free model's first dense standard cell; maj3 reached 0 DRC, LVS still open", HEX.accent2],
  ];
  steps2.forEach(([ic, h, t, col], i) => {
    const y = 1.55 + i * 1.6;
    iconCircle(s, ic, 7.55, y, 0.75, col, "nemo-step-" + i);
    text(s, h, { x: 8.5, y: y, w: 4.25, h: 0.42, fontSize: 17, bold: true, objectName: "nemo-head-" + i });
    text(s, t, { x: 8.5, y: y + 0.45, w: 4.25, h: 1.0, fontSize: 14, color: C.text2, objectName: "nemo-text-" + i });
  });
  s.addNotes("The free model's limit on dense cells was partly its budget: it spent most calls reading files. Preloading the knowledge "
    + "into its prompt let it finish the half adder. maj3 is now blocked by the router's pin access in dense cells.");

  // ================================================================== 16. open issues
  s = pres.addSlide({ masterName: "CONTENT", sectionTitle: "Learning from logs" });
  s.addText("Open issues and next steps", { placeholder: "title" });
  card(s, 0.55, 1.45, 5.95, 4.9, "open-card");
  iconCircle(s, "warn", 0.8, 1.7, 0.7, HEX.accent1, "open");
  text(s, "Still limiting", { x: 1.7, y: 1.78, w: 4.5, h: 0.5, fontSize: 19, bold: true, objectName: "open-head" });
  const open = ["Router pin access in dense standard cells (maj3, one Sonnet sweep point)",
    "Rows give clean cells but not the 2.72 µm standard-cell frame",
    "Generator cannot route the 18T latch or 28T full adder yet",
    "Free tier: 1000 requests / day; Gemma 4 rate-limited upstream"];
  text(s, open.map((t, k) => ({ text: t, options: { bullet: true, breakLine: k < open.length - 1 } })),
    { x: 0.8, y: 2.6, w: 5.45, h: 3.6, fontSize: 15, paraSpaceAfter: 10, color: C.text2, objectName: "open-list" });
  card(s, 6.8, 1.45, 5.95, 4.9, "next-card");
  iconCircle(s, "route", 7.05, 1.7, 0.7, HEX.accent2, "next");
  text(s, "Next", { x: 7.95, y: 1.78, w: 4.5, h: 0.5, fontSize: 19, bold: true, objectName: "next-head" });
  const next = ["Pin-access-aware routing for dense cells",
    "Let rows target the standard-cell frame: an easier level for weak models",
    "Level-3 floorplan benchmark with the same judge",
    "Move the best configuration into your LangGraph deepagents harness"];
  text(s, next.map((t, k) => ({ text: t, options: { bullet: true, breakLine: k < next.length - 1 } })),
    { x: 7.05, y: 2.6, w: 5.45, h: 3.6, fontSize: 15, paraSpaceAfter: 10, color: C.text2, objectName: "next-list" });
  text(s, [{ text: "Status 2026-11-11: ", options: { bold: true } },
    { text: "the work continued on a PDK-neutral canvas: larger layouts (up to 768 transistors), resistors and capacitors, "
      + "free polygons and two more PDKs. See icl_canvas.pptx." }],
    { x: 0.55, y: 6.5, w: 12.2, h: 0.45, fontSize: 12, color: C.accent6, objectName: "status-note" });
  s.addNotes("The main remaining tool limit is the router's pin access in dense standard cells. The most promising language step is "
    + "letting the row template produce standard cells in the 2.72 µm frame, which the free model already tried on its own. "
    + "This slide is the state of the ICL experiments. What followed (the canvas, three PDKs, the larger benchmark) is in "
    + "icl_canvas.pptx.");

  // ================================================================== 17. takeaways
  s = pres.addSlide({ masterName: "CLOSING_DARK", sectionTitle: "Learning from logs" });
  s.addText("Takeaways", { placeholder: "title" });
  s.addText([
    { text: "A layout language lets weaker and free models do what only strong models can do from raw coordinates.", options: { bullet: true, breakLine: true } },
    { text: "Diagnosis in the agent's own terms, distilled lessons and examples move the free model most.", options: { bullet: true, breakLine: true } },
    { text: "For strong models, techniques buy robustness, size and cost rather than pass rate.", options: { bullet: true, breakLine: true } },
    { text: "Agent logs are the best source of tool fixes.", options: { bullet: true } },
  ], { placeholder: "body" });
  text(s, "Code and results: github.com/ibrahim-me/icdsl (private).  agents/README.md, agent_compare2/RESULTS.md.  Continued in icl_canvas.pptx",
    { x: 0.6, y: 6.6, w: 12, h: 0.4, fontSize: 12, color: "9FB0C4", objectName: "closing-paths" });
  frameImage(s, "nemo_ha.png", 8.6, 1.4, 4.1, 2.46, "closing-image");
  s.addNotes("Four takeaways, and where to find the code and the detailed results.");

  await pres.writeFile({ fileName: OUT });
  await applyTheme(OUT, THEME);
  console.log("wrote", OUT);
})();
