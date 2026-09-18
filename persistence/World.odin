package persistence

import "../provision"
import "core:encoding/json"
import "core:os"
import "core:encoding/uuid"

world_clear :: proc(world: ^provision.WorldData) {
    entity_clear(world)
    world_clearMessages(world)
    for _, &entity in world.entities {
        entity_clear(&entity)
    }
    clear(&world.entities)
}

world_getMessages :: proc(world: ^provision.WorldData) -> [dynamic]provision.MessageData {
    return world.messages
}

world_save :: proc(world: ^provision.WorldData, filename: string) -> bool {
    json_data, err := json.marshal(world, allocator = context.temp_allocator)
    if err == nil {
        return os.write_entire_file(filename, json_data) == nil
    }
    return false
}

world_load :: proc(filename: string) -> (result: ^provision.WorldData, ok:bool) {
    file_data, err := os.read_entire_file(filename, context.temp_allocator)
    if err != nil {
        return nil, false
    }
    defer delete(file_data)
    result = new(provision.WorldData)
    unmarshal_err := json.unmarshal(file_data, result)
    if unmarshal_err != .None {
        free(result)
        return nil, false
    }
    return result, true
}

world_clearMessages :: proc(world: ^provision.WorldData) {
    clear(&world.messages)
}

world_addMessage_full :: proc(world: ^provision.WorldData, text: string, hints: map[string]string) {
    append(
        &world.messages, 
        provision.MessageData{
            text = text,
            hints = hints
        })
}

world_addMessage_default :: proc(world: ^provision.WorldData, text: string) {
    world_addMessage_full(world, text, map[string]string{})
}

world_addMessage :: proc{world_addMessage_default, world_addMessage_full}

world_createLocation_full :: proc(world: ^provision.WorldData, entitySubtype: string, name:string, initializer: LocationInitializer) -> Location {
    entityId:= provision.ENTITY_ID(uuid.generate_v4())
    world.entities[entityId] = {}
    provision.entityData_ctor(&world.entities[entityId], ENTITYTYPES_LOCATION)
    result, _ := world_getLocation(world, LOCATION_ID(entityId))
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_addToYokage(world, YOKAGES_LOCATIONS, entityId)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

world_createLocation_default :: proc(world: ^provision.WorldData, entitySubtype: string, name:string) -> Location {
    return world_createLocation_full(world, entitySubtype, name, nil)
}

world_createLocation :: proc{world_createLocation_default, world_createLocation_full}

world_getLocation :: proc(world: ^provision.WorldData, locationId: LOCATION_ID) -> (result: Location, ok: bool) {
    if provision.ENTITY_ID(locationId) not_in world.entities {
        return {}, false
    }
    result = Location {
        entityId = locationId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(locationId)]
    }
    return result, true
}

world_getInventory :: proc(world: ^provision.WorldData, inventoryId: INVENTORY_ID) -> (result: Inventory, ok: bool) {
    if provision.ENTITY_ID(inventoryId) not_in world.entities {
        return {}, false
    }
    result = Inventory {
        entityId = inventoryId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(inventoryId)]
    }
    return result, true
}

world_getVerb :: proc(world: ^provision.WorldData, verbId: VERB_ID) -> (result: Verb, ok: bool) {
    if provision.ENTITY_ID(verbId) not_in world.entities {
        return {}, false
    }
    result = Verb {
        entityId = verbId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(verbId)]
    }
    return result, true
}

world_getFeature :: proc(world: ^provision.WorldData, featureId: FEATURE_ID) -> (result: Feature, ok: bool) {
    if provision.ENTITY_ID(featureId) not_in world.entities {
        return {}, false
    }
    result = Feature {
        entityId = featureId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(featureId)]
    }
    return result, true
}

world_getMap :: proc(world: ^provision.WorldData, mapId: MAP_ID) -> (result: Map, ok: bool) {
    if provision.ENTITY_ID(mapId) not_in world.entities {
        return {}, false
    }
    result = Map {
        entityId = mapId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(mapId)]
    }
    return result, true
}

world_getCharacter :: proc(world: ^provision.WorldData, characterId: CHARACTER_ID) -> (result: Character, ok: bool) {
    if provision.ENTITY_ID(characterId) not_in world.entities {
        return {}, false
    }
    result = Character {
        entityId = characterId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(characterId)]
    }
    return result, true
}

world_getAvatar :: proc(world: ^provision.WorldData) -> (result: Character, ok: bool) {
    entityId: provision.ENTITY_ID
    entityId, ok = entity_getYoke(world, YOKES_AVATAR)
    if !ok {
        return {}, false
    }
    return world_getCharacter(world, CHARACTER_ID(entityId))
}

world_setAvatar :: proc(world: ^provision.WorldData, characterId: CHARACTER_ID) {
    entity_setYoke(world, YOKES_AVATAR, provision.ENTITY_ID(characterId))
}

world_clearAvatar :: proc(world: ^provision.WorldData) {
    entity_clearYoke(world, YOKES_AVATAR)
}

world_createMap :: proc(world: ^provision.WorldData, entitySubtype: string, name:string, columns: i32, rows: i32, initializer: MapInitializer) -> Map {
    entityId:= provision.ENTITY_ID(uuid.generate_v4())
    world.entities[entityId] = {}
    provision.entityData_ctor(&world.entities[entityId], ENTITYTYPES_MAP)
    result, _ := world_getMap(world, MAP_ID(entityId))
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_setCounter(result.entityData, COUNTERS_COLUMNS, columns)
    entity_setCounter(result.entityData, COUNTERS_ROWS, rows)
    entity_addToYokage(world, YOKAGES_MAPS, entityId)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

world_getItem :: proc(world: ^provision.WorldData, itemId: ITEM_ID) -> (result: Item, ok: bool) {
    if provision.ENTITY_ID(itemId) not_in world.entities {
        return {}, false
    }
    result = Item {
        entityId = itemId,
        worldData = world,
        entityData = &world.entities[provision.ENTITY_ID(itemId)]
    }
    return result, true
}
