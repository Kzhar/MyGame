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



                              6 ;.include "cmp/array_structure.h.s"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              7 .include "sys/render.h.s"
                              1 .globl sys_eren_init
                              2 .globl sys_eren_update
                              3 .globl man_game_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "assets/assets.h.s"
                              1 .globl _pal_main
                              2 .globl _sp_mainchar
                              3 .globl _sp_redball
                              4 .globl _sp_sword
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 .include "sys/input.h.s"
                              1 .globl sys_input_init
                              2 .globl sys_input_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             10 .include "sys/ai_control.h.s"
                              1 .globl sys_ai_control_init
                              2 .globl sys_ai_control_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                             11 .include "sys/physics.h.s"
                              1 .globl sys_physics_init
                              2 .globl sys_pysics_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                             12 
                             13 ;Definimos una estructura con datos para player
   0000                      14 player: 	DefineCmp_Entity 0, 0, 1, 2, 4, 16, _sp_mainchar, e_ai_st_noAI
   40FC 00 00                 1 	.db 0, 0		;posición
   40FE 01 02                 2 	.db 1, 2	;velocidad
   4100 04 10                 3 	.db 4, 16		;tamaño
   4102 2C 40                 4 	.dw _sp_mainchar		;puntero a sprite
   4104 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   4106 00                    6 	.db e_ai_st_noAI		
   4107 CC CC                 7 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   000D                      15 redball: 	DefineCmp_Entity 70, 40, 0xFF, 0xFE, 2, 8, _sp_redball, e_ai_st_stand_by
   4109 46 28                 1 	.db 70, 40		;posición
   410B FF FE                 2 	.db 0xFF, 0xFE	;velocidad
   410D 02 08                 3 	.db 2, 8		;tamaño
   410F 0C 40                 4 	.dw _sp_redball		;puntero a sprite
   4111 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   4113 01                    6 	.db e_ai_st_stand_by		
   4114 CC CC                 7 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   001A                      16 sword:	DefineCmp_Entity 40, 120, 2, 0xFC, 3, 4, _sp_sword, e_ai_st_noAI
   4116 28 78                 1 	.db 40, 120		;posición
   4118 02 FC                 2 	.db 2, 0xFC	;velocidad
   411A 03 04                 3 	.db 3, 4		;tamaño
   411C 00 40                 4 	.dw _sp_sword		;puntero a sprite
   411E 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   4120 00                    6 	.db e_ai_st_noAI		
   4121 CC CC                 7 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   4123                      17 man_game_init::
   4123 CD CE 40      [17]   18 	call man_entity_init	;resetea el número de entidades a cero
                             19 
   4126 CD C6 40      [17]   20 	call man_entity_getArray		;en todos los init se utiliza código automodificable para cargar el puntero de la posición del inicio del array de entidades
   4129 CD 56 41      [17]   21 	call sys_ai_control_init	;|utilizamos getArray porque utilizamos el init para meter el puntero al array en ix en el update mediante CODAUTMOD
   412C CD D9 41      [17]   22 	call sys_input_init
   412F CD 2E 42      [17]   23 	call sys_physics_init
   4132 CD 7B 42      [17]   24 	call sys_eren_init
                             25 
                             26 
   4135 21 FC 40      [10]   27 	ld hl, #player
   4138 CD D9 40      [17]   28 	call man_entity_create	;copia los valores a los que apunta hl en el primer sitio libre para crear una nueva entidad
   413B 21 09 41      [10]   29 	ld hl, #redball
   413E CD D9 40      [17]   30 	call man_entity_create
   4141 21 16 41      [10]   31 	ld hl, #sword
   4144 CD D9 40      [17]   32 	call man_entity_create
   4147 C9            [10]   33 ret
                             34 
   4148                      35 man_game_update::
   4148 CD DE 41      [17]   36 	call sys_input_update
   414B CD B8 41      [17]   37 	call sys_ai_control_update
   414E CD 33 42      [17]   38 	call sys_pysics_update
   4151 C9            [10]   39 ret
                             40 
   4152                      41 man_game_render::
   4152 CD 94 42      [17]   42 	call sys_eren_update
   4155 C9            [10]   43 ret
                             44 
