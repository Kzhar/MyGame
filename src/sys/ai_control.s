.include "cmp/entity.h.s"

.module sys_ai_control

sys_ai_control_init::
	ld (_ent_array_prt_tmp_standby), IX
	ld (_ent_array_ptr), ix 	;me pasan en el init una sola vez el puntero al array y mediante código automodificable, inserto ese valor en el update
ret

;RUTINAS INTERNAS
sys_ai_stand_by:
			_ent_array_prt_tmp_standby =.+2	;
			ld iy, #0x0000				;MODIFICACIÓN TEMPORAL, USAMOS IY PARA NO PISAR IX NECESITAMOS LA PRIMERA ENTIDAD, LA DEL PLAYER
			ld a, e_ai_aim_X(iy)			;utilizamos e_ai_aim_x del player porque player no utiliza esa variable, y será la que modificaremos pulsando el espacio
			or a						;un or de algo consigo mismo da si mismo y cambia el flag
			ret z

			;PRESSED KEY, MOVER PLACEHOLDER
			ld a, e_x(iy)				;cargamos en a la posición del primer elemento del array de entidades, el player	
			ld e_ai_aim_X(ix), a			;cargamos en la variable de la posición objetivo de la entidad
			ld a, e_y(iy)				;|
			ld e_ai_aim_y(ix), a			;|lo mismo para la posición y del player en la posición y objetivo de la entidad

			ld e_ai_st(ix), #e_ai_st_move_to	;nuevo estado de la entidad, move_to
ret

sys_ai_move_to:

ret

sys_ai_control_update::
	ld(_ent_counter), a		;cargamos en el punto de la constante del contador de entidades por las que hay que ir iterando
	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
	ld ix, #0x0000

	_loop:
		ld a, e_ai_st(ix)		;status de ia
		cp #e_ai_st_noAI		;comparamos con la constante correspondiente a entidad sin ia (0)
		jr z, _no_AI_ent		;si no tiene AI simplemente pasamos a la siguiente entidad

		_AIent:
			cp #e_ai_st_stand_by	;comparamos la variable e_ai_st(status) con la constante de standby
			call z, sys_ai_stand_by	;vamos a la rutina de standby
			cp #e_ai_st_move_to	;comparamos la variable e_ai_st(status) con la constante de moveto
			call z, sys_ai_move_to

		_no_AI_ent:
		_ent_counter=.+1
			ld a, #0		;|
			dec a			;|
			ret z			;|si ya se ha pasado por todas las unidades se sale de la rurina	

			ld (_ent_counter), a	;|
			ld de, #sizeof_e		;|
			add ix, de			;|se pasa a la siguiente entidad

			jr _loop

ret