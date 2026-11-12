# ICL — one layout language, four libraries (SKY130)

ICL lets you lay out SKY130 circuits at the level of abstraction the task needs, and
checks every result with signoff tools (magic DRC + netgen LVS). One syntax, one rule
engine, one router; the block type selects the library:

| block       | library      | level | you write                                                        |
|-------------|--------------|-------|------------------------------------------------------------------|
| `stdcell`   | `geom`       | 1     | shapes defined relative to other shapes (`enclose`, `right_of`, `cross`, `min`) |
| `cell`      | `assembly`   | 2     | PCell devices + placement relations + matching patterns          |
| `floorplan` | `floorplan`  | 3     | finished blocks (ICL cells or PDK std cells), DRC-aware spacing  |
| any block   | `route`      | 4     | auto/manual routing with width, spacing, symmetry, shielding, R, coupling |

A cell built at one level is instantiated by the next (`inst`), across files (`import`).

## The loop

```bash
bin/icl check  f.icl --top CELL     # compile + magic DRC + extract + netgen LVS + route report
bin/icl inspect f.icl --top CELL    # objects, positions, proximity, routes, warnings (text)
bin/icl build  f.icl --top CELL     # GDS + reference SPICE + PNG only
```
Exit code **0 = clean**, 1 = DRC/LVS/constraint violation, 2 = compile/route error.
`--json` gives a machine-readable report. Outputs go to `build/<file>/`
(`CELL.gds`, `CELL.ref.spice`, `CELL.extracted.spice`, `CELL.lvs.txt`, `CELL.png`).
Every error names the source line and usually suggests the fix; act on the hint.

## Common syntax

```
pdk sky130A
import "other.icl"
<block> <name> key=value ...
  [<name> =] <verb> <arg> <arg> ... <key>=<value> ...
end
```
* Values are expressions in **µm**: `0.5`, `0.5um`, `200nm`, `min`, `min+0.1`, `(x, y)`,
  `[a, b]`, `+ - * /`, `max(a,b)`, `grid(c, r)`, and references: `nd.top`, `M1.d.x`,
  `AMP.OUT`, `MT.cx`. Objects expose `left right bottom top cx cy w h`; devices expose pins
  `d g s`; instances expose their ports.
* `min` always means "the design-rule minimum for the layers involved".
* Nets are plain names; a net used once triggers a *dangling — did you mean* warning.
* Value bindings: `dw = 2*L + 0.81` (or `cb = max(nd.top + 0.19, snl.top + 0.25)`) on its own line
  inside a block names a value for later expressions.
* Parameters: `param WN=0.52 L=0.15 H=2.72` at file level (before the blocks); use them in any
  expression (`w=WN`, `height=H`, `w=(L + 0.53)`); override from the command line with
  `bin/icl check f.icl --param WN=0.84 --param H=3.26`. Write cells so they stay clean when the
  parameters change: derive positions from other shapes and from the parameters, and use
  `max(...)` when two rules both limit a position.
* Ports: `port <net> in|out|inout|power|ground` (+ `side=left|right|top|bottom layer=m2` in
  cells/floorplans to put the pin on an edge; `on=<shape>` in stdcells).

## Level 1 — `stdcell` (library geom)

`stdcell NAME width=<columns of 0.46> [height=2.72] [taps=yes] [nwell_y=0.48*height] [route_grid=0.115]`
The template gives: `cell` (boundary), `vgnd`/`vpwr` (met1 rails), `vgnd_li`/`vpwr_li`,
`ptap`/`ntap` (tap strips), `nwell`.

