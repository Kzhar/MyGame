ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .include "cmp/entity.h.s"
                              1 
                              2 
                              3 .macro DefineCmp_Entity _x, _y, _vx, _vy, _w, _h, _pspr, _AIstatus
                              4 	.db _x, _y		;posición
                              5 	.db _vx, _vy	;velocidad
                              6 	.db _w, _h		;tamaño
                              7 	.dw _pspr		;puntero a sprite
                              8 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
                              9 	.db _AIstatus		
                             10 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
                             11 .endm
                             12 
                             13 
                             14 .macro DefineCmp_Entity_default
                             15 	DefineCmp_Entity 0, 0, 0, 0, 1, 1, 0x0000, e_ai_st_noAI
                             16 .endm
                             17 
                             18 ;;Definición de constantes: offsets de cada entidad para usar con ix
                             19 
                             20 
                     0000    21 e_x = 0		;posición x
                     0001    22 e_y = 1		;posición y
                     0002    23 e_vx = 2 		;velocidad en x
                     0003    24 e_vy = 3		;velocidad en y
                     0004    25 e_w = 4		;anchura del sprite en bytes
                     0005    26 e_h = 5		;altura del sprite en bytes
                     0006    27 e_pspr_l = 6	;byte bajo de la dirección de memoria del sprite
                     0007    28 e_pspr_h = 7	;byte alto de la dirección de memoria del sprite (primero el bajo porque es little endian)	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
                     0008    29 e_ai_aim_X = 8	;posición objetivo de las entidades que tienen ia y su status es moverse
                     0009    30 e_ai_aim_y = 9	;posición objetivo de las entidades que tienen ia y su status es moverse
                     000A    31 e_ai_st = 10
                     000B    32 e_lastVP_l = 11	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
                     000C    33 e_lastVP_h = 12	;en este byte se guarda en status de la ia (desde 0=no tiene ia hasta moverse o permanecer parado)
                     000D    34 sizeof_e = 13	;tamaño de los datos de la entidad en bytes (para calcular el punto al que mover el puntero para pasar de una entidad a otra)
                             35 	
                             36 ;;Creamos una enumeración de status de ia
                             37 
                     0000    38 e_ai_st_noAI = 0		;status no IA, el que cargará la definición del componente por defercto
                     0001    39 e_ai_st_stand_by = 1	;stand by
                     0002    40 e_ai_st_move_to = 2
                             41 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              2 
                              3 .module sys_ai_control
                              4 
   4157                       5 sys_ai_control_init::
   4157 DD 22 62 41   [20]    6 	ld (_ent_array_prt_tmp_standby), IX
   415B DD 22 78 41   [20]    7 	ld (_ent_array_ptr), ix 	;me pasan en el init una sola vez el puntero al array y mediante código automodificable, inserto ese valor en el update
   415F C9            [10]    8 ret
                              9 
                             10 ;RUTINAS INTERNAS
   4160                      11 sys_ai_stand_by:
                     000B    12 			_ent_array_prt_tmp_standby =.+2	;
   4160 FD 21 00 00   [14]   13 			ld iy, #0x0000				;MODIFICACIÓN TEMPORAL, USAMOS IY PARA NO PISAR IX NECESITAMOS LA PRIMERA ENTIDAD, LA DEL PLAYER
   4164 FD 7E 08      [19]   14 			ld a, e_ai_aim_X(iy)			;utilizamos e_ai_aim_x del player porque player no utiliza esa variable, y será la que modificaremos pulsando el espacio
   4167 B7            [ 4]   15 			or a						;un or de algo consigo mismo da si mismo y cambia el flag
   4168 C8            [11]   16 			ret z
                             17 
                             18 			;PRESSED KEY, MOVER
   4169 DD 36 02 FF   [19]   19 			ld e_vx(ix), #-1		;|PLACEHOLDER
   416D DD 36 03 FF   [19]   20 			ld e_vy(ix), #-1   	;|de momento solo cambiamos la velocidad de las entidades
   4171 C9            [10]   21 ret
                             22 
   4172                      23 sys_ai_move_to:
                             24 
   4172 C9            [10]   25 ret
                             26 
   4173                      27 sys_ai_control_update::
   4173 32 8C 41      [13]   28 	ld(_ent_counter), a		;cargamos en el punto de la constante del contador de entidades por las que hay que ir iterando
                     0021    29 	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
   4176 DD 21 00 00   [14]   30 	ld ix, #0x0000
                             31 
   417A                      32 	_loop:
   417A DD 7E 0A      [19]   33 		ld a, e_ai_st(ix)		;status de ia
   417D FE 00         [ 7]   34 		cp #e_ai_st_noAI		;comparamos con la constante correspondiente a entidad sin ia (0)
   417F 28 0A         [12]   35 		jr z, _no_AI_ent		;si no tiene AI simplemente pasamos a la siguiente entidad
                             36 
   4181                      37 		_AIent:
   4181 FE 01         [ 7]   38 			cp #e_ai_st_stand_by	;comparamos la variable e_ai_st(status) con la constante de standby
   4183 CC 60 41      [17]   39 			call z, sys_ai_stand_by	;vamos a la rutina de standby
   4186 FE 02         [ 7]   40 			cp #e_ai_st_move_to	;comparamos la variable e_ai_st(status) con la constante de moveto
   4188 CC 72 41      [17]   41 			call z, sys_ai_move_to
                             42 
   418B                      43 		_no_AI_ent:
                     0035    44 		_ent_counter=.+1
   418B 3E 00         [ 7]   45 			ld a, #0		;|
   418D 3D            [ 4]   46 			dec a			;|
   418E C8            [11]   47 			ret z			;|si ya se ha pasado por todas las unidades se sale de la rurina	
                             48 
   418F 32 8C 41      [13]   49 			ld (_ent_counter), a	;|
   4192 11 0D 00      [10]   50 			ld de, #sizeof_e		;|
   4195 DD 19         [15]   51 			add ix, de			;|se pasa a la siguiente entidad
                             52 
   4197 18 E1         [12]   53 			jr _loop
                             54 
   4199 C9            [10]   55 ret
