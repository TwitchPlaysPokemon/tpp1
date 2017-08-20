RGBDS := rgbds

ROMSIZE := 9
RAMSIZE := 5
ROMFLAGS := 7

REAL_ROMFLAGS := $(shell bash -c "echo $$((${ROMFLAGS} + 8))")

all: padder.c testrom/charmap.asm testrom/error_count.asm testrom/font.asm testrom/fontext.asm testrom/gbhw.asm testrom/hexentry.asm testrom/hram.asm testrom/interrupt.asm testrom/macros.asm testrom/main.asm testrom/math.asm testrom/memory_viewer.asm testrom/memory_viewer_loader.asm testrom/menu.asm testrom/menudata.asm testrom/mr_tests.asm testrom/printnum.asm testrom/ram_tests.asm testrom/random.asm testrom/rom.asm testrom/rom_tests.asm testrom/rst.asm testrom/rtc_display.asm testrom/rtc_set.asm testrom/rtc_tests.asm testrom/rtc_test_utils.asm testrom/rumble_tests.asm testrom/showinfo.asm testrom/strings.asm testrom/testing.asm testrom/text.asm testrom/util.asm testrom/wram.asm
	gcc -O3 padder.c -o padder
	cd rgbds && make
	cd testrom && ../${RGBDS}/rgbasm -o ../testrom.o rom.asm
	${RGBDS}/rgblink -o testrom.gb -p 0xff -n testrom.sym testrom.o
	./padder testrom.gb ${ROMSIZE}
	${RGBDS}/rgbfix -cjv -p 0xff -x 0x100 -r ${RAMSIZE} -m ${REAL_ROMFLAGS} -l 0x33 -k TP -t TPP1TESTROM -i TPP1 testrom.gb
	sort testrom.sym -o testrom.sym

clean:
	rm -rf testrom.o testrom.gb testrom.sym padder
