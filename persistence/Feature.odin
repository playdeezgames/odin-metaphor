package persistence

import "../provision"

FEATURE_ID :: distinct provision.ENTITY_ID

Feature :: distinct MetaphorEntity(FEATURE_ID)

FeatureInitializer :: distinct proc(^Feature)

feature_getLocation :: proc(entity: ^Feature) -> (Location, bool) {
    if entityId, ok:= entity_getYoke(entity.entityData, YOKES_LOCATION); ok {
        return world_getLocation(entity.worldData, LOCATION_ID(entityId))
    }
    return {}, false
}

feature_getDestination :: proc(entity: ^Feature) -> (Location, bool) {
    if entityId, ok:= entity_getYoke(entity.entityData, YOKES_DESTINATION); ok {
        return world_getLocation(entity.worldData, LOCATION_ID(entityId))
    }
    return {}, false
}

feature_setDestination :: proc (entity: ^Feature, location: ^Location) {
    if location != nil {
        entity_setYoke(entity.entityData, YOKES_DESTINATION, provision.ENTITY_ID(location.entityId))
    } else {
        entity_clearYoke(entity.entityData, YOKES_DESTINATION)
    }
}

feature_getTwin :: proc(entity: ^Feature) -> (Feature, bool) {
    if entityId, ok:= entity_getYoke(entity.entityData, YOKES_TWIN); ok {
        return world_getFeature(entity.worldData, FEATURE_ID(entityId))
    }
    return {}, false
}

feature_setTwin :: proc (entity: ^Feature, feature: ^Feature) {
    if feature != nil {
        entity_setYoke(entity.entityData, YOKES_TWIN, provision.ENTITY_ID(feature.entityId))
    } else {
        entity_clearYoke(entity.entityData, YOKES_TWIN)
    }
}

feature_remove :: proc(entity: ^Feature) {
    if entity == nil || entity.entityData == nil {
        return
    }
    if location, ok:= feature_getLocation(entity); ok {
        entity_removeFromYokage(location.entityData, YOKAGES_FEATURES, provision.ENTITY_ID(entity.entityId))
    }
    verbs:= metaphorEntity_getVerbs(entity)
    defer delete(verbs)
    for &verb in verbs {
        verb_remove(&verb)
    }
    if twin, ok:= feature_getTwin(entity); ok {
        entity_clearYoke(entity.entityData, YOKES_TWIN)
        feature_remove(&twin)
    }
}
