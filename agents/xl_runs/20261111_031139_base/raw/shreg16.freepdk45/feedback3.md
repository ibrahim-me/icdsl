Judge:
  FAIL DRC      magic DRC did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)
  FAIL DRC2     foundry KLayout deck: 336 violation(s): 240 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm; 96 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     38800.00 x 36600.00 = 1420080000.0 um2, budget 261, reference 130.23

Tool report:
DRC2 (foundry KLayout deck): 336 violation(s), boxes in um
   240 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm   e.g. at (38670.000 18330.000 38670.000 18470.000)  (38530.000 18330.000 38530.000 18470.000)  (4530.000 18330.000 4530.000 18470.000)
    96 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (135.000 1235.000 279.550 1235.000)  (135.000 1235.000 135.000 1378.800)  (279.550 1235.000 279.550 1378.800)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?