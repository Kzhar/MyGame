.include "cmp/array_structure.h.s"


screen_width = 80
screen_height = 200

sys_physics_init::
	ld (_ent_array_ptr), ix
ret

;INPUT: 	IX POINTER TO ENTITY ARRAY
;		A NUMBER OF ELEMENTS IN THE ARRAY
sys_pysics_update::
	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
	ld ix, #0x0000			;
	;ld b, a	;b number of entities in the array

_update_loop:

	ld a, e_w(ix)
	or a
	ret z

	ld a, #screen_width + 1
	sub e_w(ix)
	ld c, a			;C = posición máxima de la entidad + 1

	ld a, e_x(ix)		;A = Posición actual
	add e_vx(ix)		;A = Posición actual + velocidad
	cp c				;comparar con la posición maxima mas uno (si es la máxima daría cero)
	jr nc, invalid_x

	valid_x:
		ld e_x(ix), a	;cargar en e_x la nueva posición
		jr endif_x

	invalid_x:
		ld a, e_vx(ix)
		neg
		ld e_vx(ix), a		;se invierte la velocidad en x

	endif_x:

	ld a, #screen_height + 1
	sub e_h(ix)
	ld c, a				;C = posición máxima de la entidad + 1

	ld a, e_y(ix)
	add e_vy(ix)
	cp c					;comparar con la posición máxima + 1 
	jr nc, invalid_y

	valid_y:
		ld e_y(ix), a	;cargar en e_y la nueva posición
		jr endif_y

	invalid_y:
		ld a, e_vy(ix)
		neg
		ld e_vy(ix), a	;se invierte la velocidad en y

	endif_y:

	;dec b		;numero de entidades en el array
	;ret z

	ld de, #sizeof_e
	add ix, de			;ix apunta a la siguiente entidad
	jr _update_loop


