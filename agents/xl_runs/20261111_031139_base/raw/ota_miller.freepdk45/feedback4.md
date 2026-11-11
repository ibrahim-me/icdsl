Judge:
  FAIL DRC      234 violation(s): 63 x Contact width < 65nm (CONTACT.1); 56 x Active spacing < 80nm (ACTIVE.2); 30 x Contact spacing < 75nm (CONTACT.2); 20 x Metal2 overlap of Via1 < 35um in one direction (METALINT.3); 18 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4); 18 x N-Diffusion overhang of nmos < 70nm (POLY.4)
  FAIL DRC2     foundry KLayout deck: 259 violation(s): 98 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm; 59 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm; 17 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm; 16 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm; 10 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm; 10 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 3/10; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.freepdk45/a4/judge/ota_miller.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     47.17 x 18.50 = 872.6 um2, budget 760, reference 379.92

Tool report:
magic DRC: 234 violation(s)
    63 x Contact width < 65nm (CONTACT.1)   e.g. at (1.410 4.970 1.415 5.035)  (5.460 4.970 5.465 5.035)  (1.410 4.970 1.415 5.035)
    56 x Active spacing < 80nm (ACTIVE.2)   e.g. at (2.375 4.920 2.425 4.970)  (2.425 4.920 2.435 4.970)  (2.375 4.970 2.425 5.035)
    30 x Contact spacing < 75nm (CONTACT.2)   e.g. at (2.375 4.970 2.380 5.035)  (4.150 4.970 4.155 5.035)  (9.485 4.970 9.490 5.035)
    20 x Metal2 overlap of Via1 < 35um in one direction (METALINT.3)   e.g. at (2.205 4.970 2.210 5.005)  (2.240 5.035 2.275 5.040)  (2.240 4.895 2.275 4.900)
    18 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (1.945 4.970 1.950 5.035)  (2.425 4.970 2.430 5.035)  (3.720 4.970 3.725 5.035)
    18 x N-Diffusion overhang of nmos < 70nm (POLY.4)   e.g. at (2.375 4.850 2.425 4.970)  (2.375 4.970 2.425 5.035)  (2.375 5.035 2.425 5.150)
    17 x Metal1 width < 65nm (METAL1.1)   e.g. at (23.420 13.030 23.550 13.035)  (23.690 13.030 34.130 13.035)  (34.265 13.030 35.380 13.035)
     6 x P-Diffusion overhang of pmos < 70nm (POLY.4)   e.g. at (36.940 12.850 36.990 12.970)  (36.940 12.970 36.990 13.030)  (36.940 13.030 36.990 13.150)
     6 x N-well spacing < 135nm (WELL.3)   e.g. at (36.555 13.150 36.640 13.285)  (39.330 13.150 39.415 13.285)  (45.785 13.150 45.870 13.285)
KLayout deck DRC: 259 violation(s)
    98 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (46.105 12.970 46.105 13.030)  (46.040 12.970 46.040 13.030)  (45.810 12.970 45.810 13.030)
    59 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm   e.g. at (16.955 5.985 16.955 6.090)  (10.555 5.985 10.555 6.090)  (13.115 5.985 13.115 6.090)
    17 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm   e.g. at (2.240 4.930 2.240 5.005)  (2.310 4.930 2.310 5.005)  (4.020 4.930 4.020 5.005)
    16 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm   e.g. at (23.420 12.970 23.550 13.030)  (23.690 12.970 34.130 13.030)  (34.265 12.970 35.380 13.030)
    10 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm   e.g. at (36.640 12.725 36.690 13.275)  (39.415 12.725 39.465 13.275)  (45.870 12.725 45.920 13.275)
    10 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm   e.g. at (36.640 12.656 36.690 13.344)  (45.870 12.656 45.920 13.344)  (9.185 4.657 9.235 5.343)
    10 x IMPLANT.4: IMPLANT.4 : Minimum spacing of nimplant/ pimplant  : 45nm   e.g. at (9.200 4.822 9.235 5.178)  (19.655 4.822 19.690 5.178)  (22.430 4.822 22.465 5.178)
    10 x CONTACT.4: CONTACT.4 : Minimum enclosure of active around contact : 5nm   e.g. at (19.940 4.965 19.940 5.040)  (9.485 4.965 9.485 5.040)  (4.150 4.965 4.150 5.040)
     8 x ACTIVE.2: ACTIVE.2 : Minimum spacing of active : 80nm   e.g. at (4.130 4.843 4.150 5.157)  (2.355 4.843 2.375 5.157)  (19.920 4.843 19.940 5.157)
     8 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap   e.g. at (36.870 12.850 36.990 13.150)  (22.645 4.850 22.765 5.150)  (19.870 4.850 19.990 5.150)
     8 x CONTACT.2: CONTACT.2 : Minimum spacing of contact : 75nm   e.g. at (4.080 4.970 4.150 5.035)  (9.415 4.970 9.485 5.035)  (19.875 4.970 19.940 5.035)
     5 x METAL2.3: METAL2.3 : Minimum enclosure around via1 on two opposite sides : 35nm   e.g. at (2.240 4.930 2.310 5.005)  (19.810 4.930 19.880 5.005)  (4.020 4.930 4.090 5.005)
LVS: Top level cell failed pin matching.   devices layout/ref [3, 10]  nets layout/ref [5, 10]
  nmos (27->1)                               |nmos (27->7) **Mismatch**
  pmos (12->2)                               |pmos (12->3) **Mismatch**
  Number of devices: 3 **Mismatch**          |Number of devices: 10 **Mismatch**
  Number of nets: 5 **Mismatch**             |Number of nets: 10 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: ota_miller                      |Circuit 2: ota_miller
  ---------------------------------------------------------------------------------------
  Net: IB                                    |Net: IB
    nmos/(drain|source) = 2                  |  nmos/(drain|source) = 1
    nmos/bulk = 1                            |  nmos/gate = 3
    pmos/(drain|source) = 4                  |
    pmos/bulk = 1                            |
                                             |
  Net: a_1100_789#                           |Net: INP
    nmos/gate = 1                            |  nmos/gate = 1
                                             |
  Net: a_8269_2189#                          |Net: INN
    pmos/gate = 1                            |  nmos/gate = 1
                                             |
  Net: a_7103_2189#                          |Net: d1
    pmos/gate = 1                            |  nmos/(drain|source) = 1
                                             |  pmos/(drain|source) = 1
                                             |  pmos/gate = 2
                                             |
  Net: w_6822_2189#                          |Net: d2
    pmos/bulk = 1                            |  nmos/(drain|source) = 2
                                             |  pmos/(drain|source) = 1
                                             |  pmos/gate = 1
                                             |
  (no matching net)                          |Net: VSS
                                             |  nmos/(drain|source) = 3
                                             |  nmos/bulk = 7
                                             |
  (no matching net)                          |Net: tail
                                             |  nmos/(drain|source) = 3
                                             |
  (no matching net)                          |Net: x
                                             |  nmos/(drain|source) = 3
                                             |