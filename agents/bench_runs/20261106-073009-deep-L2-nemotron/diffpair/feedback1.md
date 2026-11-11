The file did not compile (params {'W': 1.0, 'L': 0.5}):
line 22: `route OUTP OUTN symmetric axis=0`
error: cell diffpair: symmetric routing of OUTP/OUTN failed: pins of 'OUTN' are not mirror images of 'OUTP' pin DP_r1.col0 about x=0.000 um
hint: check that the two nets' pins are mirror images about the axis (use 'mirror' placement), and that the axis is on the 0.23 um half-grid
Fix it (only statements and keys from the reference) and return the complete file.