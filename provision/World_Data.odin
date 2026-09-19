package provision

World_Data :: struct {
    using entity: Entity_Data,
    entities: map[Entity_Id]Entity_Data,
    messages: [dynamic]Message_Data
}

world_data_init :: proc(data: ^World_Data, entity_type: string) {
    entity_data_init(&data.entity, entity_type)
    data.entities = make(map[Entity_Id]Entity_Data)
    data.messages = make([dynamic]Message_Data)
}

world_data_destroy :: proc(data: ^World_Data) {
    entity_data_destroy(&data.entity)
    for _, &entity in data.entities {
        entity_data_destroy(&entity)
    }
    delete(data.entities)
    for &message in data.messages {
        message_data_destroy(&message)
    }
    delete(data.messages)
}