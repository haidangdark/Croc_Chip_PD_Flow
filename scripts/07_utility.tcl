###################################################################
# 07_utility.tcl
# Task 01: Print all nets with wire length > 200um
# Task 02: Summarize report_timing output
###################################################################

###################################################################
# Task 01: Print all nets with wire length > 200um
#
# Usage:
#   print_long_nets           ;# default > 200um
#   print_long_nets 300       ;# custom threshold > 300um
#
# Note: Wire length is computed from routed sWire segments.
#       If error, run: dbGet [lindex [dbGet top.nets] 0].?
#       to find the correct attribute name.
###################################################################
proc print_long_nets {{min_length 200}} {
    puts "============================================================"
    puts " All nets with wire length > ${min_length} um"
    puts "============================================================"

    set net_list {}

    # Loop through all nets
    foreach net [dbGet top.nets] {
        # Skip power/ground nets
        if {[dbGet $net.isPwrOrGnd] == 1} continue

        # Calculate HPWL from bounding box (box_sizex + box_sizey)
        set sx [dbGet $net.box_sizex]
        set sy [dbGet $net.box_sizey]
        if {$sx eq "0x0" || $sy eq "0x0"} continue
        set wl [expr {$sx + $sy}]

        if {$wl > $min_length} {
            set name [dbGet $net.name]
            lappend net_list [list $name $wl]
        }
    }

    if {[llength $net_list] == 0} {
        puts "No nets found with wire length > ${min_length}um"
        puts "============================================================"
        return
    }

    # Sort by wire length descending
    set net_list [lsort -index 1 -real -decreasing $net_list]

    # Find max name length for dynamic column width
    set max_name_len [string length "Net Name"]
    foreach item $net_list {
        set nlen [string length [lindex $item 0]]
        if {$nlen > $max_name_len} { set max_name_len $nlen }
    }
    set col_w [expr {$max_name_len + 2}]
    set total_w [expr {$col_w + 14}]

    # Print header with dynamic width
    puts [format "%-${col_w}s %12s" "Net Name" "Length(um)"]
    puts [string repeat "-" $total_w]

    set count 0
    set total_wl 0.0
    foreach item $net_list {
        set name [lindex $item 0]
        set wl   [lindex $item 1]
        puts [format "%-${col_w}s %12.2f" $name $wl]
        incr count
        set total_wl [expr {$total_wl + $wl}]
    }

    puts [string repeat "-" $total_w]
    puts [format "Total nets > ${min_length}um : %d" $count]
    puts [format "Total wire length          : %.2f um" $total_wl]
    puts "============================================================"
}


