package persistence

import "../provision"

entity_clear :: proc(entity: ^provision.Entity_Data) {
    clear(&entity.counterMaximums)
    clear(&entity.counterMinimums)
    clear(&entity.counters)
    clear(&entity.dimensionMaximums)
    clear(&entity.dimensionMinimums)
    clear(&entity.dimensions)
    clear(&entity.metadatas)
    clear(&entity.tags)
    clear(&entity.yokes)
    for _, &yokage in entity.yokages {
        clear(&yokage)
    }
    clear(&entity.yokages)
}

entity_setMetadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.METADATA_ID, metadataValue: string) {
    entity.metadatas[metadataId] = metadataValue
}

entity_defaultMetadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.METADATA_ID, defaultValue: string) {
    if metadataId not_in entity.metadatas {
        entity.metadatas[metadataId] = defaultValue
    }
}

entity_setCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID, counterValue: i32) {
    entity.counters[counterId] = clamp(counterValue, entity_getCounterMinimum(entity, counterId), entity_getCounterMaximum(entity, counterId))
}

entity_defaultCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID, defaultValue: i32) {
    if counterId not_in entity.counters {
        entity.counters[counterId] = defaultValue
    }
}

entity_setCounterMinimum :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID, counterMinimm: i32) {
    entity.counterMinimums[counterId] = counterMinimm
}

entity_setCounterMaximum :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID, counterMaximum: i32) {
    entity.counterMaximums[counterId] = counterMaximum
}

entity_setTag :: proc(entity: ^provision.Entity_Data, tagId: provision.TAG_ID) {
    entity.tags[tagId] = {}
}

entity_setTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.TAG_ID){
    for tagId in tagIds {
        entity_setTag(entity, tagId)
    }
}

entity_clearTag :: proc(entity: ^provision.Entity_Data, tagId: provision.TAG_ID) {
    delete_key(&entity.tags, tagId)
}

entity_clearTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.TAG_ID){
    for tagId in tagIds {
        entity_clearTag(entity, tagId)
    }
}

entity_toggleTag :: proc(entity: ^provision.Entity_Data, tagId: provision.TAG_ID) -> bool {
    if entity_hasTag(entity, tagId) {
        entity_clearTag(entity, tagId)
    } else {
        entity_setTag(entity, tagId)
    }
    return entity_hasTag(entity, tagId)
}

entity_toggleTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.TAG_ID) {
    for tagId in tagIds {
        entity_toggleTag(entity, tagId)
    }
}

entity_setDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID, dimensionValue: f64) {
    entity.dimensions[dimensionId] = dimensionValue
}

entity_defaultDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID, defaultValue: f64) {
    if dimensionId not_in entity.dimensions {
        entity.dimensions[dimensionId] = defaultValue
    }
}

entity_setDimensionMinimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID, dimensionMinimum: f64) {
    entity.dimensionMinimums[dimensionId] = dimensionMinimum
}

entity_setDimensionMaximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID, dimensionMinimum: f64) {
    entity.dimensionMaximums[dimensionId] = dimensionMinimum
}

entity_assignTag :: proc(entity: ^provision.Entity_Data, tagId: provision.TAG_ID, value: bool) {
    if value {
        entity_setTag(entity, tagId)
    } else {
        entity_clearTag(entity, tagId)
    }
}

entity_getMetadata :: proc(entity:^provision.Entity_Data, metadataId: provision.METADATA_ID) -> (result: string, ok: bool) {
    return entity.metadatas[metadataId]
}

entity_getCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> (result: i32, ok: bool) {
    if result, ok = entity.counters[counterId]; ok {
        result = clamp(result, entity_getCounterMinimum(entity, counterId), entity_getCounterMaximum(entity, counterId))
    }
    return result, ok
}

entity_changeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID, delta: i32) -> (result: i32, ok: bool) {
    result, ok = entity_getCounter(entity, counterId)
    if ok {
        result += delta
        entity_setCounter(entity, counterId, result)
    }
    return result, ok
}

entity_getCounterMinimum :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> i32 {
    result, ok:= entity.counterMinimums[counterId]
    if ok {
        return result
    }
    return min(i32)
}

entity_getCounterMaximum :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> i32 {
    result, ok:= entity.counterMaximums[counterId]
    if ok {
        return result
    }
    return max(i32)
}

entity_hasTag :: proc(entity: ^provision.Entity_Data, tagId: provision.TAG_ID) -> bool {
    return tagId in entity.tags
}

