Judge:
  FAIL DRC      magic DRC did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)
  FAIL DRC2     foundry KLayout deck: 10602 violation(s): 10004 x via3.1_b: via3.1_b : maximum length of via3 : 0.2um; 256 x licon.1: licon.1: min/max. licon length : 0.17um; 104 x via.1a_b: via.1a_b : maximum length of via : 0.15um; 84 x m2.4: m2.4 : min. m2 enclosure of via : 0.055um; 64 x li.5: li.5 : min. li enclosure of licon of 2 adjacent edges : 0.08um; 30 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     266000.00 x 43140.00 = 11475240000.0 um2, budget 2648, reference 1323.89

Tool report:
DRC2 (foundry KLayout deck): 10602 violation(s), boxes in um
  10004 x via3.1_b: via3.1_b : maximum length of via3 : 0.2um   e.g. at (214900.000 28300.000 215100.000 28300.000)  (214900.000 28700.000 215100.000 28700.000)  (214900.000 28500.000 215100.000 28500.000)
   256 x licon.1: licon.1: min/max. licon length : 0.17um   e.g. at (182790.000 1915.000 182960.000 1915.000)  (182960.000 1915.000 182960.000 2085.000)  (182065.000 1915.000 182065.000 2085.000)
   104 x via.1a_b: via.1a_b : maximum length of via : 0.15um   e.g. at (21925.000 9925.000 21925.000 10075.000)  (22075.000 9925.000 22075.000 10075.000)  (6075.000 9925.000 6075.000 10075.000)
    84 x m2.4: m2.4 : min. m2 enclosure of via : 0.055um   e.g. at (1925.000 -75.000 1925.000 75.000)  (1925.000 75.000 2000.055 75.000)  (17925.000 -105.000 17925.000 45.000)
    64 x li.5: li.5 : min. li enclosure of licon of 2 adjacent edges : 0.08um   e.g. at (181895.000 1915.000 182065.000 2085.000)  (176790.000 1915.000 176960.000 2085.000)  (19895.000 915.000 20065.000 1085.000)
    30 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (188790.000 1915.000 188880.000 2085.000)  (71290.000 915.000 71380.000 1085.000)  (83290.000 915.000 83380.000 1085.000)
    26 x m2.5: m2.5 : min. m2 enclosure of via of 2 adjacent edges : 0.085um   e.g. at (9925.000 725.000 10075.000 875.000)  (1925.000 -75.000 2075.000 75.000)  (29925.000 -105.000 30075.000 45.000)
     8 x via2.1a_b: via2.1a_b : maximum length of via2 : 0.2um   e.g. at (37900.000 17900.000 37900.000 18100.000)  (37900.000 18100.000 38100.000 18100.000)  (38100.000 17900.000 38100.000 18100.000)
     8 x m3.4: m3.4 : min. m3 enclosure of via2 : 0.065um   e.g. at (22100.000 37900.000 22100.000 38100.000)  (37900.000 17900.000 37900.000 18100.000)  (21900.000 38100.000 22100.000 38100.000)
     7 x via2.4: via2.4 : min. m2 enclosure of via2 : 0.04um   e.g. at (21900.000 37900.000 21900.000 38100.000)  (21900.000 38100.000 22100.000 38100.000)  (22100.000 37900.000 22100.000 38100.000)
     4 x via3.4: via3.4 : min. m3 enclosure of via3 : 0.06um   e.g. at (21900.000 37900.000 21900.000 38100.000)  (21900.000 38100.000 22100.000 38100.000)  (22100.000 37900.000 22100.000 38100.000)
     4 x m4.3: m4.3 : min. m4 enclosure of via3 : 0.065um   e.g. at (21900.000 37900.000 21900.000 38100.000)  (21900.000 37900.000 22100.000 37900.000)  (21900.000 38100.000 22100.000 38100.000)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?