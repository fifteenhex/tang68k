set_device GW5A-LV25MG121NES

set_option -verilog_std sysv2017
set_option -top_module top
set_option -use_cpu_as_gpio 1
set_option -use_sspi_as_gpio 1
set_option -use_ready_as_gpio 1
set_option -use_done_as_gpio 1

add_file dgprtl/hdmiintf.v

add_file dgprtl/resetgenerator.v
add_file gowin_pll/gowin_pll.v
add_file TG68K.C/tg68kdotc.v
add_file m68k_top.v

add_file dgprtl/gfx/bin2ascii.v
add_file dgprtl/gfx/hexbox.v
add_file dgprtl/gfx/window.v
add_file dgprtl/gfx/fontrom_gowin_prom.v
add_file dgprtl/gfx/fontrenderer.v
add_file dgprtl/gfx/textbox.v
add_file display.v


add_file chipselect.v
add_file dgprtl/mem/bramwrapper_singleport_gowin.v
add_file internalram.v
add_file bootrom.v
add_file configrom.v

add_file sdram.v

add_file dgprtl/mem/bramwrapper_dualport_gowin.v
add_file dgprtl/gfx/framebuffer_xy2addr.v
add_file dgprtl/gfx/framebuffer.v

add_file cpuaddr2xy.v

add_file top.v
add_file tang68k.cst
add_file tang68k.sdc

run all
