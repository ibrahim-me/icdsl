# Level 3 - floorplan: place finished blocks (ICL cells + real SKY130 standard cells),
# let the tool work out legal spacing from the layers on the facing edges, then route the chip.
pdk sky130A
import "l1_stdcells.icl"
import "l2_analog.icl"

floorplan chip width=30 height=26
  port INP  in  side=left   layer=m3
  port INN  in  side=left   layer=m3
  port VBN  in  side=bottom layer=m3
  port VBP  in  side=top    layer=m3
  port EN   in  side=right  layer=m3
  port OUT  out side=right  layer=m3
  port VPWR power
  port VGND ground

  # signal chain: differential stage -> OTA -> inverter -> NAND (gated by EN) -> PDK inverter
  inst DIF  diff_stage  INP=INP INN=INN VBN=VBN VBP=VBP OUTP=dp OUTN=dn
  inst AMP  ota_matched INP=dp  INN=dn  VBN=VBN OUT=aout
  inst INV  inv1        A=aout  Y=ainv
  inst NAND nand2       A=ainv  B=EN    Y=gy
  inst TAP  pdk:sky130_fd_sc_hd__tapvpwrvgnd_1
  inst BUF  pdk:sky130_fd_sc_hd__inv_2  A=gy Y=OUT

  place DIF  at=(1.38, 1.38)
  place AMP  right_of=DIF align=bottom            # gap=min: abut if legal, else minimum legal gap
  place INV  above=DIF align=left gap=2.0
  place NAND right_of=INV                          # same template -> rails and wells merge
  place TAP  right_of=NAND
  place BUF  right_of=TAP                          # PDK cells: tool finds what may abut
  proximity DIF AMP
  proximity NAND TAP

  route VPWR VGND width=0.5 layers=m1,m2,m3       # wide supply nets
  route dp dn layers=m2,m3                          # keep the differential pair off met1
  keepout aout INP dist=1.0
end
