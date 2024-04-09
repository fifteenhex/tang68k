bootrom.o: bootrom.s
	m68k-linux-gnu-gcc -o $@ -c $<

bootrom.elf: bootrom.o bootrom.lds
	m68k-linux-gnu-gcc -T bootrom.lds -nostdlib -Wl,-e_start -o $@ $<

bootrom.bin: bootrom.elf
	m68k-linux-gnu-objcopy -O binary $< $@

bootrom.bin.padded: bootrom.bin
	dd if=/dev/zero of=$@ bs=1 count=2048
	dd if=$< of=$@ conv=notrunc

bootrom.bin.gowin: bootrom.bin.padded
	i=0; \
	xxd -c 32 -p $< | \
	while read LINE; do \
		printf "defparam bram_prom_0.INIT_RAM_%02X = 256'h" $$i; \
		echo $$LINE | fold -w4 | tac | tr -d "\n"; \
		echo ";" ; \
		i=$$((i+1)); \
	done > $@
