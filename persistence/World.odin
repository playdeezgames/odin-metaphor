package persistence

import "../provision"
import "core:encoding/json"
import "core:os"
import "core:encoding/uuid"

world_clear :: proc(world: ^provision.World_Data) {
    entity_clear(world)
    world_clearMessages(world)
    for _, &entity in world.entities {
        entity_clear(&entity)
    }
    clear(&world.entities)
}

world_getMessages :: proc(world: ^provision.World_Data) -> [dynamic]provision.Message_Data {
    return world.messages
}

world_save :: proc(world: ^provision.World_Data, filename: string) -> bool {
    json_data, err := json.marshal(world, allocator = context.temp_allocator)
    if err == nil {
        return os.write_entire_file(filename, json_data) == nil
    }
    return false
}

world_load :: proc(filename: string) -> (result: ^provision.World_Data, ok:bool) {
    file_data, err := os.read_entire_file(filename, context.temp_allocator)
    if err != nil {
        return nil, false
    }
    defer delete(file_data)
    result = new(provision.World_Data)
    unmarshal_err := json.unmarshal(file_data, result)
    if unmarshal_err != .None {
        free(result)
        return nil, false
    }
    return result, true
}

world_clearMessages :: proc(world: ^provision.World_Data) {
    clear(&world.messages)
}

@(private)
world_addMessage_full :: proc(world: ^provision.World_Data, text: string, hints: map[string]string) {
    append(
        &world.messages, 
        provision.Message_Data{
            text = text,
            hints = hints
        })
}

@(private)
world_addMessage_default :: proc(world: ^provision.World_Data, text: string) {
    world_addMessage_full(world, text, map[string]string{})
}

world_addMessage :: proc{world_addMessage_default, world_addMessage_full}

world_createLocation_full :: proc(world: ^provision.World_Data, entitySubtype: string, name:string, initializer: LocationInitializer) -> Location {
    entityId:= provision.Entity_Id(uuid.generate_v4())
    world.entities[entityId] = {}
    provision.entity_data_init(&world.entities[entityId], ENTITY_TYPES_LOCATION)
    result, _ := world_getLocation(world, LOCATION_ID(entityId))
    entity_set_metadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    entity_set_metadata(result.entityData, METADATAS_NAME, name)
    entity_add_to_yokage(world, YOKAGES_LOCATIONS, entityId)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

world_createLocation_default :: proc(world: ^provision.World_Data, entitySubtype: string, name:string) -> Location {
    return world_createLocation_full(world, entitySubtype, name, nil)
}

world_createLocation :: proc{world_createLocation_default, world_createLocation_full}

world_getLocation :: proc(world: ^provision.World_Data, locationId: LOCATION_ID) -> (result: Location, ok: bool) {
    if provision.Entity_Id(locationId) not_in world.entities {
        return {}, false
    }
    result = Location {
        entityId = locationId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(locationId)]
    }
    return result, true
}

world_getInventory :: proc(world: ^provision.World_Data, inventoryId: INVENTORY_ID) -> (result: Inventory, ok: bool) {
    if provision.Entity_Id(inventoryId) not_in world.entities {
        return {}, false
    }
    result = Inventory {
        entityId = inventoryId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(inventoryId)]
    }
    return result, true
}

world_getVerb :: proc(world: ^provision.World_Data, verbId: VERB_ID) -> (result: Verb, ok: bool) {
    if provision.Entity_Id(verbId) not_in world.entities {
        return {}, false
    }
    result = Verb {
        entityId = verbId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(verbId)]
    }
    return result, true
}

world_getFeature :: proc(world: ^provision.World_Data, featureId: FEATURE_ID) -> (result: Feature, ok: bool) {
    if provision.Entity_Id(featureId) not_in world.entities {
        return {}, false
    }
    result = Feature {
        entityId = featureId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(featureId)]
    }
    return result, true
}

world_getMap :: proc(world: ^provision.World_Data, mapId: MAP_ID) -> (result: Map, ok: bool) {
    if provision.Entity_Id(mapId) not_in world.entities {
        return {}, false
    }
    result = Map {
        entityId = mapId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(mapId)]
    }
    return result, true
}

world_getCharacter :: proc(world: ^provision.World_Data, characterId: CHARACTER_ID) -> (result: Character, ok: bool) {
    if provision.Entity_Id(characterId) not_in world.entities {
        return {}, false
    }
    result = Character {
        entityId = characterId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(characterId)]
    }
    return result, true
}

world_getAvatar :: proc(world: ^provision.World_Data) -> (result: Character, ok: bool) {
    entityId: provision.Entity_Id
    entityId, ok = entity_get_yoke(world, YOKES_AVATAR)
    if !ok {
        return {}, false
    }
    return world_getCharacter(world, CHARACTER_ID(entityId))
}

world_setAvatar :: proc(world: ^provision.World_Data, characterId: CHARACTER_ID) {
    entity_set_yoke(world, YOKES_AVATAR, provision.Entity_Id(characterId))
}

world_clearAvatar :: proc(world: ^provision.World_Data) {
    entity_clear_yoke(world, YOKES_AVATAR)
}

world_createMap :: proc(world: ^provision.World_Data, entitySubtype: string, name:string, columns: i32, rows: i32, initializer: MapInitializer) -> Map {
    entityId:= provision.Entity_Id(uuid.generate_v4())
    world.entities[entityId] = {}
    provision.entity_data_init(&world.entities[entityId], ENTITY_TYPES_MAP)
    result, _ := world_getMap(world, MAP_ID(entityId))
    entity_set_metadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    entity_set_metadata(result.entityData, METADATAS_NAME, name)
    entity_set_counter(result.entityData, COUNTERS_COLUMNS, columns)
    entity_set_counter(result.entityData, COUNTERS_ROWS, rows)
    entity_add_to_yokage(world, YOKAGES_MAPS, entityId)
    if initializer != nil {
        initializer(&result)
    }
    return result
}

world_getItem :: proc(world: ^provision.World_Data, itemId: ITEM_ID) -> (result: Item, ok: bool) {
    if provision.Entity_Id(itemId) not_in world.entities {
        return {}, false
    }
    result = Item {
        entityId = itemId,
        worldData = world,
        entityData = &world.entities[provision.Entity_Id(itemId)]
    }
    return result, true
}
