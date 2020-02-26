.include "cmp/entity.h.s"

.module sys_ai_control

sys_ai_control_init::
	ld (_ent_array_prt_tmp_standby), ix
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
			;ld a, e_x(iy)				;cargamos en a la posición del primer elemento del array de entidades, el player	
			;ld e_ai_aim_X(ix), a			;cargamos en la variable de la posición objetivo de la entidad
			;ld a, e_y(iy)				;|
			;ld e_ai_aim_y(ix), a			;|lo mismo para la posición y del player en la posición y objetivo de la entidad
			ld e_ai_patrol_step(ix), #0
			ld e_ai_pre_st(ix), #e_ai_st_stand_by
			ld e_ai_st(ix), #e_ai_st_patrol	;nuevo estado de la entidad, move_to
ret

sys_ai_move_to:
;COMPROBAR X ********************
	ld a, e_ai_aim_X(ix)			;a = objX
	sub e_x(ix)					;a = objX - x
	jr nc, _objx_greater_or_equal		;objX - x > 0 (objX > x)

	_objx_lesser:
		ld e_vx(ix), #-1			;move to the left
		jr _endif_x

	_objx_greater_or_equal:
		jr z, _arrived_x			;si es cero ya ha llegado al objetivo
		ld e_vx(ix), #1			;move to the right
		jr _endif_x

	_arrived_x:
		ld e_vx(ix), #0			;x velociti = 0

	_endif_x:
;COMPROBAR Y *********************
	ld a, e_ai_aim_y(ix)			;a = objX
	sub e_y(ix)					;a = objX - x
	jr nc, _objy_greater_or_equal		;objX - x > 0 (objX > x)

	_objy_lesser:
		ld e_vy(ix), #-2			
		jr _endif_y

	_objy_greater_or_equal:
		jr z, _arrived_y			;si es cero ya ha llegado al objetivo
		ld e_vy(ix), #2			
		jr _endif_y

	_arrived_y:
		ld e_vy(ix), #0			;x velociti = 0

		ld a, e_vx(ix)			;velociad de x
		or a					;comparar con cero
		jr nz, _endif_y	
				;si no es cero seguimos con el bucle
		ld a, e_ai_pre_st(ix)
		ld e_ai_st(ix), a ;si es cero (las dos son cero), cambiamos el status de la entidad a stand by
		ld e_ai_pre_st(ix), #e_ai_st_move_to

		_endif_y:

ret

sys_ai_control_update::
	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
	ld ix, #0x0000			;desde init se utiliza código automodificable para cargar en ix la posición constante del puntero al array de entidades

	_loop:
		ld a, e_w(ix)		;|
		or a				;|
		ret z				;|sw comprueva si la entidad es válida e_w(ix)!=0

		ld a, e_ai_st(ix)		;status de ia
		cp #e_ai_st_noAI		;comparamos con la constante correspondiente a entidad sin ia (0)
		jr z, _no_AI_ent		;si no tiene AI simplemente pasamos a la siguiente entidad

		_AIent:
			cp #e_ai_st_stand_by	;comparamos la variable e_ai_st(status) con la constante de standby
			call z, sys_ai_stand_by	;vamos a la rutina de standby
			cp #e_ai_st_move_to	;comparamos la variable e_ai_st(status) con la constante de moveto
			call z, sys_ai_move_to
			cp #e_ai_st_patrol	;comparamos la variable e_ai_st(status) con la constante de moveto
			call z, sys_ai_patrol

		_no_AI_ent:

			ld de, #sizeof_e		;|
			add ix, de			;|se pasa a la siguiente entidad

			jr _loop

sys_ai_patrol::
	ld a, e_ai_patrol_step(ix)
	cp #0
	jr z, _step0
	cp #1
	jr z, _step1

	_step0:
	ld e_ai_aim_X(ix), #6
	ld e_ai_aim_y(ix), #6
	ld e_ai_pre_st(ix), #e_ai_st_patrol
	ld e_ai_st(ix), #e_ai_st_move_to
	ld e_ai_patrol_step(ix), #1
	ret

	_step1:
	ld e_ai_aim_X(ix), #32
	ld e_ai_aim_y(ix), #40
	ld e_ai_pre_st(ix), #e_ai_st_patrol
	ld e_ai_st(ix), #e_ai_st_move_to
	ld e_ai_patrol_step(ix), #0
	ret

