package provision

MessageData :: struct {
    text: string,
    hints: map[string]string
}

messageData_ctor :: proc(data: ^MessageData) {
    data.hints = make(map[string]string)
}

messageData_dtor :: proc(data: ^MessageData) {
    delete(data.hints)
}