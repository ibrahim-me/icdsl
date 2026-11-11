The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}):
line 50: `cb = max(nd.top + 0.19, snl is sn2l ? sn2l.top + 0.25 : 0, sn2l.top + 0.25)`
error: stray '='
hint: write key=value without spaces around a bare '=', or bind a value with 'name = <expression>' on its own line
Fix it (only use statements and keys from the reference) and return the complete file.