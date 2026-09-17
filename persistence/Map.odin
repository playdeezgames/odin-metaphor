package persistence

import "../provision"
import "core:encoding/uuid"

MAP_ID :: distinct provision.ENTITY_ID

Map :: distinct MetaphorEntity(MAP_ID)

MapInitializer :: distinct proc(^Map)

map_getSize :: proc(entity: ^Map) -> (columns, rows: i32, ok:bool) {
    if columns, ok = entity_getCounter(entity.entityData, COUNTERS_COLUMNS); ok {
        if rows, ok = entity_getCounter(entity.entityData, COUNTERS_ROWS); ok {
            return columns, rows, ok
        }
    }
    return 0, 0, false
}

map_getLocations :: proc(entity: ^Map) -> [dynamic]Location {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_LOCATIONS)
    result:= make([dynamic]Location)
    for locationId, _ in yokage {
        if location, ok:= world_getLocation(entity.worldData, LOCATION_ID(locationId)); ok {
            append(&result, location)
        }
    }
    return result
}

map_remove :: proc(entity: ^Map) {
    if entity == nil || entity.entityData == nil {
        return
    }
    yokage:= entity_getYokage(entity.entityData, YOKAGES_LOCATIONS)
    for locationId, _ in yokage {
        if location, ok:= world_getLocation(entity.worldData, LOCATION_ID(locationId)); ok {
            location_remove(&location)
        }
    }
    metaphorEntity_remove(entity)
}

map_createLocation :: proc(entity: ^Map, entitySubtype: string, name:string, column: i32, row: i32, initializer: LocationInitializer) -> Location {
    entityId:= provision.ENTITY_ID(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entityData_ctor(&entity.worldData.entities[entityId], ENTITYTYPES_LOCATION)
    result, _ := world_getLocation(entity.worldData, LOCATION_ID(entityId))
    entity_setCounter(result.entityData, COUNTERS_COLUMN, column)
    entity_setCounter(result.entityData, COUNTERS_ROW, row)
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_addToYokage(entity.worldData, YOKAGES_LOCATIONS, entityId)
    entity_setYoke(result.entityData, YOKES_MAP, provision.ENTITY_ID(entity.entityId))
    entity_addToYokage(entity.entityData, YOKAGES_LOCATIONS, entityId)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

map_getLocation :: proc(entity: ^Map, column, row: i32) -> (Location, bool) {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_LOCATIONS)
    for entityId, _ in yokage{
        if location, ok:= world_getLocation(entity.worldData, LOCATION_ID(entityId)); ok {
            value: i32
            if value, ok = entity_getCounter(location.entityData, COUNTERS_COLUMN); ok && value == column {
                if value,ok = entity_getCounter(location.entityData, COUNTERS_ROW); ok && value == row {
                    return location, true
                }
            }
        }
    }
    return {}, false
}
