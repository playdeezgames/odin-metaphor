package extension

import "../persistence"

avatar_initialize :: proc(character:^persistence.Character) {
    persistence.metaphorEntity_createVerb(character, "POOP", "Poop!")
    persistence.world_setAvatar(character.worldData, character.entityId)
}