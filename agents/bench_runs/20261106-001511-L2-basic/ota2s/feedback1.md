The file did not compile (params {'W': 1.0, 'L': 0.5}):
line 21: `common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD`
error: cell ota2s: the n-well of 'LOAD' at (4.29..8.59, 0.80..2.16) um has no n-tap
hint: add 'tap TN kind=ntap net=VPWR' placed next to it (gap=min keeps it in the same well), or an ntap guardring around the pmos devices
Fix it (only statements and keys from the reference) and return the complete file.