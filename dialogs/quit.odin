package dialogs

import "../metaphor_state"
import "../presentation"

quit_dialog :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    return {}, false
}
