onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /basic_timer_tb/PWM_CNT_RST
add wave -noupdate /basic_timer_tb/CLK_to_BTCNT
add wave -noupdate /basic_timer_tb/RST_or_PWMRST_BTCNT
add wave -noupdate /basic_timer_tb/BTCL0
add wave -noupdate /basic_timer_tb/BTCL1
add wave -noupdate /basic_timer_tb/counter_out
add wave -noupdate /basic_timer_tb/q_clk_div
add wave -noupdate /basic_timer_tb/BTCCR0
add wave -noupdate /basic_timer_tb/BTCCR1
add wave -noupdate /basic_timer_tb/MCLK
add wave -noupdate /basic_timer_tb/Reset
add wave -noupdate /basic_timer_tb/BTOUTMD
add wave -noupdate /basic_timer_tb/BTHOLD
add wave -noupdate /basic_timer_tb/BTSSEL0
add wave -noupdate /basic_timer_tb/BTSSEL1
add wave -noupdate /basic_timer_tb/BTIP0
add wave -noupdate /basic_timer_tb/BTIP1
add wave -noupdate /basic_timer_tb/BTIP2
add wave -noupdate /basic_timer_tb/BTCL0_ENA
add wave -noupdate /basic_timer_tb/BTCL1_ENA
add wave -noupdate /basic_timer_tb/PWMout
add wave -noupdate /basic_timer_tb/Set_BTIFG
add wave -noupdate /basic_timer_tb/L0/MCLK
add wave -noupdate /basic_timer_tb/L0/Reset
add wave -noupdate /basic_timer_tb/L0/BTOUTEN
add wave -noupdate /basic_timer_tb/L0/BTOUTMD
add wave -noupdate /basic_timer_tb/L0/BTHOLD
add wave -noupdate /basic_timer_tb/L0/BTSSEL0
add wave -noupdate /basic_timer_tb/L0/BTSSEL1
add wave -noupdate /basic_timer_tb/L0/BTIP0
add wave -noupdate /basic_timer_tb/L0/BTIP1
add wave -noupdate /basic_timer_tb/L0/BTIP2
add wave -noupdate /basic_timer_tb/L0/BTCL0_ENA
add wave -noupdate /basic_timer_tb/L0/BTCL1_ENA
add wave -noupdate /basic_timer_tb/L0/PWMout
add wave -noupdate /basic_timer_tb/L0/Set_BTIFG
add wave -noupdate -radix decimal /basic_timer_tb/L0/BTCNT_out
add wave -noupdate /basic_timer_tb/BTOUTEN
add wave -noupdate -radix decimal /basic_timer_tb/L0/BTCCR0
add wave -noupdate -radix decimal /basic_timer_tb/L0/BTCCR1
add wave -noupdate -radix decimal /basic_timer_tb/L0/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2932 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 247
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {16496 ps}
