The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}):
line 28: `cV2 = array licon in=nd between=[gB1, gn1]`
error: array: only 0.210 um between gB1 and gn1; a licon column needs 0.280 um (0.055 + 0.17 + 0.055)
hint: move gn1 right (e.g. left=(gB1.right + 0.280)) or drop this contact if the node between them is a series node
Fix it (only use statements and keys from the reference) and return the complete file.