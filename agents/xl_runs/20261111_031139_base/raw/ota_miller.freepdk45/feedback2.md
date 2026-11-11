Judge:
  FAIL DRC      849 violation(s): 197 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4); 185 x N-Diffusion overhang of nmos < 70nm (POLY.4); 109 x Contact width < 65nm (CONTACT.1); 97 x Poly gate spacing < 140nm (POLY.2); 83 x P-Diffusion overhang of pmos < 70nm (POLY.4); 60 x Active spacing < 80nm (ACTIVE.2)
  FAIL DRC2     foundry KLayout deck: 394 violation(s): 100 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm; 86 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm; 78 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm; 30 x ACTIVE.3: ACTIVE.3 : Minimum enclosure/spacing of nwell/pwell to active: 55nm; 18 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm; 17 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 3/10; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.freepdk45/a2/judge/ota_miller.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     41.77 x 18.50 = 772.8 um2, budget 760, reference 379.92

Tool report:
magic DRC: 849 violation(s)
   197 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (0.700 5.035 0.765 5.040)  (1.095 7.020 1.100 7.055)  (1.510 5.035 1.575 5.040)
   185 x N-Diffusion overhang of nmos < 70nm (POLY.4)   e.g. at (0.530 7.070 1.170 7.125)  (0.530 7.070 0.600 7.125)  (1.105 7.070 1.745 7.125)
   109 x Contact width < 65nm (CONTACT.1)   e.g. at (1.100 7.070 1.165 7.085)  (1.675 7.070 1.740 7.085)  (1.910 4.970 1.915 5.035)
    97 x Poly gate spacing < 140nm (POLY.2)   e.g. at (1.175 5.035 1.240 7.020)  (1.175 4.970 1.240 5.035)  (1.175 2.945 1.240 4.970)
    83 x P-Diffusion overhang of pmos < 70nm (POLY.4)   e.g. at (30.380 10.875 30.450 10.930)  (30.380 10.875 31.520 10.930)  (31.450 10.875 31.520 10.930)
    60 x Active spacing < 80nm (ACTIVE.2)   e.g. at (1.700 5.170 1.745 5.180)  (1.700 5.100 1.710 5.170)  (1.710 5.100 1.745 5.170)
    48 x Nwell overlap of active < 55nm (ACTIVE.3/ACTIVE.4)   e.g. at (32.630 13.095 32.650 13.100)  (32.630 13.095 32.830 13.100)  (35.255 13.095 35.275 13.100)
    18 x Metal1 spacing < 65nm (METAL1.2)   e.g. at (11.890 6.090 11.940 6.185)  (11.890 5.990 11.940 6.020)  (13.825 6.120 13.885 6.185)
    18 x Metal1 width < 65nm (METAL1.1)   e.g. at (20.990 13.030 30.680 13.035)  (30.815 13.030 31.420 13.035)  (31.555 13.030 32.160 13.035)
    16 x Metal2 overlap of Via1 < 35um in one direction (METALINT.3)   e.g. at (1.950 4.970 1.955 5.005)  (1.950 4.930 1.955 4.965)  (1.885 5.035 1.920 5.040)
     6 x Via1 spacing < 75nm (VIA1.2)   e.g. at (21.000 4.970 21.035 5.005)  (21.000 4.965 21.035 4.970)  (20.925 5.005 20.960 5.035)
     4 x Metal1 overlap of Via1 < 35nm in one direction (METAL1.4)   e.g. at (1.950 4.930 1.955 4.965)  (1.885 4.895 1.920 4.900)  (21.100 4.930 21.105 4.965)
KLayout deck DRC: 394 violation(s)
   100 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (33.340 12.970 33.340 13.030)  (33.405 12.970 33.405 13.030)  (34.080 12.970 34.080 13.030)
    86 x CONTACT.6: CONTACT.6 : Minimum spacing of contact and poly : 35nm   e.g. at (27.815 6.987 27.825 7.088)  (26.740 6.987 26.750 7.088)  (25.665 6.987 25.675 7.088)
    78 x POLY.4: POLY.4 : Minimum enclosure of active around gate : 70nm   e.g. at (1.175 7.055 1.675 7.070)  (1.175 2.930 1.675 2.945)  (0.600 2.930 1.100 2.945)
    30 x ACTIVE.3: ACTIVE.3 : Minimum enclosure/spacing of nwell/pwell to active: 55nm   e.g. at (21.130 4.877 21.180 5.123)  (17.455 4.877 17.505 5.123)  (20.080 4.877 20.130 5.123)
    18 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm   e.g. at (20.860 13.035 20.960 13.035)  (20.860 12.965 20.960 12.965)  (1.850 4.930 1.850 5.005)
    17 x METAL1.1: METAL1.1 : Minimum width of metal1 : 65nm   e.g. at (20.990 12.970 30.680 13.030)  (30.815 12.970 31.420 13.030)  (31.555 12.970 32.160 13.030)
    14 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm   e.g. at (13.885 5.925 13.890 6.020)  (20.920 4.849 20.960 4.930)  (32.625 15.085 32.660 15.175)
    10 x ACTIVE.2: ACTIVE.2 : Minimum spacing of active : 80nm   e.g. at (8.145 4.828 8.180 5.172)  (1.745 4.828 1.780 5.172)  (17.220 4.828 17.255 5.172)
    10 x IMPLANT.5: IMPLANT.5 : Nimplant and pimplant must not overlap   e.g. at (40.260 12.830 40.365 13.170)  (29.935 4.830 30.040 5.170)  (32.560 12.830 32.665 13.170)
     8 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm   e.g. at (32.880 12.735 32.950 13.265)  (35.505 12.735 35.575 13.265)  (3.655 4.734 3.725 5.266)
     8 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm   e.g. at (32.880 12.662 32.950 13.338)  (2.030 4.662 2.100 5.338)  (8.430 4.662 8.500 5.338)
     8 x IMPLANT.4: IMPLANT.4 : Minimum spacing of nimplant/ pimplant  : 45nm   e.g. at (2.050 4.801 2.085 5.199)  (8.450 4.801 8.485 5.199)  (17.525 4.801 17.560 5.199)
LVS: Top level cell failed pin matching.   devices layout/ref [3, 10]  nets layout/ref [6, 10]
  pmos (12->2)                               |pmos (12->3) **Mismatch**
  nmos (27->1)                               |nmos (27->7) **Mismatch**
  Number of devices: 3 **Mismatch**          |Number of devices: 10 **Mismatch**
  Number of nets: 6 **Mismatch**             |Number of nets: 10 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: ota_miller                      |Circuit 2: ota_miller
  ---------------------------------------------------------------------------------------
  Net: a_7485_2189#                          |Net: INN
    pmos/gate = 1                            |  nmos/gate = 1
                                             |
  Net: a_8001_2594#                          |Net: INP
    pmos/(drain|source) = 1                  |  nmos/gate = 1
                                             |
  Net: a_7945_2189#                          |Net: IB
    pmos/gate = 1                            |  nmos/(drain|source) = 1
                                             |  nmos/gate = 3
                                             |
  Net: a_3593_994#                           |Net: d1
    nmos/(drain|source) = 1                  |  nmos/(drain|source) = 1
                                             |  pmos/(drain|source) = 1
                                             |  pmos/gate = 2
                                             |
  Net: a_3540_789#                           |Net: d2
    nmos/gate = 1                            |  nmos/(drain|source) = 2
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
  (no matching net)                          |Net: OUT
                                             |  nmos/(drain|source) = 1
                                             |  nmos/gate = 1
                                             |  pmos/(drain|source) = 1
                                             |