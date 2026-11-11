The file did not compile (params {'W': 1.0, 'L': 0.15}):
line 37: `route OUTP OUTN symmetric axis=M0.cx width=0.2 avoid=INP:0.5,INN:0.5`
error: cell strongarm: symmetric routing of OUTP/OUTN failed: net 'OUTP': no legal path to M4.col1, M5.g, M6.col1, M8.col1
hint: check that the two nets' pins are mirror images about the axis (use 'mirror' placement), and that the axis is on the 0.23 um half-grid
Fix it (only statements and keys from the reference) and return the complete file.