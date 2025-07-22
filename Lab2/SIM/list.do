onerror {resume}
add list -width 11 /mytb/rst
add list /mytb/ena
add list /mytb/clk
add list /mytb/x
add list /mytb/DetectionCode
add list /mytb/detector
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
