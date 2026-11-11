Judge:
  FAIL DRC      189 violation(s): 105 x poly overlap of poly contact < 0.05um (licon.8); 43 x poly spacing to diffusion tap < 0.055um (poly.5); 22 x P-tap overlap of P-tap contact < 0.12um in one direction (licon.7); 11 x Poly resistor spacing to diffusion < 0.48um (poly.9); 2 x Poly resistor spacing to poly < 0.48um (poly.9); 2 x poly spacing < 0.21um (poly.2)
  FAIL DRC2     foundry KLayout deck: 415 violation(s): 114 x licon.1: licon.1: min/max. licon length : 0.17um; 102 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um; 94 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap); 68 x licon.13_a: licon.13_a:  licon on diff in periphery can't overlap npc; 27 x licon.1_c: licon.1_c : licon should be rectangle; 10 x licon.13: licon.13:  min. licon on diff spacing to npc in periphery : 0.09um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/r2r8.sky130A/a4/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     71.75 x 15.25 = 1094.2 um2, budget 1630, reference 814.74

Tool report:
r2r8 on sky130A: 71.75 x 15.25 um (1094.19 um2), 3638 shapes, 25 declared devices
connectivity pre-check: 1 short(s), 0 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = B6 = B7 = OUT = VSS = n0 = n1 = n2 = n3 = n4 = n5 = n6 = t = x0 = x1 = x2 = x3 = x4 = x5 = x6 = x7
      m1 (8.000, 2.000) [sub.py:14]
      m1 (8.000, 2.575) [sub.py:19]
      m1 (12.467, 3.000) [sub.py:19]
      m1 (15.000, 2.575) [sub.py:19]
      m1 (15.000, 2.000) [sub.py:14]
DRC (magic drc(full) sky130A): 189 violation(s), 10 rule(s)
   105 x poly overlap of poly contact < 0.05um (licon.8)
         at (14.45, 11.25)..(15.395, 11.3)  drawn by sub.py:17 [li,m1]; sub.py:19 [m1]; sub.py:35 [npc,poly]; sub.py:70 [li,licon,psdm,tap]
         at (21.585, 11.25)..(22.535, 11.3)  drawn by sub.py:17 [li,m1]; sub.py:19 [m1]; sub.py:35 [npc,poly]; sub.py:70 [li,licon,psdm,tap]
    43 x poly spacing to diffusion tap < 0.055um (poly.5)
         at (15.345, 10.565)..(15.555, 10.62)  drawn by sub.py:35 [poly,polyres]; sub.py:70 [li,licon,psdm,tap]
         at (21.445, 10.565)..(21.635, 10.62)  drawn by sub.py:35 [poly,polyres]; sub.py:70 [li,licon,psdm,tap]
    22 x P-tap overlap of P-tap contact < 0.12um in one direction (licon.7)
         at (14.5, 10.565)..(14.62, 10.685)  drawn by sub.py:35 [poly,polyres]; sub.py:70 [li,licon,psdm,tap]
         at (22.38, 10.565)..(22.485, 10.685)  drawn by sub.py:35 [poly,polyres]; sub.py:70 [li,licon,psdm,tap]
    11 x Poly resistor spacing to diffusion < 0.48um (poly.9)
         at (14.02, 10.565)..(14.5, 11.045)  drawn by sub.py:19 [m1]; sub.py:35 [li,npc,poly,polyres]; sub.py:70 [li,licon,psdm,tap]
         at (28.02, 10.565)..(28.5, 11.045)  drawn by sub.py:19 [m1]; sub.py:35 [li,npc,poly,polyres]; sub.py:70 [li,licon,psdm,tap]
     2 x Poly resistor spacing to poly < 0.48um (poly.9)
         at (65.565, 8.995)..(65.735, 9)  drawn by sub.py:25 [li,npc,poly]; sub.py:70 [li,licon,psdm,tap]
         at (65.565, 8)..(65.735, 8.075)  drawn by sub.py:25 [li,licon,npc,poly]; sub.py:70 [li,licon,psdm,tap]
     2 x poly spacing < 0.21um (poly.2)
         at (65.565, 8.995)..(65.71, 9)  drawn by sub.py:25 [li,npc,poly]; sub.py:70 [li,licon,psdm,tap]
         at (65.565, 8)..(65.71, 8.075)  drawn by sub.py:25 [li,licon,npc,poly]; sub.py:70 [li,licon,psdm,tap]
     1 x Diffusion contact spacing < 0.17um (licon.2)
         at (65.565, 9)..(65.735, 9.165)  drawn by sub.py:25 [li,npc,poly]; sub.py:70 [li,licon,psdm,tap]
     1 x poly contact spacing to diffusion < 0.19um (licon.14)
         at (65.5, 8.075)..(65.565, 8.19)  drawn by sub.py:25 [li,licon,npc,poly,polyres]; sub.py:70 [li,licon,psdm,tap]
     1 x poly contact spacing to P-diffusion < 0.235um (licon.9 + psdm.5a)
         at (65.5, 8.075)..(65.565, 8.235)  drawn by sub.py:25 [li,licon,npc,poly,polyres]; sub.py:70 [li,licon,psdm,tap]
     1 x P-tap contact width     < 0.17um (licon.1)
         at (65.565, 8.995)..(65.735, 9)  drawn by sub.py:25 [li,npc,poly]; sub.py:70 [li,licon,psdm,tap]
