Judge:
  FAIL DRC      2560 violation(s): 1536 x MiM cap spacing to unrelated metal3 < 1.34um (capm.11); 576 x Metal3 spacing < 0.3um (met3.2); 448 x Metal3 > 3um spacing to unrelated m3 < 0.4um (met3.3d)
  FAIL DRC2     foundry KLayout deck: 192 violation(s): 64 x capm.2b_a: capm.2b_a : min. spacing between met3_bot_plate and met3 : 1.2um; 64 x capm.11: capm.11 : Min spacing of capm and met3 not overlapping capm : 0.5um; 64 x m3.3cd: m3.3cd : min. 3um.m3 spacing m3 : 0.4um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     72.80 x 76.70 = 5583.8 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 72.8 x 76.7 um (5583.76 um2), 4779 shapes, 64 declared devices
connectivity pre-check: 8 short(s), 7 open net(s)
  SHORT B0 = B3 = B4 = B5
      m3 (53.130, 51.140) [sub.py:88]
      via2 (53.130, 51.140) [sub.py:88]
      m2 (51.600, 51.400) [sub.py:90]
      via2 (45.530, 51.140) [sub.py:88]
      m3 (45.530, 51.140) [sub.py:88]
  SHORT B1 = B3 = B4 = B5
      m3 (53.130, 35.940) [sub.py:88]
      via2 (53.130, 35.940) [sub.py:88]
      m2 (51.600, 36.200) [sub.py:90]
      via2 (45.530, 35.940) [sub.py:88]
      m3 (45.530, 35.940) [sub.py:88]
  SHORT B1 = B3 = B4 = B5
      m3 (53.130, 43.540) [sub.py:88]
      via2 (53.130, 43.540) [sub.py:88]
      m2 (51.600, 43.800) [sub.py:90]
      via2 (45.530, 43.540) [sub.py:88]
      m3 (45.530, 43.540) [sub.py:88]
  SHORT B2 = B3 = B4 = B5
      m3 (53.130, 5.540) [sub.py:88]
      via2 (53.130, 5.540) [sub.py:88]
      m2 (51.600, 5.800) [sub.py:90]
      via2 (45.530, 5.540) [sub.py:88]
      m3 (45.530, 5.540) [sub.py:88]
  SHORT B2 = B3 = B4 = B5
      m3 (53.130, 13.140) [sub.py:88]
      via2 (53.130, 13.140) [sub.py:88]
      m2 (51.600, 13.400) [sub.py:90]
      via2 (45.530, 13.140) [sub.py:88]
      m3 (45.530, 13.140) [sub.py:88]
  SHORT B2 = B3 = B4 = B5
      m3 (53.130, 20.740) [sub.py:88]
      via2 (53.130, 20.740) [sub.py:88]
      m2 (51.600, 21.000) [sub.py:90]
      via2 (45.530, 20.740) [sub.py:88]
      m3 (45.530, 20.740) [sub.py:88]
  SHORT B2 = B3 = B4 = B5
      m3 (53.130, 28.340) [sub.py:88]
      via2 (53.130, 28.340) [sub.py:88]
      m2 (51.600, 28.600) [sub.py:90]
      via2 (45.530, 28.340) [sub.py:88]
      m3 (45.530, 28.340) [sub.py:88]
  SHORT B3 = B4 = B5 = VSS
      m3 (45.530, 58.740) [sub.py:88]
      via2 (45.530, 58.740) [sub.py:88]
      m2 (44.000, 59.000) [sub.py:90]
      via2 (30.330, 58.740) [sub.py:88]
      m3 (30.330, 58.740) [sub.py:88]
  OPEN  net B5 is in 41 unconnected pieces:
      m3 (-0.070, 5.540) [sub.py:88] (32 shapes)
      m3 (-0.070, 13.140) [sub.py:88] (32 shapes)
      m3 (-0.070, 20.740) [sub.py:88] (32 shapes)
      m3 (-0.070, 28.340) [sub.py:88] (32 shapes)
      m3 (-0.070, 35.940) [sub.py:88] (32 shapes)
  OPEN  net B4 is in 25 unconnected pieces:
      m3 (30.330, 5.540) [sub.py:88] (32 shapes)
      m3 (30.330, 13.140) [sub.py:88] (32 shapes)
      m3 (30.330, 20.740) [sub.py:88] (32 shapes)
      m3 (30.330, 28.340) [sub.py:88] (32 shapes)
      m3 (30.330, 35.940) [sub.py:88] (32 shapes)
  OPEN  net B3 is in 17 unconnected pieces:
      m3 (45.530, 5.540) [sub.py:88] (32 shapes)
      m3 (45.530, 13.140) [sub.py:88] (32 shapes)
      m3 (45.530, 20.740) [sub.py:88] (32 shapes)
      m3 (45.530, 28.340) [sub.py:88] (32 shapes)
      m3 (45.530, 35.940) [sub.py:88] (32 shapes)
  OPEN  net B2 is in 9 unconnected pieces:
      m3 (53.130, 5.540) [sub.py:88] (32 shapes)
      m3 (53.130, 13.140) [sub.py:88] (32 shapes)
      m3 (53.130, 20.740) [sub.py:88] (32 shapes)
      m3 (53.130, 28.340) [sub.py:88] (32 shapes)
      m2 (63.300, 69.250) [sub.py:67] (7 shapes)
  OPEN  net B1 is in 5 unconnected pieces:
      m3 (53.130, 35.940) [sub.py:88] (32 shapes)
      m3 (53.130, 43.540) [sub.py:88] (32 shapes)
      m2 (63.300, 71.250) [sub.py:67] (7 shapes)
      m3 (55.700, 32.900) [sub.py:41] (1 shapes)
      m3 (55.700, 40.500) [sub.py:41] (1 shapes)
  OPEN  net B0 is in 3 unconnected pieces:
      m3 (53.130, 51.140) [sub.py:88] (32 shapes)
      m2 (63.300, 73.250) [sub.py:67] (7 shapes)
      m3 (55.700, 48.100) [sub.py:41] (1 shapes)
  OPEN  net VSS is in 3 unconnected pieces:
      m3 (53.130, 58.740) [sub.py:88] (32 shapes)
      m2 (63.300, 75.250) [sub.py:67] (7 shapes)
      m3 (55.700, 55.700) [sub.py:41] (1 shapes)
