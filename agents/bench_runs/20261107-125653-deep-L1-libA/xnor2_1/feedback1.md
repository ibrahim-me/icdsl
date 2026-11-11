The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}):
line 103: `mcVPWR = array mcon in=pdA cx=(gA - 0.30) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) cy=H`
error: array: no mcon fits in pdA (-0.020 um usable along x within span=; one cut needs 0.170 um + margin 0.000 um each side)
Fix it (only use statements and keys from the reference) and return the complete file.