###################################################################
# Task 02: Summarize report_timing output
#
# Usage:
#   summary_timing -path_group reg2reg -max_paths 7
#   summary_timing -path_group reg2reg -max_paths 1
#   summary_timing                     ;# defaults: reg2reg, 10 paths
###################################################################
proc summary_timing {args} {
    # --- Parse arguments ---
    set path_group "reg2reg"
    set max_paths  10

    for {set i 0} {$i < [llength $args]} {incr i} {
        switch -- [lindex $args $i] {
            -path_group { incr i; set path_group [lindex $args $i] }
            -max_paths  { incr i; set max_paths  [lindex $args $i] }
        }
    }

    # --- Configure table style ---
    set_table_style -nosplit -no_frame_fix_width

    # --- Capture report_timing output ---
    set tmp_file ".tmp_summary_timing_rpt.txt"
    redirect $tmp_file "report_timing -path_group $path_group -max_paths $max_paths"

    set fp [open $tmp_file r]
    set rpt [read $fp]
    close $fp
    file delete -force $tmp_file

    set lines [split $rpt "\n"]

    # --- Pass 1: Collect all path data ---
    set all_paths {}
    set path_idx   0
    set beginpoint ""
    set endpoint_v ""
    set slack      0.0
    set in_table   0
    set levels     0
    set buf_inv    0
    set logic_cnt  0
    set max_slew   0.0
    set max_delay  0.0
    set has_data   0

    foreach line $lines {
        set trimmed [string trim $line]

        if {[regexp {^Beginpoint:\s+(\S+)} $line -> val]} {
            if {$has_data} {
                set sp_inst $beginpoint
                set ep_inst $endpoint_v
                regsub {/[^/]+$} $sp_inst {} sp_inst
                regsub {/[^/]+$} $ep_inst {} ep_inst
                lappend all_paths [list $path_idx $sp_inst $ep_inst $levels $buf_inv $logic_cnt $max_slew $max_delay $slack]
            }
            incr path_idx
            set beginpoint $val
            set endpoint_v ""
            set slack      0.0
            set in_table   0
            set levels     0
            set buf_inv    0
            set logic_cnt  0
            set max_slew   0.0
            set max_delay  0.0
            set has_data   0
            continue
        }

        if {[regexp {^Endpoint:\s+(\S+)} $line -> val]} {
            set endpoint_v $val
            continue
        }

        if {[regexp {Slack Time\s+([-\d.]+)} $line -> val]} {
            set slack $val
            continue
        }

        if {[regexp {^-{30,}} $trimmed]} {
            set in_table 1
            continue
        }

        if {$in_table} {
            if {$trimmed eq ""} continue

            if {[regexp {^Path \d+:} $trimmed] || \
                [regexp {^#} $trimmed] || \
                [regexp {^\*} $trimmed]} {
                set in_table 0
                continue
            }

            if {[regexp {(sg13g2_\w+)} $trimmed -> cell_name]} {
                incr levels
                set has_data 1

                if {[regexp -nocase {_buf_|_inv_|_clkbuf_|_clkinv_|_dlygate_} $cell_name]} {
                    incr buf_inv
                } else {
                    incr logic_cnt
                }

                set nums [regexp -inline -all {\d+\.\d+} $trimmed]
                if {[llength $nums] >= 2} {
                    set d [lindex $nums 0]
                    set s [lindex $nums 1]
                    if {$d > $max_delay} { set max_delay $d }
                    if {$s > $max_slew}  { set max_slew  $s }
                }
            }
        }
    }

    # Append last path
    if {$has_data} {
        set sp_inst $beginpoint
        set ep_inst $endpoint_v
        regsub {/[^/]+$} $sp_inst {} sp_inst
        regsub {/[^/]+$} $ep_inst {} ep_inst
        lappend all_paths [list $path_idx $sp_inst $ep_inst $levels $buf_inv $logic_cnt $max_slew $max_delay $slack]
    }

    # --- Pass 2: Find max column widths ---
    set max_sp_len [string length "start_point_inst"]
    set max_ep_len [string length "end_point_inst"]

    foreach p $all_paths {
        set sp_len [string length [lindex $p 1]]
        set ep_len [string length [lindex $p 2]]
        if {$sp_len > $max_sp_len} { set max_sp_len $sp_len }
        if {$ep_len > $max_ep_len} { set max_ep_len $ep_len }
    }

    # Add 2 chars padding
    set sp_w [expr {$max_sp_len + 2}]
    set ep_w [expr {$max_ep_len + 2}]
    set total_w [expr {4 + $sp_w + $ep_w + 5 + 5 + 5 + 7 + 7 + 8}]

    # --- Print header ---
    puts ""
    set row_fmt "%-4s %-${sp_w}s %-${ep_w}s %5s %5s %5s %7s %7s %8s"
    puts [format $row_fmt "#" "start_point_inst" "end_point_inst" "level" "b/inv" "logic" "mx_slew" "mx_dely" "slack"]
    puts [string repeat "-" $total_w]

    # --- Print each path ---
    foreach p $all_paths {
        set idx  [lindex $p 0]
        set sp   [lindex $p 1]
        set ep   [lindex $p 2]
        set lvl  [lindex $p 3]
        set buf  [lindex $p 4]
        set lgc  [lindex $p 5]
        set mslw [lindex $p 6]
        set mdly [lindex $p 7]
        set slk  [lindex $p 8]
        puts [format "%-4s %-${sp_w}s %-${ep_w}s %5d %5d %5d %7.3f %7.3f %8.3f" \
            "#$idx" $sp $ep $lvl $buf $lgc $mslw $mdly $slk]
    }

    puts [string repeat "-" $total_w]
    puts "Total paths reported: [llength $all_paths]"
    puts ""
}


###################################################################
# Quick-run (uncomment to execute):
#   print_long_nets 200
#   summary_timing -path_group reg2reg -max_paths 7
###################################################################
