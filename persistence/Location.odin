package persistence

import "../provision"
import "core:encoding/uuid"

LOCATION_ID :: distinct provision.ENTITY_ID

Location :: distinct MetaphorEntity(LOCATION_ID)

LocationInitializer :: distinct proc(^Location)

location_getFeatures :: proc(entity: ^Location) -> []Feature {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_FEATURES)
    result:= make([dynamic]Feature, 0, len(yokage))
    for featureId, _ in yokage {
        if feature, ok:= world_getFeature(entity.worldData, FEATURE_ID(featureId)); ok {
            append(&result, feature)
        }
    }
    return result[:]
}

location_hasFeatures :: proc(entity: ^Location) -> bool {
   return len(entity_getYokage(entity.entityData, YOKAGES_FEATURES)) > 0
}

location_getCharacters :: proc(entity: ^Location) -> []Character {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_CHARACTERS)
    result:= make([dynamic]Character, 0, len(yokage))
    for characterId, _ in yokage {
        if character, ok:= world_getCharacter(entity.worldData, CHARACTER_ID(characterId)); ok {
            append(&result, character)
        }
    }
    return result[:]
}

location_hasCharacters :: proc(entity: ^Location) -> bool {
   return len(entity_getYokage(entity.entityData, YOKAGES_CHARACTERS)) > 0
}

location_getMap :: proc(entity: ^Location) -> (result: Map, ok: bool) {
    entityId : provision.ENTITY_ID
    entityId, ok = entity_getYoke(entity.entityData, YOKES_MAP)
    if !ok {
        return {}, false
    }
    return world_getMap(entity.worldData, MAP_ID(entityId))
}

location_setMap :: proc(entity: ^Location, newMap: ^Map) {
    if oldMap, ok:= location_getMap(entity); ok {
        entity_removeFromYokage(oldMap.entityData, YOKAGES_LOCATIONS, provision.ENTITY_ID(entity.entityId))
    }
    if newMap != nil {
        entity_setYoke(entity.entityData, YOKES_MAP, provision.ENTITY_ID(newMap.entityId))
        entity_addToYokage(newMap.entityData, YOKAGES_LOCATIONS, provision.ENTITY_ID(entity.entityId))
    } else {
        entity_clearYoke(entity.entityData, YOKES_MAP)
    }
}

location_getColumn :: proc(entity: ^Location) -> (result: i32, ok: bool) {
    return entity_getCounter(entity.entityData, COUNTERS_COLUMN)
}

location_getRow :: proc(entity: ^Location) -> (result: i32, ok: bool) {
    return entity_getCounter(entity.entityData, COUNTERS_ROW)
}

location_remove :: proc(entity: ^Location) {
    location_setMap(entity, nil)
    entity.entityData = nil
    delete_key(&entity.worldData.entities, provision.ENTITY_ID(entity.entityId))
}

location_createCharacter :: proc(entity: ^Location, entitySubtype: string, name: string, initialize: CharacterInitializer) -> Character {
    entityId:= provision.ENTITY_ID(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entity_data_ctor(&entity.worldData.entities[entityId], ENTITYTYPES_CHARACTER)
    result, _ := world_getCharacter(entity.worldData, CHARACTER_ID(entityId))
    entity_setYoke(result.entityData, YOKES_LOCATION, provision.ENTITY_ID(entity.entityId))
    entity_addToYokage(entity.entityData, YOKAGES_CHARACTERS, entityId)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initialize != nil {
        initialize(&result)
    }
    return result
}

location_createFeature :: proc(entity: ^Location, entitySubtype: string, name: string, initialize: FeatureInitializer) -> Feature {
    entityId:= provision.ENTITY_ID(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entity_data_ctor(&entity.worldData.entities[entityId], ENTITYTYPES_FEATURE)
    result, _ := world_getFeature(entity.worldData, FEATURE_ID(entityId))
    entity_setYoke(result.entityData, YOKES_LOCATION, provision.ENTITY_ID(entity.entityId))
    entity_addToYokage(entity.entityData, YOKAGES_FEATURES, entityId)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initialize != nil {
        initialize(&result)
    }
    return result
}

location_getOtherCharacters :: proc(entity: ^Location, character: ^Character) -> []Character {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_CHARACTERS)
    result:= make([dynamic]Character, 0, len(yokage))
    for characterId, _ in yokage {
        if characterId == provision.ENTITY_ID(character.entityId) {
            continue
        }
        if character, ok:= world_getCharacter(entity.worldData, CHARACTER_ID(characterId)); ok {
            append(&result, character)
        }
    }
    return result[:]
}

location_hasOtherCharacters :: proc(entity: ^Location, character: ^Character) -> bool {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_CHARACTERS)
    for characterId, _ in yokage {
        if characterId == provision.ENTITY_ID(character.entityId) {
            continue
        }
        return true
    }
    return false
}
