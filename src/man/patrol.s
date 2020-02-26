man_patrol_init::
ret

man_patrol_get::
	ld hl, #patrol_01			;HL puntero al comienzo del array
ret

patrol_01::
	.db 6 ,6 		;posiciones x e y de los waypoints
	.db 60, 40		
	.db 70, 120
	.db 2, 50
	.db patrol_invalid_move_x	;comprobando la posición x si aparece un -1 es el final del array y habrá que volver al principio
	.dw #patrol_01			;puntero al inicio del array


patrol_invalid_move_x == -1	