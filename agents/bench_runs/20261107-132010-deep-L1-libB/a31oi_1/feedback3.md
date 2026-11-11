The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}):
line 68: `c7 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - WP + 0.18 - 0.08) margin=0.04 net=n1`
error: array: no licon fits in pd2 (0.010 um usable along y within span=; one cut needs 0.170 um + margin 0.040 um each side)
Fix it (only use statements and keys from the reference) and return the complete file.