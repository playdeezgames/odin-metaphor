package platform

import "../presentation"

Host :: struct($T: typeid) {
    state: ^T,
    running: bool,
    dialog_state:  presentation.Dialog_State(T),
    input_handler : proc(^presentation.Dialog_Prompt(T), ^T) -> (presentation.Dialog_State(T), bool)
}

host_iterate :: proc(host: ^Host($T), game_state: ^T) {
    switch &state in host.dialog_state {
        case presentation.Dialog(T):
            host.dialog_state, host.running = state.run(game_state)
        case presentation.Dialog_Prompt(T):
            if next_dialog_state, valid: = host.input_handler(&state, game_state); valid {
                host.dialog_state = next_dialog_state
            }
    }
}