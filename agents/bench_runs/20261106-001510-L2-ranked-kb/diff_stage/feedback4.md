The file did not compile (params {'W': 1.0, 'L': 0.3}):
line 35: `route OUTP OUTN symmetric axis=LOAD.cx width=0.2`
error: cell diff_stage: symmetric routing of OUTP/OUTN failed: net 'OUTP': no legal path to DIFF_r0.col3, DIFF_r0.col4, LOAD_r0.col3, LOAD_r0.col4
hint: check that the two nets' pins are mirror images about the axis (use 'mirror' placement), and that the axis is on the 0.23 um half-grid
Fix it (only statements and keys from the reference) and return the complete file.