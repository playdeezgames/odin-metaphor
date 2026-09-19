package provision

import "core:encoding/uuid"

Entity_Id :: distinct uuid.Identifier
Unit :: distinct struct{}
Tag_Set :: distinct map[Tag_Id]Unit
Entity_Id_Set :: distinct map[Entity_Id]Unit
Metadata_Id :: distinct string
Counter_Id :: distinct string
Dimension_Id :: distinct string
Tag_Id :: distinct string
Yoke_Id :: distinct string
Yokage_Id :: distinct string

Entity_Data :: struct {
    entity_type: string,
    metadatas: map[Metadata_Id]string,
    counters: map[Counter_Id]i32,
    counter_minimums: map[Counter_Id]i32,
    counter_maximums: map[Counter_Id]i32,
    dimensions: map[Dimension_Id]f64,
    dimension_minimums: map[Dimension_Id]f64,
    dimension_maximums: map[Dimension_Id]f64,
    tags: Tag_Set,
    yokes: map[Yoke_Id]Entity_Id,
    yokages: map[Yokage_Id]Entity_Id_Set
}

entity_data_init :: proc(data: ^Entity_Data, entity_type: string) {
    data.entity_type = entity_type
    data.metadatas = make(map[Metadata_Id]string)
    data.counters = make(map[Counter_Id]i32)
    data.counter_minimums = make(map[Counter_Id]i32)
    data.counter_maximums = make(map[Counter_Id]i32)
    data.dimensions = make(map[Dimension_Id]f64)
    data.dimension_minimums = make(map[Dimension_Id]f64)
    data.dimension_maximums = make(map[Dimension_Id]f64)
    data.tags = make(Tag_Set)
    data.yokes = make(map[Yoke_Id]Entity_Id)
    data.yokages = make(map[Yokage_Id]Entity_Id_Set)
}

entity_data_destroy :: proc(data: ^Entity_Data) {
    data.entity_type = ""
    delete(data.metadatas)
    delete(data.counters)
    delete(data.counter_minimums)
    delete(data.counter_maximums)
    delete(data.dimensions)
    delete(data.dimension_minimums)
    delete(data.dimension_maximums)
    delete(data.tags)
    delete(data.yokes)
    for _, yokage in data.yokages {
        delete(yokage)
    }
    delete(data.yokages)
}