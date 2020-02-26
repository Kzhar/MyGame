ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



   416E                       1 man_patrol_init::
   416E C9            [10]    2 ret
                              3 
   416F                       4 man_patrol_get::
   416F 21 73 41      [10]    5 	ld hl, #patrol_01			;HL puntero al comienzo del array
   4172 C9            [10]    6 ret
                              7 
   4173                       8 patrol_01::
   4173 06 06                 9 	.db 6 ,6 		;posiciones x e y de los waypoints
   4175 3C 28                10 	.db 60, 40		
   4177 46 78                11 	.db 70, 120
   4179 02 32                12 	.db 2, 50
   417B FF                   13 	.db patrol_invalid_move_x	;comprobando la posición x si aparece un -1 es el final del array y habrá que volver al principio
   417C 73 41                14 	.dw #patrol_01			;puntero al inicio del array
                             15 
                             16 
                     FFFFFFFF    17 patrol_invalid_move_x == -1	
