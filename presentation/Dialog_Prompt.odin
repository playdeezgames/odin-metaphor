package presentation

Dialog_Prompt :: struct {
    title: string,
    prompt_type : Dialog_Prompt_Type
}

Dialog_Prompt_Generator :: distinct proc()->Dialog_Prompt

Dialog_Prompt_Type :: union {
    Choose_Prompt,
    String_Prompt,
    Integer_Prompt,
    Double_Prompt
}

Choose_Prompt :: struct {
    choices: []Dialog_Choice,
}

String_Prompt :: struct {
    from_string:String_To_Dialog_Delegate, 
}

Integer_Prompt :: struct {
    from_integer: Integer_To_Dialog_Delegate, 
}

Double_Prompt :: struct {
    from_double: Double_To_Dialog_Delegate, 
}

String_To_Dialog_Delegate :: distinct proc(string) -> Dialog
Integer_To_Dialog_Delegate :: distinct proc(i32) -> Dialog
Double_To_Dialog_Delegate :: distinct proc(f64) -> Dialog

dialog_prompt_initialize_choice :: proc(
    prompt: ^Dialog_Prompt,
    title:string, 
    choices: []Dialog_Choice) {
        prompt.title = title
        filtered_choices:= make([dynamic]Dialog_Choice)
        for &choice in choices {
            if dialog_choice_is_enabled(&choice) {
                append(&filtered_choices, choice)
            }
        }
        prompt.prompt_type = Choose_Prompt{choices=filtered_choices[:]}
}

dialog_prompt_initialize_string :: proc(
    prompt: ^Dialog_Prompt,
    title:string, 
    from_string:String_To_Dialog_Delegate) {
        prompt.title = title
        prompt.prompt_type = String_Prompt{from_string = from_string}
}

dialog_prompt_initialize_integer :: proc(
    prompt: ^Dialog_Prompt,
    title:string, 
    from_integer: Integer_To_Dialog_Delegate) {
        prompt.title = title
        prompt.prompt_type = Integer_Prompt{from_integer = from_integer}
}

dialog_prompt_initialize_double :: proc(
    prompt: ^Dialog_Prompt,
    title:string, 
    from_double: Double_To_Dialog_Delegate) {
        prompt.title = title
        prompt.prompt_type = Double_Prompt{from_double = from_double}
}

dialog_prompt_get_choices :: proc(prompt: ^Dialog_Prompt) -> ([]string, bool) {
    #partial switch prompt_type in prompt.prompt_type {
        case Choose_Prompt:
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