```
n = rect    <layer> [w=] [h=] <x> <y> [net=]
      x: left= right= cx= | right_of=<o> | left_of=<o> | xspan=(a,b) | in=<o>
      y: bottom= top= cy= | above=<o> | below=<o> | yspan=(a,b) | in=<o>
      space= (both axes) / xspace= / yspace=   default min;  align=center|left|right|top|bottom
n = enclose <o|[o,...]> <layer> [by=min|minx|<um>|(x,y)] [left= right= top= bottom=] [net=]
      by=min: all-round rule + the one-direction extra on top/bottom; minx: extra on left/right
n = cross   <o|[o,...]> <layer> [w=min] [dir=v|h] [ext=min|<um>|(lo,hi)] <x or y position>
      a strip crossing the object(s), e.g. a gate: ext=min -> poly endcap 0.13
n = contact <cut> [in=<o>] <x> <y>                    single licon/mcon/via/via2/via3
n = array   <cut> in=<o> [left_of=<o>|right_of=<o> [gap=min] | between=[o1,o2]] [dir=y|x] [cx=|cy=]
      [space=min] [span=(lo,hi)]   column of cuts beside a gate, or centred between two gates;
      span= keeps the column between two coordinates (as many cuts as fit, centred)
n = strap   <layer> from=<o> to=<o> [w=min] [cx=|cy=]  bar joining two aligned shapes
n = copy <o> dx= dy= ;  n = mirror <o> axis=<x>
well y=<um>                                         move the n-well's bottom edge (n/p split),
      e.g. well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)   (n-diff >= 0.34 away, p-diff >= 0.18 inside)
net <net> <o> ... ;  port <net> <dir> on=<o> ;  device <name> nmos|pmos w= l= [nf=] d= g= s=
```
`device` lines are the reference netlist for LVS. After the build a **fast in-process DRC**
runs and lists violations with the statement lines involved, and a **pin-access check**
warns if a parent router could not land on a port (fix: put the pin on met1:
`m = contact mcon in=<li>`, `p = enclose m m1 by=0.06`, `port X in on=p`).
See `examples/l1_stdcells.icl` (inverter and NAND2 in hd footprints).

## Level 2 — `cell` (library assembly)

```
nmos|pmos <name> w=<um per finger> l=<um> [nf=] d= g= s=        (b= defaults to the rails)
inst <name> <cell> <port>=<net> ...
```
**Automatic rows** (quick, digital-style): `row <items> [gap=] [space=] [strap=top|bottom]`,
rows bottom to top, nmos rows below pmos rows; rails, taps, wells are automatic.

**Free placement** (analog control) — objects are devices, patterns, taps, instances:
```
place  <o> at=(x,y) | right_of=<o> | left_of=<o> | above=<o> | below=<o>
           [gap=min|<um>] [align=origin|bottom|top|center|left|right] [flip=x|y]
pair   <A> <B> axis=<x> [above=<o>|below=<o>|at_y=] [gap=min] [vgap=<um>]
           B = mirror image of A about the axis, at the minimum legal distance
mirror <o> of=<o> axis=<x> ;   move <o> dx= dy=
interdigitate   <A> <B> ... pattern=ABBA [dummies=1] [name=]    one shared diffusion
common_centroid <A> <B> pattern=AB/BA [dummies=1] [name=]       one diffusion row per '/'
abut <A> <B> ...                                                diffusion sharing, side by side
tap <name> kind=ptap|ntap net=<net> [cols=]
guardring <name> around=[o, ...] kind=ptap|ntap net=<net> [space=]
```
* `gap=min` placement is rule-aware compaction over every layer (diff, poly, implants,
  wells, li, metals). An explicit `gap=` below the legal minimum is an error naming the rule.
* Pattern letters map to the listed devices in order (A, B, ...); each device's `nf` must
  equal its letter count. Source/drain columns are solved automatically (neighbours share a
  column where they have a common net; where they cannot - e.g. two cascodes with different
  sources - the diffusion is broken there automatically, fewest breaks); gate straps go above
  or below the diffusion so interleaved devices never short. Dummies: gate to the body supply,
  source/drain tied to the neighbouring column. A non-centroid `common_centroid` pattern is
  reported.
* A cell needs a `ground` port if it has nmos devices and a `power` port if it has pmos devices.
* Wells and implants are merged automatically (n-wells closer than 2.8 µm become one well unless
  n-devices sit in between); every pmos n-well island must contain an `ntap`
  (tap or guard ring) and there must be a `ptap` — missing ties are errors with a fix.
* Placement of guard rings checks clearance and tells you how much room to leave.
See `examples/l2_analog.icl` (matched OTA; symmetric differential stage with guard rings).

## Level 3 — `floorplan` (library floorplan)

