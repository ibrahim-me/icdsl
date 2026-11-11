Judge:
  FAIL DRC      2932 violation(s): 864 x Metal1 spacing < 65nm (METAL1.2); 728 x Contact width < 65nm (CONTACT.1); 704 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4); 352 x Contact spacing < 75nm (CONTACT.2); 144 x N-well spacing < 135nm (WELL.3); 140 x Poly gate spacing < 140nm (POLY.2)
  FAIL DRC2     foundry KLayout deck: 1894 violation(s): 960 x GRID: vertexes on layer metal1 not on grid of 0.0025; 358 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm; 317 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm; 88 x CONTACT.5: CONTACT.5 : Minimum enclosure of poly around contact : 5nm; 65 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap; 44 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 442/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/shreg16.freepdk45/a4/judge/shreg16.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  ok   area     19.40 x 10.86 = 210.7 um2, budget 261, reference 130.23

Tool report:
DRC (magic drc(full)): 2932 violation(s), boxes in um
   864 x Metal1 spacing < 65nm (METAL1.2)   e.g. at (0.564 8.586 0.580 8.612)  (0.656 8.586 0.672 8.612)  (0.851 8.586 0.884 8.612)
   728 x Contact width < 65nm (CONTACT.1)   e.g. at (0.410 8.614 0.432 8.666)  (0.500 8.614 0.522 8.666)  (0.714 8.614 0.736 8.666)
   704 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (0.420 8.666 0.460 8.670)  (0.420 8.610 0.460 8.614)  (0.724 8.666 0.764 8.670)
   352 x Contact spacing < 75nm (CONTACT.2)   e.g. at (0.410 8.614 0.470 8.666)  (0.714 8.614 0.774 8.666)  (1.018 8.614 1.078 8.666)
   144 x N-well spacing < 135nm (WELL.3)   e.g. at (0.624 8.524 0.668 8.756)  (0.928 8.524 0.972 8.756)  (1.232 8.524 1.276 8.756)
   140 x Poly gate spacing < 140nm (POLY.2)   e.g. at (0.420 7.728 0.460 7.748)  (0.724 7.728 0.764 7.748)  (1.028 7.728 1.068 7.748)
DRC2 (foundry KLayout deck): 1894 violation(s), boxes in um
   960 x GRID: vertexes on layer metal1 not on grid of 0.0025   e.g. at (16.624 10.723 16.644 10.742)  (16.624 10.240 16.644 10.260)  (16.624 10.040 16.644 10.060)
   358 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm   e.g. at (10.740 8.150 10.764 8.165)  (10.562 8.268 10.697 8.315)  (15.210 9.785 15.255 9.815)
   317 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm   e.g. at (1.080 5.566 1.160 5.928)  (1.720 5.745 2.040 5.750)  (0.960 5.745 1.280 5.750)
    88 x CONTACT.5: CONTACT.5 : Minimum enclosure of poly around contact : 5nm   e.g. at (2.027 1.667 2.050 1.667)  (2.027 1.732 2.050 1.732)  (2.090 1.732 2.112 1.732)
    65 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap   e.g. at (14.935 5.735 15.265 5.760)  (14.935 3.135 15.265 3.160)  (16.075 3.135 16.405 3.160)
    44 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm   e.g. at (0.455 0.605 0.525 0.695)  (0.575 0.605 0.645 0.695)  (0.835 0.605 0.905 0.695)
    44 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (0.475 0.618 0.625 0.618)  (0.855 0.618 1.005 0.618)  (1.235 0.618 1.385 0.618)
    18 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm   e.g. at (0.700 1.805 0.780 2.095)  (1.080 1.805 1.160 2.095)  (1.840 1.805 1.920 2.095)
LVS: Top level cell failed pin matching.   devices layout/ref 442/352, nets layout/ref 465/212
  pmos (22->21)                              |pmos (11) **Mismatch**
  nmos (22->11)                              |nmos (11)
  Number of devices: 32 **Mismatch**         |Number of devices: 22 **Mismatch**
  Number of nets: 40 **Mismatch**            |Number of nets: 17 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dff                             |Circuit 2: dff
  ---------------------------------------------------------------------------------------
  Net: a_2570_3965#                          |Net: D
    pmos/gate = 1                            |  nmos/gate = 1
                                             |  pmos/gate = 1
                                             |
  Net: a_4090_3965#                          |Net: n1
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_1050_6065#                          |Net: n2
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_3330_3965#                          |Net: n3
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_1050_5680#                          |Net: n4
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_2570_6065#                          |Net: p1
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_4850_3965#                          |Net: p2
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_2570_5680#                          |Net: p3
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_1810_6065#                          |Net: p4
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_1050_3965#                          |Net: VSS
    pmos/gate = 1                            |  nmos/(drain|source) = 7
                                             |  nmos/bulk = 11
                                             |