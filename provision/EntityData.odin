package provision

import "core:encoding/uuid"

ENTITY_ID :: distinct uuid.Identifier
UNIT :: distinct struct{}
TAG_SET :: distinct map[TAG_ID]UNIT
ENTITY_ID_SET :: distinct map[ENTITY_ID]UNIT
METADATA_ID :: distinct string
COUNTER_ID :: distinct string
DIMENSION_ID :: distinct string
TAG_ID :: distinct string
YOKE_ID :: distinct string
YOKAGE_ID :: distinct string

Entity_Data :: struct {
    entityType: string,
    metadatas: map[METADATA_ID]string,
    counters: map[COUNTER_ID]i32,
    counterMinimums: map[COUNTER_ID]i32,
    counterMaximums: map[COUNTER_ID]i32,
    dimensions: map[DIMENSION_ID]f64,
    dimensionMinimums: map[DIMENSION_ID]f64,
    dimensionMaximums: map[DIMENSION_ID]f64,
    tags: TAG_SET,
    yokes: map[YOKE_ID]ENTITY_ID,
    yokages: map[YOKAGE_ID]ENTITY_ID_SET
}

entity_data_ctor :: proc(data: ^Entity_Data, entityType: string) {
    data.entityType = entityType
    data.metadatas = make(map[METADATA_ID]string)
    data.counters = make(map[COUNTER_ID]i32)
    data.counterMinimums = make(map[COUNTER_ID]i32)
    data.counterMaximums = make(map[COUNTER_ID]i32)
    data.dimensions = make(map[DIMENSION_ID]f64)
    data.dimensionMinimums = make(map[DIMENSION_ID]f64)
    data.dimensionMaximums = make(map[DIMENSION_ID]f64)
    data.tags = make(TAG_SET)
    data.yokes = make(map[YOKE_ID]ENTITY_ID)
    data.yokages = make(map[YOKAGE_ID]ENTITY_ID_SET)
}

entity_data_dtor :: proc(data: ^Entity_Data) {
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