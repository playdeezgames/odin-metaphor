package persistence

import "../provision"

VERB_ID :: distinct provision.Entity_Id

Verb :: distinct MetaphorEntity(VERB_ID)

VerbInitializer :: distinct proc(^Verb)

verb_remove :: proc(entity: ^Verb) {
    if entity == nil || entity.entityData == nil {
        return
    }
    metaphorEntity_remove(entity)
}
