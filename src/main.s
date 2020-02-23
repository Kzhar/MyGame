
;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "man/game.h.s"
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared
.area _DATA
;; Start of _CODE area
.area _CODE

_main::
;; Disable firmware to prevent it from interfering with string drawing	 
call cpct_disableFirmware_asm
call man_game_init

loop:
	call man_game_update
	call cpct_waitVSYNC_asm
	call man_game_render
   jr    loop
