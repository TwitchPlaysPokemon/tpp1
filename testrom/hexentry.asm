HexadecimalEntry::
	; returns carry if cancelled or no carry if accepted
	ld a, l
	ldh [hHexEntryData], a
	ld a, h
	ldh [hHexEntryData + 1], a
	call CountHexDataEntries
	ldh [hHexEntryCount], a
	hlcoord 0, 14
	ld de, wSavedScreenData
	ld bc, SCREEN_WIDTH * 4
	rst CopyBytes
	xor a
	ldh [hHexEntryByte], a
	ldh [hHexEntryRow], a
	ldh [hHexEntryColumn], a
	dec a
	ldh [hHexEntryCurrent], a
	call UpdateHexDigits
	call DrawHexEntryMenu
	ld a, 3
	rst DelayFrames
.loop
	ld a, 12
	ldh [hVBlankLine], a
	call DelayFrame
	call GetMenuJoypad
	jr z, .loop
	cp MENU_UP
	jr c, .action
	cp MENU_START
	jr z, .done
	call UpdateHexEntryCursor
	jr .loop
.action
	call ExecuteHexEntryAction
	jr c, .done
	call UpdateHexDigits
	ld a, 2
	rst DelayFrames
	jr .loop
.done
	xor a
	ldh [hVBlankLine], a
	ld hl, wSavedScreenData
	decoord 0, 14
	ld bc, SCREEN_WIDTH * 4
	rst CopyBytes
	ldh a, [hHexEntryCount]
	ld c, a
	ldh a, [hHexEntryByte]
	cp c
	ret

CountHexDataEntries:
	ld de, 3
	ld c, d
	jr .handle_loop
.loop
	inc c
	add hl, de
.handle_loop
	ld a, [hli]
	or [hl]
	jr nz, .loop
.done
	ld a, c
	ret

DrawHexEntryMenu:
	ld hl, .hex_entry_menu_data
	decoord 0, 14
	ld bc, SCREEN_WIDTH * 4 - 4
	rst CopyBytes
	ret

.hex_entry_menu_data
	rept SCREEN_WIDTH
		db "<->"
	endr
	db "<RIGHT>0  3  6  9  C  F   "
	db " 1  4  7  A  D  back"
	db " 2  5  8  B  E  "

UpdateHexDigits:
	xor a
	ldh [hVBlankLine], a
	ld c, a
	ldh a, [hHexEntryByte]
	ld b, a
	ld hl, hHexEntryData
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .handle_initial_loop
.initial_loop
	call .print_byte
	inc c
.handle_initial_loop
	ld a, c
	cp b
	jr c, .initial_loop
	ldh a, [hHexEntryCount]
	sub b
	jr z, .finished_entry
	ld b, a
	inc hl
	inc hl
	call .print_current
.clear_loop
	dec b
	jr z, .done
	inc hl
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, "_"
	ld [de], a
	inc de
	ld [de], a
	jr .clear_loop
.done
	ld hl, .exit_string
.update_option
	decoord 16, 17
	rst CopyString
	ret

.finished_entry
	ld hl, .done_string
	jr .update_option

.exit_string
	db "exit<@>"
.done_string
	db "done<@>"

.print_byte
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	call PrintHexByte
	pop hl
	inc hl
	inc hl
	ret

.print_current
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ldh a, [hHexEntryCurrent]
	cp 16
	jr c, .print_digit
	ld a, "-"
	ld [de], a
	inc de
	ld a, "_"
	ld [de], a
	ret
.print_digit
	add a, "0"
	cp "9" + 1
	jr c, .true_digit
	add a, "A" - ("9" + 1)
.true_digit
	ld [de], a
	inc de
	ld a, "-"
	ld [de], a
	ret

UpdateHexEntryCursor:
	push af
	call CalculateCurrentCursorPosition
	ld [hl], " "
	pop af

	sub MENU_UP
	jr nz, .not_up
	ldh a, [hHexEntryRow]
	sub 1
	jr nc, .row_ok
	ld a, 2
.row_ok
	ldh [hHexEntryRow], a
	jr .done

.not_up
	dec a
	jr nz, .not_down
	ldh a, [hHexEntryRow]
	inc a
	cp 3
	jr c, .row_ok
	xor a
	jr .row_ok

.not_down
	dec a
	jr nz, .not_left
	ldh a, [hHexEntryColumn]
	sub 1
	jr nc, .col_ok
	ld a, 5
	jr .col_ok

.not_left
	dec a
	jr nz, .done
	ldh a, [hHexEntryColumn]
	inc a
	cp 6
	jr c, .col_ok
	xor a
.col_ok
	ldh [hHexEntryColumn], a
.done
	call CalculateCurrentCursorPosition
	ld [hl], "<RIGHT>"
	ret

CalculateCurrentCursorPosition:
	hlcoord 0, 15
	ldh a, [hHexEntryRow]
	ld bc, SCREEN_WIDTH
	rst AddNTimes
	ldh a, [hHexEntryColumn]
	ld c, a
	add a, a
	add a, c
	add a, l
	ld l, a
	ret nc
	inc h
	ret

CalculateCurrentCursorValue:
	; returns 16 for back, and 17 for OK/exit
	ldh a, [hHexEntryColumn]
	ld c, a
	ldh a, [hHexEntryRow]
	add a, c
	add a, c
	add a, c
	ret

ExecuteHexEntryAction:
	dec a
	jr nz, .back_button
	call CalculateCurrentCursorValue
	cp 16
	jr z, .back
	ccf
	ret c
	ld c, a
	ldh a, [hHexEntryByte]
	ld b, a
	ldh a, [hHexEntryCount]
	cp b
	ret z
	ldh a, [hHexEntryCurrent]
	cp 16
	jr c, .enter_byte
	ld a, c
	ldh [hHexEntryCurrent], a
	ret
.enter_byte
	swap a
	or c
	ld c, a
	ld e, b
	ld d, 0
	sla e
	rl d
	sla e
	rl d
	ld hl, hHexEntryData
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], c
	inc b
	ld a, $ff
	ldh [hHexEntryCurrent], a
	ld a, b
	ldh [hHexEntryByte], a
	ldh a, [hHexEntryCount]
	cp b
	ret nz
	call CalculateCurrentCursorPosition
	ld [hl], " "
	ld a, 2
	ldh [hHexEntryRow], a
	ld a, 5
	ldh [hHexEntryColumn], a
	ld a, "<RIGHT>"
	writecoord 15, 17
	ret

.cancel_current_byte
	ld a, $ff
	ldh [hHexEntryCurrent], a
	and a
	ret

.back_button
	ldh a, [hHexEntryByte]
	and a
	jr nz, .back
	ldh a, [hHexEntryCurrent]
	cp 16
	ccf
	ret c
.back
	ldh a, [hHexEntryByte]
	ld b, a
	and a
	jr z, .cancel_current_byte
	ldh a, [hHexEntryCurrent]
	cp 16
	jr c, .cancel_current_byte
	dec b
	ld a, b
	ldh [hHexEntryByte], a
	ld d, 0
	add a, a
	rl d
	add a, a
	rl d
	ld e, a
	ld hl, hHexEntryData
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	swap a
	and 15
	ldh [hHexEntryCurrent], a
	ret
