.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "assets/assets.h.s"
.include "cmp/entity.h.s"
.include "man/entity.h.s"

screen_start = 0xC000

sys_eren_init::
	ld c, #0
	call cpct_setVideoMode_asm 	;pone el modo de video según el parámetro de c (0-3)

	ld hl, #_pal_main
	ld de, #16
	call cpct_setPalette_asm	;HL => colout array DE => number of colour to change

	cpctm_setBorder_asm HW_WHITE

ret

sys_eren_update::
	call sys_eren_render_entities
ret

sys_eren_render_entities::
	ld (_ent_counter), a	;codigo automodificable

	_update_loop:

	ld e, e_lastVP_l(ix)	;
	ld d, e_lastVP_h(ix)	;de posición antes del nuevo dibujado
	xor a				;a = 0 fondo negro
	ld c, e_w(ix)
	ld b, e_h(ix)
	push bc			;lo usaremos luego para dibujar el sprite
	call cpct_drawSolidBox_asm	;de => video memory pointer, a => 1 byte colour pattern, c => width b => height


	ld de, #screen_start
	ld c, e_x(ix)
	ld b, e_y(ix)
	call cpct_getScreenPtr_asm	;en HL => postition x y to video memory position

	ld e_lastVP_l(ix), l		;
	ld e_lastVP_h(ix), h		;guardamos la nueva posición de memoria de video en las variables de la entidad

	ex de,hl				;DE posición, en memoria de video del puntero donde pintar el sprite
	ld l, e_pspr_l(ix)
	ld h, e_pspr_h(ix)		;HL puntero al sprite
	pop bc				;BC tamaño del sptite
	call cpct_drawSprite_asm

	_ent_counter =.+1 		;constante que marca la posicíón de memoria a modificar para modificar el código
	ld a, #0				;en este caso cargaremos en a el número de entidades que quedan por renderizar
	dec a
	ret z					;si no queda ninguna por renderizar se sale del bucle

	ld (_ent_counter), a		;si no ahora la posición de ld ? (_ent counter) vale uno menos

	ld bc, #sizeof_e
	add ix, bc				;ix apunta a la siguente entidad y A => entidades pendientes de renderizar
	jr _update_loop			;volvemos al loop
