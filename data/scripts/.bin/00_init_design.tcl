###############################
# Setup
###############################
set STAGE 00_init_design
# 
setMultiCpuUsage -localCpu $env(CPU_NUM)
# limitations under the License.
setPreference ConstraintUserXGrid 0.1
setPreference ConstraintUserXOffset 0.1
setPreference ConstraintUserYGrid 0.1
setPreference ConstraintUserYOffset 0.1
setPreference SnapAllCorners 1

###############################
set init_verilog <input verilog netlist file here>
set init_design_uniquify 1
set init_design_settop 1
set init_top_cell <input top design name here>
set init_lef_file <input list of lef file here>
set init_mmmc_file <input view file here> 
set init_pwr_net {PWR}
set init_gnd_net {GND}
init_design




puts "Done init design. Please check log file if any errors during init design"

puts "REQUEST: Target utilization is 58%! Please adjust core area to achieve this utilization and continue!"

return

# save design
saveDesign SAVED/${STAGE}_init.invs
#
# check library usage
check_library  -all_lib_cell  -place > rpt/${STAGE}/check_library.rpt

#update name
source data/scripts/common/update_names_format.tcl
##################
# Create row
##################

deleteRow -all
initCoreRow
cutRow

##################
# Create track
##################
add_tracks -offset {Metal1 vert 0 Metal2 horiz 0 Metal3 vert 0 Metal4 horiz 0 Metal5 vert 0 TopMetal1 horiz 0 TopMetal2 vert 0}

####################
# Report utilization
####################
checkFPlan -reportUtil > rpt/${STAGE}/check_library.rpt

###################
# Place Hardmacro
###################
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloTop 10
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloBot 10
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloLeft  10
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloRight 10

placeInstance {i_croc_soc/i_croc/gen_sram_bank_1__i_sram/gen_512x32xBx1_i_cut} -fixed {626.08 430.0}
placeInstance {i_croc_soc/i_croc/gen_sram_bank_0__i_sram/gen_512x32xBx1_i_cut} -fixed {626.08 558.78}


####################
# Check design
####################
checkDesign -all > rpt/${STAGE}/check_design.rpt
##################
# Global Connect 
##################
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override

# Boundary rings
#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer met5 -type core_rings -jog_distance 1.7 -threshold 1.7 -nets {vssd1 vccd1} -follow io -stacked_via_bottom_layer li1 -layer {bottom met5 top met5 right met4 left met4} -width 4 -spacing 2 -offset 5
##################
# Add endcap
##################
setEndCapMode -prefix ENDCAP -leftEdge sky130_fd_sc_hd__endcap -rightEdge sky130_fd_sc_hd__endcap
addEndCap
# verify end cap
verifyEndCap

######################
### Add PG
#####################
source -e -v ./data/scripts/PG/create_pg.tcl
#verify power via
verifyPowerVia

# check open
verify_connectivity -net {VDD VSS} 

saveDesign SAVED/${STAGE}_PG.invs

######################
# Add Well Tap
######################
addWellTap -cell sky130_fd_sc_hd__tapvpwrvgnd_1 -cellInterval 40 -inRowOffset 25 -prefix WELLTAP

saveDesign SAVED/${STAGE}.invs
source ./data/scripts/utility/report_timing_format.tcl
# report timing
timeDesign -prePlace -pathReports -slackReports -numPaths 1000 -prefix  ${STAGE}_prePlace -outDir ./rpt/${STAGE}_prePlace

