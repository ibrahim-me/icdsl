Judge:
  FAIL DRC      magic DRC did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)
  FAIL DRC2     foundry KLayout deck: 260 violation(s): 72 x licon.1: licon.1: min/max. licon length : 0.17um; 72 x ct.1_b: ct.1_b : maximum length of mcon : 0.17um; 72 x via.1a_b: via.1a_b : maximum length of via : 0.15um; 18 x li.5: li.5 : min. li enclosure of licon of 2 adjacent edges : 0.08um; 18 x m2.4_a: m2.4_a : via in periphery must be enclosed by met2; 8 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     41000.00 x 83000.00 = 3403000000.0 um2, budget 4210, reference 2104.59

Tool report:
DRC2 (foundry KLayout deck): 260 violation(s), boxes in um
    72 x licon.1: licon.1: min/max. licon length : 0.17um   e.g. at (615.000 2415.000 785.000 2415.000)  (4215.000 3915.000 4215.000 4085.000)  (4215.000 4085.000 4385.000 4085.000)
    72 x ct.1_b: ct.1_b : maximum length of mcon : 0.17um   e.g. at (615.000 2415.000 785.000 2415.000)  (4215.000 3915.000 4215.000 4085.000)  (4215.000 4085.000 4385.000 4085.000)
    72 x via.1a_b: via.1a_b : maximum length of via : 0.15um   e.g. at (625.000 2575.000 775.000 2575.000)  (775.000 2425.000 775.000 2575.000)  (625.000 2425.000 775.000 2425.000)
    18 x li.5: li.5 : min. li enclosure of licon of 2 adjacent edges : 0.08um   e.g. at (615.000 2415.000 785.000 2585.000)  (4215.000 915.000 4385.000 1085.000)  (3515.000 3915.000 3685.000 4085.000)
    18 x m2.4_a: m2.4_a : via in periphery must be enclosed by met2   e.g. at (625.000 2425.000 775.000 2575.000)  (4225.000 3925.000 4375.000 4075.000)  (4225.000 925.000 4375.000 1075.000)
     8 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (3525.000 3415.000 3675.000 3585.000)  (4215.000 2415.000 4375.000 2585.000)  (2825.000 3915.000 2975.000 3920.000)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?