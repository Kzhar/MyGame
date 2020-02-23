ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;.area _DATA
                              2 ;;.area _CODE
                              3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              4 .include "man/entity.h.s"
                              1 .globl man_entity_init
                              2 .globl man_entity_create
                              3 .globl man_entity_new
                              4 .globl man_entity_getArray
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              5 .include "cmp/entity.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              6 .include "sys/render.h.s"
                              1 .globl sys_eren_init
                              2 .globl sys_eren_update
                              3 .globl man_game_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              7 .include "assets/assets.h.s"
                              1 .globl _pal_main
                              2 .globl _sp_mainchar
                              3 .globl _sp_redball
                              4 .globl _sp_sword
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "sys/input.h.s"
                              1 .globl sys_input_init
                              2 .globl sys_input_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 .include "sys/ai_control.h.s"
                              1 .globl sys_ai_control_init
                              2 .globl sys_ai_control_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             10 .include "sys/physics.h.s"
                              1 .globl sys_physics_init
                              2 .globl sys_pysics_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                             11 
                             12 ;Definimos una estructura con datos para player
   0000                      13 player: 	DefineCmp_Entity 0, 0, 1, 2, 4, 16, _sp_mainchar, e_ai_st_noAI
   40F1 00 00                 1 	.db 0, 0		;posición
   40F3 01 02                 2 	.db 1, 2	;velocidad
   40F5 04 10                 3 	.db 4, 16		;tamaño
   40F7 2C 40                 4 	.dw _sp_mainchar		;puntero a sprite
   40F9 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   40FB 00                    6 	.db e_ai_st_noAI		
   40FC CC CC                 7 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   000D                      14 redball: 	DefineCmp_Entity 70, 40, 0xFF, 0xFF, 2, 8, _sp_redball, e_ai_st_stand_by
   40FE 46 28                 1 	.db 70, 40		;posición
   4100 FF FF                 2 	.db 0xFF, 0xFF	;velocidad
   4102 02 08                 3 	.db 2, 8		;tamaño
   4104 0C 40                 4 	.dw _sp_redball		;puntero a sprite
   4106 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   4108 01                    6 	.db e_ai_st_stand_by		
   4109 CC CC                 7 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   001A                      15 sword:	DefineCmp_Entity 40, 120, 2, 0xFC, 3, 4, _sp_sword, e_ai_st_noAI
   410B 28 78                 1 	.db 40, 120		;posición
   410D 02 FC                 2 	.db 2, 0xFC	;velocidad
   410F 03 04                 3 	.db 3, 4		;tamaño
   4111 00 40                 4 	.dw _sp_sword		;puntero a sprite
   4113 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   4115 00                    6 	.db e_ai_st_noAI		
   4116 CC CC                 7 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   4118                      16 man_game_init::
   4118 CD C9 40      [17]   17 	call man_entity_init	;resetea el número de entidades a cero
                             18 
   411B CD C1 40      [17]   19 	call man_entity_getArray	;|	
   411E CD 57 41      [17]   20 	call sys_ai_control_init	;|utilizamos getArray porque utilizamos el init para meter el puntero al array en ix en el update mediante CODAUTMOD
   4121 CD 2A 42      [17]   21 	call sys_eren_init
   4124 CD 9A 41      [17]   22 	call sys_input_init
   4127 CD E7 41      [17]   23 	call sys_physics_init
                             24 
                             25 
   412A 21 F1 40      [10]   26 	ld hl, #player
   412D CD D4 40      [17]   27 	call man_entity_create	;copia los valores a los que apunta hl en el primer sitio libre para crear una nueva entidad
   4130 21 FE 40      [10]   28 	ld hl, #redball
   4133 CD D4 40      [17]   29 	call man_entity_create
   4136 21 0B 41      [10]   30 	ld hl, #sword
   4139 CD D4 40      [17]   31 	call man_entity_create
   413C C9            [10]   32 ret
                             33 
   413D                      34 man_game_update::
   413D CD C1 40      [17]   35 	call man_entity_getArray
   4140 CD 9B 41      [17]   36 	call sys_input_update
   4143 CD C1 40      [17]   37 	call man_entity_getArray	;¡¡¡¡de momento hay que pasar esto, puntero a entidades en ix ya no hace falta pasarlo, pero hasta próxima modificación si que hay que pasar número de entidades en a
   4146 CD 73 41      [17]   38 	call sys_ai_control_update
   4149 CD C1 40      [17]   39 	call man_entity_getArray
   414C CD E8 41      [17]   40 	call sys_pysics_update
   414F C9            [10]   41 ret
                             42 
   4150                      43 man_game_render::
   4150 CD C1 40      [17]   44 	call man_entity_getArray
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   4153 CD 3F 42      [17]   45 	call sys_eren_update
   4156 C9            [10]   46 ret
                             47 
