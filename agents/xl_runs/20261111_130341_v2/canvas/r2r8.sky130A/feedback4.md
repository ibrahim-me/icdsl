Judge:
  FAIL DRC      63 violation(s): 60 x Local interconnect spacing < 0.17um (li.3); 3 x mrp1 resistor width < 0.33um (poly.3)
  FAIL DRC2     foundry KLayout deck: 66 violation(s): 45 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um; 15 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um; 6 x licon.1: licon.1: min/max. licon length : 0.17um
  FAIL LVS      Netlists do not match.  (devices layout/ref 10/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.sky130A/a4/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     48.52 x 25.54 = 1239.2 um2, budget 1630, reference 814.74

Tool report:
r2r8 on sky130A: 48.52 x 25.54 um (1239.2 um2), 317 shapes, 25 declared devices
connectivity pre-check: 2 short(s), 17 open net(s)
  SHORT VSS = n0
      li (0.500, -3.415) [sub.py:16]
      licon (0.160, -3.415) [sub.py:16]
      poly (0.500, -3.375) [sub.py:16]
      poly (0.500, -3.125) [sub.py:16]
      licon (0.160, -3.085) [sub.py:16]
      li (0.500, -3.085) [sub.py:16]
  SHORT n0 = t
      li (0.500, 2.915) [sub.py:16]
      li (0.500, 3.085) [sub.py:16]
  OPEN  net n0 is in 4 unconnected pieces:
      li (0.500, -3.085) [sub.py:16] (11 shapes)
      li (0.500, 2.915) [sub.py:16] (8 shapes)
      li (2.915, 0.500) [sub.py:16] (5 shapes)
      li (0.000, 0.000) [sub.py:49] (1 shapes)
  OPEN  net OUT is in 3 unconnected pieces:
      li (48.085, 0.500) [sub.py:16] (6 shapes)
      li (46.000, 2.915) [sub.py:16] (5 shapes)
      li (45.500, 0.000) [sub.py:49] (1 shapes)
  OPEN  net n1 is in 3 unconnected pieces:
      li (9.085, 0.500) [sub.py:16] (10 shapes)
      li (7.000, 2.915) [sub.py:16] (5 shapes)
      li (6.500, 0.000) [sub.py:49] (1 shapes)
  OPEN  net n2 is in 3 unconnected pieces:
      li (15.585, 0.500) [sub.py:16] (10 shapes)
      li (13.500, 2.915) [sub.py:16] (5 shapes)
      li (13.000, 0.000) [sub.py:49] (1 shapes)
  OPEN  net n3 is in 3 unconnected pieces:
      li (22.085, 0.500) [sub.py:16] (10 shapes)
      li (20.000, 2.915) [sub.py:16] (5 shapes)
      li (19.500, 0.000) [sub.py:49] (1 shapes)
  OPEN  net n4 is in 3 unconnected pieces:
      li (28.585, 0.500) [sub.py:16] (10 shapes)
      li (26.500, 2.915) [sub.py:16] (5 shapes)
      li (26.000, 0.000) [sub.py:49] (1 shapes)
  OPEN  net n5 is in 3 unconnected pieces:
      li (35.085, 0.500) [sub.py:16] (10 shapes)
      li (33.000, 2.915) [sub.py:16] (5 shapes)
      li (32.500, 0.000) [sub.py:49] (1 shapes)
  OPEN  net n6 is in 3 unconnected pieces:
      li (41.585, 0.500) [sub.py:16] (10 shapes)
      li (39.500, 2.915) [sub.py:16] (5 shapes)
      li (39.000, 0.000) [sub.py:49] (1 shapes)
  OPEN  net t is in 3 unconnected pieces:
      li (0.500, 3.085) [sub.py:16] (8 shapes)
      li (0.500, -9.585) [sub.py:16] (5 shapes)
      li (0.000, -6.000) [sub.py:49] (1 shapes)
  OPEN  net x0 is in 2 unconnected pieces:
      li (0.500, 9.085) [sub.py:16] (10 shapes)
      li (0.000, 6.000) [sub.py:49] (1 shapes)
  OPEN  net x1 is in 2 unconnected pieces:
      li (7.000, 9.085) [sub.py:16] (10 shapes)
      li (6.500, 6.000) [sub.py:49] (1 shapes)
  OPEN  net x2 is in 2 unconnected pieces:
      li (13.500, 9.085) [sub.py:16] (10 shapes)
      li (13.000, 6.000) [sub.py:49] (1 shapes)
DRC (magic drc(full) sky130A): 63 violation(s), 2 rule(s)
    60 x Local interconnect spacing < 0.17um (li.3)
         at (-0.005, 9.16)..(0.075, 9.17)  drawn by sub.py:16 [li,licon,npc,poly]
         at (-0.005, 9.33)..(0.075, 9.34)  drawn by sub.py:16 [li,licon,npc,poly]
     3 x mrp1 resistor width < 0.33um (poly.3)
         at (-0.25, 3.17)..(0, 3.5)  drawn by sub.py:16 [li,npc,poly,polyres]
         at (0.075, 2.83)..(0.33, 3.17)  drawn by sub.py:16 [li,licon,npc,poly,polyres]
DRC (KLayout, sky130A_mr.drc): 66 violation(s), 3 rule(s)
    45 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um
         at (35.17, 0.755)..(35.33, 0.925)  drawn by sub.py:16 [li,licon,npc,poly]
         at (35.17, 0.415)..(35.33, 0.585)  drawn by sub.py:16 [li,licon,npc,poly]
    15 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um
         at (45.495, 9.17)..(46.505, 9.33)  drawn by sub.py:16 [li,licon,npc,poly]
         at (38.995, 9.17)..(40.005, 9.33)  drawn by sub.py:16 [li,licon,npc,poly]
     6 x licon.1: licon.1: min/max. licon length : 0.17um
         at (0.075, 2.83)..(0.075, 3.17)  drawn by sub.py:16 [li,licon,npc,poly,polyres]
         at (0.245, 2.83)..(0.245, 3.17)  drawn by sub.py:16 [li,licon,npc,poly,polyres]
LVS (netgen): MISMATCH - Netlists do not match.  devices layout/ref 10/16, nets 20/17
    Number of devices: 10 **Mismatch**         |Number of devices: 16 **Mismatch**
    Number of nets: 20 **Mismatch**            |Number of nets: 17 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: r2r8                            |Circuit 2: r2r8
    ---------------------------------------------------------------------------------------
    Net: VSS                                   |Net: V
...
Net: B1                                    |Net: B1
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: B2                                    |Net: B2
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: B3                                    |Net: B3
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: B4                                    |Net: B4
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: B5                                    |Net: B5
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: B6                                    |Net: B6
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: B7                                    |Net: B7
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: a_5200_550#                           |Net: n0
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 3
                                               |
    Net: a_1300_550#                           |Net: n1
      sky130_fd_pr__res_generic_po/(1|2) = 1   |  sky130_fd_pr__res_generic_po/(1|2) = 3
                                               |
    Net: a_6500_550#                           |Net: n2
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.sky130A/a4/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.sky130A/a4/r2r8.extracted.spice
result: VIOLATIONS   (5.3 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.sky130A/a4/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.sky130A/a4/r2r8.png