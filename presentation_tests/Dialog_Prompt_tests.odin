package presentation_tests

import "core:testing"
import "../presentation"

@(test)
test_dialog_prompt_initialize_string :: proc(t: ^testing.T) {
    sut: presentation.Dialog_Prompt
    PROMPT_TITLE : string : "PROMPT_TITLE"
    delegate : presentation.String_To_Dialog_Delegate : proc(string) -> presentation.Dialog {
        return {}
    }
    presentation.dialog_prompt_initialize_string(&sut, PROMPT_TITLE, delegate)

    testing.expect(t, sut.title == PROMPT_TITLE)

    choose_prompt : presentation.Choose_Prompt
    ok: bool
    choose_prompt, ok = sut.prompt_type.(presentation.Choose_Prompt)
    testing.expect(t, !ok)
    
    string_prompt : presentation.String_Prompt
    string_prompt, ok = sut.prompt_type.(presentation.String_Prompt)
    testing.expect(t, string_prompt.from_string == delegate)
    testing.expect(t, ok)
    
    integer_prompt : presentation.Integer_Prompt
    integer_prompt, ok = sut.prompt_type.(presentation.Integer_Prompt)
    testing.expect(t, !ok)
    
    double_prompt : presentation.Double_Prompt
    double_prompt, ok = sut.prompt_type.(presentation.Double_Prompt)
    testing.expect(t, !ok)
}

@(test)
test_dialog_prompt_initialize_integer :: proc(t: ^testing.T) {
    sut: presentation.Dialog_Prompt
    PROMPT_TITLE : string : "PROMPT_TITLE"
    delegate : presentation.Integer_To_Dialog_Delegate : proc(i32) -> presentation.Dialog {
        return {}
    }
    presentation.dialog_prompt_initialize_integer(&sut, PROMPT_TITLE, delegate)

    testing.expect(t, sut.title == PROMPT_TITLE)

    choose_prompt : presentation.Choose_Prompt
    ok: bool
    choose_prompt, ok = sut.prompt_type.(presentation.Choose_Prompt)
    testing.expect(t, !ok)
    
    string_prompt : presentation.String_Prompt
    string_prompt, ok = sut.prompt_type.(presentation.String_Prompt)
    testing.expect(t, !ok)
    
    integer_prompt : presentation.Integer_Prompt
    integer_prompt, ok = sut.prompt_type.(presentation.Integer_Prompt)
    testing.expect(t, integer_prompt.from_integer == delegate)
    testing.expect(t, ok)
    
    double_prompt : presentation.Double_Prompt
    double_prompt, ok = sut.prompt_type.(presentation.Double_Prompt)
    testing.expect(t, !ok)
}

@(test)
test_dialog_prompt_initialize_double :: proc(t: ^testing.T) {
    sut: presentation.Dialog_Prompt
    PROMPT_TITLE : string : "PROMPT_TITLE"
    delegate : presentation.Double_To_Dialog_Delegate : proc(f64) -> presentation.Dialog {
        return {}
    }
    presentation.dialog_prompt_initialize_double(&sut, PROMPT_TITLE, delegate)

    testing.expect(t, sut.title == PROMPT_TITLE)

    choose_prompt : presentation.Choose_Prompt
    ok: bool
    choose_prompt, ok = sut.prompt_type.(presentation.Choose_Prompt)
    testing.expect(t, !ok)
    
    string_prompt : presentation.String_Prompt
    string_prompt, ok = sut.prompt_type.(presentation.String_Prompt)
    testing.expect(t, !ok)
    
    integer_prompt : presentation.Integer_Prompt
    integer_prompt, ok = sut.prompt_type.(presentation.Integer_Prompt)
    testing.expect(t, !ok)
    
    double_prompt : presentation.Double_Prompt
    double_prompt, ok = sut.prompt_type.(presentation.Double_Prompt)
    testing.expect(t, double_prompt.from_double == delegate)
    testing.expect(t, ok)
}


@(test)
test_dialog_prompt_initialize_choice :: proc(t: ^testing.T) {
    sut: presentation.Dialog_Prompt
    PROMPT_TITLE : string : "PROMPT_TITLE"
    choices : []presentation.Dialog_Choice : {}
    presentation.dialog_prompt_initialize_choice(&sut, PROMPT_TITLE, choices)

    testing.expect(t, sut.title == PROMPT_TITLE)

    choose_prompt : presentation.Choose_Prompt
    ok: bool
    choose_prompt, ok = sut.prompt_type.(presentation.Choose_Prompt)
    testing.expect(t, len(choose_prompt.choices) == 0)
    testing.expect(t, ok)
    
    string_prompt : presentation.String_Prompt
    string_prompt, ok = sut.prompt_type.(presentation.String_Prompt)
    testing.expect(t, !ok)
    
    integer_prompt : presentation.Integer_Prompt
    integer_prompt, ok = sut.prompt_type.(presentation.Integer_Prompt)
    testing.expect(t, !ok)
    
    double_prompt : presentation.Double_Prompt
    double_prompt, ok = sut.prompt_type.(presentation.Double_Prompt)
    testing.expect(t, !ok)
}