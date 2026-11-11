Judge:
  FAIL DRC      1580 violation(s): 1128 x P-Diffusion overlap of contact < 0.065um (CO.4); 452 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)
  FAIL DRC2     foundry KLayout deck: 2527 violation(s): 1632 x CO.1: CO.1 : Min/max contact size. : 0.22µm; 168 x CO.11: CO.11 : Contact on field oxide is forbidden; 139 x MSLOT1.1: MSLOT1.1 : Maximum metal width without slotting: 30µm; 128 x CO.10: CO.10 : Contact on Poly2 gate over COMP is forbidden; 128 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm; 120 x DF.2b: DF.2b : Max. COMP width for all cases except those used for capacitors,
           
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 89/168; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.gf180mcuD/a3/judge/dec4to16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     56000.00 x 24630.00 = 1379280000.0 um2, budget 1398, reference 698.53

Tool report:
magic DRC: 1580 violation(s)
  1128 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (6710.000 4589.930 6740.070 4589.995)  (6740.005 4589.995 6740.070 4743.600)  (6740.005 4589.930 6740.070 4589.995)
   452 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)   e.g. at (6740.005 4700.000 6740.150 4743.600)  (6740.005 4589.995 6740.150 4700.000)  (6710.000 4810.005 6740.005 4810.150)
KLayout deck DRC: 2527 violation(s)
  1632 x CO.1: CO.1 : Min/max contact size. : 0.22µm   e.g. at (26990.000 1770.000 27210.000 1770.000)  (26990.000 1990.000 27210.000 1990.000)  (26940.000 4050.000 27160.000 4050.000)
   168 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (26990.000 1770.000 27210.000 1990.000)  (26940.000 3830.000 27160.000 4050.000)  (26990.000 7770.000 27210.000 7990.000)
   139 x MSLOT1.1: MSLOT1.1 : Maximum metal width without slotting: 30µm   e.g. at (24250.000 9770.000 28320.000 10110.000)  (0.000 435.000 54000.000 11630.000)  (24250.000 13710.000 28270.000 14050.000)
   128 x CO.10: CO.10 : Contact on Poly2 gate over COMP is forbidden   e.g. at (18710.000 16590.000 18740.000 16810.000)  (18960.000 16590.000 18990.000 16810.000)  (19810.000 16590.000 19840.000 16810.000)
   128 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm   e.g. at (18520.000 16590.000 18710.000 16810.000)  (18990.000 16590.000 19180.000 16810.000)  (19620.000 16590.000 19810.000 16810.000)
   120 x DF.2b: DF.2b : Max. COMP width for all cases except those used for capacitors,
                  marked by 'MOS_CAP_MK' layer: 100um   e.g. at (24320.000 1120.000 29680.000 1480.000)  (26680.000 4340.000 27420.000 5060.000)  (24320.000 7120.000 29680.000 7480.000)
    84 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwell): 20um   e.g. at (320.000 4340.000 5680.000 5060.000)  (6480.000 4340.000 7220.000 5060.000)  (7580.000 4340.000 8320.000 5060.000)
    72 x V1.1: V1.1 : Min/max via1 size . : 0.26µm   e.g. at (2870.000 7670.000 2870.000 7930.000)  (2870.000 7930.000 3130.000 7930.000)  (3130.000 7670.000 3130.000 7930.000)
    36 x DF.14_LV: DF.14_LV : Max distance of substrate tap (PCOMP outside Nwell) from (NCOMP outside Nwell): 20um   e.g. at (320.000 1120.000 5680.000 1480.000)  (6320.000 1120.000 11680.000 1480.000)  (12320.000 1120.000 17680.000 1480.000)
    20 x MSLOT2.1: MSLOT2.1 : Maximum metal width without slotting: 30µm   e.g. at (0.000 7660.000 2869.800 7940.000)  (3130.200 7660.000 8869.800 7940.000)  (9130.200 7660.000 14869.800 7940.000)
LVS: Top level cell failed pin matching.   devices layout/ref [89, 168]  nets layout/ref [195, 90]
  nfet_03v3 (84->65)                         |nfet_03v3 (84) **Mismatch**
  pfet_03v3 (84->24)                         |pfet_03v3 (84) **Mismatch**
  Number of devices: 89 **Mismatch**         |Number of devices: 168 **Mismatch**
  Number of nets: 195 **Mismatch**           |Number of nets: 90 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dec4to16                        |Circuit 2: dec4to16
  ---------------------------------------------------------------------------------------
  Net: a_9028000_2624000#                    |Net: Y0
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_8464000_2624000#                    |Net: Y1
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_4864000_3824000#                    |Net: Y2
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_2464000_224000#                     |Net: Y3
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3664000_2624000#                    |Net: Y4
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_2464000_1424000#                    |Net: Y5
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3664000_3824000#                    |Net: Y6
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_2464000_2624000#                    |Net: Y7
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |