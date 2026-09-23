package metaphor

import "provision"
import "core:fmt"
import "presentation"
import "core:bufio"
import "core:os"
import "core:strings"
import "core:strconv"

COUNTER_SATIETY : provision.Counter_Id : "SATIETY"

Game_State :: struct {

}

main :: proc () {
    dialog:= presentation.Dialog(Game_State) {
        run = main_menu
    }

    game_state:= Game_State{}

    running:= true
    for running {
        prompt: presentation.Dialog_Prompt(Game_State)
        if prompt, running = dialog.run(&game_state); running {
            fmt.print(prompt.title)
            switch &prompt_type in prompt.prompt_type {
                case presentation.Choose_Prompt(Game_State):
                    dialog, running = input_choice(&prompt_type, &game_state)
                case presentation.String_Prompt(Game_State):
                    dialog, running = input_string(&prompt_type, &game_state)
                case presentation.Integer_Prompt(Game_State):
                    dialog, running = input_int(&prompt_type, &game_state)
                case presentation.Double_Prompt(Game_State):
                    dialog, running = input_double(&prompt_type, &game_state)
            }
        }
    }
}

main_menu :: proc(state: ^Game_State) -> (presentation.Dialog_Prompt(Game_State), bool) {
    fmt.println("Main Menu:")

    result : presentation.Dialog_Prompt(Game_State)
    choice: presentation.Dialog_Choice(Game_State)
    presentation.dialog_choice_init(&choice, true, "Quit", exit_game)
    choices:= make([dynamic]presentation.Dialog_Choice(Game_State))
    append(&choices, choice)
    presentation.dialog_prompt_initialize_choice(&result, "Now What?", choices[:])
    return result, true
}

exit_game :: proc(state: ^Game_State) -> (presentation.Dialog(Game_State), bool) {
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

    for {
        line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
        if err != nil {
            return {}, false
        }
        cleaned := strings.trim_space(line)
        val, ok := strconv.parse_int(cleaned)
        if ok {
            return prompt_type.from_integer(state, i32(val))
        }
    }
}

input_double :: proc(prompt_type: ^presentation.Double_Prompt(Game_State), state:^Game_State) -> (presentation.Dialog(Game_State), bool) {
    reader: bufio.Reader

    bufio.reader_init(&reader, os.to_stream(os.stdin))
    defer bufio.reader_destroy(&reader)

    for {
        line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
        if err != nil {
            return {}, false
        }
        cleaned := strings.trim_space(line)
        val, ok := strconv.parse_f64(cleaned)
        if ok {
            return prompt_type.from_double(state, val)
        }
    }
}

input_choice :: proc(prompt_type: ^presentation.Choose_Prompt(Game_State), state:^Game_State) -> (presentation.Dialog(Game_State), bool) {
    fmt.println()
    for &choice, index in prompt_type.choices {
        fmt.printfln("%d: %s", index + 1, choice.text)
    }

    reader: bufio.Reader

    bufio.reader_init(&reader, os.to_stream(os.stdin))
    defer bufio.reader_destroy(&reader)

    for {
        line, err := bufio.reader_read_string(&reader, '\n', context.temp_allocator)
        if err != nil {
            return {}, false
        }
        cleaned := strings.trim_space(line)
        val, ok := strconv.parse_int(cleaned)
        if ok && val >=1 && val <= len(prompt_type.choices){
            return prompt_type.choices[val-1].next_dialog_generator(state)
        }
    }
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
