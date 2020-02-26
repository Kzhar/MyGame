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
                              9 	.db _AIstatus	;AI status
                             10 	.db _AIstatus	;Previous AI status
                             11 	.dw 0x0000		;puntero al array de waypoints
                             12 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
                             13 .endm
                             14 
                             15 
                             16 .macro DefineCmp_Entity_default
                             17 	DefineCmp_Entity 0, 0, 0, 0, 1, 1, 0x0000, e_ai_st_noAI
                             18 .endm
                             19 
                             20 ;;Definición de constantes: offsets de cada entidad para usar con ix
                             21 
                             22 
                     0000    23 e_x = 0		;posición x
                     0001    24 e_y = 1		;posición y
                     0002    25 e_vx = 2 		;velocidad en x
                     0003    26 e_vy = 3		;velocidad en y
                     0004    27 e_w = 4		;anchura del sprite en bytes
                     0005    28 e_h = 5		;altura del sprite en bytes
                     0006    29 e_pspr_l = 6	;byte bajo de la dirección de memoria del sprite
                     0007    30 e_pspr_h = 7	;byte alto de la dirección de memoria del sprite (primero el bajo porque es little endian)	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
                     0008    31 e_ai_aim_X = 8	;posición objetivo de las entidades que tienen ia y su status es moverse
                     0009    32 e_ai_aim_y = 9	;posición objetivo de las entidades que tienen ia y su status es moverse
                     000A    33 e_ai_st = 10	;status de la ia
                     000B    34 e_ai_pre_st = 11	;status previo de la ia para volver al estado anterior si es necesario
                     000C    35 e_ai_patrol_step_l = 12	;parte baja del puntero del array de waypoints
                     000D    36 e_ai_patrol_step_h = 13	;parte alta del puntero del array de waypoints
                     000E    37 e_lastVP_l = 14	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
                     000F    38 e_lastVP_h = 15	;en este byte se guarda en status de la ia (desde 0=no tiene ia hasta moverse o permanecer parado)
                     0010    39 sizeof_e = 16	;tamaño de los datos de la entidad en bytes (para calcular el punto al que mover el puntero para pasar de una entidad a otra)
                             40 	
                             41 ;;Creamos una enumeración de status de ia
                             42 
                     0000    43 e_ai_st_noAI = 0		;status no IA, el que cargará la definición del componente por defercto
                     0001    44 e_ai_st_stand_by = 1	;stand by
                     0002    45 e_ai_st_move_to = 2
                     0003    46 e_ai_st_patrol = 3
                             47 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              2 .include "man/patrol.h.s"
                              1 .globl patrol_invalid_move_x 
                              2 
                              3 .globl man_patrol_init
                              4 .globl man_patrol_get
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              3 
                              4 .module sys_ai_control
                              5 
   417E                       6 sys_ai_control_init::
   417E DD 22 89 41   [20]    7 	ld (_ent_array_prt_tmp_standby), ix
   4182 DD 22 E9 41   [20]    8 	ld (_ent_array_ptr), ix 	;me pasan en el init una sola vez el puntero al array y mediante código automodificable, inserto ese valor en el update
   4186 C9            [10]    9 ret
                             10 
                             11 ;RUTINAS INTERNAS
   4187                      12 sys_ai_stand_by:
                     000B    13 			_ent_array_prt_tmp_standby =.+2	;
   4187 FD 21 00 00   [14]   14 			ld iy, #0x0000				;MODIFICACIÓN TEMPORAL, USAMOS IY PARA NO PISAR IX NECESITAMOS LA PRIMERA ENTIDAD, LA DEL PLAYER
   418B FD 7E 08      [19]   15 			ld a, e_ai_aim_X(iy)			;utilizamos e_ai_aim_x del player porque player no utiliza esa variable, y será la que modificaremos pulsando el espacio
   418E B7            [ 4]   16 			or a						;un or de algo consigo mismo da si mismo y cambia el flag
   418F C8            [11]   17 			ret z
                             18 
                             19 			;PRESSED KEY, MOVER PLACEHOLDER
                             20 			;ld a, e_x(iy)				;cargamos en a la posición del primer elemento del array de entidades, el player	
                             21 			;ld e_ai_aim_X(ix), a			;cargamos en la variable de la posición objetivo de la entidad
                             22 			;ld a, e_y(iy)				;|
                             23 			;ld e_ai_aim_y(ix), a			;|lo mismo para la posición y del player en la posición y objetivo de la entidad
   4190 CD 6F 41      [17]   24 			call man_patrol_get			;en HL el puntero al primer elemento del array de waypoints de patrulla
   4193 DD 75 0C      [19]   25 			ld e_ai_patrol_step_l(ix), l		;|
   4196 DD 74 0D      [19]   26 			ld e_ai_patrol_step_h(ix), h		;|cargado en las variables de la entidad el puntero al array de waypoints
   4199 DD 36 0B 01   [19]   27 			ld e_ai_pre_st(ix), #e_ai_st_stand_by
   419D DD 36 0A 03   [19]   28 			ld e_ai_st(ix), #e_ai_st_patrol	;nuevo estado de la entidad, move_to
   41A1 C9            [10]   29 ret
                             30 
   41A2                      31 sys_ai_move_to:
                             32 ;COMPROBAR X ********************
   41A2 DD 7E 08      [19]   33 	ld a, e_ai_aim_X(ix)			;a = objX
   41A5 DD 96 00      [19]   34 	sub e_x(ix)					;a = objX - x
   41A8 30 06         [12]   35 	jr nc, _objx_greater_or_equal		;objX - x > 0 (objX > x)
                             36 
   41AA                      37 	_objx_lesser:
   41AA DD 36 02 FF   [19]   38 		ld e_vx(ix), #-1			;move to the left
   41AE 18 0C         [12]   39 		jr _endif_x
                             40 
   41B0                      41 	_objx_greater_or_equal:
   41B0 28 06         [12]   42 		jr z, _arrived_x			;si es cero ya ha llegado al objetivo
   41B2 DD 36 02 01   [19]   43 		ld e_vx(ix), #1			;move to the right
   41B6 18 04         [12]   44 		jr _endif_x
                             45 
   41B8                      46 	_arrived_x:
   41B8 DD 36 02 00   [19]   47 		ld e_vx(ix), #0			;x velociti = 0
                             48 
   41BC                      49 	_endif_x:
                             50 ;COMPROBAR Y *********************
   41BC DD 7E 09      [19]   51 	ld a, e_ai_aim_y(ix)			;a = objX
   41BF DD 96 01      [19]   52 	sub e_y(ix)					;a = objX - x
   41C2 30 06         [12]   53 	jr nc, _objy_greater_or_equal		;objX - x > 0 (objX > x)
                             54 
   41C4                      55 	_objy_lesser:
   41C4 DD 36 03 FE   [19]   56 		ld e_vy(ix), #-2			
   41C8 18 1C         [12]   57 		jr _endif_y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                             58 
   41CA                      59 	_objy_greater_or_equal:
   41CA 28 06         [12]   60 		jr z, _arrived_y			;si es cero ya ha llegado al objetivo
   41CC DD 36 03 02   [19]   61 		ld e_vy(ix), #2			
   41D0 18 14         [12]   62 		jr _endif_y
                             63 
   41D2                      64 	_arrived_y:
   41D2 DD 36 03 00   [19]   65 		ld e_vy(ix), #0			;x velociti = 0
                             66 
   41D6 DD 7E 02      [19]   67 		ld a, e_vx(ix)			;velociad de x
   41D9 B7            [ 4]   68 		or a					;comparar con cero
   41DA 20 0A         [12]   69 		jr nz, _endif_y	
                             70 				;si no es cero seguimos con el bucle
   41DC DD 7E 0B      [19]   71 		ld a, e_ai_pre_st(ix)
   41DF DD 77 0A      [19]   72 		ld e_ai_st(ix), a ;si es cero (las dos son cero), cambiamos el status de la entidad a stand by
   41E2 DD 36 0B 02   [19]   73 		ld e_ai_pre_st(ix), #e_ai_st_move_to
                             74 
   41E6                      75 		_endif_y:
                             76 
   41E6 C9            [10]   77 ret
                             78 
   41E7                      79 sys_ai_control_update::
                     006B    80 	_ent_array_ptr = .+2		;ld ix es una instrucción del juego extendido, por ellos la posición de 0x0000 será .+2
   41E7 DD 21 00 00   [14]   81 	ld ix, #0x0000			;desde init se utiliza código automodificable para cargar en ix la posición constante del puntero al array de entidades
                             82 
   41EB                      83 	_loop:
   41EB DD 7E 04      [19]   84 		ld a, e_w(ix)		;|
   41EE B7            [ 4]   85 		or a				;|
   41EF C8            [11]   86 		ret z				;|sw comprueva si la entidad es válida e_w(ix)!=0
                             87 
   41F0 DD 7E 0A      [19]   88 		ld a, e_ai_st(ix)		;status de ia
   41F3 FE 00         [ 7]   89 		cp #e_ai_st_noAI		;comparamos con la constante correspondiente a entidad sin ia (0)
   41F5 28 0F         [12]   90 		jr z, _no_AI_ent		;si no tiene AI simplemente pasamos a la siguiente entidad
                             91 
   41F7                      92 		_AIent:
   41F7 FE 01         [ 7]   93 			cp #e_ai_st_stand_by	;comparamos la variable e_ai_st(status) con la constante de standby
   41F9 CC 87 41      [17]   94 			call z, sys_ai_stand_by	;vamos a la rutina de standby
   41FC FE 02         [ 7]   95 			cp #e_ai_st_move_to	;comparamos la variable e_ai_st(status) con la constante de moveto
   41FE CC A2 41      [17]   96 			call z, sys_ai_move_to
   4201 FE 03         [ 7]   97 			cp #e_ai_st_patrol	;comparamos la variable e_ai_st(status) con la constante de moveto
   4203 CC 0D 42      [17]   98 			call z, sys_ai_patrol
                             99 
   4206                     100 		_no_AI_ent:
                            101 
   4206 11 10 00      [10]  102 			ld de, #sizeof_e		;|
   4209 DD 19         [15]  103 			add ix, de			;|se pasa a la siguiente entidad
                            104 
   420B 18 DE         [12]  105 			jr _loop
                            106 
   420D                     107 sys_ai_patrol::
   420D DD 6E 0C      [19]  108 	ld l, e_ai_patrol_step_l(ix)		;	
   4210 DD 66 0D      [19]  109 	ld h, e_ai_patrol_step_h(ix)		;cargamos en hl el puntero al waypoint actual
   4213 7E            [ 7]  110 	ld a, (hl)					;a = posición x del waypoint
   4214 FE FF         [ 7]  111 	cp #patrol_invalid_move_x		;si es -1 volvemos al primer punto del waypoint (guardado en las siguientes posiciones de memoria)
   4216 28 18         [12]  112 	jr z, _reset_patrol 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                            113 
   4218 DD 77 08      [19]  114 	ld e_ai_aim_X(ix), a			;metemos en las variables de la entidad las posiciones objetivo x e y del waypoint al que tiene que ir
   421B 23            [ 6]  115 	inc hl
   421C 7E            [ 7]  116 	ld a, (hl)
   421D DD 77 09      [19]  117 	ld e_ai_aim_y(ix), a
                            118 
   4220 23            [ 6]  119 	inc hl					;|
   4221 DD 75 0C      [19]  120 	ld e_ai_patrol_step_l(ix), l		;|
   4224 DD 74 0D      [19]  121 	ld e_ai_patrol_step_h(ix), h		;|una vez guardada la posición objetivo podemos guardar en la unidad el waypoint siguiente
                            122 
   4227 DD 36 0B 03   [19]  123 	ld e_ai_pre_st(ix), #e_ai_st_patrol	;estado actual pasa a estado previo
   422B DD 36 0A 02   [19]  124 	ld e_ai_st(ix), #e_ai_st_move_to	;nuevo estado => move to para la siguiente iretación
   422F C9            [10]  125 ret
                            126 
   4230                     127 _reset_patrol:
   4230 23            [ 6]  128 	inc hl 	;donde está guardada la posición de memoria del inicio del array
   4231 7E            [ 7]  129 	ld a, (hl)	;parte baja de la posición de memoria del inicio del array
   4232 23            [ 6]  130 	inc hl
   4233 66            [ 7]  131 	ld h, (hl)	;parte alta de la posición de memoria del inicio del array
   4234 DD 77 0C      [19]  132 	ld e_ai_patrol_step_l(ix), a		;|	
   4237 DD 74 0D      [19]  133 	ld e_ai_patrol_step_h(ix), h		;|puntero al comienzo del array de waypoitns
                            134 
   423A C9            [10]  135 ret
