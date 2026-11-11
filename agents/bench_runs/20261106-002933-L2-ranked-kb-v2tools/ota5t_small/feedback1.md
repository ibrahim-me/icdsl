The file did not compile (params {'W': 1.0, 'L': 0.5}):
line 0
error: tool crashed: dsl/icdsl/design.py", line 47, in build
    lay = B(self, blk).build()
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/lib_assembly.py", line 182, in build
    fn(st)
    ~~^^^^
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/lib_assembly.py", line 543, in st_guardring
    sh, half, need = build()
                     ~~~~~^^
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/lib_assembly.py", line 498, in build
    extra = nm(self.scope.eval(st.kw["space"], st.line)) if "space" in st.kw else 0
            ~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/ibrahim/claude-workspace/icdsl/icdsl/syntax.py", line 421, in nm
    return int(round(float(v_um) * 1000 / 5.0)) * 5
                     ~~~~~^^^^^^
TypeError: float() argument must be a string or a real number, not 'Min'

Fix it (only statements and keys from the reference) and return the complete file.