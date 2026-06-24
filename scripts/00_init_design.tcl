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
set init_verilog "../input_data/netlist/croc_chip_yosys.v"
set init_design_uniquify 1
set init_design_settop 1
set init_top_cell "croc_chip"
set init_lef_file "../input_data/lef/sg13g2_tech.lef \
	../input_data/lef/sg13g2_stdcell_weltap.lef \
	../input_data/lef/sg13g2_io.lef \
	../input_data/lef/bondpad_70x70.lef \
	../input_data/lef/RM_IHPSG13_1P_1024x16_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_1024x64_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_1024x8_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_2048x64_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_256x48_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_256x64_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_4096x16_c3_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_4096x8_c3_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_512x64_c2_bm_bist.lef \
	../input_data/lef/RM_IHPSG13_1P_64x64_c2_bm_bist.lef"
set init_mmmc_file "../input_data/croc_mmmc.view"
set init_pwr_net {VDD}
set init_gnd_net {VSS}
init_design


puts "Done init design."


###############################
# Floorplan — Die: 1840.32 x 1840.02, Margin: 168 all sides
# Core area: (168, 168) to (1672.32, 1672.02)
###############################
floorPlan -site CoreSite -d 1840.32 1840.02 168 168 168 168


# save design
saveDesign ../SAVED/${STAGE}_init.invs


# check library usage
check_library  -all_lib_cell  -place > ../rpt/${STAGE}/check_library.rpt


#update name
source ../data/scripts/common/update_names_format.tcl
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
checkFPlan -reportUtil > ../rpt/${STAGE}/check_library.rpt


###################
# Place Hardmacro — Upper-right corner (INSIDE core area)
# SRAM: RM_IHPSG13_1P_256x64_c2_bm_bist (784.48 x 118.78 µm)
# Die box: (0, 0) to (1840.32, 1840.02)
# Core box: (348, 348) to (1492.32, 1492.02)
# SRAM 5µm from core edges (top & right), 5µm gap between SRAMs
#
# Calculation:
#   sram_x  = 1492.32 - 5 - 784.48 = 702.84
#   sram0_y = 1492.02 - 5 - 118.78 = 1368.24  (top SRAM)
#   sram1_y = 1368.24 - 5 - 118.78 = 1244.46  (bottom SRAM)
#   Right edge: 702.84+784.48 = 1487.32 < 1492.32 ✓
#   Top edge:   1368.24+118.78 = 1487.02 < 1492.02 ✓
#   Left edge:  702.84 > 348 ✓
#   Bottom edge: 1244.46 > 348 ✓
###################
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloTop 5
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloBot 5
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloLeft  5
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloRight 5


placeInstance {i_croc_soc/i_croc/gen_sram_bank_0__i_sram/gen_512x32xBx1_i_cut} -fixed {702.84 1368.24}
placeInstance {i_croc_soc/i_croc/gen_sram_bank_1__i_sram/gen_512x32xBx1_i_cut} -fixed {702.84 1244.46}


# Cut rows around SRAMs (after placement)
#cutRow


##########################################################
# Routing blockage — margin area (between core and IO pads)
# Block signal routing, allow only PG mesh to reach IO pads
# Core box: (348, 348) to (1492.32, 1492.02)
##########################################################
# puts "=== Adding routing blockage in margin area ==="
# # Left margin
# createRouteBlk -box 0 0 348.0 1840.02 -exceptpgnet
# # Right margin
# createRouteBlk -box 1492.32 0 1840.32 1840.02 -exceptpgnet
# # Bottom margin
# createRouteBlk -box 0 0 1840.32 348.0 -exceptpgnet
# # Top margin
# createRouteBlk -box 0 1492.02 1840.32 1840.02 -exceptpgnet


####################
# Check design
####################
checkDesign -all > ../rpt/${STAGE}/check_design.rpt
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
source -e -v ../data/scripts/PG/create_pg.tcl
#verify power via
verifyPowerVia


# check open
verify_connectivity -net {VDD VSS}


saveDesign ../SAVED/${STAGE}_PG.invs


######################
# Add Well Tap
######################
addWellTap -cell sky130_fd_sc_hd__tapvpwrvgnd_1 -cellInterval 40 -inRowOffset 25 -prefix WELLTAP


saveDesign ../SAVED/${STAGE}.invs
source ../data/scripts/utility/report_timing_format.tcl
# report timing
timeDesign -prePlace -pathReports -slackReports -numPaths 1000 -prefix  ${STAGE}_prePlace -outDir ../rpt/${STAGE}_prePlace









