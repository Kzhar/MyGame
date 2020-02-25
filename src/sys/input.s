;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "cmp/entity.h.s"

;INPUT IX = POINTER TO ENTITY[0]
sys_input_init::
	ld (_ent_array_ptr), ix
ret

;UPDATE La actualización del sistema de input lo que hace es actualizar excusivamente
;la entidad "0" que es el player por defecto
;INPUT IX = POINTER TO ENTITY[0]

sys_input_update::
	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
	ld ix, #0x0000			;codigo automodificable desde el init

	ld e_vx(ix), #0
	ld e_vy(ix), #0	;ponemos velocidad y,x de la entidad a cero

	call cpct_scanKeyboard_f_asm

	ld hl, #Key_O			;A 16-bit value containing a Matrix-Line(1B, L) and a BitMask(1B, H).
	call cpct_isKeyPressed_asm	
	jr z, O_NotPressed

	O_pressed:
		ld e_vx(ix), #-1

	O_NotPressed:

	ld hl, #Key_P
	call cpct_isKeyPressed_asm	
	jr z, P_NotPressed

	P_pressed:
		ld e_vx(ix), #1

	P_NotPressed:

	ld hl, #Key_Q
	call cpct_isKeyPressed_asm	
	jr z, Q_NotPressed

	Q_pressed:
		ld e_vy(ix), #-2

	Q_NotPressed:

	ld hl, #Key_A
	call cpct_isKeyPressed_asm	
	jr z, A_NotPressed

	A_pressed:
		ld e_vy(ix), #2

	A_NotPressed:
		;PLACEHOLDER SI PRESIONAMOS UNA TECLA CAMBIAMOS EL COMPORTAMIENTO DEL SISTEMA DE IA DE LAS ENTIDADES CON IA
		ld e_ai_aim_X(ix), #0	;reiniciamos esta variable a 0 que será la que comprovaremos

	ld hl, #Key_Space
	call cpct_isKeyPressed_asm	
	jr z, spc_NotPressed
	spc_pressed:
		ld e_ai_aim_X(ix), #1	;cambiamos temporalmente el valor de esta variable para que la compruebe el sistema de IA 

	spc_NotPressed:
ret