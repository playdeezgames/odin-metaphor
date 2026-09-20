package persistence

import "../provision"

ITEM_ID :: distinct provision.Entity_Id

Item :: distinct Metaphor_Entity(ITEM_ID)

ItemInitializer :: distinct proc(^Item)

item_getContainer :: proc(entity: ^Item) -> (Inventory, bool) {
    if entityId, ok:= entity_getYoke(entity.entityData, YOKES_CONTAINER); ok {
        return world_getInventory(entity.worldData, INVENTORY_ID(entityId))
    }
    return {}, false
}

item_setContainer :: proc(entity: ^Item, container: ^Inventory) {
    if inventory, ok:= item_getContainer(entity); ok {
        entity_removeFromYokage(inventory.entityData, YOKAGES_ITEMS, provision.Entity_Id(entity.entityId))
    }
    if container!= nil {
        entity_addToYokage(container.entityData, YOKAGES_ITEMS, provision.Entity_Id(entity.entityId))
        entity_setYoke(entity.entityData, YOKES_CONTAINER, provision.Entity_Id(container.entityId))
    } else {
        entity_clearYoke(entity.entityData, YOKES_CONTAINER)
    }
}

item_remove :: proc(entity: ^Item) {
    if entity == nil || entity.entityData == nil {
        return
    }
    item_setContainer(entity, nil)
    metaphor_entity_remove(entity)
}

