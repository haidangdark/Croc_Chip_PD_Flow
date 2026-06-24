# set cpu usage
setMultiCpuUsage -localCpu $env(CPU_NUM)
##--- Set user grids
setPreference ConstraintUserXGrid 0.1
setPreference ConstraintUserXOffset 0.1
setPreference ConstraintUserYGrid 0.1
setPreference ConstraintUserYOffset 0.1
setPreference SnapAllCorners 1
#Timing global setting
setAnalysisMode -analysisType onchipvariation
set_interactive_constraint_modes [all_constraint_modes -active]
set_propagated_clock [all_clocks]
set_max_fanout 32 [current_design]
set_max_transition 0.5 [current_design] ;# 0.25
setExtractRCMode -layerIndependent 1
setExtractRCMode -defViaCap true    

##############################
### Process ###
##############################
setDesignMode -reset -congEffort
setDesignMode -flowEffort standard -process 130
#setDesignMode -process 130


setDesignMode -topRoutingLayer Metal5
setDesignMode -bottomRoutingLayer Metal2


dbset top.terms.net.skipRouting  1

setDesignMode -congEffort high ;# medium low extreme
##############################
### setup place ###
##############################
#TMP setPlaceMode -place_detail_check_cut_spacing true
#TMP setPlaceMode -place_detail_use_check_drc true
#TMP setPlaceMode -place_detail_check_route true
#TMP setPlaceMode -place_detail_dpt_flow true
setPlaceMode -place_opt_post_place_tcl  ../data/scripts/common/place_opt_post_place.tcl

############################
### report timing format ####
############################
#set_table_style -no_frame_fix_width
#set_global timing_report_enable_auto_column_width true
##set_global report_timing_format {instance arc cell delay incr_delay user_derate slew fanout load arrival instance_location}
#set_global report_timing_format {instance arc cell delay slew fanout load arrival instance_location}
source ../data/scripts/utility/report_timing_format.tcl

############################
### set path group ###
############################
#reset
reset_path_group -all
##Basic path group
group_path -name reg2reg -from [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"] -to [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"]
group_path -name reg2icg -from [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"] -to [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
group_path -name reg2mem -from [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"] -to [filter_collection [all_registers -macros] "is_memory_cell == true"]
group_path -name mem2reg -from [filter_collection [all_registers -macros] "is_memory_cell == true"] -to  [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"]
group_path -name reg2out -from [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"] -to [all_outputs]
group_path -name in2reg  -from [all_inputs -no_clocks] -to [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"]
group_path -name in2icg  -from [all_inputs -no_clocks] -to [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
group_path -name in2out  -from [all_inputs -no_clocks] -to [all_outputs]

# set path group
setPathGroupOptions reg2reg -effortLevel high
setPathGroupOptions reg2icg -effortLevel high
setPathGroupOptions reg2mem -effortLevel high
setPathGroupOptions mem2reg -effortLevel high
setPathGroupOptions reg2out -effortLevel low
setPathGroupOptions in2reg  -effortLevel low
setPathGroupOptions in2icg  -effortLevel low
setPathGroupOptions in2out  -effortLevel low

reportPathGroupOptions
