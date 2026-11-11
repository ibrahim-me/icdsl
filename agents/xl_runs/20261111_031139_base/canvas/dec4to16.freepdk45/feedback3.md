Judge:
  FAIL DRC      373 violation(s): 297 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4); 28 x Metal2 > 1500nm and runlength > 4.0um spacing to unrelated m2 < 1500nm (METALINT.9); 25 x Metal2 > 900nm and runlength > 2.7um spacing to unrelated m2 < 900nm (METALINT.8); 13 x Metal2 > 500nm and runlength > 1.8um spacing to unrelated m2 < 500nm (METALINT.7); 7 x Metal2 > 270nm and runlength > 300nm spacing to unrelated m2 < 270nm (METALINT.6); 3 x N-well width < 200nm (WELL.4)
  FAIL DRC2     foundry KLayout deck: 54 violation(s): 23 x WELL.1: WELL.1 : nwell/pwell must not overlap; 21 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap; 3 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm; 2 x METAL2.6: METAL2.6 : Minimum spacing of  intermediate metal2 wider than 270 nm and longer ; 2 x METAL2.7: METAL2.7 : Minimum spacing of  intermediate metal2 wider than 500 nm and longer ; 2 x METAL2.8: METAL2.8 : Minimum spacing of  intermediate metal2 wider than 900 nm and longer 
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 4/36; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/dec4to16.freepdk45/a3/judge/dec4to16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     16.35 x 4.96 = 81.0 um2, budget 127, reference 63.17

Tool report:
dec4to16 on freepdk45: 16.24 x 4.955 um (80.47 um2), 2510 shapes, 168 declared devices
connectivity pre-check: 6 short(s), 2 open net(s)
  SHORT A0 = A1 = A2 = A3 = AB0 = AB1 = AB2 = AB3 = VDD = VSS = Y0 = Y1 = Y10 = Y11 = Y12 = Y13 = Y14 = Y15 = Y2 = Y3 = Y4 = Y5 = Y6 = Y7 = Y8 = Y9 = YB0 = YB1 = YB10 = YB11 = YB12 = YB13 = YB14 = YB15 = YB2 = YB3 = YB4 = YB5 = YB6 = YB7 = YB8 = YB9
      m2 (0.280, 0.415) [sub.py:105]
      m2 (0.280, 0.432) [sub.py:90]
      m2 (0.280, 0.965) [sub.py:90]
      via1 (0.280, 1.480) in IA1 [sub.py:9]
      m2 (0.280, 1.480) [sub.py:105]
  SHORT VDD = VSS
      m1 (0.280, 1.062) in IA0 [sub.py:9]
      m1 (0.280, 1.062) in IA1 [sub.py:9]
  SHORT VDD = VSS
      m1 (0.280, 2.127) in IA1 [sub.py:9]
      m1 (0.280, 2.127) in IA2 [sub.py:9]
  SHORT VDD = VSS
      m1 (0.280, 3.192) in IA2 [sub.py:9]
      m1 (0.280, 3.192) in IA3 [sub.py:9]
  SHORT VDD = VSS
      m1 (1.260, 1.903) in N0 [sub.py:10]
      m1 (1.260, 1.903) in N8 [sub.py:10]
  SHORT VDD = VSS
      m1 (12.040, 1.062) in IY0 [sub.py:9]
      m1 (12.040, 1.062) in IY8 [sub.py:9]
  OPEN  net VDD is in 9 unconnected pieces:
      m2 (8.120, 4.505) [sub.py:85] (1624 shapes)
      m1 (1.260, 1.903) in N0 [sub.py:10] (256 shapes)
      m1 (1.260, 3.808) in N8 [sub.py:10] (160 shapes)
      m1 (12.040, 1.062) in IY0 [sub.py:9] (144 shapes)
      m1 (12.040, 2.127) in IY8 [sub.py:9] (72 shapes)
  OPEN  net VSS is in 7 unconnected pieces:
      m2 (8.120, -0.250) [sub.py:86] (1624 shapes)
      m1 (1.260, 1.903) in N8 [sub.py:10] (256 shapes)
      m1 (0.280, -0.003) in IA0 [sub.py:9] (177 shapes)
      m1 (12.040, 1.062) in IY8 [sub.py:9] (144 shapes)
      m1 (0.280, 1.062) in IA1 [sub.py:9] (18 shapes)
