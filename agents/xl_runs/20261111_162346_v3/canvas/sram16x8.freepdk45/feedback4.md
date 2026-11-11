Judge:
  FAIL DRC      2812 violation(s): 1400 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4); 896 x Via1 spacing < 75nm (VIA1.2); 512 x Via2 spacing < 85nm (VIA2.2); 4 x Metal2 width < 70nm (METALINT.1)
  FAIL DRC2     foundry KLayout deck: 501 violation(s): 256 x VIA2.2: VIA2.2 : Minimum spacing of via2 : 85nm; 120 x WELL.1: WELL.1 : nwell/pwell must not overlap; 120 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap; 3 x METAL2.1: METAL2.1 : Minimum width of  intermediate metal2 : 70nm; 2 x VIA1.2: VIA1.2 : Minimum spacing of via1 : 75nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 2/128; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/sram16x8.freepdk45/a4/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     13.20 x 30.24 = 399.2 um2, budget 592, reference 295.8

Tool report:
sram16x8 on freepdk45: 13.2 x 30.24 um (399.17 um2), 15907 shapes, 768 declared devices
connectivity pre-check: 17 short(s), 2 open net(s)
  SHORT BL0 = BL1 = BL2 = BL3 = BL4 = BL5 = BL6 = BL7 = BLB0 = BLB1 = BLB2 = BLB3 = BLB4 = BLB5 = BLB6 = BLB7 = WL0 = WL1 = WL10 = WL11 = WL12 = WL13 = WL14 = WL15 = WL2 = WL3 = WL4 = WL5 = WL6 = WL7 = WL8 = WL9
      m2 (0.700, 0.415) [sub.py:66]
      via2 (0.700, 0.415) [sub.py:66]
      m3 (0.700, 14.120) [sub.py:62]
      via3 (0.700, 0.695) [sub.py:38]
      m4 (5.600, 0.695) [sub.py:34]
      via3 (2.100, 0.695) [sub.py:38]
      m3 (2.100, 14.120) [sub.py:62]
      via2 (2.100, 0.415) [sub.py:66]
      m2 (2.100, 0.415) [sub.py:66]
  SHORT VDD = VSS
      m2 (5.600, 1.762) [sub.py:45]
      via2 (11.700, 1.760) [sub.py:55]
      m3 (11.700, 14.120) [sub.py:51]
      via2 (11.700, 0.000) [sub.py:55]
      m2 (5.600, -0.005) [sub.py:45]
  SHORT VDD = VSS
      m1 (0.700, 1.762) in XB0_0 [sub.py:8]
      m1 (0.700, 1.762) in XB1_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 3.527) in XB1_0 [sub.py:8]
      m1 (0.700, 3.527) in XB2_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 5.293) in XB2_0 [sub.py:8]
      m1 (0.700, 5.293) in XB3_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 7.058) in XB3_0 [sub.py:8]
      m1 (0.700, 7.058) in XB4_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 8.822) in XB4_0 [sub.py:8]
      m1 (0.700, 8.822) in XB5_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 10.588) in XB5_0 [sub.py:8]
      m1 (0.700, 10.588) in XB6_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 12.352) in XB6_0 [sub.py:8]
      m1 (0.700, 12.352) in XB7_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 14.117) in XB7_0 [sub.py:8]
      m1 (0.700, 14.117) in XB8_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 15.883) in XB8_0 [sub.py:8]
      m1 (0.700, 15.883) in XB9_0 [sub.py:8]
  SHORT VDD = VSS
      m1 (0.700, 17.648) in XB9_0 [sub.py:8]
      m1 (0.700, 17.648) in XB10_0 [sub.py:8]
  OPEN  net VDD is in 17 unconnected pieces:
      m1 (0.700, 1.762) in XB0_0 [sub.py:8] (192 shapes)
      m1 (0.700, 3.527) in XB1_0 [sub.py:8] (192 shapes)
      m1 (0.700, 5.293) in XB2_0 [sub.py:8] (192 shapes)
      m1 (0.700, 7.058) in XB3_0 [sub.py:8] (192 shapes)
      m1 (0.700, 8.822) in XB4_0 [sub.py:8] (192 shapes)
  OPEN  net VSS is in 17 unconnected pieces:
      m1 (0.700, 1.762) in XB1_0 [sub.py:8] (192 shapes)
      m1 (0.700, 3.527) in XB2_0 [sub.py:8] (192 shapes)
      m1 (0.700, 5.293) in XB3_0 [sub.py:8] (192 shapes)
      m1 (0.700, 7.058) in XB4_0 [sub.py:8] (192 shapes)
      m1 (0.700, 8.822) in XB5_0 [sub.py:8] (192 shapes)
