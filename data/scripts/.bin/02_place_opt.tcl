###############################
# Setup
###############################
#global STAGE 02_place_opt
set STAGE 02_place_opt


set report_dir rpt
set stage_rpt ${report_dir}/${STAGE}
#
#if {![info exist $report_dir]} {exec mkdir $report_dir}
if {[glob -nocomplain $stage_rpt] == ""} {exec mkdir $stage_rpt}


source ./data/scripts/common/common_settings.tcl ;# 
source ./data/scripts/common/user_settings.tcl ;# 
source ./data/scripts/common/config.tcl
###############################

#####################
## Placement
#####################


place_opt_design

#place_design
#
#timeDesign -preCTS -pathReports -slackReports -numPaths 1000 -prefix place_opt -outDir ./rpt/${STAGE}
#
#saveDesign SAVED/${STAGE}.invs
#return


# check legality
#checkPlace

setTieHiLoMode -reset
setTieHiLoMode -cell {sg13g2_tiehi sg13g2_tielo} -maxFanOut 10 -honorDontTouch false -createHierPort false
addTieHiLo -cell {sg13g2_tiehi sg13g2_tielo} -prefix TIE

saveDesign SAVED/${STAGE}.invs
timeDesign -preCTS -pathReports -slackReports -numPaths 1000 -prefix croc_place -outDir ./rpt/${STAGE}/${STAGE}_setup

