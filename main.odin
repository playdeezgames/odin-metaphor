package metaphor

import "provision"
import "core:fmt"
import "presentation"
import "core:bufio"
import "core:os"
import "core:strings"
import "core:strconv"
import "platform"

COUNTER_SATIETY : provision.Counter_Id : "SATIETY"

Game_State :: struct {

}

main :: proc () {
    game_state:= Game_State{}
    host:= platform.Host(Game_State) {
        state = &game_state,
        dialog_state = presentation.Dialog(Game_State) { run = title_screen},
        running = true,
        input_choice = input_choice,
        input_string = input_string,
        input_integer = input_int,
        input_double = input_double
    }
    for host.running {
        switch &state in host.dialog_state {
            case presentation.Dialog(Game_State):
                host.dialog_state, host.running = state.run(&game_state)
            case presentation.Dialog_Prompt(Game_State):
                fmt.print(state.title)
                valid: bool = false
                next_dialog: presentation.Dialog(Game_State)
                switch &prompt_type in state.prompt_type {
                     case presentation.Choose_Prompt(Game_State):
                         next_dialog, valid = host.input_choice(&prompt_type, &game_state)
                     case presentation.String_Prompt(Game_State):
                         next_dialog, valid = host.input_string(&prompt_type, &game_state)
                     case presentation.Integer_Prompt(Game_State):
                         next_dialog, valid = host.input_integer(&prompt_type, &game_state)
                     case presentation.Double_Prompt(Game_State):
                         next_dialog, valid = host.input_double(&prompt_type, &game_state)
                }
                if valid {
                    host.dialog_state = next_dialog
                }
        }
    }
}

title_screen :: proc(state: ^Game_State) -> (presentation.Dialog_State(Game_State), bool) {
    fmt.println("Welcome to the Metaphor of SPLORR!!")
    fmt.println()
    return presentation.Dialog(Game_State) { run = main_menu}, true
}

main_menu :: proc(state: ^Game_State) -> (presentation.Dialog_State(Game_State), bool) {
    fmt.println("Main Menu:")

    result : presentation.Dialog_Prompt(Game_State)
    choice: presentation.Dialog_Choice(Game_State)
    presentation.dialog_choice_init(&choice, true, "Quit", choose_quit)
    choices:= make([dynamic]presentation.Dialog_Choice(Game_State))
    append(&choices, choice)
    presentation.dialog_prompt_initialize_choice(&result, "Now What?", choices[:])
    return result, true
}

choose_quit :: proc(state: ^Game_State) -> (presentation.Dialog(Game_State), bool) {
    return presentation.Dialog(Game_State) { run = quit_metaphor}, true
}

quit_metaphor :: proc(state: ^Game_State) -> (presentation.Dialog_State(Game_State), bool) {
    return {}, false
}

input_string :: proc(prompt_type: ^presentation.String_Prompt(Game_State), state:^Game_State) -> (presentation.Dialog(Game_State), bool) {
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

input_int :: proc(prompt_type: ^presentation.Integer_Prompt(Game_State), state:^Game_State) -> (presentation.Dialog(Game_State), bool) {
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

input_double :: proc(prompt_type: ^presentation.Double_Prompt(Game_State), state:^Game_State) -> (presentation.Dialog(Game_State), bool) {
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

input_choice :: proc(prompt_type: ^presentation.Choose_Prompt(Game_State), state:^Game_State) -> (presentation.Dialog(Game_State), bool) {
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

    // for _ in 0..<6 {
    //     fmt.println(extension.rng_roll_dice("1d6*2"))
    // }

    // world: provision.World_Data
    // provision.world_data_init(&world, persistence.ENTITY_TYPES_WORLD)
    // defer provision.world_data_destroy(&world)
    // extension.world_initialize(&world)

    // character, _:= persistence.world_getAvatar(&world)
    // location, _ := persistence.character_getLocation(&character)
    // characters:= persistence.location_getOtherCharacters(&location, &character)
    // defer delete(characters)
    // for &character in characters {
    //     name, _:= persistence.metaphor_entity_get_name(&character)
    //     fmt.println(name)
    // }