DRC (KLayout, sky130A_mr.drc): 415 violation(s), 6 rule(s)
   114 x licon.1: licon.1: min/max. licon length : 0.17um
         at (65.905, 3.385)..(66, 3.385)  drawn by sub.py:58 [li,licon,npc,poly,polyres]; sub.py:70 [li,licon,psdm,tap]
         at (66.075, 3.215)..(66.075, 3.255)  drawn by sub.py:58 [li,licon,npc,poly]; sub.py:70 [li,licon,psdm,tap]
   102 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um
         at (66.17, 3.402)..(66.245, 3.578)  drawn by sub.py:58 [li,licon,npc,poly]; sub.py:70 [li,licon,psdm,tap]
         at (66.17, 3.062)..(66.245, 3.238)  drawn by sub.py:17 [li,m1,mcon]; sub.py:58 [li,licon,npc,poly]; sub.py:70 [li,licon,psdm,tap]
    94 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)
         at (63.5, 11.245)..(63.625, 11.25)  drawn by sub.py:19 [m1]; sub.py:52 [npc,poly]; sub.py:70 [li,licon,psdm,tap]
         at (56.995, 11.245)..(57.165, 11.25)  drawn by sub.py:17 [li,m1]; sub.py:19 [m1]; sub.py:35 [npc,poly]; sub.py:70 [li,licon,psdm,tap]
    68 x licon.13_a: licon.13_a:  licon on diff in periphery can't overlap npc
         at (63.795, 11.245)..(63.965, 11.27)  drawn by sub.py:17 [li,m1]; sub.py:19 [m1]; sub.py:52 [npc,poly]; sub.py:70 [li,licon,psdm,tap]
         at (56.995, 11.245)..(57.165, 11.27)  drawn by sub.py:17 [li,m1]; sub.py:19 [m1]; sub.py:35 [npc,poly]; sub.py:70 [li,licon,psdm,tap]
    27 x licon.1_c: licon.1_c : licon should be rectangle
         at (65.905, 2.535)..(66.17, 2.745)  drawn by su
...
(no matching net)                          |Net: B1
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: B2
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: B3
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: B4
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: B5
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: B6
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: B7
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    (no matching net)                          |Net: n0
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 3
                                               |
    (no matching net)                          |Net: n1
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 3
                                               |
    (no matching net)                          |Net: n2
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/r2r8.sky130A/a4/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/r2r8.sky130A/a4/r2r8.extracted.spice
result: VIOLATIONS   (5.8 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/r2r8.sky130A/a4/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/r2r8.sky130A/a4/r2r8.png