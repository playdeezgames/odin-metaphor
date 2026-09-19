package persistence

import "../provision"
import "core:encoding/uuid"

INVENTORY_ID :: distinct provision.Entity_Id

Inventory :: distinct MetaphorEntity(INVENTORY_ID)

InventoryInitializer :: distinct proc(^Inventory)

inventory_hasItems :: proc(entity: ^Inventory) -> bool {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_ITEMS)
    return len(yokage) > 0
}

inventory_getItems :: proc(entity: ^Inventory) -> [dynamic]Item {
    yokage:= entity_getYokage(entity.entityData, YOKAGES_ITEMS)
    result:= make([dynamic]Item, 0, len(yokage))
    for itemId, _ in yokage {
        if item, ok:= world_getItem(entity.worldData, ITEM_ID(itemId)); ok {
            append(&result, item)
        }
    }
    return result
}

inventory_remove :: proc(entity: ^Inventory) {
    if entity == nil || entity.entityData == nil {
        return
    }
    for &item in inventory_getItems(entity) {
        item_remove(&item)
    }
    metaphorEntity_remove(entity)
}

inventory_createItem :: proc(entity: ^Inventory, entitySubtype: string, name: string, initialize: ItemInitializer) -> Item {
    entityId:= provision.Entity_Id(uuid.generate_v4())
    entity.worldData.entities[entityId] = {}
    provision.entity_data_init(&entity.worldData.entities[entityId], ENTITYTYPES_ITEM)
    result, _ := world_getItem(entity.worldData, ITEM_ID(entityId))
    item_setContainer(&result, entity)
    entity_setMetadata(result.entityData, METADATAS_NAME, name)
    entity_setMetadata(result.entityData, METADATAS_SUBTYPE, entitySubtype)
    if initialize != nil {
        initialize(&result)
    }
    return result
}

inventory_hasItemOfSubtype :: proc(entity: ^Inventory, entitySubtype: string) -> bool {
    items:= inventory_getItems(entity)
    defer delete(items)
    for &item in items {
        if subType, ok:= metaphorEntity_getEntitySubtype(&item); ok && subType == entitySubtype {
            return true
        }
    }
    return false
}

inventory_getItemsOfSubtype :: proc(entity: ^Inventory, entitySubtype: string) -> [dynamic]Item {
    items:= inventory_getItems(entity)
    defer delete(items)
    result:= make([dynamic]Item)
    for &item in items {
        if subType, ok:= metaphorEntity_getEntitySubtype(&item); ok && subType == entitySubtype {
            append(&result, item)
        }
    }
    return result
}

inventory_getItemStacks :: proc(entity: ^Inventory) -> [dynamic]ItemStack {
    stackMap:= make(map[string]ItemStack)
    defer delete(stackMap)
    items:= inventory_getItems(entity)
    defer delete(items)
    for &item in items {
        if subType, ok:= metaphorEntity_getEntitySubtype(&item); ok {
            if _, ok = stackMap[subType]; !ok {
                stackMap[subType] = ItemStack {
                    inventory = entity^,
                    itemType = subType
                }
            }
        }
    }
    result:= make([dynamic]ItemStack, 0, len(stackMap))
    for _, itemStack in stackMap {
        append(&result, itemStack)
    }
    return result
}
