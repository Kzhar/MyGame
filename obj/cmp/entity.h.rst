ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



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
                             11 	.db 0x00		;Step, contador de waypoints
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
                     000A    33 e_ai_st = 10
                     000B    34 e_ai_pre_st = 11
                     000C    35 e_ai_patrol_step = 12
                     000D    36 e_lastVP_l = 13	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
                     000E    37 e_lastVP_h = 14	;en este byte se guarda en status de la ia (desde 0=no tiene ia hasta moverse o permanecer parado)
                     000F    38 sizeof_e = 15	;tamaño de los datos de la entidad en bytes (para calcular el punto al que mover el puntero para pasar de una entidad a otra)
                             39 	
                             40 ;;Creamos una enumeración de status de ia
                             41 
                     0000    42 e_ai_st_noAI = 0		;status no IA, el que cargará la definición del componente por defercto
                     0001    43 e_ai_st_stand_by = 1	;stand by
                     0002    44 e_ai_st_move_to = 2
                     0003    45 e_ai_st_patrol = 3
                             46 
