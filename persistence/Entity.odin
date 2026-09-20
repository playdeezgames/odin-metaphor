package persistence

import "../provision"

entity_clear :: proc(entity: ^provision.Entity_Data) {
    clear(&entity.counter_maximums)
    clear(&entity.counter_minimums)
    clear(&entity.counters)
    clear(&entity.dimension_maximums)
    clear(&entity.dimension_minimums)
    clear(&entity.dimensions)
    clear(&entity.metadatas)
    clear(&entity.tags)
    clear(&entity.yokes)
    for _, &yokage in entity.yokages {
        clear(&yokage)
    }
    clear(&entity.yokages)
}

entity_set_metadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.Metadata_Id, metadataValue: string) {
    entity.metadatas[metadataId] = metadataValue
}

entity_default_metadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.Metadata_Id, defaultValue: string) {
    if metadataId not_in entity.metadatas {
        entity.metadatas[metadataId] = defaultValue
    }
}

entity_set_counter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, counterValue: i32) {
    entity.counters[counterId] = clamp(counterValue, entity_get_counter_minimum(entity, counterId), entity_get_counter_maximum(entity, counterId))
}

entity_default_counter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, defaultValue: i32) {
    if counterId not_in entity.counters {
        entity.counters[counterId] = defaultValue
    }
}

entity_set_counter_minimum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, counterMinimm: i32) {
    entity.counter_minimums[counterId] = counterMinimm
}

entity_set_counter_maximum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, counterMaximum: i32) {
    entity.counter_maximums[counterId] = counterMaximum
}

entity_set_tag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) {
    entity.tags[tagId] = {}
}

entity_set_tags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id){
    for tagId in tagIds {
        entity_set_tag(entity, tagId)
    }
}

entity_clear_tag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) {
    delete_key(&entity.tags, tagId)
}

entity_clear_tags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id){
    for tagId in tagIds {
        entity_clear_tag(entity, tagId)
    }
}

entity_toggle_tag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) -> bool {
    if entity_has_tag(entity, tagId) {
        entity_clear_tag(entity, tagId)
    } else {
        entity_set_tag(entity, tagId)
    }
    return entity_has_tag(entity, tagId)
}

entity_toggle_tags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id) {
    for tagId in tagIds {
        entity_toggle_tag(entity, tagId)
    }
}

entity_set_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, dimensionValue: f64) {
    entity.dimensions[dimensionId] = dimensionValue
}

entity_default_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, defaultValue: f64) {
    if dimensionId not_in entity.dimensions {
        entity.dimensions[dimensionId] = defaultValue
    }
}

entity_set_dimension_minimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, dimensionMinimum: f64) {
    entity.dimension_minimums[dimensionId] = dimensionMinimum
}

entity_set_dimension_maximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, dimensionMinimum: f64) {
    entity.dimension_maximums[dimensionId] = dimensionMinimum
}

entity_assign_tag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id, value: bool) {
    if value {
        entity_set_tag(entity, tagId)
    } else {
        entity_clear_tag(entity, tagId)
    }
}

entity_get_metadata :: proc(entity:^provision.Entity_Data, metadataId: provision.Metadata_Id) -> (result: string, ok: bool) {
    return entity.metadatas[metadataId]
}

entity_get_counter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (result: i32, ok: bool) {
    if result, ok = entity.counters[counterId]; ok {
        result = clamp(result, entity_get_counter_minimum(entity, counterId), entity_get_counter_maximum(entity, counterId))
    }
    return result, ok
}

entity_changeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, delta: i32) -> (result: i32, ok: bool) {
    result, ok = entity_get_counter(entity, counterId)
    if ok {
        result += delta
        entity_set_counter(entity, counterId, result)
    }
    return result, ok
}

entity_get_counter_minimum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> i32 {
    result, ok:= entity.counter_minimums[counterId]
    if ok {
        return result
    }
    return min(i32)
}

entity_get_counter_maximum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> i32 {
    result, ok:= entity.counter_maximums[counterId]
    if ok {
        return result
    }
    return max(i32)
}

entity_has_tag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) -> bool {
    return tagId in entity.tags
}

