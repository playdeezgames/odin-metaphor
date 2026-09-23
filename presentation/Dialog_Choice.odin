package presentation

Dialog_Choice :: struct($T: typeid) {
    enabled: bool,
    text: string,
    next_dialog_generator: proc(^T) -> (Dialog(T), bool)
}

dialog_choice_is_enabled :: proc(choice: ^Dialog_Choice($T)) -> bool {
    return choice.enabled
}

dialog_choice_get_text :: proc(choice: ^Dialog_Choice($T)) -> string {
    return choice.text
}

dialog_choice_get_next_dialog :: proc(choice: ^Dialog_Choice($T)) -> Dialog(T) {
    return choice.next_dialog_generator()
}

dialog_choice_init :: proc(choice: ^Dialog_Choice($T), enabled: bool, text:string, next_dialog_generator: proc(^T) -> (Dialog(T), bool)) {
    choice.enabled = enabled
    choice.text = text
    choice.next_dialog_generator = next_dialog_generator
}
