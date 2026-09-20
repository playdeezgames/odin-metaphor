package persistence

import "../provision"

FEATURE_ID :: distinct provision.Entity_Id

Feature :: distinct Metaphor_Entity(FEATURE_ID)

FeatureInitializer :: distinct proc(^Feature)

feature_getLocation :: proc(entity: ^Feature) -> (Location, bool) {
    if entityId, ok:= entity_get_yoke(entity.entityData, YOKES_LOCATION); ok {
        return world_getLocation(entity.worldData, LOCATION_ID(entityId))
    }
    return {}, false
}

feature_getDestination :: proc(entity: ^Feature) -> (Location, bool) {
    if entityId, ok:= entity_get_yoke(entity.entityData, YOKES_DESTINATION); ok {
        return world_getLocation(entity.worldData, LOCATION_ID(entityId))
    }
    return {}, false
}

feature_setDestination :: proc (entity: ^Feature, location: ^Location) {
    if location != nil {
        entity_set_yoke(entity.entityData, YOKES_DESTINATION, provision.Entity_Id(location.entityId))
    } else {
        entity_clear_yoke(entity.entityData, YOKES_DESTINATION)
    }
}

feature_getTwin :: proc(entity: ^Feature) -> (Feature, bool) {
    if entityId, ok:= entity_get_yoke(entity.entityData, YOKES_TWIN); ok {
        return world_getFeature(entity.worldData, FEATURE_ID(entityId))
    }
    return {}, false
}

feature_setTwin :: proc (entity: ^Feature, feature: ^Feature) {
    if feature != nil {
        entity_set_yoke(entity.entityData, YOKES_TWIN, provision.Entity_Id(feature.entityId))
    } else {
        entity_clear_yoke(entity.entityData, YOKES_TWIN)
    }
}

feature_remove :: proc(entity: ^Feature) {
    if entity == nil || entity.entityData == nil {
        return
    }
    if location, ok:= feature_getLocation(entity); ok {
        entity_remove_from_yokage(location.entityData, YOKAGES_FEATURES, provision.Entity_Id(entity.entityId))
    }
    verbs:= metaphor_entity_get_verbs(entity)
    defer delete(verbs)
    for &verb in verbs {
        verb_remove(&verb)
    }
    if twin, ok:= feature_getTwin(entity); ok {
        entity_clear_yoke(entity.entityData, YOKES_TWIN)
        feature_remove(&twin)
    }
    entity_remove_from_yokage(entity.worldData, YOKAGES_FEATURES, provision.Entity_Id(entity.entityId))
    metaphor_entity_remove(entity)
}
