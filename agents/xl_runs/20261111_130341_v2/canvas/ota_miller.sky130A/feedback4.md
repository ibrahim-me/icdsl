Judge:
  FAIL DRC      368 violation(s): 183 x Diffusion contact to gate < 0.055um (licon.11); 96 x Local interconnect spacing < 0.17um (li.3); 14 x N-tap overlap of N-tap contact < 0.12um in one direction (licon.7); 12 x Varactor N-well must not contain P+ diffusion (varac.7); 10 x poly resistor spacing to N-tap < 0.48um (poly.9); 10 x P-tap spacing to N-well < 0.13um (diff/tap.11)
  FAIL DRC2     foundry KLayout deck: 376 violation(s): 196 x licon.1: licon.1: min/max. licon length : 0.17um; 49 x licon.1_c: licon.1_c : licon should be rectangle; 49 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um; 30 x licon.13_a: licon.13_a:  licon on diff in periphery can't overlap npc; 30 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap); 16 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 12/10; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/ota_miller.sky130A/a4/judge/ota_miller.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     45.34 x 28.41 = 1287.7 um2, budget 2648, reference 1323.89

Tool report:
ota_miller on sky130A: 45.335 x 28.405 um (1287.74 um2), 2103 shapes, 32 declared devices
connectivity pre-check: 2 short(s), 6 open net(s)
  SHORT IB = OUT = VDD = VSS = d1 = d2 = tail
      poly (0.765, 1.000) [sub.py:16]
      licon (0.765, 1.000) [sub.py:77]
      li (12.745, 1.000) [sub.py:93]
      li (16.405, 1.000) [sub.py:24]
  SHORT OUT = d1 = d2 = x
      m2 (33.880, 12.465) [sub.py:110]
      m2 (21.038, 8.000) [sub.py:110]
      m2 (8.125, 4.465) [sub.py:120]
      m2 (6.045, 6.500) [sub.py:95]
      m2 (10.685, 4.285) [sub.py:95]
  OPEN  net OUT is in 7 unconnected pieces:
      li (16.405, 1.000) [sub.py:24] (811 shapes)
      m2 (33.880, 12.465) [sub.py:110] (24 shapes)
      li (8.125, 8.000) [sub.py:37] (13 shapes)
      li (9.685, 8.000) [sub.py:37] (13 shapes)
      li (11.245, 8.000) [sub.py:37] (13 shapes)
  OPEN  net d1 is in 5 unconnected pieces:
      li (10.685, 2.000) [sub.py:20] (811 shapes)
      m2 (10.685, 4.285) [sub.py:95] (24 shapes)
      poly (0.765, 8.000) [sub.py:33] (13 shapes)
      poly (4.375, 8.000) [sub.py:35] (13 shapes)
      li (1.405, 8.000) [sub.py:33] (13 shapes)
  OPEN  net d2 is in 4 unconnected pieces:
      li (13.295, 2.000) [sub.py:22] (811 shapes)
      poly (7.735, 8.000) [sub.py:37] (49 shapes)
      m2 (13.295, 4.285) [sub.py:98] (24 shapes)
      li (5.015, 8.000) [sub.py:35] (13 shapes)
  OPEN  net x is in 3 unconnected pieces:
      capm (33.880, 17.000) [sub.py:107] (1091 shapes)
      m2 (23.302, 7.500) [sub.py:109] (24 shapes)
      li (22.795, 7.500) [sub.py:106] (5 shapes)
  OPEN  net INN is in 2 unconnected pieces:
      poly (10.295, 2.000) [sub.py:20] (2 shapes)
      poly (11.075, 2.000) [sub.py:20] (1 shapes)
  OPEN  net INP is in 2 unconnected pieces:
      poly (12.905, 2.000) [sub.py:22] (2 shapes)
      poly (13.685, 2.000) [sub.py:22] (1 shapes)