entity_hasTags :: proc(entity: ^provision.Entity_Data, tagIds: ..provision.TAG_ID) -> bool {
    for tagId in tagIds {
        if !entity_hasTag(entity, tagId) {
            return false
        }
    }
    return true
}

entity_getDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> (result: f64, ok: bool) {
    result, ok = entity.dimensions[dimensionId]
    if ok {
        result = clamp(result, entity_getDimensionMinimum(entity, dimensionId), entity_getDimensionMaximum(entity, dimensionId))
    }
    return result, ok
}

entity_changeDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID, delta: f64) -> (result: f64, ok: bool) {
    result, ok = entity_getDimension(entity, dimensionId)
    if ok {
        result += delta
        entity_setDimension(entity, dimensionId, result)
    }
    return result, ok
}

entity_getDimensionMinimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> f64 {
    result, ok:= entity.dimensionMinimums[dimensionId]
    if ok {
        return result
    }
    return min(f64)
}

entity_getDimensionMaximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> f64 {
    result, ok:= entity.dimensionMaximums[dimensionId]
    if ok {
        return result
    }
    return max(f64)
}

entity_isCounterMinimum :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> (result: bool, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity, counterId)
    result = ok && value == entity_getCounterMinimum(entity, counterId)
    return result, ok
}

entity_isCounterMaximum :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> (result: bool, ok: bool) {
    value : i32
    value, ok = entity_getCounter(entity, counterId)
    result = ok && value == entity_getCounterMaximum(entity, counterId)
    return result, ok
}

entity_hasMetadata :: proc(entity: ^provision.Entity_Data, metadataId: provision.METADATA_ID) -> bool {
    return metadataId in entity.metadatas
}

entity_hasCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> bool {
    return counterId in entity.counters
}

entity_hasDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> bool {
    return dimensionId in entity.dimensions
}

entity_isDimensionMinimum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> (result: bool, ok: bool) {
    value : f64
    value, ok = entity_getDimension(entity, dimensionId)
    result = ok && value == entity_getDimensionMinimum(entity, dimensionId)
    return result, ok
}

entity_isDimensionMaximum :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> (result: bool, ok: bool) {
    value : f64
    value, ok = entity_getDimension(entity, dimensionId)
    result = ok && value == entity_getDimensionMaximum(entity, dimensionId)
    return result, ok
}

entity_setYoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.YOKE_ID, identifier: provision.ENTITY_ID) {
    entity.yokes[yokeId] = identifier    
}

entity_getYoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.YOKE_ID) -> (provision.ENTITY_ID, bool) {
    return entity.yokes[yokeId]
}

entity_clearYoke :: proc(entity: ^provision.Entity_Data, yokeId: provision.YOKE_ID) {
    delete_key(&entity.yokes, yokeId)
}

entity_getYokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.YOKAGE_ID) -> ^provision.ENTITY_ID_SET {
    _, ok:= entity.yokages[yokageId]
    if !ok {
        entity.yokages[yokageId] = make(provision.ENTITY_ID_SET)
    }
    return &entity.yokages[yokageId]
}

entity_addToYokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.YOKAGE_ID, identifier: provision.ENTITY_ID) {
    yokage:= entity_getYokage(entity, yokageId)
    yokage[identifier] = {}
}

entity_removeFromYokage :: proc(entity: ^provision.Entity_Data, yokageId: provision.YOKAGE_ID, identifier: provision.ENTITY_ID) {
    yokage:= entity_getYokage(entity, yokageId)
    delete_key(yokage, identifier)
}

entity_minimizeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> (i32, bool) {
    entity_setCounter(entity, counterId, entity_getCounterMinimum(entity, counterId))
    return entity_getCounter(entity, counterId)
}

entity_maximizeCounter :: proc(entity: ^provision.Entity_Data, counterId: provision.COUNTER_ID) -> (i32, bool) {
    entity_setCounter(entity, counterId, entity_getCounterMaximum(entity, counterId))
    return entity_getCounter(entity, counterId)
}

entity_minimizeDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> (f64, bool) {
    entity_setDimension(entity, dimensionId, entity_getDimensionMinimum(entity, dimensionId))
    return entity_getDimension(entity, dimensionId)
}

entity_maximizeDimension :: proc(entity: ^provision.Entity_Data, dimensionId: provision.DIMENSION_ID) -> (f64, bool) {
    entity_setDimension(entity, dimensionId, entity_getDimensionMaximum(entity, dimensionId))
    return entity_getDimension(entity, dimensionId)
}