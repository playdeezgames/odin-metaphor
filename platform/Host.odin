package platform

import "../presentation"

Host :: struct($T: typeid) {
    state: ^T,
    running: bool,
    dialog_state:  presentation.Dialog_State(T),
    input_choice : proc(^presentation.Choose_Prompt(T), ^T) -> (presentation.Dialog_State(T), bool),
    input_string : proc(^presentation.String_Prompt(T), ^T) -> (presentation.Dialog_State(T), bool),
    input_integer : proc(^presentation.Integer_Prompt(T), ^T) -> (presentation.Dialog_State(T), bool),
    input_double : proc(^presentation.Double_Prompt(T), ^T) -> (presentation.Dialog_State(T), bool)
}