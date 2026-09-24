package metaphor

import "presentation"
import "core:bufio"
import "core:os"
import "core:strings"
import "core:fmt"
import "core:strconv"
import "metaphor_state"

input_string :: proc(prompt_type: ^presentation.String_Prompt(metaphor_state.Game_State), state:^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    reader: bufio.Reader

    bufio.reader_init(&reader, os.to_stream(os.stdin))
    defer bufio.reader_destroy(&reader)

    line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
    if err != nil {
        return {}, false
    }
    cleaned := strings.trim_space(line)
    return prompt_type.from_string(state, cleaned)
}

input_handler :: proc(prompt: ^presentation.Dialog_Prompt(metaphor_state.Game_State), state:^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    fmt.print(prompt.title)
    switch &prompt_type in prompt.prompt_type {
        case presentation.Choose_Prompt(metaphor_state.Game_State):
            return input_choice(&prompt_type, state)
        case presentation.String_Prompt(metaphor_state.Game_State):
            return input_string(&prompt_type, state)
        case presentation.Integer_Prompt(metaphor_state.Game_State):
            return input_integer(&prompt_type, state)
        case presentation.Double_Prompt(metaphor_state.Game_State):
            return input_double(&prompt_type, state)
    }
    return {}, false
}

input_integer :: proc(prompt_type: ^presentation.Integer_Prompt(metaphor_state.Game_State), state:^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    reader: bufio.Reader

    bufio.reader_init(&reader, os.to_stream(os.stdin))
    defer bufio.reader_destroy(&reader)

    line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
    if err != nil {
        return {}, false
    }
    cleaned := strings.trim_space(line)
    val, ok := strconv.parse_int(cleaned)
    if ok {
        return prompt_type.from_integer(state, i32(val))
    }
    return {}, false
}

input_double :: proc(prompt_type: ^presentation.Double_Prompt(metaphor_state.Game_State), state:^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    reader: bufio.Reader

    bufio.reader_init(&reader, os.to_stream(os.stdin))
    defer bufio.reader_destroy(&reader)

    line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
    if err != nil {
        return {}, false
    }
    cleaned := strings.trim_space(line)
    val, ok := strconv.parse_f64(cleaned)
    if ok {
        return prompt_type.from_double(state, val)
    }
    return {}, false
}

input_choice :: proc(prompt_type: ^presentation.Choose_Prompt(metaphor_state.Game_State), state:^metaphor_state.Game_State) -> (presentation.Dialog_State(metaphor_state.Game_State), bool) {
    fmt.println()
    for &choice, index in prompt_type.choices {
        fmt.printfln("%d: %s", index + 1, choice.text)
    }

    reader: bufio.Reader

    bufio.reader_init(&reader, os.to_stream(os.stdin))
    defer bufio.reader_destroy(&reader)

    line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
    if err != nil {
        return {}, false
    }
    cleaned := strings.trim_space(line)
    val, ok := strconv.parse_int(cleaned)
    if ok && val >=1 && val <= len(prompt_type.choices){
        return prompt_type.choices[val-1].next_dialog_generator(state)
    }
    return {}, false
}