DRC (magic drc(full) freepdk45): 2812 violation(s), 4 rule(s)
  1400 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4)
         at (0.1, 10.43)..(0.255, 10.435)  drawn by sub.py:8 [diff,nwell,poly,pplus]
         at (0.255, 10.43)..(0.305, 10.435)  drawn by sub.py:8 [diff,nwell,poly,pplus]
   896 x Via1 spacing < 75nm (VIA1.2)
         at (0.525, 11.875)..(0.53, 11.88)  drawn by sub.py:8 [contact,m1,m2,poly,pwell,via1]
         at (0.525, 11.81)..(0.53, 11.875)  drawn by sub.py:8 [contact,m1,m2,poly,pwell,via1]
   512 x Via2 spacing < 85nm (VIA2.2)
         at (0.665, 11.25)..(0.735, 11.265)  drawn by sub.py:34 [m4]; sub.py:38 [m2,m3,m4,via2,via3]; sub.py:62 [m3]; sub.py:8 [m2,pwell]
         at (2.065, 11.25)..(2.135, 11.265)  drawn by sub.py:34 [m4]; sub.py:38 [m2,m3,m4,via2,via3]; sub.py:62 [m3]; sub.py:8 [m2,pwell]
     4 x Metal2 width < 70nm (METALINT.1)
         at (-1, 1.795)..(-0.535, 1.8)  drawn by sub.py:45 [m2]; sub.py:51 [m3]; sub.py:55 [m2,m3,via2]
         at (-0.465, 1.795)..(11.665, 1.8)  drawn by sub.py:45 [m2]; sub.py:51 [m3]; sub.py:55 [m2,m3,via2]; sub.py:62 [m3]; sub.py:8 [contact,diff,m1,nplus,nwell,pplus,pwell]
DRC (KLayout, drc_freepdk45.lydrc): 501 violation(s), 5 rule(s)
   256 x VIA2.2: VIA2.2 : Minimum spacing of via2 : 85nm
         at (6.265, 25.16)..(6.335, 25.23)  drawn by sub.py:62 [m3]; sub.py:66 [m2,m3,via2]; sub.py:8 [m2,pwell]
         at (6.265, 21.63)..(6.335, 21.7)  drawn by sub.py:62 [m3]; sub.py:66 [m2,m3,via2]; sub.py:8 [m2,pwell]
   120 x WELL.1: WELL.1 : nwell/pwell must not overlap
         at (5.545, 24.605)..(7.055, 24.81)  drawn by sub.py:45 [m2]; sub.py:62 [m3]; sub.py:8 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]
         at (5.545, 5.19)..(7.055, 5.395)  drawn by sub.py:45 [m2]; sub.py:62 [m3]; sub.py:8 [contact,diff,m1,nplus,nwell,poly,pplus,pwell]
   120 x IMPLANT.5: IMPLANT.5 : Nimpla
...
--------------------------------------------------------------------
    Cell pin lists are equivalent.
    Device classes sram6t and sram6t are equivalent.
    Cell sram16x8 (0) disconnected node: VSS
    Class sram16x8 (0):  Merged 126 parallel devices.
    Cell sram16x8 (0) disconnected node: VSS
    Subcircuit summary:
    Circuit 1: sram16x8                        |Circuit 2: sram16x8
    -------------------------------------------|-------------------------------------------
    sram6t (128->2)                            |sram6t (128) **Mismatch**
    Number of devices: 2 **Mismatch**          |Number of devices: 128 **Mismatch**
    Number of nets: 3 **Mismatch**             |Number of nets: 34 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: sram16x8                        |Circuit 2: sram16x8
    ---------------------------------------------------------------------------------------
    Net: sram6t_9/VSS                          |Net: VSS
      sram6t/VSS = 2                           |  sram6t/VSS = 128
      sram6t/VDD = 1                           |
                                               |
    Net: WL9                                   |Net: WL9
      sram6t/WL = 2                            |  sram6t/WL = 8
      sram6t/BLB = 2                           |
      sram6t/BL = 2                            |
                                               |
    Net: sram6t_85/VDD                         |Net: BL0
      sram6t/VDD = 1                           |  sram6t/BL = 16
                                               |
    (no matching net)                          |Net: BL1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/sram16x8.freepdk45/a4/sram16x8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/sram16x8.freepdk45/a4/sram16x8.extracted.spice
result: VIOLATIONS   (6.9 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/sram16x8.freepdk45/a4/sram16x8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/sram16x8.freepdk45/a4/sram16x8.png