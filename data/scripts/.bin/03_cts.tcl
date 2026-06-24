###############################
# Setup
###############################
set STAGE 03_CTS

# limitations under the License.
set central_path data
source ${central_path}/scripts/common/common_settings.tcl
source ${central_path}/scripts/common/user_settings.tcl
source ${central_path}/scripts/common/config.tcl
#############
# clock tree synthesys - ccopt
############
set_ccopt_mode -integration native
#tmp set ctsBuf [ list sg13g2_buf_16 sg13g2_buf_8 sg13g2_buf_4 sg13g2_buf_2 ]
#tmp set ctsBufRoot sg13g2_buf_8
#tmp the repair_timing/repair_design commands may try to use IO cells as buffers sg13g2_IOPadIn

#####################
## set dont use
#####################
set dont_use_cells sg13g2_IOPad*
set_dont_use $dont_use_cells

create_ccopt_clock_tree_spec -file ccopt_native.spec
source ccopt_native.spec

setCTSMode -bottomPreferredLayer Metal3
setCTSMode -routeTopPreferredLayer Metal4
#set_ccopt_property target_max_trans 0.223
#set_ccopt_property target_max_trans 2.083
#set_ccopt_property target_max_trans 1.083
#set_ccopt_property target_max_capacitance 
set_ccopt_property target_max_trans 0.8
set_ccopt_property -max_fanout 32
set_ccopt_property -target_skew 0.15

set_ccopt_property override_minimum_skew_target true
#set_ccopt_property insertion_delay -pin i_croc_soc/i_croc/gen_sram_bank_1__i_sram/gen_512x32xBx1_i_cut/A_CLK 0.500
#set_ccopt_property insertion_delay -pin i_croc_soc/i_croc/gen_sram_bank_0__i_sram/gen_512x32xBx1_i_cut/A_CLK 0.500
set_ccopt_property insertion_delay -pin i_croc_soc/i_croc/i_gpio/i_reg_file_reg_q_188__reg/CLK 0.150
set_ccopt_property sink_type -pin i_croc_soc/i_croc/i_gpio/i_reg_file_new_reg_251__reg/CLK ignore

ccopt_design -cts

saveDesign SAVED/${STAGE}.invs
exec mkdir -p ./rpt/${STAGE}
report_ccopt_skew_groups -file ./rpt/${STAGE}/ccopt_skew_groups.rpt
report_ccopt_clock_trees -file ./rpt/${STAGE}/ccopt_clock_trees.rpt
#report_ccopt_worst_chain -file ./rpt/${STAGE}/ccopt_worst_chain.rpt
# run checkers
checkFPlan -reportUtil > rpt/${STAGE}/check_util.rpt
checkDesign -all > rpt/${STAGE}/check_design.rpt
checkPlace > rpt/${STAGE}/checkPlace.rpt
reportCongestion  -overflow  -includeBlockage  -hotSpot > rpt/${STAGE}/reportCongestion.rpt
# report timing
timeDesign -postCTS       -pathReports -slackReports -numPaths 1000 -prefix  croc_postCTS -outDir ./rpt/${STAGE}/${STAGE}_setup
timeDesign -postCTS -hold -pathReports -slackReports -numPaths 1000 -prefix  croc_postCTS -outDir ./rpt/${STAGE}/${STAGE}_hold

