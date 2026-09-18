package extension

import "../provision"
import "../persistence"

world_initialize :: proc(world: ^provision.WorldData) {
    location:= persistence.world_createLocation(world, "Blue Room", "The Blue Room", blueRoom_initialize)
}