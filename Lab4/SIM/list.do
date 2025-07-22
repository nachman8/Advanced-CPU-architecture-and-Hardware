onerror {resume}
add list -width 11 /tb_top/Y
add list /tb_top/X
add list /tb_top/ALUFN
add list /tb_top/ALUout
add list /tb_top/Nflag
add list /tb_top/Cflag
add list /tb_top/Zflag
add list /tb_top/Vflag
add list /tb_top/PWM_out
add list /tb_top/tb_clk
add list /tb_top/tb_rst
add list /tb_top/tb_ena
add list /tb_top/L0/PWM_module/counter
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
