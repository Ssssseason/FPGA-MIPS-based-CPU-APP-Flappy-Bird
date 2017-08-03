
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name OExp09-mcpu -dir "C:/computerorganization/OExp13/planAhead_run_2" -part xc7k160tffg676-2L
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/computerorganization/OExp13/Top_OExp12_MSOC.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/computerorganization/OExp13} {ipcore_dir} }
add_files [list {ipcore_dir/RAM_B.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "SOC-Sword.ucf" [current_fileset -constrset]
add_files [list {SOC-Sword.ucf}] -fileset [get_property constrset [current_run]]
link_design
