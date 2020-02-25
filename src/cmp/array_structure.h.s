.include "cmp/entity.h.s"


;define un array de _N entidades del tipo _DefineTypeMacroDefault
;el símbolo ' se utiliza para concatenar nombres, por lo tanto los dos primeros elementos llevarán las etiquetas
;con el nombre dado, en principio no habrá ningúna entidad porque solo se reserva sitio en memoria para las entidades
;no las entidades en si. Para generan entidades en este hueco se utiliza otras rutinas => man_entity_create y man_entity_new
;de man/entity.h.s
;_Tname_pend (_entity_pend en este caso) guarda la dirección que apunta al lugar donde se debe crear la nueva entidad
;es decir, al final del array

.macro DefineComponentArrayStructure _Tname, _N, _DefineTypeMacroDefault
	_Tname'_num: .db 0
	_Tname'_pend: .dw _Tname'_array
	_Tname'_array:
	.rept _N
		_DefineTypeMacroDefault
	.endm
	.db #0xDE, #0xAD, #0x00, #0x00, #0x00			;se crean tres nuevos bytes al final del array de forma provisional 
.endm