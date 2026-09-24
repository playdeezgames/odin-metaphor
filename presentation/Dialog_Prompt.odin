package presentation

Dialog_Prompt :: struct($T: typeid) {
    title: string,
    prompt_type : Dialog_Prompt_Type(T)
}

Dialog_Prompt_Type :: union($T: typeid) {
    Choose_Prompt(T),
    String_Prompt(T),
    Integer_Prompt(T),
    Double_Prompt(T)
}

Choose_Prompt :: struct($T: typeid) {
    choices: []Dialog_Choice(T),
}

String_Prompt :: struct($T: typeid) {
    from_string: proc(^T, string) -> (Dialog_State(T) , bool)
}

Integer_Prompt :: struct($T: typeid) {
    from_integer: proc(^T, i32) -> (Dialog_State(T) , bool)
}

Double_Prompt :: struct($T: typeid) {
    from_double: proc(^T, f64) -> (Dialog_State(T) , bool)
}

dialog_prompt_initialize_choice :: proc(
    prompt: ^Dialog_Prompt($T),
    title:string, 
    choices: []Dialog_Choice(T)) {
        prompt.title = title
        filtered_choices:= make([dynamic]Dialog_Choice(T))
        for &choice in choices {
            if dialog_choice_is_enabled(&choice) {
                append(&filtered_choices, choice)
            }
        }
        prompt.prompt_type = Choose_Prompt(T){choices=filtered_choices[:]}
}

dialog_prompt_initialize_string :: proc(
    prompt: ^Dialog_Prompt($T),
    title:string, 
    from_string: proc(T, string) -> Dialog(T)) {
        prompt.title = title
        prompt.prompt_type = String_Prompt{from_string = from_string}
}

dialog_prompt_initialize_integer :: proc(
    prompt: ^Dialog_Prompt($T),
    title:string, 
    from_integer: proc(T, i32) -> Dialog(T)) {
        prompt.title = title
        prompt.prompt_type = Integer_Prompt{from_integer = from_integer}
}

dialog_prompt_initialize_double :: proc(
    prompt: ^Dialog_Prompt($T),
    title:string, 
    from_double: proc(T, f64) -> Dialog(T)) {
        prompt.title = title
        prompt.prompt_type = Double_Prompt{from_double = from_double}
}

dialog_prompt_get_choices :: proc(prompt: ^Dialog_Prompt($T)) -> ([]string, bool) {
    #partial switch prompt_type in prompt.prompt_type {
        case Choose_Prompt(T):
            result:= make([dynamic]string,0,len(prompt_type.choices))
            for choice in prompt_type.choices {
                if choice.enabled {
                    append(&result, choice.text)
                }
            }
            return result[:], true
    }
    return {}, false
}

//     Public ReadOnly Property Title As String Implements IDialogPrompt.Title
//     Private ReadOnly _choices As IDialogChoice()
//     Private ReadOnly fromString As StringToDialogDelegate
//     Private ReadOnly fromInteger As IntegerToDialogDelegate
//     Private ReadOnly fromDouble As DoubleToDialogDelegate

//     Public Function Respond(
//                            Optional text As String = Nothing,
//                            Optional counter As Integer? = Nothing,
//                            Optional dimension As Double? = Nothing) As IDialog Implements IDialogPrompt.Respond
//         Select Case PromptType
//             Case DialogPromptType.PROMPT_CHOOSE
//                 Return _choices(counter.Value).NextDialog()
//             Case DialogPromptType.PROMPT_DOUBLE
//                 Return fromDouble(dimension.Value)
//             Case DialogPromptType.PROMPT_INTEGER
//                 Return fromInteger(counter.Value)
//             Case DialogPromptType.PROMPT_STRING
//                 Return fromString(text)
//             Case Else
//                 Throw New NotImplementedException
//         End Select
//     End Function
dialog_prompt_respond_text :: proc(prompt: ^Dialog_Prompt($T), model: ^T, choice: int) -> (Dialog(T), bool) {

}

//     Public Shared Function CreateChoicePrompt(
//                                              title As String,
//                                              ParamArray choices As IDialogChoice()) As IDialogPrompt
//         Return New DialogPrompt(DialogPromptType.PROMPT_CHOOSE, title, choices:=choices)
//     End Function

//     Public Shared Function CreateIntegerPrompt(title As String, fromInteger As IntegerToDialogDelegate) As IDialogPrompt
//         Return New DialogPrompt(DialogPromptType.PROMPT_INTEGER, title, fromInteger:=fromInteger)
//     End Function

//     Public Shared Function CreateDoublePrompt(title As String, fromDouble As DoubleToDialogDelegate) As IDialogPrompt
//         Return New DialogPrompt(DialogPromptType.PROMPT_DOUBLE, title, fromDouble:=fromDouble)
//     End Function

//     Public Shared Function CreateStringPrompt(title As String, fromString As StringToDialogDelegate) As IDialogPrompt
//         Return New DialogPrompt(DialogPromptType.PROMPT_STRING, title, fromString:=fromString)
//     End Function
// End Class
