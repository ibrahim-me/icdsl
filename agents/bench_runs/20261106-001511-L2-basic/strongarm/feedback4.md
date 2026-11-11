The file did not compile (params {'W': 1.0, 'L': 0.15}):
line 35: `route INP INN symmetric axis=0 width=0.2`
error: cell strongarm: symmetric routing of INP/INN failed: pins of 'INN' are not mirror images of 'INP' pin M1.g about x=0.000 um
hint: check that the two nets' pins are mirror images about the axis (use 'mirror' placement), and that the axis is on the 0.23 um half-grid
Fix it (only statements and keys from the reference) and return the complete file.