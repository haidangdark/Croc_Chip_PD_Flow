#### USER SETTING => PLEASE DON'T CHANGE ANY THING IN THIS FILE! ###



source /ictc/student_data/share/pd/data/final_project/fn_prj_here/data/scripts/common/ictc_deepdive_enc.tcl > /dev/null
if {[regexp 02_place_opt $STAGE]} {
  ##
  setOptMode -addInstancePrefix ictc_preCTS_
} elseif {[regexp 03_CTS $STAGE]} {
  #setMultiCpuUsage -keepLicense true 
  #set_interactive_constraint_modes [all_constraint_modes -active]
  # setExtractRCMode -effortLevel medium 
  # setExtractRCMode -effortLevel low
  
  set_ccopt_property -integration native
  #/ictc/teacher_data/ictc_thenguyen/croc/openroad/scripts/init_tech.tcl
  #set ctsBuf [ list sg13g2_buf_16 sg13g2_buf_8 sg13g2_buf_4 sg13g2_buf_2 ]
  #set ctsBufRoot sg13g2_buf_8
  set_ccopt_property -buffer_cells [ list sg13g2_buf_16 sg13g2_buf_8 sg13g2_buf_4 sg13g2_buf_2 ]
  #set_ccopt_property -inverter_cells
  #set_ccopt_property -use_inverter_cells
  #set_ccopt_property -clock_gating_cells
  #set_ccopt_property top_inverter_cells
  #set_ccopt_property leaf_inverter_cells
  if {[dbget -p head.rules.name ndr_1w2s ] == "0x0" } {
    add_ndr -name ndr_1w2s -spacing_multiplier {Metal2:Metal5 2} -width_multiplier {Metal2:Metal5 2}
    modify_ndr -name ndr_1w2s -generate_via
  }
  if {[dbget -p head.rules.name ndr_3w3s ] == "0x0" } {
    add_ndr -name ndr_3w3s -spacing_multiplier {Metal2:Metal5 3} -width_multiplier {Metal2:Metal5 3}
    modify_ndr -name ndr_3w3s -generate_via
  }
  
  if {[dbget -p head.rules.name Trunk_ndr ] == "0x0" } {
    add_ndr -name ndr_2w2s -spacing_multiplier {Metal2:Metal5 2} -width_multiplier {Metal2:Metal5 2}
    modify_ndr -name ndr_2w2s -generate_via
  }
  
  create_route_type -name clk_trunk -top_preferred_layer Metal5 -bottom_preferred_layer Metal3 -non_default_rule ndr_3w3s
  create_route_type -name clk_leaf  -top_preferred_layer Metal4 -bottom_preferred_layer Metal1 -non_default_rule ndr_2w2s
  
  set_ccopt_property -route_type clk_trunk -net_type trunk
  set_ccopt_property -route_type clk_leaf  -net_type leaf
  
  set_ccopt_property -max_fanout 32
  set_ccopt_property -target_max_trans 1.6
  set_ccopt_property -target_skew 0.2
  # set_ccopt_property -target_max_capacitance ?
} elseif {[regexp 04_CTS $STAGE]} {
  set_ccopt_property -update_io_latency true
}

