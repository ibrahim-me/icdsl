pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell tt width=12 height=H
  dN2 = rect diff w=1.54 h=WN2 left=0.61 above=ptap
  dP3 = rect diff w=1.11 h=WP left=3.80 below=ntap
  dN3 = rect diff w=1.11 h=WN left=3.80 above=ptap
end
