package persistence

import "core:fmt"
import "../provision"
import "core:encoding/uuid"

Metaphor_Entity :: struct($T: typeid) {
    worldData: ^provision.World_Data,
    entityId: T,
    entityData: ^provision.Entity_Data
}

metaphor_entity_initialize :: proc(
    entity: ^Metaphor_Entity($T), 
    worldData: ^provision.World_Data, 
    entityId: T, 
    entityData: ^provision.Entity_Data) {
        entity.worldData = worldData
        entity.entityId = entityId
        entity.entityData = entityData
}

metaphor_entity_get_name :: proc(entity: ^Metaphor_Entity($T)) -> (result: string, ok: bool) {
    return entity_getMetadata(entity.entityData, METADATAS_NAME)
}

metaphor_entity_get_entity_id :: proc(entity: ^Metaphor_Entity($T)) -> T {
    return entity.entityId
}

metaphor_entity_get_entity_subtype :: proc(entity: ^Metaphor_Entity($T)) -> (result: string, ok: bool) {
    return entity_getMetadata(entity.entityData, METADATAS_SUBTYPE)
}

metaphor_entity_exists :: proc(entity: ^Metaphor_Entity($T)) -> bool {
    return provision.Entity_Id(entity.entityId) in entity.worldData.entities
}

@(private)
metaphor_entity_add_message_full :: proc(entity: ^Metaphor_Entity($T), text: string, hints: map[string]string, silent: bool) {
    if !silent {
        world_addMessage(entity.worldData, text, hints)
    }
}

@(private)
metaphor_entity_add_message_default_1 :: proc(entity: ^Metaphor_Entity($T), text: string, hints: map[string]string) {
    metaphor_entity_add_message_full(entity, text, hints, false)
}

@(private)
metaphor_entity_add_message_default_2 :: proc(entity: ^Metaphor_Entity($T), text: string) {
    metaphor_entity_add_message_full(entity, text, map[string]string{}, false)
}

metaphor_entity_add_message :: proc{metaphor_entity_add_message_default_2, metaphor_entity_add_message_default_1, metaphor_entity_add_message_full}

metaphor_entity_initialize_counter :: proc(entity: ^Metaphor_Entity($T), counterId: provision.Counter_Id, value: i32, minimum: i32, maximum: i32) {
    entity_setCounterMaximum(entity.entityData, counterId, maximum)
    entity_setCounterMinimum(entity.entityData, counterId, minimum)
    entity_setCounter(entity.entityData, counterId, value)
}

metaphor_entity_get_counter_percentage :: proc(entity: ^Metaphor_Entity($T), counterId: provision.Counter_Id) -> (result: string, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity.entityData, counterId)
    if ok {
        percentage: int = 100 * value / entity_getCounterMaximum(entity.entityData, counterId)
        result = fmt.tprintf("%d%%", percentage)
    } else {
        result = ""
    }
    return result, ok
}

metaphor_entity_initialize_dimension :: proc(entity: ^Metaphor_Entity($T), dimensionId: provision.Dimension_Id, value: f64, minimum: f64, maximum: f64) {
    entity_setDimensionMaximum(entity.entityData, dimensionId, maximum)
    entity_setDimensionMinimum(entity.entityData, dimensionId, minimum)
    entity_setDimension(entity.entityData, dimensionId, value)
}

metaphor_entity_get_counter_statistic :: proc(entity: ^Metaphor_Entity($T), counterId: provision.Counter_Id) -> (result: string, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity.entityData, counterId)
    if ok {
        result = fmt.tprintf("%d/%d", value, entity_getCounterMaximum(entity.entityData, counterId))
    } else {
        result = ""
    }
    return result, ok
}

metaphor_entity_get_dimension_statistic :: proc(entity: ^Metaphor_Entity($T), dimensionId: provision.Dimension_Id) -> (result: string, ok: bool) {
    value: f64
    value, ok= entity_getDimension(entity.entityData, dimensionId)
    if ok {
        result = fmt.tprintf("%.2f/%.2f", value, entity_getDimensionMaximum(entity.entityData, dimensionId))
    } else {
        result = ""
    }
    return result, ok
}

metaphor_entity_get_counter_capacity :: proc(entity: ^Metaphor_Entity($T), counterId: provision.Counter_Id) -> (result: i32, ok: bool) {
    if result, ok = entity_getCounter(entity.entityData, counterId); ok {
        result = entity_getCounterMaximum(entity.entityData, counterId) - result
    }
    return result, ok
}

metaphor_entity_get_dimension_capacity :: proc(entity: ^Metaphor_Entity($T), dimensionId: provision.Dimension_Id) -> (result: i32, ok: bool) {
    if result, ok = entity_getDimension(entity.entityData, dimensionId); ok {
        result = entity_getDimensionMaximum(entity.entityData, dimensionId) - result
    }
    return result, ok
}

metaphor_entity_get_inventory :: proc(entity: ^Metaphor_Entity($T)) -> Inventory {
    inventoryId, ok:= entity_getYoke(entity.entityData, YOKES_INVENTORY)
    if !ok {
        inventoryId= provision.Entity_Id(uuid.generate_v4())
        entity.worldData.entities[inventoryId] = {}
        provision.entity_data_init(&entity.worldData.entities[inventoryId], ENTITY_TYPES_INVENTORY)
    }
    result, _:= world_getInventory(entity.worldData, INVENTORY_ID(inventoryId))
    return result
}

metaphor_entity_get_verbs :: proc(entity: ^Metaphor_Entity($T)) -> [dynamic]Verb {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_VERBS)
    result:= make([dynamic]Verb, 0, len(yokage))
    for verbId, _ in yokage {
        if verb, ok:= world_getVerb(entity.worldData, VERB_ID(verbId)); ok {
            append(&result, verb)
        }
    }
    return result
}

@(private)
metaphor_entity_create_verb_full :: proc(entity: ^Metaphor_Entity($T), entitySubtype: string, name:string, initializer: VerbInitializer) -> Verb {
    entityId:= provision.Entity_Id(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entity_data_init(&entity.worldData.entities[entityId],ENTITY_TYPES_VERB)
    result, _ := world_getVerb(entity.worldData, VERB_ID(entityId))
    entity_addToYokage(entity.entityData, YOKAGES_VERBS, entityId)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

@(private)
metaphor_entity_create_verb_default :: proc(entity: ^Metaphor_Entity($T), entitySubtype: string, name:string) -> Verb {
    return metaphor_entity_create_verb_full(entity, entitySubtype, name, nil)
}

metaphor_entity_create_verb :: proc{metaphor_entity_create_verb_default, metaphor_entity_create_verb_full}

metaphor_entity_remove :: proc(entity: ^Metaphor_Entity($T)) {
    if entityData, ok:= entity.worldData.entities[provision.Entity_Id(entity.entityId)]; ok {
        provision.entity_data_destroy(&entityData)
        delete_key(&entity.worldData.entities, provision.Entity_Id(entity.entityId))
    }
}
