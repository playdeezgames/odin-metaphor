package metaphor

import "presentation"
import "platform"
import "metaphor_state"
import "dialogs"

main :: proc () {
    game_state:= metaphor_state.Game_State{}
    host:= platform.Host(metaphor_state.Game_State) {
        state = &game_state,
        dialog_state = presentation.Dialog(metaphor_state.Game_State) { run = dialogs.title_screen_dialog},
        running = true,
        input_handler = input_handler
    }
    for host.running {
        platform.host_iterate(&host, &game_state)
    }
}

