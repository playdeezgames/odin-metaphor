package extension

import "../persistence"

avatar_initialize :: proc(character:^persistence.Character) {
    persistence.metaphor_entity_create_verb(character, "POOP", "Poop!")
    persistence.world_setAvatar(character.worldData, character.entityId)
}