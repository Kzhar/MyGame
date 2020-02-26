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
   4103 00 00                 1 	.db 0, 0		;posición
   4105 01 02                 2 	.db 1, 2	;velocidad
   4107 04 10                 3 	.db 4, 16		;tamaño
   4109 2C 40                 4 	.dw _sp_mainchar		;puntero a sprite
   410B 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   410D 00                    6 	.db e_ai_st_noAI	;AI status
   410E 00                    7 	.db e_ai_st_noAI	;Previous AI status
   410F 00                    8 	.db 0x00		;Step, contador de waypoints
   4110 CC CC                 9 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   000F                      15 redball: 	DefineCmp_Entity 70, 40, 0xFF, 0xFE, 2, 8, _sp_redball, e_ai_st_stand_by
   4112 46 28                 1 	.db 70, 40		;posición
   4114 FF FE                 2 	.db 0xFF, 0xFE	;velocidad
   4116 02 08                 3 	.db 2, 8		;tamaño
   4118 0C 40                 4 	.dw _sp_redball		;puntero a sprite
   411A 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   411C 01                    6 	.db e_ai_st_stand_by	;AI status
   411D 01                    7 	.db e_ai_st_stand_by	;Previous AI status
   411E 00                    8 	.db 0x00		;Step, contador de waypoints
   411F CC CC                 9 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   001E                      16 sword:	DefineCmp_Entity 40, 120, 2, 0xFC, 3, 4, _sp_sword, e_ai_st_noAI
   4121 28 78                 1 	.db 40, 120		;posición
   4123 02 FC                 2 	.db 2, 0xFC	;velocidad
   4125 03 04                 3 	.db 3, 4		;tamaño
   4127 00 40                 4 	.dw _sp_sword		;puntero a sprite
   4129 00 00                 5 	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
   412B 00                    6 	.db e_ai_st_noAI	;AI status
   412C 00                    7 	.db e_ai_st_noAI	;Previous AI status
   412D 00                    8 	.db 0x00		;Step, contador de waypoints
   412E CC CC                 9 	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
   4130                      17 man_game_init::
   4130 CD D5 40      [17]   18 	call man_entity_init	;resetea el número de entidades a cero
                             19 
   4133 CD D0 40      [17]   20 	call man_entity_getArray		;en todos los init se utiliza código automodificable para cargar el puntero de la posición del inicio del array de entidades
   4136 CD 63 41      [17]   21 	call sys_ai_control_init	;|utilizamos getArray porque utilizamos el init para meter el puntero al array en ix en el update mediante CODAUTMOD
   4139 CD 22 42      [17]   22 	call sys_input_init
   413C CD 77 42      [17]   23 	call sys_physics_init
   413F CD C4 42      [17]   24 	call sys_eren_init
                             25 
                             26 
   4142 21 03 41      [10]   27 	ld hl, #player
   4145 CD E0 40      [17]   28 	call man_entity_create	;copia los valores a los que apunta hl en el primer sitio libre para crear una nueva entidad
   4148 21 12 41      [10]   29 	ld hl, #redball
   414B CD E0 40      [17]   30 	call man_entity_create
   414E 21 21 41      [10]   31 	ld hl, #sword
   4151 CD E0 40      [17]   32 	call man_entity_create
   4154 C9            [10]   33 ret
                             34 
   4155                      35 man_game_update::
   4155 CD 27 42      [17]   36 	call sys_input_update
   4158 CD C7 41      [17]   37 	call sys_ai_control_update
   415B CD 7C 42      [17]   38 	call sys_pysics_update
   415E C9            [10]   39 ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



                             40 
   415F                      41 man_game_render::
   415F CD DD 42      [17]   42 	call sys_eren_update
   4162 C9            [10]   43 ret
                             44 
