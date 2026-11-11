The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}):
line 72: `c5 = array licon in=nd1 cx=(x4 + L + 0.15) span=(-0.085 + 0.08, nb + 0.25 - 0.08) margin=0.04 net=VGND`
error: array: no licon fits in nd1 (0.130 um usable along y within span=; one cut needs 0.170 um + margin 0.040 um each side)
Fix it (only use statements and keys from the reference) and return the complete file.