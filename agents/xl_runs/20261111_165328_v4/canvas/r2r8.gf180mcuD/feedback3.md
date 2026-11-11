Judge:
  FAIL DRC      237 violation(s): 144 x Poly overlap of contact < 0.065um (CO.3); 38 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7); 36 x rpp spacing to Cont < 0.215um (PRES.7 - CO.6); 18 x ppolyres minimum width < 0.8um (PRES.1); 1 x Metal1 spacing < 0.23um (M1.2a)
  FAIL DRC2     foundry KLayout deck: 119 violation(s): 36 x PRES.7: PRES.7 : Minimum space from salicide block to contact on Poly2 resistor: 0.22.um; 36 x SB.4: SB.4 : Space from salicide block to contact: 0.15 um; 36 x SB.8: SB.8 : Non-salicided contacts are forbidden.; 7 x PP.2: PP.2 : min. pplus spacing : 0.4µm; 2 x CO.2a: CO.2a : min. contact spacing : 0.25µm; 1 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 9/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a3/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     75.16 x 25.08 = 1885.0 um2, budget 1705, reference 852.06

Tool report:
r2r8 on gf180mcuD: 75.16 x 25.08 um (1885.01 um2), 691 shapes, 25 declared devices
connectivity pre-check: 1 short(s), 16 open net(s)
  SHORT OUT = VSS = n0 = n1 = n2 = n3 = n4 = n5 = n6 = t
      m1 (58.330, 0.500) [sub.py:33]
      m1 (21.980, -1.480) [sub.py:56]
      m1 (-9.330, 0.500) [sub.py:26]
  OPEN  net OUT is in 2 unconnected pieces:
      m1 (58.330, 0.500) [sub.py:33] (501 shapes)
      m1 (56.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n0 is in 2 unconnected pieces:
      m1 (3.330, 0.500) [sub.py:28] (501 shapes)
      m1 (0.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n1 is in 2 unconnected pieces:
      m1 (10.330, 0.500) [sub.py:33] (501 shapes)
      m1 (8.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n2 is in 2 unconnected pieces:
      m1 (18.330, 0.500) [sub.py:33] (501 shapes)
      m1 (16.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n3 is in 2 unconnected pieces:
      m1 (26.330, 0.500) [sub.py:33] (501 shapes)
      m1 (24.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n4 is in 2 unconnected pieces:
      m1 (34.330, 0.500) [sub.py:33] (501 shapes)
      m1 (32.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n5 is in 2 unconnected pieces:
      m1 (42.330, 0.500) [sub.py:33] (501 shapes)
      m1 (40.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net n6 is in 2 unconnected pieces:
      m1 (50.330, 0.500) [sub.py:33] (501 shapes)
      m1 (48.500, 5.670) [sub.py:40] (4 shapes)
  OPEN  net x0 is in 2 unconnected pieces:
      m1 (0.500, 12.330) [sub.py:40] (3 shapes)
      m1 (0.500, 11.670) [sub.py:42] (3 shapes)
  OPEN  net x1 is in 2 unconnected pieces:
      m1 (8.500, 12.330) [sub.py:40] (3 shapes)
      m1 (8.500, 11.670) [sub.py:42] (3 shapes)
  OPEN  net x2 is in 2 unconnected pieces:
      m1 (16.500, 12.330) [sub.py:40] (3 shapes)
      m1 (16.500, 11.670) [sub.py:42] (3 shapes)
  OPEN  net x3 is in 2 unconnected pieces:
      m1 (24.500, 12.330) [sub.py:40] (3 shapes)
      m1 (24.500, 11.670) [sub.py:42] (3 shapes)
DRC (magic drc(full) gf180mcuD): 237 violation(s), 5 rule(s)
   144 x Poly overlap of contact < 0.065um (CO.3)
         at (0.085, 12.445)..(0.915, 12.51)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
         at (0.085, 12.445)..(0.15, 12.51)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
    38 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7)
         at (0.155, 12.22)..(0.375, 12.44)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
         at (0.625, 12.22)..(0.845, 12.44)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
    36 x rpp spacing to Cont < 0.215um (PRES.7 - CO.6)
         at (0.85, 12.445)..(1, 12.66)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
         at (0.85, 12.215)..(1, 12.445)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
    18 x ppolyres minimum width < 0.8um (PRES.1)
         at (0.15, 12.215)..(0.8, 12.445)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
         at (0.15, 11.555)..(0.8, 11.785)  drawn by sub.py:40 [poly,pplus,res_mk,sab]; sub.py:42 [contact,m1,poly,pplus]
     1 x Metal1 spacing < 0.23um (M1.2a)
         at (3.555, 0.85)..(3.675, 0.905)  drawn by sub.py:28 [pplus]; sub.py:33 [contact,m1,poly,pplus]
DRC (KLayout, gf180mcu.drc): 119 violation(s), 7 rule(s)
    36 x PRES.7: PRES.7 : Minimum space from salicide block to contact on Poly2 resistor: 0.22.um
         at (32.155, 12.22)..(32.375, 12.44)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
         at (16.155, 12.22)..(16.375, 12.44)  drawn by sub.py:40 [contact,m1,poly,pplus]; sub.py:42 [poly,pplus,res_mk,sab]
    36 x SB.4: SB.4 : Space from salicide block to contact: 0.15 um
         at (-3.44, 0.155)..(-3.22, 0.375)  drawn by sub.py:26 [poly,pplus,res_mk,sab]; sub.py:28 [contact,m1,poly,pplus]; sub.py:56 [m1]
         at (-2.78, 0.155)..(-2.56, 0.375)  drawn by sub.py:26 [contact,m1,poly,pplus]; sub.py:28 [poly,pplus,res_mk,sab]; sub.py:56 [m1]
    36 x SB.8: SB.8 : Non-salicided contacts are forbidden.
         at (-3.44, 0.155)..(-3.22, 0.375)  drawn by sub.py:26 [poly,pplus,res_mk,sab]; sub.py:28 [contact,m1,poly,pplus]; sub.py:56 [m1]
         at (-2.78, 0.155)..(-2.56, 0.375)  drawn by sub.py:26 [contact,m1,poly,pplus]; sub.py:28 [poly,pplus,res_mk,sab]; sub.py:56 [m1]
     7 x PP
...
                             |
    Net: B1                                    |Net: B1
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B2                                    |Net: B2
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B3                                    |Net: B3
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B4                                    |Net: B4
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B5                                    |Net: B5
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B6                                    |Net: B6
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B7                                    |Net: B7
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: VSS                                   |Net: VSS
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
      ppolyf_u/3 = 9                           |  ppolyf_u/3 = 16
                                               |
    Net: a_3230_2443#                          |Net: n0
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: a_1630_2443#                          |Net: n1
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 3
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a3/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a3/r2r8.extracted.spice
result: VIOLATIONS   (10.9 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a3/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a3/r2r8.png