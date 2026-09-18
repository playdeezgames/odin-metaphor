package persistence

ItemStack :: struct {
    inventory: Inventory,
    itemType: string
}

itemStack_getContainer :: proc(itemStack: ^ItemStack) -> Inventory {
    return itemStack.inventory
}

itemStack_getItemType :: proc(itemStack: ^ItemStack) -> string {
    return itemStack.itemType
}

itemStack_getItems :: proc(itemStack: ^ItemStack) -> [dynamic]Item {
    candidates := inventory_getItems(&itemStack.inventory)
    defer delete(candidates)
    result:= make([dynamic]Item)
    for &candidate in candidates {
        if itemType, ok := metaphorEntity_getEntitySubtype(&candidate); ok && itemType == itemStack.itemType {
            append(&result, candidate)
        }
    }
    return result
}

itemStack_getCount :: proc(itemStack: ^ItemStack) -> int {
    candidates := inventory_getItems(&itemStack.inventory)
    defer delete(candidates)
    result: int = 0
    for &candidate in candidates {
        if itemType, ok := metaphorEntity_getEntitySubtype(&candidate); ok && itemType == itemStack.itemType {
            result += 1
        }
    }
    return result
}

itemStack_getTop :: proc(itemStack: ^ItemStack) -> (Item, bool) {
    candidates := inventory_getItems(&itemStack.inventory)
    defer delete(candidates)
    for &candidate in candidates {
        if itemType, ok := metaphorEntity_getEntitySubtype(&candidate); ok && itemType == itemStack.itemType {
            return candidate, true
        }
    }
    return {}, false
}
