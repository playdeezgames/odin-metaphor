package persistence

import "../provision"

CHARACTER_ID :: distinct provision.Entity_Id

Character :: distinct Metaphor_Entity(CHARACTER_ID)

CharacterInitializer :: distinct proc(^Character)

character_getLocation :: proc(entity: ^Character) -> (Location, bool) {
    if entityId, ok := entity_get_yoke(entity.entityData, YOKES_LOCATION); ok {
        return world_getLocation(entity.worldData, LOCATION_ID(entityId))
    }
    return {}, false
}

character_setLocation :: proc(entity: ^Character, location: ^Location) {
    if oldLocation, ok:= character_getLocation(entity); ok {
        entity_remove_from_yokage(oldLocation.entityData, YOKAGES_CHARACTERS, provision.Entity_Id(entity.entityId))
    }
    if location != nil {
        entity_set_yoke(entity.entityData, YOKES_LOCATION, provision.Entity_Id(location.entityId))
        entity_add_to_yokage(location.entityData, YOKAGES_CHARACTERS, provision.Entity_Id(entity.entityId))
    } else {
        entity_clear_yoke(entity.entityData, YOKES_LOCATION)
    }
}

character_getDialogMode :: proc(entity: ^Character) -> (string, bool) {
    return entity_get_metadata(entity.entityData, METADATAS_DIALOG_MODE)
}

character_setDialogMode :: proc(entity: ^Character, dialogMode: string) {
    entity_set_metadata(entity.entityData, METADATAS_DIALOG_MODE, dialogMode)
}

character_getMap :: proc(entity: ^Character) -> (Map, bool) {
    if location, ok := character_getLocation(entity); ok {
        return location_getMap(&location)
    }
    return {}, false
}

character_remove :: proc(entity: ^Character) {
    if entity == nil || entity.entityData == nil {
        return
    }
    inventory:= metaphor_entity_get_inventory(entity)
    inventory_remove(&inventory)
    character_setLocation(entity, nil)
    entity_remove_from_yokage(entity.worldData, YOKAGES_CHARACTERS, provision.Entity_Id(entity.entityId))
    metaphor_entity_remove(entity)
}
