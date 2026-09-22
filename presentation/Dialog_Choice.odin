package presentation

Dialog_Choice :: struct {
    enabled: bool,
    text: string,
    next_dialog_generator: proc() -> Dialog
}

dialog_choice_is_enabled :: proc(choice: ^Dialog_Choice) -> bool {
    return choice.enabled
}

dialog_choice_get_text :: proc(choice: ^Dialog_Choice) -> string {
    return choice.text
}

dialog_choice_get_next_dialog :: proc(choice: ^Dialog_Choice) -> Dialog {
    return choice.next_dialog_generator()
}

dialog_choice_init :: proc(choice: ^Dialog_Choice, enabled: bool, text:string, next_dialog_generator: proc() -> Dialog) {
    choice.enabled = enabled
    choice.text = text
    choice.next_dialog_generator = next_dialog_generator
}
