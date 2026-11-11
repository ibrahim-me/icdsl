Judge:
  FAIL DRC      16479 violation(s): 5280 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4); 2560 x Contact width < 65nm (CONTACT.1); 2229 x Metal1 width < 65nm (METAL1.1); 2112 x P-Diffusion overhang of pmos < 70nm (POLY.4); 1056 x Contact spacing < 75nm (CONTACT.2); 922 x Metal1 spacing < 65nm (METAL1.2)
  FAIL DRC2     foundry KLayout deck: 2646 violation(s): 1539 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm; 893 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm; 60 x METAL1.5: METAL1.5 : Minimum spacing of metal1 wider than 90 nm and longer than 300 nm : 9; 44 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm; 44 x ACTIVE.4: ACTIVE.4 : active must be inside nwell or pwell; 22 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 382/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/shreg16.freepdk45/a2/judge/shreg16.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     19.60 x 21.80 = 427.3 um2, budget 261, reference 130.23

Tool report:
DRC (magic drc(full)): 16479 violation(s), boxes in um
  5280 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4)   e.g. at (0.408 8.586 0.460 8.624)  (0.460 8.586 0.500 8.624)  (0.500 8.586 0.552 8.624)
  2560 x Contact width < 65nm (CONTACT.1)   e.g. at (0.434 8.534 0.454 8.586)  (0.552 8.534 0.578 8.586)  (0.914 8.534 0.934 8.586)
  2229 x Metal1 width < 65nm (METAL1.1)   e.g. at (0.984 9.334 0.988 9.336)  (0.984 9.336 0.988 9.600)  (0.570 9.304 0.870 9.308)
  2112 x P-Diffusion overhang of pmos < 70nm (POLY.4)   e.g. at (0.404 8.640 0.460 8.680)  (0.404 8.530 0.408 8.640)  (0.408 8.624 0.460 8.640)
  1056 x Contact spacing < 75nm (CONTACT.2)   e.g. at (0.454 8.534 0.494 8.586)  (0.526 8.534 0.552 8.586)  (0.934 8.534 0.974 8.586)
   922 x Metal1 spacing < 65nm (METAL1.2)   e.g. at (0.068 8.760 0.104 8.812)  (0.120 8.600 0.156 8.760)  (0.606 8.600 0.834 8.636)
   704 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (0.460 9.306 0.500 9.310)  (0.460 9.250 0.500 9.254)  (0.940 9.306 0.980 9.310)
   704 x N-Diffusion overhang of nmos < 70nm (POLY.4)   e.g. at (0.404 9.250 0.444 9.360)  (0.516 9.250 0.556 9.360)  (0.404 9.200 0.444 9.310)
   704 x Poly to diffusion spacing < 50nm (POLY.5)   e.g. at (0.460 8.640 0.500 8.680)  (0.940 8.640 0.980 8.680)  (1.420 8.640 1.460 8.680)
   176 x N-well width < 200nm (WELL.4)   e.g. at (0.364 8.624 0.596 8.656)  (0.844 8.624 1.076 8.656)  (1.324 8.624 1.556 8.656)
    32 x Metal1 > 270nm and runlength > 300nm spacing to unrelated m1 < 270nm (METAL1.6)   e.g. at (0.354 8.290 0.606 8.360)  (0.834 8.290 1.086 8.360)  (4.274 8.290 4.526 8.360)
DRC2 (foundry KLayout deck): 2646 violation(s), boxes in um
  1539 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm   e.g. at (9.500 4.470 9.830 4.530)  (0.070 9.770 0.130 11.400)  (9.500 9.670 9.830 9.730)
   893 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm   e.g. at (15.794 20.067 16.006 20.120)  (14.830 18.188 14.850 18.512)  (16.920 20.866 16.930 21.070)
    60 x METAL1.5: METAL1.5 : Minimum spacing of metal1 wider than 90 nm and longer than 300 nm : 90nm   e.g. at (17.452 14.868 17.858 14.870)  (7.052 9.668 7.548 9.669)  (2.752 9.668 3.158 9.669)
    44 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm   e.g. at (1.110 4.100 1.175 4.300)  (1.225 4.100 1.290 4.300)  (2.955 2.000 2.975 2.200)
    44 x ACTIVE.4: ACTIVE.4 : active must be inside nwell or pwell   e.g. at (2.310 5.380 2.490 5.400)  (1.710 5.380 1.890 5.400)  (0.510 5.380 0.690 5.400)
    22 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (0.522 0.968 0.677 0.968)  (1.123 0.968 1.278 0.968)  (1.722 0.968 1.877 0.968)
    22 x CONTACT.2: CONTACT.2 : Minimum spacing of contact : 75nm   e.g. at (3.033 5.268 3.058 5.332)  (2.942 4.168 2.967 4.232)  (3.033 4.168 3.058 4.232)
    22 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm   e.g. at (2.425 5.255 2.458 5.346)  (1.825 5.255 1.857 5.346)  (1.143 5.255 1.175 5.346)
LVS: Top level cell failed pin matching.   devices layout/ref 382/352, nets layout/ref 404/212
  pmos (22->21)                              |pmos (11) **Mismatch**
  nmos (22->11)                              |nmos (11)
  Number of devices: 32 **Mismatch**         |Number of devices: 22 **Mismatch**
  Number of nets: 39 **Mismatch**            |Number of nets: 17 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dff                             |Circuit 2: dff
  ---------------------------------------------------------------------------------------
  Net: a_230_2133#                           |Net: n1
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_230_1360#                           |Net: n2
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_1190_1360#                          |Net: n3
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_1430_1360#                          |Net: n4
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |
  Net: a_470_2133#                           |Net: D
    pmos/gate = 1                            |  nmos/gate = 1
                                             |  pmos/gate = 1
                                             |
  Net: a_710_2133#                           |Net: p1
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_470_1360#                           |Net: p2
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_710_1360#                           |Net: p3
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_950_2133#                           |Net: p4
    pmos/gate = 1                            |  pmos/(drain|source) = 2
                                             |
  Net: a_950_1360#                           |Net: VSS
    pmos/gate = 1                            |  nmos/(drain|source) = 7
                                             |  nmos/bulk = 11
                                             |