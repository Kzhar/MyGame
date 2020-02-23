;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.8 #9946 (Linux)
;--------------------------------------------------------
	.module player01
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _sp_mainchar
	.globl _pal_main
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
	.area _CODE
_pal_main:
	.db #0x54	; 84	'T'
	.db #0x44	; 68	'D'
	.db #0x55	; 85	'U'
	.db #0x5c	; 92
	.db #0x4c	; 76	'L'
	.db #0x56	; 86	'V'
	.db #0x57	; 87	'W'
	.db #0x5e	; 94
	.db #0x40	; 64
	.db #0x4e	; 78	'N'
	.db #0x47	; 71	'G'
	.db #0x52	; 82	'R'
	.db #0x53	; 83	'S'
	.db #0x4a	; 74	'J'
	.db #0x43	; 67	'C'
	.db #0x4b	; 75	'K'
_sp_mainchar:
	.db #0x44	; 68	'D'
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0x44	; 68	'D'
	.db #0xc3	; 195
	.db #0xc3	; 195
	.db #0x00	; 0
	.db #0xcc	; 204
	.db #0xc3	; 195
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xc9	; 201
	.db #0xc3	; 195
	.db #0xae	; 174
	.db #0x82	; 130
	.db #0xc9	; 201
	.db #0xc3	; 195
	.db #0xc3	; 195
	.db #0x82	; 130
	.db #0xc9	; 201
	.db #0xc3	; 195
	.db #0xc3	; 195
	.db #0x82	; 130
	.db #0xc9	; 201
	.db #0xc3	; 195
	.db #0xc3	; 195
	.db #0x82	; 130
	.db #0x44	; 68	'D'
	.db #0xc3	; 195
	.db #0x92	; 146
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.db #0xc3	; 195
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2c	; 44
	.db #0x3c	; 60
	.db #0x69	; 105	'i'
	.db #0x00	; 0
	.db #0x2c	; 44
	.db #0x0c	; 12
	.db #0x49	; 73	'I'
	.db #0x00	; 0
	.db #0x2c	; 44
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x2c	; 44
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xcc	; 204
	.db #0x44	; 68	'D'
	.db #0x88	; 136
	.area _INITIALIZER
	.area _CABS (ABS)
