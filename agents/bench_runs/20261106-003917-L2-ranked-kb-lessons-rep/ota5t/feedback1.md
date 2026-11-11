The file did not compile (params {'W': 1.0, 'L': 0.5}):
line 25: `tap PT kind=ptap net=VGND cols=2 below=MT align=center gap=min`
error: tap: unknown parameter 'below'
hint: allowed: cols, kind, net
Fix it (only statements and keys from the reference) and return the complete file.