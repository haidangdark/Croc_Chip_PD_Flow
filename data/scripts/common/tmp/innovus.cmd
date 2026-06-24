#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed Jul  2 11:58:42 2025                
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
setMultiCpuUsage -localCpu 32
restoreDesign /ictc/teacher_data/ictc_mynguyen/Downloads/eFPGA---RTL-to-GDS-with-SKY130-main/UoM_eFPGA/common/SAVED/cts_opt.invs.dat/ pm32
win
win
setLayerPreference node_layer -isVisible 0
zoomBox 99.96500 13.69700 104.16300 9.50000
zoomBox 99.40400 9.21300 104.39700 14.15100
zoomBox 94.89700 6.80400 106.15000 17.93300
fit
zoomBox 31.26300 3.60600 37.60900 -1.33000
fit
zoomBox 0.59000 100.73600 3.76300 96.68200
zoomBox -2.88900 96.15000 7.82700 100.91900
zoomBox -7.16200 91.70300 16.98800 102.45200
zoomOut
zoomOut
zoomBox -4.71500 71.50600 10.68900 64.88200
fit
zoomBox -5.22700 5.54500 21.74400 -2.91700
fit
zoomBox 98.77800 8.54200 105.83000 4.31100
selectInst WELLTAP_9
fit
deselectAll
selectInst _583_
deselectAll
selectInst WELLTAP_78
selectInstByCellName sky130_fd_sc_hd__tapvpwrvgnd_1
win
fit
highlight -index 1
deselectAll
win
fit
selectInst WELLTAP_18
