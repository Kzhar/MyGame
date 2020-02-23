ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .include "cmp/array_structure.h.s"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              2 
                              3 
                              4 ;define un array de _N entidades del tipo _DefineTypeMacroDefault
                              5 ;el símbolo ' se utiliza para concatenar nombres, por lo tanto los dos primeros elementos llevarán las etiquetas
                              6 ;con el nombre dado, en principio no habrá ningúna entidad porque solo se reserva sitio en memoria para las entidades
                              7 ;no las entidades en si. Para generan entidades en este hueco se utiliza otras rutinas => man_entity_create y man_entity_new
                              8 ;de man/entity.h.s
                              9 ;_Tname_pend (_entity_pend en este caso) guarda la dirección que apunta al lugar donde se debe crear la nueva entidad
                             10 ;es decir, al final del array
                             11 
                             12 .macro DefineComponentArrayStructure _Tname, _N, _DefineTypeMacroDefault
                             13 	_Tname'_num: .db 0
                             14 	_Tname'_pend: .dw _Tname'_array
                             15 	_Tname'_array:
                             16 	.rept _N
                             17 		_DefineTypeMacroDefault
                             18 	.endm
                             19 .endm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              2 
                              3 
                     0050     4 screen_width = 80
                     00C8     5 screen_height = 200
                              6 
   41E7                       7 sys_physics_init::
   41E7 C9            [10]    8 ret
                              9 
                             10 ;INPUT: 	IX POINTER TO ENTITY ARRAY
                             11 ;		A NUMBER OF ELEMENTS IN THE ARRAY
   41E8                      12 sys_pysics_update::
   41E8 47            [ 4]   13 	ld b, a	;b number of entities in the array
                             14 
   41E9                      15 _update_loop:
   41E9 3E 51         [ 7]   16 	ld a, #screen_width + 1
   41EB DD 96 04      [19]   17 	sub e_w(ix)
   41EE 4F            [ 4]   18 	ld c, a			;C = posición máxima de la entidad + 1
                             19 
   41EF DD 7E 00      [19]   20 	ld a, e_x(ix)		;A = Posición actual
   41F2 DD 86 02      [19]   21 	add e_vx(ix)		;A = Posición actual + velocidad
   41F5 B9            [ 4]   22 	cp c				;comparar con la posición maxima mas uno (si es la máxima daría cero)
   41F6 30 05         [12]   23 	jr nc, invalid_x
                             24 
   41F8                      25 	valid_x:
   41F8 DD 77 00      [19]   26 		ld e_x(ix), a	;cargar en e_x la nueva posición
   41FB 18 08         [12]   27 		jr endif_x
                             28 
   41FD                      29 	invalid_x:
   41FD DD 7E 02      [19]   30 		ld a, e_vx(ix)
   4200 ED 44         [ 8]   31 		neg
   4202 DD 77 02      [19]   32 		ld e_vx(ix), a		;se invierte la velocidad en x
                             33 
   4205                      34 	endif_x:
                             35 
   4205 3E C9         [ 7]   36 	ld a, #screen_height + 1
   4207 DD 96 05      [19]   37 	sub e_h(ix)
   420A 4F            [ 4]   38 	ld c, a				;C = posición máxima de la entidad + 1
                             39 
   420B DD 7E 01      [19]   40 	ld a, e_y(ix)
   420E DD 86 03      [19]   41 	add e_vy(ix)
   4211 B9            [ 4]   42 	cp c					;comparar con la posición máxima + 1 
   4212 30 05         [12]   43 	jr nc, invalid_y
                             44 
   4214                      45 	valid_y:
   4214 DD 77 01      [19]   46 		ld e_y(ix), a	;cargar en e_y la nueva posición
   4217 18 08         [12]   47 		jr endif_y
                             48 
   4219                      49 	invalid_y:
   4219 DD 7E 03      [19]   50 		ld a, e_vy(ix)
   421C ED 44         [ 8]   51 		neg
   421E DD 77 03      [19]   52 		ld e_vy(ix), a	;se invierte la velocidad en y
                             53 
   4221                      54 	endif_y:
                             55 
   4221 05            [ 4]   56 	dec b		;numero de entidades en el array
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   4222 C8            [11]   57 	ret z
                             58 
   4223 11 0D 00      [10]   59 	ld de, #sizeof_e
   4226 DD 19         [15]   60 	add ix, de			;ix apunta a la siguiente entidad
   4228 18 BF         [12]   61 	jr _update_loop
                             62 
                             63 
