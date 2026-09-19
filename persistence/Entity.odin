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

entity_setMetadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.Metadata_Id, metadataValue: string) {
    entity.metadatas[metadataId] = metadataValue
}

entity_defaultMetadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.Metadata_Id, defaultValue: string) {
    if metadataId not_in entity.metadatas {
        entity.metadatas[metadataId] = defaultValue
    }
}

entity_setCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, counterValue: i32) {
    entity.counters[counterId] = clamp(counterValue, entity_getCounterMinimum(entity, counterId), entity_getCounterMaximum(entity, counterId))
}

entity_defaultCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, defaultValue: i32) {
    if counterId not_in entity.counters {
        entity.counters[counterId] = defaultValue
    }
}

entity_setCounterMinimum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, counterMinimm: i32) {
    entity.counter_minimums[counterId] = counterMinimm
}

entity_setCounterMaximum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, counterMaximum: i32) {
    entity.counter_maximums[counterId] = counterMaximum
}

entity_setTag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) {
    entity.tags[tagId] = {}
}

entity_setTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id){
    for tagId in tagIds {
        entity_setTag(entity, tagId)
    }
}

entity_clearTag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) {
    delete_key(&entity.tags, tagId)
}

entity_clearTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id){
    for tagId in tagIds {
        entity_clearTag(entity, tagId)
    }
}

entity_toggleTag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) -> bool {
    if entity_hasTag(entity, tagId) {
        entity_clearTag(entity, tagId)
    } else {
        entity_setTag(entity, tagId)
    }
    return entity_hasTag(entity, tagId)
}

entity_toggleTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id) {
    for tagId in tagIds {
        entity_toggleTag(entity, tagId)
    }
}

entity_setDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, dimensionValue: f64) {
    entity.dimensions[dimensionId] = dimensionValue
}

entity_defaultDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, defaultValue: f64) {
    if dimensionId not_in entity.dimensions {
        entity.dimensions[dimensionId] = defaultValue
    }
}

entity_setDimensionMinimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, dimensionMinimum: f64) {
    entity.dimension_minimums[dimensionId] = dimensionMinimum
}

entity_setDimensionMaximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, dimensionMinimum: f64) {
    entity.dimension_maximums[dimensionId] = dimensionMinimum
}

entity_assignTag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id, value: bool) {
    if value {
        entity_setTag(entity, tagId)
    } else {
        entity_clearTag(entity, tagId)
    }
}

entity_getMetadata :: proc(entity:^provision.Entity_Data, metadataId: provision.Metadata_Id) -> (result: string, ok: bool) {
    return entity.metadatas[metadataId]
}

entity_getCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (result: i32, ok: bool) {
    if result, ok = entity.counters[counterId]; ok {
        result = clamp(result, entity_getCounterMinimum(entity, counterId), entity_getCounterMaximum(entity, counterId))
    }
    return result, ok
}

entity_changeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id, delta: i32) -> (result: i32, ok: bool) {
    result, ok = entity_getCounter(entity, counterId)
    if ok {
        result += delta
        entity_setCounter(entity, counterId, result)
    }
    return result, ok
}

entity_getCounterMinimum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> i32 {
    result, ok:= entity.counter_minimums[counterId]
    if ok {
        return result
    }
    return min(i32)
}

entity_getCounterMaximum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> i32 {
    result, ok:= entity.counter_maximums[counterId]
    if ok {
        return result
    }
    return max(i32)
}

entity_hasTag :: proc(entity: ^provision.Entity_Data, tagId: provision.Tag_Id) -> bool {
    return tagId in entity.tags
}

entity_hasTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.Tag_Id) -> bool {
    for tagId in tagIds {
        if !entity_hasTag(entity, tagId) {
            return false
        }
    }
    return true
}

entity_getDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (result: f64, ok: bool) {
    result, ok = entity.dimensions[dimensionId]
    if ok {
        result = clamp(result, entity_getDimensionMinimum(entity, dimensionId), entity_getDimensionMaximum(entity, dimensionId))
    }
    return result, ok
}

entity_changeDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id, delta: f64) -> (result: f64, ok: bool) {
    result, ok = entity_getDimension(entity, dimensionId)
    if ok {
        result += delta
        entity_setDimension(entity, dimensionId, result)
    }
    return result, ok
}

entity_getDimensionMinimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> f64 {
    result, ok:= entity.dimension_minimums[dimensionId]
    if ok {
        return result
    }
    return min(f64)
}

entity_getDimensionMaximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> f64 {
    result, ok:= entity.dimension_maximums[dimensionId]
    if ok {
        return result
    }
    return max(f64)
}

entity_isCounterMinimum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (result: bool, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity, counterId)
    result = ok && value == entity_getCounterMinimum(entity, counterId)
    return result, ok
}

entity_isCounterMaximum :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (result: bool, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity, counterId)
    result = ok && value == entity_getCounterMaximum(entity, counterId)
    return result, ok
}

entity_hasMetadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.Metadata_Id) -> bool {
    return metadataId in entity.metadatas
}

entity_hasCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> bool {
    return counterId in entity.counters
}

entity_hasDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> bool {
    return dimensionId in entity.dimensions
}

entity_isDimensionMinimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (result: bool, ok: bool) {
    value : f64
    value, ok = entity_getDimension(entity, dimensionId)
    result = ok && value == entity_getDimensionMinimum(entity, dimensionId)
    return result, ok
}

entity_isDimensionMaximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (result: bool, ok: bool) {
    value : f64
    value, ok = entity_getDimension(entity, dimensionId)
    result = ok && value == entity_getDimensionMaximum(entity, dimensionId)
    return result, ok
}

entity_setYoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.Yoke_Id, identifier: provision.Entity_Id) {
    entity.yokes[yokeId] = identifier    
}

entity_getYoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.Yoke_Id) -> (provision.Entity_Id, bool) {
    return entity.yokes[yokeId]
}

entity_clearYoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.Yoke_Id) {
    delete_key(&entity.yokes, yokeId)
}

entity_getYokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.Yokage_Id) -> ^provision.Entity_Id_Set {
    _, ok:= entity.yokages[yokageId]
    if !ok {
        entity.yokages[yokageId] = make(provision.Entity_Id_Set)
    }
    return &entity.yokages[yokageId]
}

entity_addToYokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.Yokage_Id, identifier: provision.Entity_Id) {
    yokage:= entity_getYokage(entity, yokageId)
    yokage[identifier] = {}
}

entity_removeFromYokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.Yokage_Id, identifier: provision.Entity_Id) {
    yokage:= entity_getYokage(entity, yokageId)
    delete_key(yokage, identifier)
}

entity_minimizeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (i32, bool) {
    entity_setCounter(entity, counterId, entity_getCounterMinimum(entity, counterId))
    return entity_getCounter(entity, counterId)
}

entity_maximizeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.Counter_Id) -> (i32, bool) {
    entity_setCounter(entity, counterId, entity_getCounterMaximum(entity, counterId))
    return entity_getCounter(entity, counterId)
}

entity_minimizeDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (f64, bool) {
    entity_setDimension(entity, dimensionId, entity_getDimensionMinimum(entity, dimensionId))
    return entity_getDimension(entity, dimensionId)
}

entity_maximizeDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.Dimension_Id) -> (f64, bool) {
    entity_setDimension(entity, dimensionId, entity_getDimensionMaximum(entity, dimensionId))
    return entity_getDimension(entity, dimensionId)
}