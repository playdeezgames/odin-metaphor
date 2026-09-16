package persistence

import "core:fmt"
import "../provision"
import "core:encoding/uuid"

MetaphorEntity :: struct($T: typeid) {
    worldData: ^provision.WorldData,
    entityId: T,
    entityData: ^provision.EntityData
}

metaphorEntity_ctor :: proc(
    entity: ^MetaphorEntity($T), 
    worldData: ^provision.WorldData, 
    entityId: T, 
    entityData: ^provision.EntityData) {
        entity.worldData = worldData
        entity.entityId = entityId
        entity.entityData = entityData
}

metaphorEntity_getName :: proc(entity: ^MetaphorEntity($T)) -> (result: string, ok: bool) {
    return entity_getMetadata(entity.entityData, METADATAS_NAME)
}

metaphorEntity_getEntityId :: proc(entity: ^MetaphorEntity($T)) -> T {
    return entity.entityId
}

metaphorEntity_getEntitySubtype :: proc(entity: ^MetaphorEntity($T)) -> (result: string, ok: bool) {
    return entity_getMetadata(entity.entityData, METADATAS_SUBTYPE)
}

metaphorEntity_exists :: proc(entity: ^MetaphorEntity($T)) -> bool {
    return provision.ENTITY_ID(entity.entityId) in entity.worldData.entities
}

//     Public Sub AddMessage(
//                          text As String,
//                          Optional hints As IDictionary(Of String, String) = Nothing,
//                          Optional silent As Boolean = False) Implements IMetaphorEntity.AddMessage
//         If Not silent Then
//             World.AddMessage(text, hints)
//         End If
//     End Sub
metaphorEntity_addMessage_full :: proc(entity: ^MetaphorEntity($T), text: string, hints: map[string]string, silent: bool) {
    if !silent {
        world_addMessage(entity.worldData, text, hints)
    }
}

metaphorEntity_addMessage_default1 :: proc(entity: ^MetaphorEntity($T), text: string, hints: map[string]string) {
    metaphorEntity_addMessage_full(entity, text, hints, false)
}

metaphorEntity_addMessage_default2 :: proc(entity: ^MetaphorEntity($T), text: string) {
    metaphorEntity_addMessage_full(entity, text, map[string]string{}, false)
}

metaphorEntity_addMessage :: proc{metaphorEntity_addMessage_default2, metaphorEntity_addMessage_default1, metaphorEntity_addMessage_full}

metaphorEntity_initializeCounter :: proc(entity: ^MetaphorEntity($T), counterId: provision.COUNTER_ID, value: i32, minimum: i32, maximum: i32) {
    entity_setCounterMaximum(entity.entityData, counterId, maximum)
    entity_setCounterMinimum(entity.entityData, counterId, minimum)
    entity_setCounter(entity.entityData, counterId, value)
}

metaphorEntity_getCounterPercentage :: proc(entity: ^MetaphorEntity($T), counterId: provision.COUNTER_ID) -> (result: string, ok: bool) {
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

metaphorEntity_initializeDimension :: proc(entity: ^MetaphorEntity($T), dimensionId: provision.DIMENSION_ID, value: f64, minimum: f64, maximum: f64) {
    entity_setDimensionMaximum(entity.entityData, dimensionId, maximum)
    entity_setDimensionMinimum(entity.entityData, dimensionId, minimum)
    entity_setDimension(entity.entityData, dimensionId, value)
}

metaphorEntity_getCounterStatistic :: proc(entity: ^MetaphorEntity($T), counterId: provision.COUNTER_ID) -> (result: string, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity.entityData, counterId)
    if ok {
        result = fmt.tprintf("%d/%d", value, entity_getCounterMaximum(entity.entityData, counterId))
    } else {
        result = ""
    }
    return result, ok
}

metaphorEntity_getDimensionStatistic :: proc(entity: ^MetaphorEntity($T), dimensionId: provision.DIMENSION_ID) -> (result: string, ok: bool) {
    value: f64
    value, ok= entity_getDimension(entity.entityData, dimensionId)
    if ok {
        result = fmt.tprintf("%.2f/%.2f", value, entity_getDimensionMaximum(entity.entityData, dimensionId))
    } else {
        result = ""
    }
    return result, ok
}

metaphorEntity_getCounterCapacity :: proc(entity: ^MetaphorEntity($T), counterId: provision.COUNTER_ID) -> (result: i32, ok: bool) {
    if result, ok = entity_getCounter(entity.entityData, counterId); ok {
        result = entity_getCounterMaximum(entity.entityData, counterId) - result
    }
    return result, ok
}

metaphorEntity_getDimensionCapacity :: proc(entity: ^MetaphorEntity($T), dimensionId: provision.DIMENSION_ID) -> (result: i32, ok: bool) {
    if result, ok = entity_getDimension(entity.entityData, dimensionId); ok {
        result = entity_getDimensionMaximum(entity.entityData, dimensionId) - result
    }
    return result, ok
}

metaphorEntity_getInventory :: proc(entity: ^MetaphorEntity($T)) -> Inventory {
    inventoryId, ok:= entity_getYoke(entity.entityData, YOKES_INVENTORY)
    if !ok {
        inventoryId= provision.ENTITY_ID(uuid.generate_v4())
        world.entities[inventoryId] = {}
        provision.entityData_ctor(&world.entities[inventoryId], ENTITYTYPES_INVENTORY)
    }
    result, _:= world_getInventory(entity.worldData, INVENTORY_ID(inventoryId))
    return result
}

metaphorEntity_getVerbs :: proc(entity: ^MetaphorEntity($T)) -> []Verb {
    yokage:= entity_getYokage(entity.entityData, YOKAGE_VERBS)
    result:= make([dynamic]Verb, 0, len(yokage))
    for verbId, _ in yokage {
        if verb, ok:= world_getVerb(entity.worldData, VERB_ID(verbId)); ok {
            append(&result, verb)
        }
    }
    return result[:]
}

metaphorEntity_createVerb_full :: proc(entity: ^MetaphorEntity($T), entitySubtype: string, name:string, initializer: VerbInitializer) -> Verb {
    entityId:= provision.ENTITY_ID(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entityData_ctor(&entity.worldData.entities[entityId],ENTITYTYPES_VERB)
    result, _ := world_getVerb(entity.worldData, VERB_ID(entityId))
    entity_addToYokage(entity.entityData, YOKAGES_VERBS, entityId)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

metaphorEntity_createVerb_default :: proc(entity: ^MetaphorEntity($T), entitySubtype: string, name:string) -> Verb {
    return metaphorEntity_createVerb_full(entity, entitySubtype, name, nil)
}

metaphorEntity_createVerb :: proc{metaphorEntity_createVerb_default, metaphorEntity_createVerb_full}
