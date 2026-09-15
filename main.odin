package metaphor

import "provision"
import "persistence"
import "core:fmt"

COUNTER_SATIETY : provision.COUNTER_ID : "SATIETY"

main :: proc () {
    world: provision.WorldData
    provision.worldData_ctor(&world)
    defer provision.worldData_dtor(&world)
    location:= persistence.world_createLocation(&world, "Blue Room", "The Blue Room", nil)
    fmt.println(persistence.metaphorEntity_getName(&location))
    fmt.println(location.entityData.entityType)
    verb:= persistence.metaphorEntity_createVerb(&location, "POOP", "Poop!")
    fmt.println(persistence.metaphorEntity_getName(&verb))
}