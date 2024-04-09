include dgprtl/common.mk

sdram_extra_srcs=dgprtl/mem/sdram_chip_intf.v

all: chipselect.vcd sdram.vcd

TG68K.C/tg68kdotc.v:
	$(MAKE) -C TG68K.C/ tg68kdotc.v

top_extra_srcs=dgprtl/resetgenerator.v \
		dgprtl/gowin_SP.v \
		dgprtl/gowin_CLKDIV2.v \
		TG68K.C/tg68kdotc.v \
		m68k_top.v

test: top.vcd

doit:
	rm -rf impl
	LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libfreetype.so.6 ~/gowin/IDE/bin/gw_sh build.tcl

flashit:
	sudo openFPGALoader impl/pnr/project.fs

