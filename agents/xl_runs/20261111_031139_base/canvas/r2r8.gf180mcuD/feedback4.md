The script did not build:
Traceback (most recent call last):
  File "<frozen runpy>", line 203, in _run_module_as_main
  File "<frozen runpy>", line 88, in _run_code
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/__main__.py", line 3, in <module>
    sys.exit(main())
             ~~~~^^
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/cli.py", line 287, in main
    return _canvas(args)
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/cli.py", line 251, in _canvas
    cell, rep = C.run_script(args.file, top=args.top, pdk=args.pdk, out=args.out, lvs=not args.no_lvs,
                ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                             ref=args.ref, do_check=args.command == "check", klayout=not args.no_klayout)
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/canvas/check.py", line 228, in run_script
    ns = runpy.run_path(path, run_name="__icl__")
  File "<frozen runpy>", line 294, in run_path
  File "<frozen runpy>", line 98, in _run_module_code
  File "<frozen runpy>", line 88, in _run_code
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a4/sub.py", line 70, in <module>
    strip(net)
    ~~~~~^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a4/sub.py", line 55, in strip
    pads = [p for _, _, p in find_pads(net)]
                             ~~~~~~~~~^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a4/sub.py", line 50, in find_pads
    if r.nets[0 if w == "a" else 1] == net:
       ^^^^^^
AttributeError: 'TwoTerm' object has no attribute 'nets'