DRC (magic drc(full) sky130A): 368 violation(s), 18 rule(s)
   183 x Diffusion contact to gate < 0.055um (licon.11)
         at (0.625, 8.085)..(0.85, 8.14)  drawn by sub.py:129 [nwell]; sub.py:33 [diff,nwell,poly,psdm]; sub.py:75 [m1]; sub.py:77 [li,licon,m1,mcon,npc,poly]
         at (1.905, 8.085)..(2.13, 8.14)  drawn by sub.py:129 [nwell]; sub.py:33 [diff,nwell,poly,psdm]; sub.py:75 [m1]; sub.py:77 [li,licon,m1,mcon,npc,poly]
    96 x Local interconnect spacing < 0.17um (li.3)
         at (7.4, 8.085)..(7.43, 8.255)  drawn by sub.py:129 [nwell]; sub.py:37 [diff,li,licon,nwell,psdm]; sub.py:58 [li]; sub.py:75 [m1]
         at (8.04, 8.085)..(8.07, 8.255)  drawn by sub.py:129 [nwell]; sub.py:37 [diff,li,licon,nwell,psdm]; sub.py:75 [m1]
    14 x N-tap overlap of N-tap contact < 0.12um in one direction (licon.7)
         at (14.555, 7.88)..(14.725, 8)  drawn by sub.py:106 [li,licon,npc,poly,polyres]; sub.py:108 [m2]; sub.py:110 [m2]; sub.py:129 [li,licon,nsdm,nwell,tap]
         at (14.555, 7)..(14.725, 7.12)  drawn by sub.py:106 [li,licon,npc,poly,polyres]; sub.py:129 [li,licon,nsdm,nwell,tap]
    12 x Varactor N-well must not contain P+ diffusion (varac.7)
         at (0, 6)..(2.81, 10)  drawn by sub.py:129 [nwell]; sub.py:33 [diff,li,licon,nwell,poly,psdm]; sub.py:58 [li]; sub.py:75 [m1]; sub.py:77 [li,licon,m1,mcon,npc,poly]; (+2 more lines)
         at (3.61, 6)..(6.42, 10)  drawn by sub.py:129 [nwell]; sub.py:35 [diff,li,licon,nwell,poly,psdm]; sub.py:58 [li]; sub.py:75 [m1]; sub.py:77 [li,licon,m1,mcon,npc,poly]; (+4 more lines)
    10 x poly resistor spacing to N-tap < 0.48um (poly.9)
         at (14.435, 8.425)..(14.845, 8.48)  drawn by sub.py:129 [li,licon,nsdm,nwell,tap]
         at (14.435, 8.255)..(14.555, 8.425)  drawn by sub.py:129 [li,licon,nsdm,nwell,tap]
    10 x P-tap spacing to N-well < 0.13um (diff/tap.11)
         at (14.895, 4.73)..(15.025, 4.81)  drawn by sub.py:128 [li,psdm,tap]; sub.py:129 [nsdm,nwell]
         at (14.895, 5.02)..(15.025, 5.14)  drawn by sub.py:128 [li,licon,psdm,tap]; sub.py:129 [nsdm,nwell]
    10 x Poly resistor spacing to diffusion < 0.48um (poly.9)
         at (14.435, 8.425)..(14.845, 8.48)  drawn by sub.py:129 [li,licon,nsdm,nwell,tap]
         at (14.435, 8.255)..(14.555, 8.425)  drawn by sub.py:129 [li,licon,nsdm,nwell,tap]
    10 x N-well overlap of N-tap < 0.18um (diff/tap.10)
         at (14.715, 5.27)..(14.845, 5.45)  drawn by sub.py:128 [psdm]; sub.py:129 [li,nsdm,nwell,tap]
         at (-0.94, 4.85)..(-0.415, 4.99)  drawn by sub.py:128 [li,licon,psdm,tap]; sub.py:129 [li,licon,nsdm,nwell,tap]
     5 x P-tap spacing to N-well < 0.005um (diff/
...
 |Net: INP
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |
    Net: a_53_1174#                            |Net: x
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |  sky130_fd_pr__cap_mim_m3_1/1 = 1
                                               |
    Net: a_3821_n26#                           |Net: IB
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__nfet_01v8/2 = 3
                                               |
    Net: a_1965_1174#                          |Net: d1
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__pfet_01v8/2 = 2
                                               |
    Net: a_1809_1174#                          |Net: d2
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |  sky130_fd_pr__res_generic_po/(1|2) = 1
                                               |
    Net: VSS                                   |Net: VSS
      sky130_fd_pr__nfet_01v8/(1|3) = 6        |  sky130_fd_pr__nfet_01v8/(1|3) = 3
      sky130_fd_pr__nfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/4 = 5
      sky130_fd_pr__pfet_01v8/4 = 6            |
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/ota_miller.sky130A/a4/ota_miller.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/ota_miller.sky130A/a4/ota_miller.extracted.spice
result: VIOLATIONS   (6.8 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/ota_miller.sky130A/a4/ota_miller.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/ota_miller.sky130A/a4/ota_miller.png