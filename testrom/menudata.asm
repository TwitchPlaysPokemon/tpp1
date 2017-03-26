MainTestingMenu::
	menu "Main menu", MainTestingMenu
	option "ROM bank tests", OPTION_MENU, ROMTestingMenu
	option "RAM bank tests", OPTION_MENU, RAMTestingMenu
	option "RTC tests", OPTION_EXEC, NotImplemented
	option "Rumble tests", OPTION_EXEC, NotImplemented
	option "MR register tests", OPTION_EXEC, NotImplemented
	option "Reset", OPTION_EXEC, DoReset
	end_menu

ROMTestingMenu:
	menu "ROM bank tests", MainTestingMenu
	option "Test bank sample", OPTION_EXEC, TestROMBankSampleOption
	option "Test bank range", OPTION_EXEC, TestROMBankRangeOption
	option "Test all banks", OPTION_EXEC, TestAllROMBanksOption
	option "Back", OPTION_MENU, MainTestingMenu
	end_menu

RAMTestingMenu:
	menu "RAM bank tests", MainTestingMenu
	option "Initialize banks", OPTION_EXEC, InitializeRAMBanks
	option "Run all tests", OPTION_EXEC, NotImplemented
	option "Test reads R/O", OPTION_EXEC, TestRAMReadsReadOnlyOption
	option "Test reads R/W", OPTION_EXEC, TestRAMReadsReadWriteOption
	option "Write and verify", OPTION_EXEC, NotImplemented
	option "Test writes R/O", OPTION_EXEC, NotImplemented
	option "Write deselected", OPTION_EXEC, NotImplemented
	option "Swap banks desel.", OPTION_EXEC, NotImplemented
	option "Full test<COMMA> 1 bank", OPTION_EXEC, NotImplemented
	option "Full test<COMMA> range", OPTION_EXEC, NotImplemented
	option "Full test<COMMA> all", OPTION_EXEC, NotImplemented
	option "In-bank aliasing", OPTION_EXEC, NotImplemented
	option "Cross-bank alias.", OPTION_EXEC, NotImplemented
	option "Back", OPTION_MENU, MainTestingMenu
	end_menu

NotImplemented:
	ld hl, .text
	call MessageBox
	ld a, ACTION_UPDATE
	ld [hNextMenuAction], a
	ret

.text
	db "Not implemented.<@>"

DoReset:
	xor a
	ld hl, rMR3w
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], 1
	rst Reset
