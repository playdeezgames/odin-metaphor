package presentation

Dialog :: struct($T: typeid) {
    run: proc(^T) -> (Dialog_State(T), bool) //TODO: this can return a Dialog_State instead of a Dialog_Prompt
}

