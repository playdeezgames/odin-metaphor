package provision

import "core:encoding/uuid"

WorldData :: struct {
    using entity: Entity_Data,
    entities: map[ENTITY_ID]Entity_Data,
    messages: [dynamic]MessageData
}

worldData_ctor :: proc(data: ^WorldData, entityType: string) {
    entity_data_ctor(&data.entity, entityType)
    data.entities = make(map[ENTITY_ID]Entity_Data)
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