entity_has_tags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id) -> bool {
    for tagId in tagIds {
        if !entity_has_tag(entity, tagId) {
            return false
        }
    }
    return true
}

entity_get_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (result: f64, ok: bool) {
    result, ok = entity.dimensions[dimensionId]
    if ok {
        result = clamp(result, entity_get_dimension_minimum(entity, dimensionId), entity_get_dimension_maximum(entity, dimensionId))
    }
    return result, ok
}

entity_change_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, delta: f64) -> (result: f64, ok: bool) {
    result, ok = entity_get_dimension(entity, dimensionId)
    if ok {
        result += delta
        entity_set_dimension(entity, dimensionId, result)
    }
    return result, ok
}

entity_get_dimension_minimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> f64 {
    result, ok:= entity.dimension_minimums[dimensionId]
    if ok {
        return result
    }
    return min(f64)
}

entity_get_dimension_maximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> f64 {
    result, ok:= entity.dimension_maximums[dimensionId]
    if ok {
        return result
    }
    return max(f64)
}

entity_is_counter_minimum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (result: bool, ok: bool) {
    value : i32
    value, ok = entity_get_counter(entity, counterId)
    result = ok && value == entity_get_counter_minimum(entity, counterId)
    return result, ok
}

entity_is_counter_maximum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (result: bool, ok: bool) {
    value : i32
    value, ok = entity_get_counter(entity, counterId)
    result = ok && value == entity_get_counter_maximum(entity, counterId)
    return result, ok
}

entity_has_metadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.Metadata_Id) -> bool {
    return metadataId in entity.metadatas
}

entity_has_counter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> bool {
    return counterId in entity.counters
}

entity_has_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> bool {
    return dimensionId in entity.dimensions
}

entity_is_dimension_minimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (result: bool, ok: bool) {
    value : f64
    value, ok = entity_get_dimension(entity, dimensionId)
    result = ok && value == entity_get_dimension_minimum(entity, dimensionId)
    return result, ok
}

entity_is_dimension_maximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (result: bool, ok: bool) {
    value : f64
    value, ok = entity_get_dimension(entity, dimensionId)
    result = ok && value == entity_get_dimension_maximum(entity, dimensionId)
    return result, ok
}

entity_set_yoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.Yoke_Id, identifier: provision.Entity_Id) {
    entity.yokes[yokeId] = identifier    
}

entity_get_yoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.Yoke_Id) -> (provision.Entity_Id, bool) {
    return entity.yokes[yokeId]
}

entity_clear_yoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.Yoke_Id) {
    delete_key(&entity.yokes, yokeId)
}

entity_get_yokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.Yokage_Id) -> ^provision.Entity_Id_Set {
    _, ok:= entity.yokages[yokageId]
    if !ok {
        entity.yokages[yokageId] = make(provision.Entity_Id_Set)
    }
    return &entity.yokages[yokageId]
}

entity_add_to_yokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.Yokage_Id, identifier: provision.Entity_Id) {
    yokage:= entity_get_yokage(entity, yokageId)
    yokage[identifier] = {}
}

entity_remove_from_yokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.Yokage_Id, identifier: provision.Entity_Id) {
    yokage:= entity_get_yokage(entity, yokageId)
    delete_key(yokage, identifier)
}

entity_minimize_counter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (i32, bool) {
    entity_set_counter(entity, counterId, entity_get_counter_minimum(entity, counterId))
    return entity_get_counter(entity, counterId)
}

entity_maximize_counter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (i32, bool) {
    entity_set_counter(entity, counterId, entity_get_counter_maximum(entity, counterId))
    return entity_get_counter(entity, counterId)
}

entity_minimize_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (f64, bool) {
    entity_set_dimension(entity, dimensionId, entity_get_dimension_minimum(entity, dimensionId))
    return entity_get_dimension(entity, dimensionId)
}

entity_maximize_dimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (f64, bool) {
    entity_set_dimension(entity, dimensionId, entity_get_dimension_maximum(entity, dimensionId))
    return entity_get_dimension(entity, dimensionId)
}