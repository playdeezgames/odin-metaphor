package metaphor

import "provision"
import "persistence"
import "core:fmt"
import "core:encoding/uuid"

COUNTER_SATIETY : provision.COUNTER_ID : "SATIETY"

main :: proc () {
    world: provision.WorldData
    provision.worldData_ctor(&world, persistence.ENTITYTYPES_WORLD)
    defer provision.worldData_dtor(&world)
    location:= persistence.world_createLocation(&world, "Blue Room", "The Blue Room", nil)
    verb:= persistence.metaphorEntity_createVerb(&location, "POOP", "Poop!")
    character:= persistence.location_createCharacter(&location, "N00B", "N00b", nil)
    persistence.location_createCharacter(&location, "NPC", "Gorachan", nil)
    characters:= persistence.location_getOtherCharacters(&location, &character)
    defer delete(characters)
    for &character in characters {
        fmt.println(persistence.metaphorEntity_getName(&character))
    }
}