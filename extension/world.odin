package extension

import "../provision"
import "../persistence"

world_initialize :: proc(world: ^provision.World_Data) {
    location:= persistence.world_createLocation(world, "Blue Room", "The Blue Room", blue_room_initialize)
}