DRC (magic drc(full) freepdk45): 373 violation(s), 6 rule(s)
   297 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4)
         at (0.615, 3.84)..(0.67, 3.855)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell]; sub.py:88 [m2]; sub.py:9 [nwell,pwell]
         at (0.615, 3.775)..(0.665, 3.84)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell]; sub.py:88 [m2]; sub.py:9 [pwell]
    28 x Metal2 > 1500nm and runlength > 4.0um spacing to unrelated m2 < 1500nm (METALINT.9)
         at (0.56, 1.655)..(11.76, 1.855)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:9 [nwell,pplus,pwell]; sub.py:90 [m2]
         at (0.56, 1.585)..(11.76, 1.655)  drawn by sub.py:10 [contact,diff,m1,nwell,poly,pplus]; sub.py:88 [m2]; sub.py:9 [pwell]; sub.py:90 [m2]
    25 x Metal2 > 900nm and runlength > 2.7um spacing to unrelated m2 < 900nm (METALINT.8)
         at (0.56, 1.655)..(11.76, 1.855)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:9 [nwell,pplus,pwell]; sub.py:90 [m2]
         at (0.56, 1.585)..(11.76, 1.655)  drawn by sub.py:10 [contact,diff,m1,nwell,poly,pplus]; sub.py:88 [m2]; sub.py:9 [pwell]; sub.py:90 [m2]
    13 x Metal2 > 500nm and runlength > 1.8um spacing to unrelated m2 < 500nm (METALINT.7)
         at (0.56, 1.655)..(11.76, 1.855)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:9 [nwell,pplus,pwell]; sub.py:90 [m2]
         at (0.56, 1.585)..(11.76, 1.655)  drawn by sub.py:10 [contact,diff,m1,nwell,poly,pplus]; sub.py:88 [m2]; sub.py:9 [pwell]; sub.py:90 [m2]
     7 x Metal2 > 270nm and runlength > 300nm spacing to unrelated m2 < 270nm (METALINT.6)
         at (0.56, 1.68)..(11.76, 1.855)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:9 [nwell,pplus,pwell]; sub.py:90 [m2]
         at (0.56, 1.95)..(11.76, 2.125)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:9 [diff,m1,nplus,nwell,pplus,pwell]; sub.py:90 [m2]
     3 x N-well width < 200nm (WELL.4)
         at (0.615, 3.91)..(0.815, 4.07)  drawn by sub.py:10 [nwell]; sub.py:88 [m2]; sub.py:9 [nwell]
         at (11.505, 1.8)..(11.705, 1.94)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:9 [nwell]; sub.py:90 [m2]
DRC (KLayout, drc_freepdk45.lydrc): 54 violation(s), 7 rule(s)
    23 x WELL.1: WELL.1 : nwell/pwell must not overlap
         at (7.505, 1.8)..(9.015, 2.005)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:90 [m2]
         at (4.705, 1.8)..(6.215, 2.005)  drawn by sub.py:10 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]; sub.py:88 [m2]; sub.py:90 [m2]
    21 x IMPLANT.5: IMPLANT.5
...
Net: Y9                                    |Net: Y9
      inv/Y = 2                                |  inv/Y = 1
      nand4/A = 2                              |
      nand4/B = 2                              |
      nand4/C = 2                              |
      nand4/D = 2                              |
      nand4/Y = 2                              |
      inv/A = 2                                |
                                               |
    Net: inv_9/VSS                             |Net: YB1
      nand4/VSS = 2                            |  nand4/Y = 1
      nand4/VDD = 1                            |  inv/A = 1
      inv/VSS = 2                              |
      inv/VDD = 1                              |
                                               |
    Net: inv_16/VDD                            |Net: YB2
      inv/VDD = 1                              |  nand4/Y = 1
      nand4/VDD = 1                            |  inv/A = 1
                                               |
    (no matching net)                          |Net: YB3
                                               |  nand4/Y = 1
                                               |  inv/A = 1
                                               |
    (no matching net)                          |Net: YB4
                                               |  nand4/Y = 1
                                               |  inv/A = 1
                                               |
    (no matching net)                          |Net: YB5
                                               |  nand4/Y = 1
                                               |  inv/A = 1
                                               |
    (no matching net)                          |Net: YB6
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/dec4to16.freepdk45/a3/dec4to16.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/dec4to16.freepdk45/a3/dec4to16.extracted.spice
result: VIOLATIONS   (4.5 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/dec4to16.freepdk45/a3/dec4to16.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/dec4to16.freepdk45/a3/dec4to16.png