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
    if json_data, err := json.marshal(world, allocator = context.temp_allocator); err == nil {
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
    provision.entityData_ctor(&world.entities[entityId])
    result, _ := world_getLocation(world, LOCATION_ID(entityId))
    result.entityData.entityType = entitySubtype
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

//     Public Function GetFeature(featureId As Guid?) As IFeature Implements IWorld.GetFeature
//         Return Feature.Create(Me, worldData, featureId)
//     End Function

//     Public Function CreateMap(entitySubtype As String, name As String, size As (Columns As Integer, Rows As Integer), Optional initializer As MapInitializer = Nothing) As IMap Implements IWorld.CreateMap
//         Dim mapId = Guid.NewGuid
//         worldData.Entities(mapId) = New EntityData With
//             {
//                 .EntityType = EntityTypes.MAP_ENTITY,
//                 .Metadatas = New Dictionary(Of String, String) From
//                 {
//                     {Metadatas.ENTITY_SUBTYPE, entitySubtype},
//                     {Metadatas.NAME, name}
//                 },
//                 .Counters = New Dictionary(Of String, Integer) From
//                 {
//                     {Counters.COLUMNS, size.Columns},
//                     {Counters.ROWS, size.Rows}
//                 }
//             }
//         Dim result = Map.Create(Me, worldData, mapId)
//         initializer?.Invoke(result)
//         Return result
//     End Function

//     Public Function GetMap(mapId As Guid?) As IMap Implements IWorld.GetMap
//         Return Map.Create(Me, worldData, mapId)
//     End Function

//     Public Function GetItem(itemId As Guid?) As IItem Implements IWorld.GetItem
//         Return Item.Create(Me, worldData, itemId)
//     End Function
// End Class

