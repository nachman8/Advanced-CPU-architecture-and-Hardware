onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /addersub_tb/x
add wave -noupdate /addersub_tb/y
add wave -noupdate /addersub_tb/sub_cont
add wave -noupdate /addersub_tb/cout
add wave -noupdate /addersub_tb/s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {82223 ps} 0}
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
WaveRestoreZoom {0 ps} {128 ns}
