;;.area _DATA
;;.area _CODE

.include "man/entity.h.s"
.include "cmp/entity.h.s"
;.include "cmp/array_structure.h.s"
.include "sys/render.h.s"
.include "assets/assets.h.s"
.include "sys/input.h.s"
.include "sys/ai_control.h.s"
.include "sys/physics.h.s"

;Definimos una estructura con datos para player
player: 	DefineCmp_Entity 0, 0, 1, 2, 4, 16, _sp_mainchar, e_ai_st_noAI
redball: 	DefineCmp_Entity 70, 40, 0xFF, 0xFE, 2, 8, _sp_redball, e_ai_st_stand_by
sword:	DefineCmp_Entity 40, 120, 2, 0xFC, 3, 4, _sp_sword, e_ai_st_noAI
man_game_init::
	call man_entity_init	;resetea el número de entidades a cero

	call man_entity_getArray		;en todos los init se utiliza código automodificable para cargar el puntero de la posición del inicio del array de entidades
	call sys_ai_control_init	;|utilizamos getArray porque utilizamos el init para meter el puntero al array en ix en el update mediante CODAUTMOD
	call sys_input_init
	call sys_physics_init
	call sys_eren_init


	ld hl, #player
	call man_entity_create	;copia los valores a los que apunta hl en el primer sitio libre para crear una nueva entidad
	ld hl, #redball
	call man_entity_create
	ld hl, #sword
	call man_entity_create
ret

man_game_update::
	call sys_input_update
	call sys_ai_control_update
	call sys_pysics_update
ret

man_game_render::
	call sys_eren_update
ret

