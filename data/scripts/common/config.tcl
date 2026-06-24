set TIE_CELL     	"sg13g2_tiehi sg13g2_tielo"
set TIE_DISTANCE 	50
set TIE_FANOUT     	30
set DIO_CELL      	"sky130_fd_sc_hd__diode_2"
set FILLER_CELL 	""
set setupTargetSlack	"0.02"
set holdTargetSlack	"0"
set holdfixCell    	""


#Clock tree option
set ccopt_effort low
set clock_layer_trunk_top 5
set clock_layer_trunk_bottom 4
set clock_layer_leaf_top 4
set clock_layer_leaf_bottom 2

set clock_ndr_trunk trunk_ndr
set clock_ndr_leaf  leaf_ndr
set cts_target_skew 0.15
set cts_target_trans 0.4
set cts_target_fanout 32
set cts_target_cap 0.2
set cts_use_inverter true
set cts_priority insertion_delay
set skew_buffer "sg13g2_buf_16 sg13g2_buf_8 sg13g2_buf_4 sg13g2_buf_2 "
set skew_inverter ""

set reclaim_area true
set power_effort none
set useful_skew true
set usefulSkewPreCTS true
set usefulSkewCCOPT none
set hold_opt 1
set fix_hold true
set ant_cell ""
set maxLength 150
set max_route_layer 5
set min_route_layer 1


#setDesignMode -topRoutingLayer TopMetal2
setDesignMode -topRoutingLayer Metal5
setDesignMode -bottomRoutingLayer Metal1
