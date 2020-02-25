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
   4156                       5 sys_ai_control_init::
   4156 DD 22 61 41   [20]    6 	ld (_ent_array_prt_tmp_standby), ix
   415A DD 22 BA 41   [20]    7 	ld (_ent_array_ptr), ix 	;me pasan en el init una sola vez el puntero al array y mediante código automodificable, inserto ese valor en el update
   415E C9            [10]    8 ret
                              9 
                             10 ;RUTINAS INTERNAS
   415F                      11 sys_ai_stand_by:
                     000B    12 			_ent_array_prt_tmp_standby =.+2	;
   415F FD 21 00 00   [14]   13 			ld iy, #0x0000				;MODIFICACIÓN TEMPORAL, USAMOS IY PARA NO PISAR IX NECESITAMOS LA PRIMERA ENTIDAD, LA DEL PLAYER
   4163 FD 7E 08      [19]   14 			ld a, e_ai_aim_X(iy)			;utilizamos e_ai_aim_x del player porque player no utiliza esa variable, y será la que modificaremos pulsando el espacio
   4166 B7            [ 4]   15 			or a						;un or de algo consigo mismo da si mismo y cambia el flag
   4167 C8            [11]   16 			ret z
                             17 
                             18 			;PRESSED KEY, MOVER PLACEHOLDER
   4168 FD 7E 00      [19]   19 			ld a, e_x(iy)				;cargamos en a la posición del primer elemento del array de entidades, el player	
   416B DD 77 08      [19]   20 			ld e_ai_aim_X(ix), a			;cargamos en la variable de la posición objetivo de la entidad
   416E FD 7E 01      [19]   21 			ld a, e_y(iy)				;|
   4171 DD 77 09      [19]   22 			ld e_ai_aim_y(ix), a			;|lo mismo para la posición y del player en la posición y objetivo de la entidad
                             23 
   4174 DD 36 0A 02   [19]   24 			ld e_ai_st(ix), #e_ai_st_move_to	;nuevo estado de la entidad, move_to
   4178 C9            [10]   25 ret
                             26 
   4179                      27 sys_ai_move_to:
                             28 ;COMPROBAR X ********************
   4179 DD 7E 08      [19]   29 	ld a, e_ai_aim_X(ix)			;a = objX
   417C DD 96 00      [19]   30 	sub e_x(ix)					;a = objX - x
   417F 30 06         [12]   31 	jr nc, _objx_greater_or_equal		;objX - x > 0 (objX > x)
                             32 
   4181                      33 	_objx_lesser:
   4181 DD 36 02 FF   [19]   34 		ld e_vx(ix), #-1			;move to the left
   4185 18 0C         [12]   35 		jr _endif_x
                             36 
   4187                      37 	_objx_greater_or_equal:
   4187 28 06         [12]   38 		jr z, _arrived_x			;si es cero ya ha llegado al objetivo
   4189 DD 36 02 01   [19]   39 		ld e_vx(ix), #1			;move to the right
   418D 18 04         [12]   40 		jr _endif_x
                             41 
   418F                      42 	_arrived_x:
   418F DD 36 02 00   [19]   43 		ld e_vx(ix), #0			;x velociti = 0
                             44 
   4193                      45 	_endif_x:
                             46 ;COMPROBAR Y *********************
   4193 DD 7E 09      [19]   47 	ld a, e_ai_aim_y(ix)			;a = objX
   4196 DD 96 01      [19]   48 	sub e_y(ix)					;a = objX - x
   4199 30 06         [12]   49 	jr nc, _objy_greater_or_equal		;objX - x > 0 (objX > x)
                             50 
   419B                      51 	_objy_lesser:
   419B DD 36 03 FE   [19]   52 		ld e_vy(ix), #-2			
   419F 18 16         [12]   53 		jr _endif_y
                             54 
   41A1                      55 	_objy_greater_or_equal:
   41A1 28 06         [12]   56 		jr z, _arrived_y			;si es cero ya ha llegado al objetivo
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   41A3 DD 36 03 02   [19]   57 		ld e_vy(ix), #2			
   41A7 18 0E         [12]   58 		jr _endif_y
                             59 
   41A9                      60 	_arrived_y:
   41A9 DD 36 03 00   [19]   61 		ld e_vy(ix), #0			;x velociti = 0
                             62 
   41AD DD 7E 02      [19]   63 		ld a, e_vx(ix)			;velociad de x
   41B0 B7            [ 4]   64 		or a					;comparar con cero
   41B1 20 04         [12]   65 		jr nz, _endif_y			;si no es cero seguimos con el bucle
   41B3 DD 36 0A 01   [19]   66 			ld e_ai_st(ix), #e_ai_st_stand_by ;si es cero (las dos son cero), cambiamos el status de la entidad a stand by
                             67 
   41B7                      68 	_endif_y:
                             69 
   41B7 C9            [10]   70 ret
                             71 
   41B8                      72 sys_ai_control_update::
                     0064    73 	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
   41B8 DD 21 00 00   [14]   74 	ld ix, #0x0000			;desde init se utiliza código automodificable para cargar en ix la posición constante del puntero al array de entidades
                             75 
   41BC                      76 	_loop:
   41BC DD 7E 04      [19]   77 		ld a, e_w(ix)		;|
   41BF B7            [ 4]   78 		or a				;|
   41C0 C8            [11]   79 		ret z				;|sw comprueva si la entidad es válida e_w(ix)!=0
                             80 
   41C1 DD 7E 0A      [19]   81 		ld a, e_ai_st(ix)		;status de ia
   41C4 FE 00         [ 7]   82 		cp #e_ai_st_noAI		;comparamos con la constante correspondiente a entidad sin ia (0)
   41C6 28 0A         [12]   83 		jr z, _no_AI_ent		;si no tiene AI simplemente pasamos a la siguiente entidad
                             84 
   41C8                      85 		_AIent:
   41C8 FE 01         [ 7]   86 			cp #e_ai_st_stand_by	;comparamos la variable e_ai_st(status) con la constante de standby
   41CA CC 5F 41      [17]   87 			call z, sys_ai_stand_by	;vamos a la rutina de standby
   41CD FE 02         [ 7]   88 			cp #e_ai_st_move_to	;comparamos la variable e_ai_st(status) con la constante de moveto
   41CF CC 79 41      [17]   89 			call z, sys_ai_move_to
                             90 
   41D2                      91 		_no_AI_ent:
                             92 
   41D2 11 0D 00      [10]   93 			ld de, #sizeof_e		;|
   41D5 DD 19         [15]   94 			add ix, de			;|se pasa a la siguiente entidad
                             95 
   41D7 18 E3         [12]   96 			jr _loop
                             97 
                             98 ;ret
