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
   415B DD 22 BE 41   [20]    7 	ld (_ent_array_ptr), ix 	;me pasan en el init una sola vez el puntero al array y mediante código automodificable, inserto ese valor en el update
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
                             18 			;PRESSED KEY, MOVER PLACEHOLDER
   4169 FD 7E 00      [19]   19 			ld a, e_x(iy)				;cargamos en a la posición del primer elemento del array de entidades, el player	
   416C DD 77 08      [19]   20 			ld e_ai_aim_X(ix), a			;cargamos en la variable de la posición objetivo de la entidad
   416F FD 7E 01      [19]   21 			ld a, e_y(iy)				;|
   4172 DD 77 09      [19]   22 			ld e_ai_aim_y(ix), a			;|lo mismo para la posición y del player en la posición y objetivo de la entidad
                             23 
   4175 DD 36 0A 02   [19]   24 			ld e_ai_st(ix), #e_ai_st_move_to	;nuevo estado de la entidad, move_to
   4179 C9            [10]   25 ret
                             26 
   417A                      27 sys_ai_move_to:
                             28 ;COMPROBAR X ********************
   417A DD 7E 08      [19]   29 	ld a, e_ai_aim_X(ix)			;a = objX
   417D DD 96 00      [19]   30 	sub e_x(ix)					;a = objX - x
   4180 30 06         [12]   31 	jr nc, _objx_greater_or_equal		;objX - x > 0 (objX > x)
                             32 
   4182                      33 	_objx_lesser:
   4182 DD 36 02 FF   [19]   34 		ld e_vx(ix), #-1			;move to the left
   4186 18 0C         [12]   35 		jr _endif_x
                             36 
   4188                      37 	_objx_greater_or_equal:
   4188 28 06         [12]   38 		jr z, _arrived_x			;si es cero ya ha llegado al objetivo
   418A DD 36 02 01   [19]   39 		ld e_vx(ix), #1			;move to the right
   418E 18 04         [12]   40 		jr _endif_x
                             41 
   4190                      42 	_arrived_x:
   4190 DD 36 02 00   [19]   43 		ld e_vx(ix), #0			;x velociti = 0
                             44 
   4194                      45 	_endif_x:
                             46 ;COMPROBAR Y *********************
   4194 DD 7E 09      [19]   47 	ld a, e_ai_aim_y(ix)			;a = objX
   4197 DD 96 01      [19]   48 	sub e_y(ix)					;a = objX - x
   419A 30 06         [12]   49 	jr nc, _objy_greater_or_equal		;objX - x > 0 (objX > x)
                             50 
   419C                      51 	_objy_lesser:
   419C DD 36 03 FE   [19]   52 		ld e_vy(ix), #-2			
   41A0 18 16         [12]   53 		jr _endif_y
                             54 
   41A2                      55 	_objy_greater_or_equal:
   41A2 28 06         [12]   56 		jr z, _arrived_y			;si es cero ya ha llegado al objetivo
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   41A4 DD 36 03 02   [19]   57 		ld e_vy(ix), #2			
   41A8 18 0E         [12]   58 		jr _endif_y
                             59 
   41AA                      60 	_arrived_y:
   41AA DD 36 03 00   [19]   61 		ld e_vy(ix), #0			;x velociti = 0
                             62 
   41AE DD 7E 02      [19]   63 		ld a, e_vx(ix)			;velociad de x
   41B1 B7            [ 4]   64 		or a					;comparar con cero
   41B2 20 04         [12]   65 		jr nz, _endif_y			;si no es cero seguimos con el bucle
   41B4 DD 36 0A 01   [19]   66 			ld e_ai_st(ix), #e_ai_st_stand_by ;si es cero (las dos son cero), cambiamos el status de la entidad a stand by
                             67 
   41B8                      68 	_endif_y:
                             69 
   41B8 C9            [10]   70 ret
                             71 
   41B9                      72 sys_ai_control_update::
   41B9 32 D2 41      [13]   73 	ld(_ent_counter), a		;cargamos en el punto de la constante del contador de entidades por las que hay que ir iterando
                     0067    74 	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
   41BC DD 21 00 00   [14]   75 	ld ix, #0x0000
                             76 
   41C0                      77 	_loop:
   41C0 DD 7E 0A      [19]   78 		ld a, e_ai_st(ix)		;status de ia
   41C3 FE 00         [ 7]   79 		cp #e_ai_st_noAI		;comparamos con la constante correspondiente a entidad sin ia (0)
   41C5 28 0A         [12]   80 		jr z, _no_AI_ent		;si no tiene AI simplemente pasamos a la siguiente entidad
                             81 
   41C7                      82 		_AIent:
   41C7 FE 01         [ 7]   83 			cp #e_ai_st_stand_by	;comparamos la variable e_ai_st(status) con la constante de standby
   41C9 CC 60 41      [17]   84 			call z, sys_ai_stand_by	;vamos a la rutina de standby
   41CC FE 02         [ 7]   85 			cp #e_ai_st_move_to	;comparamos la variable e_ai_st(status) con la constante de moveto
   41CE CC 7A 41      [17]   86 			call z, sys_ai_move_to
                             87 
   41D1                      88 		_no_AI_ent:
                     007B    89 		_ent_counter=.+1
   41D1 3E 00         [ 7]   90 			ld a, #0		;|
   41D3 3D            [ 4]   91 			dec a			;|
   41D4 C8            [11]   92 			ret z			;|si ya se ha pasado por todas las unidades se sale de la rurina	
                             93 
   41D5 32 D2 41      [13]   94 			ld (_ent_counter), a	;|
   41D8 11 0D 00      [10]   95 			ld de, #sizeof_e		;|
   41DB DD 19         [15]   96 			add ix, de			;|se pasa a la siguiente entidad
                             97 
   41DD 18 E1         [12]   98 			jr _loop
                             99 
   41DF C9            [10]  100 ret
