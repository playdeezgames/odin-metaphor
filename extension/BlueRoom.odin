package extension

import "../persistence"

blueRoom_initialize :: proc(location: ^persistence.Location) {
    persistence.location_createCharacter(location, "N00B", "N00b", avatar_initialize)
    persistence.location_createCharacter(location, "NPC", "Gorachan", gorachan_initialize)
}