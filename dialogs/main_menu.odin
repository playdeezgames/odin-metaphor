package dialogs

import "../metaphor_state"
import "../presentation"
import "core:fmt"

main_menu_dialog :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    fmt.println("Main Menu:")

    result : presentation.Dialog_Prompt(metaphor_state.Game_State)

    choice: presentation.Dialog_Choice(metaphor_state.Game_State)
    presentation.dialog_choice_init(&choice, true, "Quit", main_menu_quit_choice)
    choices:= make([dynamic]presentation.Dialog_Choice(metaphor_state.Game_State))
    append(&choices, choice)

    presentation.dialog_prompt_initialize_choice(&result, "Now What?", choices[:])
    return result, true
}

main_menu_quit_choice :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    return presentation.Dialog(metaphor_state.Game_State) { run = quit_dialog}, true
}

