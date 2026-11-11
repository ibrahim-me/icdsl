Judge:
  FAIL DRC      587 violation(s): 180 x N-Diffusion overhang of nmos < 70nm (POLY.4); 147 x Contact width < 65nm (CONTACT.1); 80 x P-Diffusion overhang of pmos < 70nm (POLY.4); 64 x Active spacing < 80nm (ACTIVE.2); 47 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4); 22 x Metal2 overlap of Via1 < 35um in one direction (METALINT.3)
  FAIL DRC2     foundry KLayout deck: 353 violation(s): 112 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm; 78 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm; 59 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm; 19 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm; 18 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm; 12 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 3/10; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.freepdk45/a3/judge/ota_miller.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     47.37 x 18.50 = 876.3 um2, budget 760, reference 379.92

Tool report:
magic DRC: 587 violation(s)
   180 x N-Diffusion overhang of nmos < 70nm (POLY.4)   e.g. at (0.610 7.070 1.250 7.125)  (0.610 2.875 0.680 2.930)  (0.610 7.070 0.680 7.125)
   147 x Contact width < 65nm (CONTACT.1)   e.g. at (1.180 7.070 1.245 7.085)  (1.420 4.970 1.425 5.035)  (1.960 7.070 2.025 7.085)
    80 x P-Diffusion overhang of pmos < 70nm (POLY.4)   e.g. at (34.315 10.875 34.385 10.930)  (34.315 10.875 35.455 10.930)  (35.385 10.875 35.455 10.930)
    64 x Active spacing < 80nm (ACTIVE.2)   e.g. at (2.395 4.920 2.445 4.970)  (2.445 4.920 2.455 4.970)  (2.395 4.970 2.400 5.035)
    47 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (1.175 7.020 1.180 7.055)  (1.955 7.020 1.960 7.055)  (2.445 4.970 2.450 5.035)
    22 x Metal2 overlap of Via1 < 35um in one direction (METALINT.3)   e.g. at (2.225 4.970 2.230 5.005)  (2.260 5.035 2.295 5.040)  (2.260 4.895 2.295 4.900)
    19 x Metal1 width < 65nm (METAL1.1)   e.g. at (23.530 13.030 23.650 13.035)  (23.790 13.030 34.280 13.035)  (34.410 13.030 35.530 13.035)
    11 x Metal1 spacing < 65nm (METAL1.2)   e.g. at (2.365 5.035 2.425 5.070)  (4.160 5.035 4.220 5.070)  (9.515 5.035 9.575 5.070)
     8 x Contact spacing < 75nm (CONTACT.2)   e.g. at (4.195 4.970 4.200 5.035)  (4.120 5.005 4.125 5.035)  (4.120 4.970 4.125 5.005)
     6 x N-well spacing < 135nm (WELL.3)   e.g. at (36.715 13.150 36.800 13.285)  (39.510 13.150 39.595 13.285)  (45.985 13.150 46.070 13.285)
     2 x Metal1 overlap of Via1 < 35nm in one direction (METAL1.4)   e.g. at (19.990 4.930 19.995 4.965)  (19.925 4.895 19.960 4.900)
     1 x Via1 width < 70nm (VIA1.1)   e.g. at (23.755 5.005 23.760 5.035)
KLayout deck DRC: 353 violation(s)
   112 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (46.300 12.970 46.300 13.030)  (46.235 12.970 46.235 13.030)  (46.005 12.970 46.005 13.030)
    78 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm   e.g. at (1.460 7.055 1.960 7.070)  (0.680 7.055 1.180 7.070)  (1.460 2.930 1.960 2.945)
    59 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm   e.g. at (14.465 5.985 14.465 6.090)  (13.185 5.985 13.185 6.090)  (7.830 5.985 7.830 6.090)
    19 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm   e.g. at (39.760 17.735 39.835 17.735)  (39.760 17.665 39.835 17.665)  (2.260 4.930 2.260 5.005)
    18 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm   e.g. at (23.530 12.970 23.650 13.030)  (23.790 12.970 34.280 13.030)  (34.410 12.970 35.530 13.030)
    12 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm   e.g. at (9.510 5.035 9.515 5.070)  (4.155 5.035 4.160 5.070)  (19.990 4.900 19.995 4.970)
    10 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm   e.g. at (36.800 12.725 36.850 13.275)  (39.595 12.725 39.645 13.275)  (46.070 12.725 46.120 13.275)
    10 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm   e.g. at (36.800 12.656 36.850 13.344)  (46.070 12.656 46.120 13.344)  (2.095 4.657 2.145 5.343)
    10 x IMPLANT.4: IMPLANT.4 : Minimum spacing of nimplant/ pimplant  : 45nm   e.g. at (3.905 4.822 3.940 5.178)  (9.260 4.822 9.295 5.178)  (19.735 4.822 19.770 5.178)
     8 x ACTIVE.2: ACTIVE.2 : Minimum spacing of active : 80nm   e.g. at (9.525 4.843 9.545 5.157)  (2.375 4.843 2.395 5.157)  (20.000 4.843 20.020 5.157)
     8 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap   e.g. at (37.030 12.850 37.150 13.150)  (23.760 4.850 23.880 5.150)  (22.745 4.850 22.865 5.150)
     6 x METAL2.3: METAL2.3 : Minimum enclosure around via1 on two opposite sides : 35nm   e.g. at (2.260 4.930 2.330 5.005)  (4.060 4.930 4.130 5.005)  (19.890 4.930 19.960 5.005)
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
  Net: a_4020_789#                           |Net: INP
    nmos/gate = 1                            |  nmos/gate = 1
                                             |
  Net: a_7692_2189#                          |Net: INN
    pmos/gate = 1                            |  nmos/gate = 1
                                             |
  Net: a_7133_2189#                          |Net: d1
    pmos/gate = 1                            |  nmos/(drain|source) = 1
                                             |  pmos/(drain|source) = 1
                                             |  pmos/gate = 2
                                             |
  Net: w_6850_2175#                          |Net: d2
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