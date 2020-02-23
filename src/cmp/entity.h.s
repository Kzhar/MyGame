

.macro DefineCmp_Entity _x, _y, _vx, _vy, _w, _h, _pspr, _AIstatus
	.db _x, _y		;posición
	.db _vx, _vy	;velocidad
	.db _w, _h		;tamaño
	.dw _pspr		;puntero a sprite
	.db 0x00, 0x00	;e_ai_aim_x y e_ai_aim_y posición objetivo a la que moverse
	.db _AIstatus		
	.dw #0xCCCC		;últia posición del sprite en memoria de video (para utilizarla para el borrado del sprite)
.endm


.macro DefineCmp_Entity_default
	DefineCmp_Entity 0, 0, 0, 0, 1, 1, 0x0000, e_ai_st_noAI
.endm

;;Definición de constantes: offsets de cada entidad para usar con ix


e_x = 0		;posición x
e_y = 1		;posición y
e_vx = 2 		;velocidad en x
e_vy = 3		;velocidad en y
e_w = 4		;anchura del sprite en bytes
e_h = 5		;altura del sprite en bytes
e_pspr_l = 6	;byte bajo de la dirección de memoria del sprite
e_pspr_h = 7	;byte alto de la dirección de memoria del sprite (primero el bajo porque es little endian)	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
e_ai_aim_X = 8	;posición objetivo de las entidades que tienen ia y su status es moverse
e_ai_aim_y = 9	;posición objetivo de las entidades que tienen ia y su status es moverse
e_ai_st = 10
e_lastVP_l = 11	;byte bajo de la posición de memoria de video antes de mover el sprite para su borrado
e_lastVP_h = 12	;en este byte se guarda en status de la ia (desde 0=no tiene ia hasta moverse o permanecer parado)
sizeof_e = 13	;tamaño de los datos de la entidad en bytes (para calcular el punto al que mover el puntero para pasar de una entidad a otra)
	
;;Creamos una enumeración de status de ia

e_ai_st_noAI = 0		;status no IA, el que cargará la definición del componente por defercto
e_ai_st_stand_by = 1	;stand by
e_ai_st_move_to = 2

