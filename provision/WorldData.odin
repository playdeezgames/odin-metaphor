package provision

import "core:encoding/uuid"

WorldData :: struct {
    using entity: EntityData,
    entities: map[ENTITY_ID]EntityData,
    messages: [dynamic]MessageData
}

worldData_ctor :: proc(data: ^WorldData, entityType: string) {
    entityData_ctor(&data.entity, entityType)
    data.entities = make(map[ENTITY_ID]EntityData)
    data.messages = make([dynamic]MessageData)
}

worldData_dtor :: proc(data: ^WorldData) {
    entityData_dtor(&data.entity)
    for _, &entity in data.entities {
        entityData_dtor(&entity)
    }
    delete(data.entities)
    for &message in data.messages {
        messageData_dtor(&message)
    }
    delete(data.messages)
}