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
    entityType: string,
    metadatas: map[Metadata_Id]string,
    counters: map[Counter_Id]i32,
    counterMinimums: map[Counter_Id]i32,
    counterMaximums: map[Counter_Id]i32,
    dimensions: map[Dimension_Id]f64,
    dimensionMinimums: map[Dimension_Id]f64,
    dimensionMaximums: map[Dimension_Id]f64,
    tags: Tag_Set,
    yokes: map[Yoke_Id]Entity_Id,
    yokages: map[Yokage_Id]Entity_Id_Set
}

entity_data_init :: proc(data: ^Entity_Data, entityType: string) {
    data.entityType = entityType
    data.metadatas = make(map[Metadata_Id]string)
    data.counters = make(map[Counter_Id]i32)
    data.counterMinimums = make(map[Counter_Id]i32)
    data.counterMaximums = make(map[Counter_Id]i32)
    data.dimensions = make(map[Dimension_Id]f64)
    data.dimensionMinimums = make(map[Dimension_Id]f64)
    data.dimensionMaximums = make(map[Dimension_Id]f64)
    data.tags = make(Tag_Set)
    data.yokes = make(map[Yoke_Id]Entity_Id)
    data.yokages = make(map[Yokage_Id]Entity_Id_Set)
}

entity_data_destroy :: proc(data: ^Entity_Data) {
    data.entityType = ""
    delete(data.metadatas)
    delete(data.counters)
    delete(data.counterMinimums)
    delete(data.counterMaximums)
    delete(data.dimensions)
    delete(data.dimensionMinimums)
    delete(data.dimensionMaximums)
    delete(data.tags)
    delete(data.yokes)
    for _, yokage in data.yokages {
        delete(yokage)
    }
    delete(data.yokages)
}