DRC (magic drc(full) sky130A): 2560 violation(s), 3 rule(s)
  1536 x MiM cap spacing to unrelated metal3 < 1.34um (capm.11)
         at (0, 57.96)..(1.435, 58.2)  drawn by sub.py:41 [capm,m3,m4]; sub.py:49 [m5]
         at (0, 57.64)..(0.24, 57.96)  drawn by sub.py:41 [capm,m3,m4]; sub.py:49 [m5]
   576 x Metal3 spacing < 0.3um (met3.2)
         at (-0.14, 58.075)..(0.395, 58.34)  drawn by sub.py:41 [capm,m3]; sub.py:49 [m5]
         at (0.095, 58.075)..(0.395, 58.34)  drawn by sub.py:41 [capm,m3]; sub.py:49 [m5]
   448 x Metal3 > 3um spacing to unrelated m3 < 0.4um (met3.3d)
         at (-0.235, 58.6)..(-0.21, 58.74)  drawn by sub.py:49 [m5]; sub.py:86 [m2]; sub.py:88 [m2,m3]
         at (-0.21, 58.6)..(0.07, 58.74)  drawn by sub.py:49 [m5]; sub.py:86 [m2]; s
...
                                          |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B3
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B2
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B1
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B0
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: VSS
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
    ---------------------------------------------------------------------------------------
    DEVICE mismatches: Class fragments follow (with node fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Instance: sky130_fd_pr__cap_mim_m3_1:0     |Instance: sky130_fd_pr__cap_mim_m3_1:C0
      1 = 1                                    |  1 = 7
      2 = 1                                    |  2 = 1
                                               |
    (no matching instance)                     |Instance: sky130_fd_pr__cap_mim_m3_1:C1
                                               |  1 = 7
                                               |  2 = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a4/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a4/cdac6.extracted.spice
result: VIOLATIONS   (6.4 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a4/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a4/cdac6.png