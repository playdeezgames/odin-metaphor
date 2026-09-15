package persistence

import "../provision"

message_getText :: proc(message: ^provision.MessageData) -> string {
    return message.text
}

message_getHintNames :: proc(message: ^provision.MessageData) -> [dynamic]string {
    hints := message.hints
    result:= make([dynamic]string, 0, len(hints))
    for name in hints {
        append(&result, name)
    }
    return result
}
message_hasHint :: proc(message: ^provision.MessageData, hintName: string) -> bool {
    return hintName in message.hints
}

message_getHint :: proc(message: ^provision.MessageData, hintName: string) -> (result:string, ok: bool) {
    hints := message.hints
    if hintName in hints {
        return hints[hintName], true
    }
    return "", false
}
