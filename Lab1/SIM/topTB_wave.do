onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/Y
add wave -noupdate /tb_top/X
add wave -noupdate /tb_top/ALUFN
add wave -noupdate /tb_top/ALUout
add wave -noupdate /tb_top/Nflag
add wave -noupdate /tb_top/Cflag
add wave -noupdate /tb_top/Zflag
add wave -noupdate /tb_top/Vflag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {256 ns}
