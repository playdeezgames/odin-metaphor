package provision

Message_Data :: struct {
    text: string,
    hints: map[string]string
}

message_data_init :: proc(data: ^Message_Data) {
    data.hints = make(map[string]string)
}

message_data_destroy :: proc(data: ^Message_Data) {
    delete(data.hints)
}