```
floorplan <name> [width=<um> height=<um>] [route_grid=0.23]
  inst <name> <cell | pdk:sky130_fd_sc_hd__inv_2> <port>=<net> ...      (alias: block)
  place / pair / mirror / move       as in cells
  proximity <A> <B>                  report: abut legal?, minimum legal gap + binding rule,
                                     layers on the facing edges and their distance to the edge
  port <net> <dir> side=<edge> layer=m3
```
`place B right_of=A` (gap=min) **abuts** B to A when every facing layer either keeps its
spacing or merges legally (same well/implant, same-net rails); otherwise B goes to the
smallest legal gap and the binding rule is recorded (`icl inspect` → `proximity:` lines).
PDK std cells (`pdk:` prefix) come with their real GDS and SPICE; their bodies (VPB/VNB)
connect to the supplies and need a tap cell abutted (`pdk:sky130_fd_sc_hd__tapvpwrvgnd_1`).
Chip routing defaults to met1–met3. See `examples/l3_chip.icl`.

## Level 4 — routing (library route, every block)

```
route <net> ... [layers=m1,m2,m3] [width=<um>] [space=<um>] [avoid=NET:<um>,NET:<um>]
                [prefer=m2] [maxres=<ohm>] [shield=<net>]
route * [layers=...]                               defaults for all other nets
route <A> <B> symmetric axis=<x>                   B is routed as the exact mirror of A
wire  <net> layer=<m> [width=] path=[<pin|point>, (x, y), ...]     manual, checked, via stacks added
wire  <net> from=<pin> to=<pin> [layers=] [width=] [space=] [avoid=]   constrained point-to-point
keepout <A> <B> dist=<um>                          pairwise spacing
limit coupling <A> <B> max=<fF>                    router re-spaces until met (sidewall estimate)
limit resistance <net> max=<ohm>                   fewer vias first, then wider (unless width= fixed)
```
Order: manual wires → symmetric pairs → nets named in `route` (in order) → supplies → the
rest (shortest first), with rip-up and retry. A wide route (`width=`) necks down to the minimum
width within about 0.5 µm of its own pins, so it can land on narrow contact columns. Keep-outs (`avoid`, `keepout`, `space`) apply
to wires and vias; pin landings, and wires within the keep-out distance of either net's pin
landing (the escape zone), only need the design-rule spacing — two pins 0.46 µm apart could
never satisfy a larger keep-out. A failure lists every constraint on the net with its line. Legality is checked on real geometry with the
spacing that applies to each pair of nets, so wide wires, keep-aways and shields never
create spacing errors; a failure is reported with the blocking object. The `route` report
(`check`/`inspect`) gives per-net length, layers, cut count, width and worst pin-to-pin
resistance, plus coupling estimates for every `limit coupling` pair.

## Reading failures

| message | what to do |
|---|---|
| `line N: ... hint: ...` | fix that statement as hinted |
| `gap=... violates <layer> spacing ... minimum legal gap is X` | use `gap=min` or ≥ X |
| `guardring ... does not fit ... needs about X um` | increase the gap/vgap around its contents |
| `routing failed: net 'x': pin P has no legal access point (blocked by O on m1)` | move O, give space, allow another layer, or put the pin on metal |
| `fast pre-check found N rule issue(s) ... near <shape> (line L)` | level 1: fix the listed shapes |
| magic DRC rule list with `near <objects>` | the objects under the error box, by DSL name |
| `LVS MISMATCH` with `Net: <name>` | nets use DSL names; `(no matching net)` = broken / misnamed |
| `port X: no legal met1/met2 access point for a parent router` | expose the pin on met1 |

## Limits

These limits are those of the ICL language (`.icl`). They do not apply to the canvas (`.py` scripts, [CANVAS.md](CANVAS.md)): any layer, any polygon, resistors / MIM capacitors / any declared device, sky130A, gf180mcuD and freepdk45 (45 nm), with the PDK's KLayout DRC deck as a second DRC judge (asap7, 7 nm FinFET: shapes and `mos` / `tap` / `via` only, see CANVAS.md section 11). Use the canvas when a task does not fit ICL.

1.8 V nfet/pfet only (no R/C/HV/BJT/diode devices); routing met1–met4; the row template has a
single n-well band; instance rows in the row template must be equal height; coupling is a
sidewall estimate, resistance a sheet/via estimate; for `.icl` files KLayout's official DRC deck is
not run (magic `drc(full)` is the signoff check).
