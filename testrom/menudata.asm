MainTestingMenu::
	menu "Main menu", MainTestingMenu
	option "Run all tests", OPTION_EXEC, RunAllTests
	option "ROM bank tests", OPTION_MENU, ROMTestingMenu
	option "RAM bank tests", OPTION_CHECK, LoadRAMTestingMenu
	option "RTC tests", OPTION_CHECK, LoadRTCTestingMenu
	option "Rumble tests", OPTION_CHECK, LoadRumbleTestingMenu
	option "MR register tests", OPTION_MENU, MRTestingMenu
	option "Initial tests", OPTION_TEST, CheckInitialTests
	option "Memory viewer", OPTION_MENU, MemoryViewerMenu
	option "About", OPTION_EXEC, AboutBox
	option "System info", OPTION_EXEC, DisplaySystemInformation
	option "Reset", OPTION_EXEC, DoReset
	end_menu

ROMTestingMenu::
	menu "ROM bank tests", MainTestingMenu
	option "Run all tests", OPTION_TEST, RunAllROMTests
	option "Test bank sample", OPTION_EXEC, TestROMBankSampleOption
	option "Test bank range", OPTION_EXEC, TestROMBankRangeOption
	option "Test all banks", OPTION_TEST, TestAllROMBanks
	option "Bankswitch speed", OPTION_TEST, TestROMBankswitchSpeed, GoBackOption
GoBackOption:
	option "Back", OPTION_MENU, MainTestingMenu
	end_menu

RAMTestingMenu::
	menu "RAM bank tests", MainTestingMenu
	option "Initialize banks", OPTION_EXEC, InitializeRAMBanks
	option "Run all tests", OPTION_TEST, RunAllRAMTests
	option "Test reads R/O", OPTION_TEST, TestRAMReadsReadOnly
	option "Test reads R/W", OPTION_TEST, TestRAMReadsReadWrite
	option "Write and verify", OPTION_TEST, TestRAMWrites
	option "Test writes R/O", OPTION_TEST, TestRAMWritesReadOnly
	option "Write deselected", OPTION_TEST, TestRAMWritesDeselected
	option "Swap banks desel.", OPTION_TEST, TestSwapRAMBanksDeselected
	option "R/W test (1 bank)", OPTION_EXEC, TestOneRAMBankReadWriteOption
	option "R/W test (range)", OPTION_EXEC, TestRAMBankRangeReadWriteOption
	option "R/W test (all)", OPTION_EXEC, TestAllRAMBanksReadWriteOption
	option "In-bank aliasing", OPTION_TEST, TestRAMInBankAliasing
	option "Cross-bank alias.", OPTION_TEST, TestRAMCrossBankAliasing, GoBackOption

RTCTestingMenu::
	menu "RTC tests", MainTestingMenu
	option "Run all tests", OPTION_TEST, RunAllRTCTests
	option "On/off test", OPTION_TEST, RTCOnOffTest
	option "Setting test<COMMA> on", OPTION_TEST, RTCSetWhileOnTest
	option "Setting test<COMMA> off", OPTION_TEST, RTCSetWhileOffTest
	option "Rollovers test", OPTION_TEST, RTCRolloversTest
	option "Overflow test", OPTION_TEST, RTCOverflowTest
	option "Access time test", OPTION_TEST, RTCTimingTest
	option "Timing<COMMA> 1x speed", OPTION_CHECK, RTCSingleSpeedTiming
	option "Latching test", OPTION_TEST, RTCLatchTest
	option "Running flag test", OPTION_TEST, RTCRunningFlagTest
	option "MR4 writing test", OPTION_TEST, RTCWritingMR4Test
	option "Unmap&latch test", OPTION_TEST, RTCUnmapLatchTest
	option "Mirroring test<COMMA> R", OPTION_TEST, RTCMirroringTestRead
	option "Mirroring test<COMMA> W", OPTION_TEST, RTCMirroringTestWrite
	option "Set RTC manually", OPTION_EXEC, Timeset
	option "View RTC status", OPTION_EXEC, DisplayRTCState, GoBackOption

RumbleTestingMenu::
	menu "Rumble tests", MainTestingMenu
	option "Test MR4", OPTION_TEST, TestRumbleMR4
	option "Manual testing", OPTION_MENU, ManualRumbleSelection, GoBackOption

ManualRumbleSelection::
	menu "Rumble controls", RumbleTestingMenu
	option "Off", OPTION_EXEC, SetRumbleOff
	option "Low", OPTION_EXEC, SetRumbleLow
	option "Medium", OPTION_EXEC, SetRumbleMedium
	option "High", OPTION_EXEC, SetRumbleHigh
	option "Go to main menu", OPTION_MENU, MainTestingMenu
	option "Back", OPTION_MENU, RumbleTestingMenu
	end_menu

MRTestingMenu::
	menu "MR register tests", MainTestingMenu
	option "Run all tests", OPTION_TEST, RunAllMRTests
	option "Mapping test", OPTION_TEST, MRMappingTest
	option "Reading test", OPTION_TEST, MRReadingTest
	option "Writing test", OPTION_TEST, MRWritesTest
	option "Mirroring test<COMMA> R", OPTION_TEST, MRMirroringReadTest
	option "Mirroring test<COMMA> W", OPTION_TEST, MRMirroringWriteTest
	option "Restore values", OPTION_EXEC, RestoreMRValues, GoBackOption

MemoryViewerMenu::
	menu "Memory viewer", MainTestingMenu
	option "ROM viewer", OPTION_CHECK, ROMViewer
	option "RAM viewer/editor", OPTION_CHECK, RAMViewer, GoBackOption
