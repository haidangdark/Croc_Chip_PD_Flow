############################
### report timing format ####
############################
set_table_style -no_frame_fix_width
set_global timing_report_enable_auto_column_width true
#set_global report_timing_format {instance arc cell delay incr_delay user_derate slew fanout load arrival instance_location}
#set_global report_timing_format {instance arc cell delay user_derate slew fanout load arrival instance_location}
#set_global report_timing_format {hpin cell fanout load slew delay user_derate total_derate arrival stage_count pin_location power_domain}
set_global report_timing_format {hpin cell fanout load slew delay arrival pin_location}
