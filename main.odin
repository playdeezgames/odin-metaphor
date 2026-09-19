package metaphor

import "provision"
import "persistence"
import "core:fmt"
import "extension"

COUNTER_SATIETY : provision.COUNTER_ID : "SATIETY"

main :: proc () {
    for _ in 0..<6 {
        fmt.println(extension.rng_roll_dice("1d6*2"))
    }

    world: provision.WorldData
    provision.worldData_ctor(&world, persistence.ENTITYTYPES_WORLD)
    defer provision.worldData_dtor(&world)
    extension.world_initialize(&world)

    character, _:= persistence.world_getAvatar(&world)
    location, _ := persistence.character_getLocation(&character)
    characters:= persistence.location_getOtherCharacters(&location, &character)
    defer delete(characters)
    for &character in characters {
        name, _:= persistence.metaphorEntity_getName(&character)
        fmt.println(name)
    }
}