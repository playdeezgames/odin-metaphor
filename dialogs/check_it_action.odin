package dialogs

import "../metaphor_state"
import "../presentation"
import "core:fmt"

check_it_action :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    fmt.printfln("You check it!")
    state.check_count += 1
    return presentation.Dialog(metaphor_state.Game_State) { run = main_menu_dialog}, true
}
