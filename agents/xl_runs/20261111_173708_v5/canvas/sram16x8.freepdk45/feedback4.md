Judge:
  FAIL DRC      27767 violation(s): 4080 x Poly overlap of poly contact < 5nm in one direction (CONTACT.5); 3840 x N-Diffusion overhang of nmos < 70nm (POLY.4); 3360 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4); 2688 x Via1 spacing < 75nm (VIA1.2); 2336 x Contact spacing < 75nm (CONTACT.2); 2128 x Metal1 spacing < 65nm (METAL1.2)
  FAIL DRC2     foundry KLayout deck: 7249 violation(s): 1792 x CONTACT.2: CONTACT.2 : Minimum spacing of contact : 75nm; 1536 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm; 1056 x POLY.3: POLY.3 : Minimum poly extension beyond active : 50nm; 816 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm; 544 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm; 512 x VIA1.2: VIA1.2 : Minimum spacing of via1 : 75nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 18/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/sram16x8.freepdk45/a4/judge/sram16x8.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     29.80 x 32.60 = 971.6 um2, budget 592, reference 295.8

Tool report:
sram16x8 on freepdk45: 29.805 x 32.6 um (971.64 um2), 14434 shapes, 768 declared devices
connectivity pre-check: 8 short(s), 36 open net(s)
  SHORT BL = BL0 = BL1 = BL2 = BL3 = BL4 = BL5 = BL6 = BL7 = BLB = BLB0 = BLB1 = BLB2 = BLB3 = BLB4 = BLB5 = BLB6 = BLB7 = Q = QB = VDD = VSS = WL0 = WL1 = WL10 = WL11 = WL12 = WL13 = WL14 = WL15 = WL2 = WL3 = WL4 = WL5 = WL6 = WL7 = WL8 = WL9
      m1 (0.598, 0.443) [sub.py:34]
      via1 (0.560, 0.440) [sub.py:112]
      m2 (0.560, 1.000) [sub.py:115]
  SHORT BL = BL1 = BLB = BLB1 = Q = QB = VDD = VSS
      m1 (-1.403, 0.443) [sub.py:34]
      via1 (-1.440, 0.440) [sub.py:112]
      m2 (-1.440, 1.000) [sub.py:115]
  SHORT BL = BL2 = BLB = BLB2 = Q = QB = VDD = VSS
      m1 (-3.402, 0.443) [sub.py:34]
      via1 (-3.440, 0.440) [sub.py:112]
      m2 (-3.440, 1.000) [sub.py:115]
  SHORT BL = BL3 = BLB = BLB3 = Q = QB = VDD = VSS
      m1 (-5.402, 0.443) [sub.py:34]
      via1 (-5.440, 0.440) [sub.py:112]
      m2 (-5.440, 1.000) [sub.py:115]
  SHORT BL = BL4 = BLB = BLB4 = Q = QB = VDD = VSS
      m1 (-7.402, 0.443) [sub.py:34]
      via1 (-7.440, 0.440) [sub.py:112]
      m2 (-7.440, 1.000) [sub.py:115]
  SHORT BL = BL5 = BLB = BLB5 = Q = QB = VDD = VSS
      m1 (-9.402, 0.443) [sub.py:34]
      via1 (-9.440, 0.440) [sub.py:112]
      m2 (-9.440, 1.000) [sub.py:115]
  SHORT BL = BL6 = BLB = BLB6 = Q = QB = VDD = VSS
      m1 (-11.402, 0.443) [sub.py:34]
      via1 (-11.440, 0.440) [sub.py:112]
      m2 (-11.440, 1.000) [sub.py:115]
  SHORT BL = BL7 = BLB = BLB7 = Q = QB = VDD = VSS
      m1 (-13.402, 0.443) [sub.py:34]
      via1 (-13.440, 0.440) [sub.py:112]
      m2 (-13.440, 1.000) [sub.py:115]
  OPEN  net WL0 is in 15 unconnected pieces:
      poly (1.000, 0.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 0.445) [sub.py:34] (1 shapes)
      poly (-0.425, 0.445) [sub.py:34] (1 shapes)
      poly (-3.305, 0.445) [sub.py:34] (1 shapes)
      poly (-2.425, 0.445) [sub.py:34] (1 shapes)
  OPEN  net WL1 is in 15 unconnected pieces:
      poly (1.000, 2.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 2.445) [sub.py:34] (1 shapes)
      poly (-0.425, 2.445) [sub.py:34] (1 shapes)
      poly (-3.305, 2.445) [sub.py:34] (1 shapes)
      poly (-2.425, 2.445) [sub.py:34] (1 shapes)
  OPEN  net WL10 is in 15 unconnected pieces:
      poly (1.000, 20.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 20.445) [sub.py:34] (1 shapes)
      poly (-0.425, 20.445) [sub.py:34] (1 shapes)
      poly (-3.305, 20.445) [sub.py:34] (1 shapes)
      poly (-2.425, 20.445) [sub.py:34] (1 shapes)
  OPEN  net WL11 is in 15 unconnected pieces:
      poly (1.000, 22.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 22.445) [sub.py:34] (1 shapes)
      poly (-0.425, 22.445) [sub.py:34] (1 shapes)
      poly (-3.305, 22.445) [sub.py:34] (1 shapes)
      poly (-2.425, 22.445) [sub.py:34] (1 shapes)
  OPEN  net WL12 is in 15 unconnected pieces:
      poly (1.000, 24.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 24.445) [sub.py:34] (1 shapes)
      poly (-0.425, 24.445) [sub.py:34] (1 shapes)
      poly (-3.305, 24.445) [sub.py:34] (1 shapes)
      poly (-2.425, 24.445) [sub.py:34] (1 shapes)
  OPEN  net WL13 is in 15 unconnected pieces:
      poly (1.000, 26.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 26.445) [sub.py:34] (1 shapes)
      poly (-0.425, 26.445) [sub.py:34] (1 shapes)
      poly (-3.305, 26.445) [sub.py:34] (1 shapes)
      poly (-2.425, 26.445) [sub.py:34] (1 shapes)
  OPEN  net WL14 is in 15 unconnected pieces:
      poly (1.000, 28.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 28.445) [sub.py:34] (1 shapes)
      poly (-0.425, 28.445) [sub.py:34] (1 shapes)
      poly (-3.305, 28.445) [sub.py:34] (1 shapes)
      poly (-2.425, 28.445) [sub.py:34] (1 shapes)
  OPEN  net WL15 is in 15 unconnected pieces:
      poly (1.000, 30.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 30.445) [sub.py:34] (1 shapes)
      poly (-0.425, 30.445) [sub.py:34] (1 shapes)
      poly (-3.305, 30.445) [sub.py:34] (1 shapes)
      poly (-2.425, 30.445) [sub.py:34] (1 shapes)
  OPEN  net WL2 is in 15 unconnected pieces:
      poly (1.000, 4.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 4.445) [sub.py:34] (1 shapes)
      poly (-0.425, 4.445) [sub.py:34] (1 shapes)
      poly (-3.305, 4.445) [sub.py:34] (1 shapes)
      poly (-2.425, 4.445) [sub.py:34] (1 shapes)
  OPEN  net WL3 is in 15 unconnected pieces:
      poly (1.000, 6.400) [sub.py:45] (2980 shapes)
      poly (-1.305, 6.445) [su
...
 nmos/(drain|source) = 4                  |
      nmos/bulk = 2                            |
      pmos/(drain|source) = 32                 |
      pmos/gate = 16                           |
                                               |
    Net: a_n1866_2855#                         |Net: VDD
      nmos/gate = 1                            |  pmos/(drain|source) = 256
                                               |  pmos/bulk = 256
                                               |
    Net: w_9_5019#                             |Net: BL0
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    Net: w_9_1019#                             |Net: BLB0
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    Net: w_9_4619#                             |Net: BL1
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    Net: w_9_3019#                             |Net: BLB1
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    Net: w_9_619#                              |Net: BL2
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    Net: w_9_2619#                             |Net: BLB2
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    Net: w_9_6219#                             |Net: BL3
      pmos/bulk = 1                            |  nmos/(drain|source) = 16
                                               |
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/sram16x8.freepdk45/a4/sram16x8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/sram16x8.freepdk45/a4/sram16x8.extracted.spice
result: VIOLATIONS   (9.0 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/sram16x8.freepdk45/a4/sram16x8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/sram16x8.freepdk45/a4/sram16x8.png