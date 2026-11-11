Judge:
  FAIL DRC      magic DRC did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)
  FAIL DRC2     foundry KLayout deck: 515 violation(s): 256 x V4.1: V4.1 : Min/max via4 size . : 0.26µm; 72 x MIMTM.3: MIMTM.3 : Minimum MiM bottom plate overlap of Top plate.; 64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.; 64 x MIMTM.8b: MIMTM.8b : Maximum single MIM Cap area (Use multiple MIM caps in
               ; 57 x MSLOT4.1: MSLOT4.1 : Maximum metal width without slotting: 30µm; 1 x MIMTM.11: MIMTM.11 : Bottom plate of multiple MIM caps can be shared (for common nodes)
  
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     121000.00 x 62360.00 = 7545560000.0 um2, budget 10578, reference 5288.9

Tool report:
DRC2 (foundry KLayout deck): 515 violation(s), boxes in um
   256 x V4.1: V4.1 : Min/max via4 size . : 0.26µm   e.g. at (52630.000 31370.000 52630.000 31630.000)  (52370.000 31370.000 52630.000 31370.000)  (52370.000 31630.000 52630.000 31630.000)
    72 x MIMTM.3: MIMTM.3 : Minimum MiM bottom plate overlap of Top plate.   e.g. at (52359.399 399.999 52640.601 400.001)  (38359.399 399.999 38640.601 400.001)  (31359.399 399.999 31640.601 400.001)
    64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.   e.g. at (400.000 400.000 6600.000 6600.000)  (7400.000 400.000 13600.000 6600.000)  (14400.000 400.000 20600.000 6600.000)
    64 x MIMTM.8b: MIMTM.8b : Maximum single MIM Cap area (Use multiple MIM caps in
                       parallel connection if bigger capacitors are require   e.g. at (400.000 400.000 6600.000 6600.000)  (7400.000 400.000 13600.000 6600.000)  (14400.000 400.000 20600.000 6600.000)
    57 x MSLOT4.1: MSLOT4.1 : Maximum metal width without slotting: 30µm   e.g. at (3360.000 6605.000 3640.000 7395.000)  (10360.000 6605.000 10640.000 7395.000)  (17360.000 6605.000 17640.000 7395.000)
     1 x MIMTM.11: MIMTM.11 : Bottom plate of multiple MIM caps can be shared (for common nodes)
                     as long as total MIM area with that singl   e.g. at (400.000 400.000 119000.000 59140.000)
     1 x MSLOT5.1: MSLOT5.1 : Maximum metal width without slotting: 30µm   e.g. at (-2000.000 -3220.000 58000.000 56000.000)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?