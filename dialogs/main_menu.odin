package dialogs

import "../metaphor_state"
import "../presentation"
import "core:fmt"

main_menu_dialog :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    fmt.println("Main Menu:")
    fmt.printfln("Checks: %d", state.check_count)

    result : presentation.Dialog_Prompt(metaphor_state.Game_State)

    choices:= make([dynamic]presentation.Dialog_Choice(metaphor_state.Game_State))

    append(&choices, presentation.dialog_choice_make(true, "Check It!", main_menu_check_it_choice))
    append(&choices, presentation.dialog_choice_make(true, "Quit", main_menu_quit_choice))

    presentation.dialog_prompt_initialize_choice(&result, "Now What?", choices[:])
    return result, true
}

main_menu_quit_choice :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    return presentation.Dialog(metaphor_state.Game_State) { run = quit_action}, true
}

main_menu_check_it_choice :: proc(state: ^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    return presentation.Dialog(metaphor_state.Game_State) { run = check_it_action}, true
}
