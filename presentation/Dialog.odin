package presentation

Dialog :: struct($T: typeid) {
    run: proc(^T) -> (Dialog_Prompt(T), bool)
}

