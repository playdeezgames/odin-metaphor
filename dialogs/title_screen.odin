package dialogs

import "../presentation"
import "core:fmt"
import "../metaphor_state"


title_screen_dialog :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    fmt.println("Welcome to the Metaphor of SPLORR!!")
    fmt.println()
    return presentation.Dialog(metaphor_state.Game_State) { run = main_menu_dialog}, true
}

