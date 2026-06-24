#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Jul  5 14:18:32 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.10-p004_1 (64bit) 05/07/2020 20:02 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p004_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 05/07/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006
#@(#)CDS: IQuantus/TQuantus 19.1.3-s155 (64bit) Sun Nov 3 18:26:52 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
win off
setMultiCpuUsage -lo32
setMultiCpuUsage -localCpu 32
setPreference ConstraintUserXGrid 0.1
setPreference ConstraintUserXOffset 0.1
setPreference ConstraintUserYGrid 0.1
setPreference ConstraintUserYOffset 0.1
setPreference SnapAllCorners 1
set init_verilog /ictc/student_data/share/pd/data/user_setting/croc_chip_yosys.v
set init_design_uniquify 1
set init_design_settop 1
set init_top_cell croc_chip
set init_lef_file { /ictc/student_data/share/pd/data/user_setting/sg13g2_tech.lef  /ictc/student_data/share/pd/data/user_setting/sg13g2_stdcell_weltap.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_2048x64_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_4096x8_c3_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_4096x16_c3_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_64x64_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_1024x16_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_256x48_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_1024x64_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_1024x8_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_256x64_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/RM_IHPSG13_1P_512x64_c2_bm_bist.lef  /ictc/student_data/share/pd/data/user_setting/sg13g2_io_notracks.lef  /ictc/student_data/share/pd/data/user_setting/sg13g2_io.lef  /ictc/student_data/share/pd/data/user_setting/bondpad_70x70.lef  }
set init_mmmc_file /ictc/student_data/share/pd/data/user_setting/backup/croc_mmmc.view
set init_pwr_net VDD
set init_gnd_net VSS
init_design
saveDesign SAVED/00_init_design_init.invs
check_library -all_lib_cell -place > rpt/00_init_design/check_library.rpt
deleteRow -all
initCoreRow
cutRow
add_tracks -offset {Metal1 vert 0 Metal2 horiz 0 Metal3 vert 0 Metal4 horiz 0 Metal5 vert 0 TopMetal1 horiz 0 TopMetal2 vert 0}
checkFPlan -reportUtil > rpt/00_init_design/check_library.rpt
placeInstance {i_croc_soc/i_croc/gen_sram_bank[1].i_sram/gen_512x32xBx1.i_cut} -fixed {620.07 202.06}
placeInstance {i_croc_soc/i_croc/gen_sram_bank[0].i_sram/gen_512x32xBx1.i_cut} -fixed {620.07 335.84}
checkDesign -all > rpt/00_init_design/check_design.rpt
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override
win
win
fit
setLayerPreference allM1 -isVisible 0
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM3Cont -isVisible 1
setLayerPreference allM4Cont -isVisible 1
setLayerPreference allM5Cont -isVisible 1
setLayerPreference allM6Cont -isVisible 1
setLayerPreference allM7Cont -isVisible 1
setLayerPreference allM8Cont -isVisible 1
fit
editDelete -type Special -use POWER
globalNetConnect VDD -type pgpin -pin VDDARRAY -inst * -override
globalNetConnect VDD -type pgpin -pin VDDARRAY! -inst * -override
globalNetConnect VDD -type pgpin -pin VDD! -inst * -override
globalNetConnect VSS -type pgpin -pin VSS! -inst * -override
createRouteBlk -name sram_rblk -layer Metal5 -box {{610.07 192.06 1414.55 464.62}}
sroute -connect { blockPin corePin floatingStripe } -layerChangeRange { Metal1  TopMetal2 } -blockPinTarget { nearestRingStripe nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange {  Metal1 TopMetal2 } -nets {VDD VSS} -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1 TopMetal2 }
setAddStripeMode -reset
setAddStripeMode -stacked_via_top_layer Metal3 -stacked_via_bottom_layer Metal1 -stapling_nets_style side_to_side
addStripe -layer Metal3 -direction vertical -nets {VDD VSS} -width 1 -set_to_set_distance 10 -spacing 2 -start 0.5
setAddStripeMode -reset
setAddStripeMode -stacked_via_top_layer Metal4 -stacked_via_bottom_layer Metal3 -stapling_nets_style side_to_side
addStripe -layer Metal4 -direction horizontal -nets {VDD VSS} -width 1 -set_to_set_distance 10 -spacing 2 -start 0.5
setAddStripeMode -stacked_via_top_layer Metal5 -stacked_via_bottom_layer Metal4 -stapling_nets_style side_to_side
addStripe -layer Metal5 -direction vertical -nets {VDD VSS} -width 1 -set_to_set_distance 10 -spacing 2 -start 0.5
setAddStripeMode -stacked_via_top_layer TopMetal1 -stacked_via_bottom_layer Metal5 -stapling_nets_style side_to_side
addStripe -layer TopMetal1 -direction horizontal -nets {VDD VSS} -width 4 -set_to_set_distance 30 -spacing 4 -start 0.5
setAddStripeMode -stacked_via_top_layer TopMetal2 -stacked_via_bottom_layer TopMetal1 -stapling_nets_style side_to_side
addStripe -layer TopMetal2 -direction vertical -nets {VDD VSS} -width 4 -set_to_set_distance 30 -spacing 4
deleteRouteBlk -name sram_rblk
editPowerVia -nets VDD -add_vias true -top_layer TopMetal1 -area {{610.07 192.06 1414.55 464.62}} -uda -orthogonal_only
editPowerVia -nets VSS -add_vias true -top_layer TopMetal1 -area {{610.07 192.06 1414.55 464.62}} -uda -orthogonal_only
win
editDelete -type Special -use POWER
globalNetConnect VDD -type pgpin -pin VDDARRAY -inst * -override
globalNetConnect VDD -type pgpin -pin VDDARRAY! -inst * -override
globalNetConnect VDD -type pgpin -pin VDD! -inst * -override
globalNetConnect VSS -type pgpin -pin VSS! -inst * -override
createRouteBlk -name sram_rblk -layer Metal5 -box {{610.07 192.06 1414.55 464.62}}
sroute -connect { blockPin corePin floatingStripe } -layerChangeRange { Metal1  TopMetal2 } -blockPinTarget { nearestRingStripe nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange {  Metal1 TopMetal2 } -nets {VDD VSS} -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1 TopMetal2 }
setAddStripeMode -reset
setAddStripeMode -stacked_via_top_layer Metal3 -stacked_via_bottom_layer Metal1 -stapling_nets_style side_to_side
addStripe -layer Metal3 -direction vertical -nets {VDD VSS} -width 1 -set_to_set_distance 15 -spacing 2 -start 0.5
setAddStripeMode -reset
setAddStripeMode -stacked_via_top_layer Metal4 -stacked_via_bottom_layer Metal3 -stapling_nets_style side_to_side
addStripe -layer Metal4 -direction horizontal -nets {VDD VSS} -width 1 -set_to_set_distance 15 -spacing 2 -start 0.5
setAddStripeMode -stacked_via_top_layer Metal5 -stacked_via_bottom_layer Metal4 -stapling_nets_style side_to_side
addStripe -layer Metal5 -direction vertical -nets {VDD VSS} -width 1 -set_to_set_distance 15 -spacing 2 -start 0.5
setAddStripeMode -stacked_via_top_layer TopMetal1 -stacked_via_bottom_layer Metal5 -stapling_nets_style side_to_side
addStripe -layer TopMetal1 -direction horizontal -nets {VDD VSS} -width 4 -set_to_set_distance 30 -spacing 4 -start 0.5
setAddStripeMode -stacked_via_top_layer TopMetal2 -stacked_via_bottom_layer TopMetal1 -stapling_nets_style side_to_side
addStripe -layer TopMetal2 -direction vertical -nets {VDD VSS} -width 4 -set_to_set_distance 30 -spacing 4
win
fit
setLayerPreference node_layer -isVisible 1
zoomBox 552.92800 465.58300 798.16400 331.20700
zoomBox 633.77000 443.78400 679.83700 404.49200
selectWire 180.0000 420.5000 1460.0000 424.5000 6 VDD
setLayerPreference node_layer -isVisible 0
setLayerPreference TopVia1 -isVisible 1
setLayerPreference Metal5 -isVisible 1
setLayerPreference Via4 -isVisible 1
setLayerPreference TopMetal1 -isVisible 1
zoomBox 612.28700 386.75200 687.30000 460.93600
zoomBox 590.90300 372.21300 694.72800 474.89100
zoomBox 561.30700 352.09000 705.01000 494.20500
zoomBox 494.29300 306.52700 728.29000 537.93800
verify_connectivity -net {VDD VSS}
win
fit
deselectAll
fit
win
setLayerPreference node_layer -isVisible 1
zoomBox 544.52900 482.38000 699.06200 388.31700
zoomBox 616.19000 459.60900 644.04100 417.21900
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
deselectAll
selectWire 180.2200 444.5600 609.6000 445.0000 1 VDD
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
zoomBox 576.33300 394.23300 727.55600 475.44000
zoomBox 571.04900 385.74600 748.95900 481.28400
zoomBox 548.91300 350.19700 838.61300 505.76600
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
fit
deselectAll
saveDesign SAVED/00_init_design_PG.invs
win
fit
setLayerPreference node_layer -isVisible 0
setLayerPreference allM1 -isVisible 1
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM8Cont -isVisible 0
setLayerPreference allM2 -isVisible 1
setLayerPreference allM2Cont -isVisible 1
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM8Cont -isVisible 0
zoomBox 621.79500 962.77500 796.48400 788.08600
setLayerPreference allM3 -isVisible 1
setLayerPreference allM2Cont -isVisible 1
setLayerPreference allM3Cont -isVisible 1
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM8Cont -isVisible 0
zoomBox 690.59700 893.48500 720.20000 864.53300
zoomBox 703.13400 882.32500 711.22100 876.66400
zoomBox 700.77500 876.19900 713.17700 882.85900
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
gui_select -rect {708.22900 880.08100 710.03900 878.90300}
deselectAll
setEditMode -snap false
uiSetTool copy
zoomBox 701.56000 876.69600 712.10200 882.35700
editCopy -2.98 0.011 -keep_net_name
zoomBox 702.23000 877.10700 711.19100 881.91900
zoomBox 702.79900 877.45600 710.41700 881.54700
zoomBox 704.04400 878.22000 708.72300 880.73300
uiSetTool move
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1457.8200 -1 3 7
uiSetTool select
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
setLayerPreference node_inst -isVisible 0
deselectAll
selectMarker 180.0000 180.1800 1460.0000 1458.0400 -1 3 7
setLayerPreference node_inst -isVisible 1
setLayerPreference violation -isVisible 0
deselectAll
gui_select -rect {706.88800 879.98900 705.17100 879.17900}
uiSetTool move
uiSetTool select
deselectAll
selectWire 180.2200 879.2600 1459.6800 879.7000 1 VSS
deselectAll
gui_select -rect {706.68700 879.88100 705.26000 879.15600}
uiSetTool move
editMove -dx -0.014 -dy 0
uiSetTool select
zoomBox 701.61200 876.92900 710.57900 881.74400
zoomBox 699.66000 875.89200 712.07000 882.55600
zoomBox 693.21600 872.47100 716.99100 885.23800
zoomBox 690.83700 871.20800 718.80800 886.22800
zoomBox 680.87100 865.91600 726.41800 890.37500
zoomBox 676.31300 863.49700 729.89800 892.27200
zoomBox 657.22000 853.36200 744.47700 900.21900
zoomBox 626.13200 836.85900 768.21600 913.15800
zoomBox 611.91500 829.31100 779.07300 919.07500
fit
zoomBox -859.70200 -82.00000 2499.70200 1722.00000
deselectAll
setLayerPreference node_layer -isVisible 1
setLayerPreference node_layer -isVisible 0
setLayerPreference Metal4 -isVisible 1
setLayerPreference Via4 -isVisible 1
setLayerPreference Metal5 -isVisible 1
zoomBox 477.34100 841.83600 557.96700 744.41300
zoomBox 495.70200 807.54700 514.75100 786.14000
zoomBox 483.43700 784.09300 530.33600 809.27800
zoomBox 478.68200 778.85200 543.59300 813.70900
zoomBox 471.94900 771.72100 561.79300 819.96700
zoomBox 456.70600 755.57600 603.00200 834.13700
zoomBox 420.40000 717.26100 700.66200 867.76200
zoomBox 406.79800 703.11600 736.51900 880.17600
zoomBox 390.79700 686.47500 778.70400 894.78100
gui_select -rect {445.49200 837.75900 552.94200 745.43700}
deleteSelectedFromFPlan
setLayerPreference node_layer -isVisible 1
setLayerPreference node_layer -isVisible 0
setLayerPreference Metal3 -isVisible 1
setLayerPreference Via3 -isVisible 1
setLayerPreference Metal4 -isVisible 1
fit
zoomBox 1219.76900 1339.02800 1340.70800 1214.73000
zoomBox 1279.54400 1317.50200 1317.04200 1287.87400
zoomBox 1267.41400 1284.49500 1332.32500 1319.35200
zoomBox 1239.62000 1256.21200 1385.91800 1334.77400
zoomBox 1230.71300 1247.22700 1402.82800 1339.65300
gui_select -rect {1270.64400 1312.63100 1312.81200 1288.01800}
deleteSelectedFromFPlan
fit
zoomBox 232.10400 411.83200 490.77800 294.25300
zoomBox 334.02200 371.02000 362.47600 350.06700
zoomBox 331.27300 350.99800 364.43900 368.80800
zoomBox 333.44200 351.78800 361.63300 366.92700
selectWire 345.5000 180.1800 346.5000 1457.8200 3 VDD
zoomBox 335.37700 352.60800 359.34200 365.47700
zoomBox 338.42200 353.89700 355.73800 363.19600
deselectAll
selectWire 345.5000 180.1800 346.5000 1457.8200 3 VDD
uiSetTool copy
editCopy 2.979 -0.052 -keep_net_name
uiSetTool select
deselectAll
zoomBox 336.77700 353.28300 357.15000 364.22300
zoomBox 334.84300 352.56000 358.81100 365.43100
fit
uiSetTool select
fit
zoomBox 490.77800 247.22200 551.24800 206.90900
fit
zoomBox 561.32600 203.54900 601.63900 180.03400
fit
zoomBox 568.04500 274.09700 662.10800 133.00200
zoomBox 578.02900 190.54400 607.45700 170.04900
zoomBox 585.26200 183.71200 592.17000 178.14000
selectWire 588.5000 180.1800 589.5000 1457.8200 3 VSS
uiSetTool move
uiSetTool select
deselectAll
selectWire 588.5000 180.1800 589.5000 1457.8200 3 VSS
uiSetTool move
editResize -direction y -offset 0.063 -side low -no_conn 1
uiSetTool select
deselectAll
zoomBox 582.24300 177.46100 594.45000 184.01600
zoomBox 574.39600 173.32700 597.78100 185.88500
fit
zoomBox 470.62200 233.78400 524.37200 183.39300
fit
zoomBox 171.63500 297.61300 225.38600 240.50300
zoomBox 178.51600 262.51700 185.53500 252.73300
selectWire 180.0000 258.5000 619.1700 259.5000 4 VSS
uiSetTool move
editResize -direction x -offset 0.037 -side low -no_conn 1
uiSetTool select
deselectAll
fit
setLayerPreference violation -isVisible 1
zoomBox 309.37100 1463.32600 433.66900 1392.77800
zoomBox 343.01200 1458.85900 356.93800 1452.15900
selectMarker 180.0000 180.1800 1460.0000 1457.8200 -1 3 7
setLayerPreference violation -isVisible 0
deselectAll
selectWire 180.0000 1455.5000 1460.0000 1456.5000 4 VDD
deselectAll
win
fit
zoomBox 484.06000 253.94000 662.10800 116.20500
zoomBox 498.95800 186.48300 520.24700 175.71100
selectWire 510.5000 180.1800 511.5000 1457.8200 3 VDD
deselectAll
selectWire 513.5000 180.1800 514.5000 1457.8200 3 VSS
deselectAll
uiSetTool cutWire
editCutWire -only_visible_wires -line { 506.43 184.918 506.43 182.64 }
uiSetTool select
fit
win off
saveDesign SAVED/00_init_design_PG.invs
addWellTap -cell sky130_fd_sc_hd__tapvpwrvgnd_1 -cellInterval 40 -inRowOffset 25 -prefix WELLTAP
win
win
fit
setLayerPreference node_layer -isVisible 1
setLayerPreference node_layer -isVisible 0
zoomBox 551.24800 905.66500 756.17100 744.41300
zoomBox 631.48900 833.29700 654.61000 817.68200
zoomBox 641.97300 827.56900 646.48000 824.13700
setLayerPreference allM1 -isVisible 1
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM8Cont -isVisible 0
zoomBox 635.31500 821.72000 652.26800 830.82400
setLayerPreference allM1 -isVisible 0
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM8Cont -isVisible 0
win
selectInst WELLTAP_4065
setLayerPreference Cont -isVisible 1
setLayerPreference Metal1 -isVisible 1
deselectAll
setLayerPreference allM1 -isVisible 0
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM8Cont -isVisible 0
zoomBox 631.30300 820.06600 654.76900 832.66700
zoomBox 618.06600 814.60800 663.02000 838.74800
zoomBox 607.43000 810.22200 669.65000 843.63400
win off
saveDesign SAVED/00_init_design_PG.invs
