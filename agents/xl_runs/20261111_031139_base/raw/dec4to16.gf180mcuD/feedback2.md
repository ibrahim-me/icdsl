Judge:
  FAIL DRC      3269 violation(s): 1148 x N-Diffusion overlap of contact < 0.065um (CO.4); 1124 x P-Diffusion overlap of contact < 0.065um (CO.4); 997 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)
  FAIL DRC2     foundry KLayout deck: 1833 violation(s): 1184 x CO.1: CO.1 : Min/max contact size. : 0.22µm; 229 x MSLOT1.1: MSLOT1.1 : Maximum metal width without slotting: 30µm; 168 x CO.10: CO.10 : Contact on Poly2 gate over COMP is forbidden; 72 x V1.1: V1.1 : Min/max via1 size . : 0.26µm; 72 x DF.2b: DF.2b : Max. COMP width for all cases except those used for capacitors,
           ; 36 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwe
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 28/168; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.gf180mcuD/a2/judge/dec4to16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     52400.00 x 22965.00 = 1203366000.0 um2, budget 1398, reference 698.53

Tool report:
magic DRC: 3269 violation(s)
  1148 x N-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (2689.930 1239.995 2689.995 1366.800)  (2689.930 1239.930 2689.995 1239.995)  (2689.930 1239.930 2814.000 1239.995)
  1124 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (2689.930 4139.995 2689.995 4261.200)  (2689.930 4139.930 2689.995 4139.995)  (2689.930 4139.930 2814.000 4139.995)
   997 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)   e.g. at (2689.850 1460.005 2814.000 1460.150)  (2689.850 4360.005 2814.000 4360.150)  (2689.850 7060.005 2814.000 7060.150)
KLayout deck DRC: 1833 violation(s)
  1184 x CO.1: CO.1 : Min/max contact size. : 0.22µm   e.g. at (50060.000 18040.000 50060.000 18260.000)  (49840.000 18040.000 50060.000 18040.000)  (49840.000 18260.000 50060.000 18260.000)
   229 x MSLOT1.1: MSLOT1.1 : Maximum metal width without slotting: 30µm   e.g. at (0.000 435.000 50400.000 10765.000)  (0.000 11635.000 50400.000 16365.000)  (0.000 17235.000 50400.000 21965.000)
   168 x CO.10: CO.10 : Contact on Poly2 gate over COMP is forbidden   e.g. at (25390.000 12440.000 25610.000 12660.000)  (25990.000 12440.000 26210.000 12660.000)  (30690.000 12440.000 30910.000 12660.000)
    72 x V1.1: V1.1 : Min/max via1 size . : 0.26µm   e.g. at (2670.000 7070.000 2670.000 7330.000)  (2670.000 7330.000 2930.000 7330.000)  (2930.000 7070.000 2930.000 7330.000)
    72 x DF.2b: DF.2b : Max. COMP width for all cases except those used for capacitors,
                  marked by 'MOS_CAP_MK' layer: 100um   e.g. at (220.000 1170.000 5380.000 1530.000)  (5820.000 1170.000 10980.000 1530.000)  (11420.000 1170.000 16580.000 1530.000)
    36 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwell): 20um   e.g. at (220.000 3890.000 5380.000 4610.000)  (5820.000 3890.000 10980.000 4610.000)  (11420.000 3890.000 16580.000 4610.000)
    36 x DF.14_LV: DF.14_LV : Max distance of substrate tap (PCOMP outside Nwell) from (NCOMP outside Nwell): 20um   e.g. at (220.000 1170.000 5380.000 1530.000)  (5820.000 1170.000 10980.000 1530.000)  (11420.000 1170.000 16580.000 1530.000)
    20 x MSLOT2.1: MSLOT2.1 : Maximum metal width without slotting: 30µm   e.g. at (0.000 7060.000 2669.800 7340.000)  (2930.200 7060.000 8269.800 7340.000)  (8530.200 7060.000 13869.800 7340.000)
    16 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm   e.g. at (5940.000 4140.000 6010.000 4360.000)  (11540.000 4140.000 11610.000 4360.000)  (17140.000 4140.000 17210.000 4360.000)
LVS: Top level cell failed pin matching.   devices layout/ref [28, 168]  nets layout/ref [85, 90]
  nfet_03v3 (84->4)                          |nfet_03v3 (84) **Mismatch**
  pfet_03v3 (84->24)                         |pfet_03v3 (84) **Mismatch**
  Number of devices: 28 **Mismatch**         |Number of devices: 168 **Mismatch**
  Number of nets: 85 **Mismatch**            |Number of nets: 90 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dec4to16                        |Circuit 2: dec4to16
  ---------------------------------------------------------------------------------------
  Net: a_2717999_3607999#                    |Net: Y0
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_2648000_3594000#                    |Net: Y1
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_6764000_3594000#                    |Net: Y2
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_1648000_1354000#                    |Net: Y3
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_5644000_2474000#                    |Net: Y4
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_2712000_3550000#                    |Net: Y5
    nfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_7252000_3550000#                    |Net: Y6
    nfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_1712000_1310000#                    |Net: Y7
    nfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |