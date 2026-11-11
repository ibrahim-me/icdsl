Judge:
  FAIL DRC      magic DRC did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)
  FAIL DRC2     foundry KLayout deck: 348 violation(s): 260 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm; 88 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     134400.00 x 8980.00 = 1206912000.0 um2, budget 261, reference 130.23

Tool report:
DRC2 (foundry KLayout deck): 348 violation(s), boxes in um
   260 x VIA1.1: VIA1.1 : Minimum/Maximum width of via1 : 70nm   e.g. at (130070.000 530.000 130070.000 670.000)  (129930.000 670.000 130070.000 670.000)  (129930.000 530.000 129930.000 670.000)
    88 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (955.000 6335.000 955.000 6465.000)  (2645.000 3535.000 2645.000 3665.000)  (1845.000 3535.000 1845.000 3665.000)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?