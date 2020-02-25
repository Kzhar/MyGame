;;.area _DATA
;;.area _CODE

.include "cmp/array_structure.h.s"
.include "cpctelera.h.s"

;;constantes
max_entities == #05 ;numero máximo de entidades que se pueden crear

;Macro para crear la estructura de entidades vacía (nombre, número máximo de entidades y llamada
;a la macro que crea las entidades vacías)
;la macro DefineCmp_Entity_default se encuentra en el fichero cmp/entity.h.s donde se encuentran las macros de creación de entidades vacías
;la macro DefineComponentArrayStructure se encuentra en el fichero cmp/array_structure.h.s y crea toda la estructura de entidades vacías

DefineComponentArrayStructure  _entity, max_entities, DefineCmp_Entity_default

;Para trabajar con entidades se necesita poner el puntero ix en el comienzo del array de entidades
;RETURN a número de entidades
man_entity_getArray::
	ld ix, #_entity_array
	ld a, (_entity_num)
ret

;se resetea el número de entidades a cero y se situa al principio del array el puntero _entity_pend
;puntero que señala al byte donde se debe crear la nueva entidad (en este caso al principio) 
man_entity_init::
	xor a				;a=0
	ld (_entity_num), a	;iniciamos el número de unidades creadas a cero

	ld hl, #_entity_array	;hl apunta a la primera posición del array de entidades
	ld (_entity_pend), hl	;posición donde se creará la siguiente entidad => primera posición del array

ret


;INPUT HL => PUNTERO A VALORES DE INICIALIZACIÓN DE LA ENTIDAD A CREAR
;RETURN ix => PUNTERO A LA ENTIDAD CREADA
man_entity_create::
	push hl			;man_entity_new destruye hl
	call man_entity_new

	ld__ixh_d
	ld__ixl_e	;instrucciones no comentadas de CPC (macro de cpctelera) ix = de puntero a la entidad añadida

	pop hl
	ldir		;copia array hl en array de (tamaño del array bc)

ret

;se añade uno al contador de unidades y se mueve _entity_pend a la posición para crear la siguiente entidad
;Devueleve los siguientes valores para el ldir
;RETURN  	DE= PUNTERO AL NUEVO ELEMENTO A AÑADIR (AÑADIDO PERO SIN DATOS?)
;		BC= TAMAÑO DE LA ENTIDAD PARA HACER EL LDIR sizeof_e		
man_entity_new::
	ld hl, #_entity_num
	inc (hl)			;+1 ENTIDAD NUEVA CREADA

	ld hl,(_entity_pend)	;PUNTERO A LA DIRECCIÓN DE MEMORIA DONDE SE CREARÁ LA UNIDAD

	ld d, h
	ld e, l
	ld bc, #sizeof_e
	add hl, bc
	ld (_entity_pend), hl	;AHORA EL PUNTERO PARA LA CREAR LA SIGUIENTE UNIDAD SE MUEVE EL TAMAÑO DE UNA ENTIDAD EN EL ARRAY
	
	inc hl
	inc hl
	inc hl
	inc hl
	ld (hl), #0x00			;se rellena con 0 la teórica posición ew_x de la siguiente entidad, lo que significa que la entidad es no valida

ret
