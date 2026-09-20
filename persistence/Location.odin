package persistence

import "../provision"
import "core:encoding/uuid"

LOCATION_ID :: distinct provision.Entity_Id

Location :: distinct Metaphor_Entity(LOCATION_ID)

LocationInitializer :: distinct proc(^Location)

location_getFeatures :: proc(entity: ^Location) -> []Feature {
    yokage:= entity_get_yokage(entity.entityData, YOKAGES_FEATURES)
    result:= make([dynamic]Feature, 0, len(yokage))
    for featureId, _ in yokage {
        if feature, ok:= world_getFeature(entity.worldData, FEATURE_ID(featureId)); ok {
            append(&result, feature)
        }
    }
    return result[:]
}

location_hasFeatures :: proc(entity: ^Location) -> bool {
   return len(entity_get_yokage(entity.entityData, YOKAGES_FEATURES)) > 0
}

location_getCharacters :: proc(entity: ^Location) -> []Character {
    yokage:= entity_get_yokage(entity.entityData, YOKAGES_CHARACTERS)
    result:= make([dynamic]Character, 0, len(yokage))
    for characterId, _ in yokage {
        if character, ok:= world_getCharacter(entity.worldData, CHARACTER_ID(characterId)); ok {
            append(&result, character)
        }
    }
    return result[:]
}

location_hasCharacters :: proc(entity: ^Location) -> bool {
   return len(entity_get_yokage(entity.entityData, YOKAGES_CHARACTERS)) > 0
}

location_getMap :: proc(entity: ^Location) -> (result: Map, ok: bool) {
    entityId : provision.Entity_Id
    entityId, ok = entity_get_yoke(entity.entityData, YOKES_MAP)
    if !ok {
        return {}, false
    }
    return world_getMap(entity.worldData, MAP_ID(entityId))
}

location_setMap :: proc(entity: ^Location, newMap: ^Map) {
    if oldMap, ok:= location_getMap(entity); ok {
        entity_remove_from_yokage(oldMap.entityData, YOKAGES_LOCATIONS, provision.Entity_Id(entity.entityId))
    }
    if newMap != nil {
        entity_set_yoke(entity.entityData, YOKES_MAP, provision.Entity_Id(newMap.entityId))
        entity_add_to_yokage(newMap.entityData, YOKAGES_LOCATIONS, provision.Entity_Id(entity.entityId))
    } else {
        entity_clear_yoke(entity.entityData, YOKES_MAP)
    }
}

location_getColumn :: proc(entity: ^Location) -> (result: i32, ok: bool) {
    return entity_get_counter(entity.entityData, COUNTERS_COLUMN)
}

location_getRow :: proc(entity: ^Location) -> (result: i32, ok: bool) {
    return entity_get_counter(entity.entityData, COUNTERS_ROW)
}

location_remove :: proc(entity: ^Location) {
    location_setMap(entity, nil)
    //TODO: clean up characters!
    entity_remove_from_yokage(entity.worldData, YOKAGES_LOCATIONS, provision.Entity_Id(entity.entityId))
    metaphor_entity_remove(entity)
}

location_createCharacter :: proc(entity: ^Location, entitySubtype: string, name: string, initialize: CharacterInitializer) -> Character {
    entityId:= provision.Entity_Id(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entity_data_init(&entity.worldData.entities[entityId], ENTITY_TYPES_CHARACTER)
    result, _ := world_getCharacter(entity.worldData, CHARACTER_ID(entityId))
    entity_set_yoke(result.entityData, YOKES_LOCATION, provision.Entity_Id(entity.entityId))
    entity_add_to_yokage(entity.entityData, YOKAGES_CHARACTERS, entityId)
    entity_set_metadata(result.entityData, METADATAS_NAME, name)
    entity_set_metadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initialize != nil {
        initialize(&result)
    }
    return result
}

location_createFeature :: proc(entity: ^Location, entitySubtype: string, name: string, initialize: FeatureInitializer) -> Feature {
    entityId:= provision.Entity_Id(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entity_data_init(&entity.worldData.entities[entityId], ENTITY_TYPES_FEATURE)
    result, _ := world_getFeature(entity.worldData, FEATURE_ID(entityId))
    entity_set_yoke(result.entityData, YOKES_LOCATION, provision.Entity_Id(entity.entityId))
    entity_add_to_yokage(entity.entityData, YOKAGES_FEATURES, entityId)
    entity_set_metadata(result.entityData, METADATAS_NAME, name)
    entity_set_metadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initialize != nil {
        initialize(&result)
    }
    return result
}

location_getOtherCharacters :: proc(entity: ^Location, character: ^Character) -> []Character {
    yokage:= entity_get_yokage(entity.entityData, YOKAGES_CHARACTERS)
    result:= make([dynamic]Character, 0, len(yokage))
    for characterId, _ in yokage {
        if characterId == provision.Entity_Id(character.entityId) {
            continue
        }
        if character, ok:= world_getCharacter(entity.worldData, CHARACTER_ID(characterId)); ok {
            append(&result, character)
        }
    }
    return result[:]
}

location_hasOtherCharacters :: proc(entity: ^Location, character: ^Character) -> bool {
    yokage:= entity_get_yokage(entity.entityData, YOKAGES_CHARACTERS)
    for characterId, _ in yokage {
        if characterId == provision.Entity_Id(character.entityId) {
            continue
        }
        return true
    }
    return false
}
