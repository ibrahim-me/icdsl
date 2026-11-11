Judge:
  ok   DRC      clean
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 320/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/icl/shreg16.sky130A/a3/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     111.39 x 11.04 = 1229.7 um2, budget 1857, reference 928.02

Tool report:
== shreg16  111.32 x 11.04 um  ->  VIOLATIONS  (132.0s)
DRC (magic drc(full) sky130A): 0 violation(s)
LVS (netgen sky130A_setup): MISMATCH - Top level cell failed pin matching.  devices [320, 352] nets [132, 212]  pins_equivalent=True
   | sky130_fd_pr__pfet_01v8 (10)               |sky130_fd_pr__pfet_01v8 (11) **Mismatch**  
   | sky130_fd_pr__nfet_01v8 (10)               |sky130_fd_pr__nfet_01v8 (11) **Mismatch**  
   | Number of devices: 20 **Mismatch**         |Number of devices: 22 **Mismatch**         
   | Number of nets: 12 **Mismatch**            |Number of nets: 17 **Mismatch**            
   | ---------------------------------------------------------------------------------------
   | NET mismatches: Class fragments follow (with fanout counts):
   | Circuit 1: dff                             |Circuit 2: dff                             
   | ---------------------------------------------------------------------------------------
   | Net: m2                                    |Net: mb                                    
   |   sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/2 = 2            
   |   sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1        
   |   sky130_fd_pr__nfet_01v8/(1|3) = 2        |  sky130_fd_pr__pfet_01v8/2 = 2            
   |   sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__pfet_01v8/(1|3) = 1        
   |                                            |                                           
   | Net: CKB                                   |Net: CK                                    
   |   sky130_fd_pr__pfet_01v8/2 = 3            |  sky130_fd_pr__nfet_01v8/2 = 3            
   |   sky130_fd_pr__nfet_01v8/(1|3) = 1        |  sky130_fd_pr__pfet_01v8/2 = 3            
   |   sky130_fd_pr__nfet_01v8/2 = 3            |                                           
   |   sky130_fd_pr__pfet_01v8/(1|3) = 1        |                                           
   |                                            |                                           
   | Net: m3                                    |Net: n1                                    
   |   sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/(1|3) = 2        
   |   sky130_fd_pr__nfet_01v8/(1|3) = 2        |                                           
   |                                            |                                           
   | Net: s3                                    |Net: n2                                    
   |   sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/(1|3) = 2        
   |   sky130_fd_pr__nfet_01v8/(1|3) = 2        |                                           
   |                                            |                                           
   | Net: VPWR                                  |Net: n4                                    
   |   sky130_fd_pr__pfet_01v8/4 = 10           |  sky130_fd_pr__nfet_01v8/(1|3) = 2        
   |   sky130_fd_pr__pfet_01v8/(1|3) = 6        |                                           
   |                                            |                                           
   | Net: VGND                                  |Net: n3                                    
   |   sky130_fd_pr__nfet_01v8/(1|3) = 6        |  sky130_fd_pr__nfet_01v8/(1|3) = 2        
   |   sky130_fd_pr__nfet_01v8/4 = 10           |                                           
   |                                            |                                           
   | Net: D                                     |Net: p1                                    
   |   sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__pfet_01v8/(1|3) = 2        
   |   sky130_fd_pr__nfet_01v8/(1|3) = 1        |                                           
   |                                            |                                           
image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/icl/shreg16.sky130A/a3/shreg16.svg   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/icl/shreg16.sky130A/a3/shreg16.gds