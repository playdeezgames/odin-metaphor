package provision

import "core:encoding/uuid"

WorldData :: struct {
    using entity: Entity_Data,
    entities: map[Entity_Id]Entity_Data,
    messages: [dynamic]MessageData
}

worldData_ctor :: proc(data: ^WorldData, entity_type: string) {
    entity_data_init(&data.entity, entity_type)
    data.entities = make(map[Entity_Id]Entity_Data)
    data.messages = make([dynamic]MessageData)
}

worldData_dtor :: proc(data: ^WorldData) {
    entity_data_destroy(&data.entity)
    for _, &entity in data.entities {
        entity_data_destroy(&entity)
    }
    delete(data.entities)
    for &message in data.messages {
        messageData_dtor(&message)
    }
    delete(data.messages)
}