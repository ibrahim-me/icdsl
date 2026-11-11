Judge:
  FAIL DRC      518 violation(s): 130 x P-Ohmic overhang of Varactor < 0.32um (FIXME); 100 x P-Diffusion overlap of contact < 0.065um (CO.4); 85 x Poly resistor spacing to diffusion < 0.6um (PRES/LRES.3); 64 x Poly overhang of transistor < 0.22um (PL.4); 48 x N-well overlap of P-Diffusion < 0.43um (DF.7); 32 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)
  FAIL DRC2     foundry KLayout deck: 172 violation(s): 64 x PP.10: PP.10 : Overlap of unsalicided COMP. : 0.18µm; 36 x SB.4: SB.4 : Space from salicide block to contact: 0.15 um; 36 x SB.8: SB.8 : Non-salicided contacts are forbidden.; 20 x PRES.7: PRES.7 : Minimum space from salicide block to contact on Poly2 resistor: 0.22.um; 14 x PP.2: PP.2 : min. pplus spacing : 0.4µm; 1 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm
  FAIL LVS      Netlists do not match.  (devices layout/ref 23/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a2/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     74.41 x 22.37 = 1664.4 um2, budget 1705, reference 852.06

Tool report:
r2r8 on gf180mcuD: 74.405 x 22.37 um (1664.44 um2), 654 shapes, 25 declared devices
connectivity pre-check: 3 short(s), 0 open net(s)
  SHORT B6 = B7
      m1 (48.500, 18.330) [sub.py:22]
      m1 (48.500, 18.330) [sub.py:22]
  SHORT OUT = VSS = n0 = n1 = n2 = n3 = n4 = n5 = n6 = t
      m1 (54.330, 0.500) [sub.py:22]
      m1 (51.270, 1.940) [sub.py:58]
      m1 (16.000, -1.228) [sub.py:76]
      m1 (-12.330, 0.500) [sub.py:22]
  SHORT x6 = x7
      m1 (48.500, 10.330) [sub.py:22]
      m1 (48.500, 10.330) [sub.py:22]
DRC (magic drc(full) gf180mcuD): 518 violation(s), 13 rule(s)
   130 x P-Ohmic overhang of Varactor < 0.32um (FIXME)
         at (-0.32, 15.36)..(0, 15.385)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [diff,m1,pplus]
         at (-0.32, 15.295)..(0, 15.36)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [contact,diff,m1,pplus]
   100 x P-Diffusion overlap of contact < 0.065um (CO.4)
         at (-0.33, 15.23)..(0, 15.295)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [contact,diff,m1,pplus]
         at (-0.595, 15.065)..(-0.57, 15.295)  drawn by sub.py:63 [contact,diff,m1,pplus]
    85 x Poly resistor spacing to diffusion < 0.6um (PRES/LRES.3)
         at (0, 15.36)..(1, 15.96)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [diff,m1,pplus]
         at (0.93, 15.36)..(1, 15.96)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [diff,m1,pplus]
    64 x Poly overhang of transistor < 0.22um (PL.4)
         at (-0.22, 15.065)..(0, 15.285)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [contact,diff,m1,pplus]
         at (-0.22, 15)..(0, 15.065)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [contact,diff,m1,pplus]
    48 x N-well overlap of P-Diffusion < 0.43um (DF.7)
         at (-0.31, 15.24)..(0, 15.295)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [contact,diff,m1,pplus]
         at (1, 15.24)..(1.31, 15.295)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [contact,diff,m1,pplus]
    32 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)
         at (0.855, 15.36)..(1, 15.44)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [diff,m1,pplus]
         at (0.855, 15.295)..(1, 15.36)  drawn by sub.py:22 [poly,pplus,res_mk,sab]; sub.py:63 [diff,m1,pplus]
    16 x Poly overlap of contact < 0.065um (CO.3)
         at (47.49, 0.85)..(47.85, 0.915)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
         at (50.15, 0.85)..(50.51, 0.915)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
    13 x P-diffusion and N-ohmic must be over N-well or deep N-well
         at (-0.33, 15.065)..(-0.31, 15.295)  drawn by sub.py:22 [pplus]; sub.py:63 [contact,diff,m1,pplus]
         at (7.66, 15.065)..(7.69, 15.295)  drawn by sub.py:22 [pplus]; sub.py:63 [contact,diff,m1,pplus]
    11 x Diffusion contact spacing < 0.24um (CO.2a - 2 * CO.6)
         at (25.525, 15.065)..(25.765, 15.295)  drawn by sub.py:63 [contact,diff,m1,pplus]
         at (25.535, 15.065)..(25.765, 15.295)  drawn by sub.py:63 [contact,diff,m1,pplus]
     7 x Diffusion spacing < 0.28um (DF.3a)
         at (-0.33, 15.065)..(-0.25, 15.295)  drawn by sub.py:22 [pplus,sab]; sub.py:63 [contact,diff,m1,pplus]
         at (7.66, 15.065)..(7.75, 15.295)  drawn by sub.py:22 [pplus,sab]; sub.py:63 [contact,diff,m1,pplus]
     6 x rpp spacing to Cont < 0.215um (PRES.7 - CO.6)
         at (47.34, 0.85)..(47.785, 1)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
         at (50, 0.85)..(50.445, 1)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
     4 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7)
         at (47.56, 0.625)..(47.78, 0.845)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
         at (50.22, 0.625)..(50.44, 0.845)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
     2 x ppolyres minimum width < 0.8um (PRES.1)
         at (47.555, 0.15)..(47.785, 0.8)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
         at (50.215, 0.15)..(50.445, 0.8)  drawn by sub.py:22 [contact,m1,poly,pplus,res_mk,sab]; sub.py:58 [m1]; sub.py:76 [m1]
DRC (KLayout, gf180mcu.drc): 172 violation(s), 7 rule(s)
    64 x PP.10: PP.10 : Overlap of unsalicided COMP. : 0.18µm
         at (1.28, 15.341)..(
...
                                        |
    Net: B0                                    |Net: B0
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B1                                    |Net: B1
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B2                                    |Net: B2
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B3                                    |Net: B3
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B4                                    |Net: B4
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B5                                    |Net: B5
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: w_4738_2938#                          |Net: B6
      ppolyf_u/3 = 2                           |  ppolyf_u/(1|2) = 1
                                               |
    Net: B7                                    |Net: B7
      ppolyf_u/(1|2) = 2                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: VSS                                   |Net: VSS
      ppolyf_u/(1|2) = 11                      |  ppolyf_u/(1|2) = 1
      ppolyf_u/3 = 8                           |  ppolyf_u/3 = 16
                                               |
    Net: w_6338_2938#                          |(no matching net)
      ppolyf_u/3 = 2                           |
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a2/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a2/r2r8.extracted.spice
result: VIOLATIONS   (7.1 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a2/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/r2r8.gf180mcuD/a2/r2r8.png