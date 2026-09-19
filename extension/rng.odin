package extension

import "core:math/rand"
import "core:strings"
import "core:strconv"

rng_from_generator ::proc(table: ^map[$T]int) -> (T, bool) {
    total:int=0
    for _, weight in table {
        total += weight
    }
    if total<=0 {
        return {}, false
    }
    generated := rand.int_max(total)
    for key, weight in table {
        generated -= weight
        if generated < 0 {
            return key, true
        }
    }
    return {}, false
}

rng_from_set :: proc(table: ^map[$T]struct{}) -> (T, bool) {
    new_table:= make(map[T]int)
    defer delete(new_table)
    for key, _ in table {
        new_table[key] = 1
    }
    return rng_fromGenerator(&new_table)
}

rng_make_bool_generator :: proc(false_weight: int, true_weight: int) -> map[bool]int {
    result:= make(map[bool]int)
    if false_weight>0 {
        result[false] = false_weight
    }
    if true_weight>0 {
        result[true] = true_weight
    }
    return result
}

rng_from_int_range :: proc(minimum, maximum: int) -> int {
    return rand.int_range(minimum, maximum + 1)
}

rng_from_float_range :: proc(minimum, maximum: f64) -> f64 {
    return rand.float64_range(minimum, maximum)
}

rng_roll_x_d_y :: proc(die_count, die_size: int) -> int {
    result: int = 0
    for _ in 0..<die_count {
        result += rng_from_int_range(1, die_size)
    }
    return result
}

rng_validate_dice :: proc(dice_text: string) -> bool {
    _, ok:= rng_roll_dice(dice_text)
    return ok
}

rng_roll_dice :: proc(dice_text : string) -> (int, bool) {
    if len(dice_text) == 0 {
        return 0, false
    }
    dice_sets, err := strings.split(dice_text, "+", context.temp_allocator)
    if err != nil {
        return 0, false
    }
    result := 0
    for dice_set in dice_sets {
        multiplier := 1
        divisor := 1
        scratch : string
        ok : bool
        if strings.contains(dice_set, "*") {
            scale_tokens, err:= strings.split(dice_set, "*", context.temp_allocator)
            if err != nil || len(scale_tokens) != 2 {
                return 0, false
            }
            multiplier, ok = strconv.parse_int(scale_tokens[1])
            if !ok {
                return 0, false
            }
            scratch, err = strings.to_upper(scale_tokens[0], context.temp_allocator)
            if err!= nil {
                return 0, false
            }
        } else if strings.contains(dice_set, "/") {
            scale_tokens, err:= strings.split(dice_set, "/", context.temp_allocator)
            if err != nil || len(scale_tokens) != 2 {
                return 0, false
            }
            divisor, ok = strconv.parse_int(scale_tokens[1])
            if !ok {
                return 0, false
            }
            scratch, err = strings.to_upper(scale_tokens[0], context.temp_allocator)
            if err!= nil {
                return 0, false
            }
        } else {
            scratch, err = strings.to_upper(dice_set, context.temp_allocator)
            if err!= nil {
                return 0, false
            }
        }
        tokens, err := strings.split(scratch, "D", context.temp_allocator)
        if err != nil || len(tokens) != 2 {
            return 0, false
        }
        die_count: int
        die_count, ok = strconv.parse_int(tokens[0])
        if !ok {
            return 0, false
        }
        die_size: int
        die_size, ok = strconv.parse_int(tokens[1])
        if !ok {
            return 0, false
        }
        result += rng_roll_x_d_y(die_count, die_size) * multiplier / divisor
    }
    return result, true
}
rng_from_list :: proc(items: ^[]$T) -> (T, bool) {
    if len(items) == 0 {
        return {}, false
    }
    generator:= make(map[T]int, context.temp_allocator)
    for item in items {
        generator[item] = 1
    }
    return rng_from_generator(&generator)
}

// Public Module DictionaryExtensions
//     <Extension()>
//     Function CombineGenerator(first As Dictionary(Of Integer, Integer), second As Dictionary(Of Integer, Integer)) As Dictionary(Of Integer, Integer)
//         Dim result As New Dictionary(Of Integer, Integer)
//         For Each firstItem In first
//             For Each secondItem In second
//                 Dim combinedKey = firstItem.Key + secondItem.Key
//                 Dim combinedValue = firstItem.Value * secondItem.Value
//                 If result.ContainsKey(combinedKey) Then
//                     result(combinedKey) += combinedValue
//                 Else
//                     result.Add(combinedKey, combinedValue)
//                 End If
//             Next
//         Next
//         Return result
//     End Function
//     Public Function MaximumRoll(diceText As String) As Integer
//         If String.IsNullOrWhiteSpace(diceText) Then
//             Return Zero
//         End If
//         Dim diceSets = diceText.Split("+")
//         Dim tally = Zero
//         For Each diceSet In diceSets
//             Dim multiplier = 1
//             Dim divisor = 1
//             If diceSet.Contains("*"c) Then
//                 Dim scaleTokens = diceSet.Split("*"c)
//                 multiplier = CInt(scaleTokens(1))
//                 diceSet = scaleTokens(Zero)
//             ElseIf diceSet.Contains("/"c) Then
//                 Dim scaleTokens = diceSet.Split("/"c)
//                 divisor = CInt(scaleTokens(1))
//                 diceSet = scaleTokens(Zero)
//             End If
//             Dim tokens = diceSet.Split("d"c, "D"c)
//             Dim dieCount = CInt(tokens(Zero))
//             Dim dieSize = CInt(tokens(1))
//             tally += (Math.Max(dieCount * dieSize, dieCount) * multiplier) \ divisor
//         Next
//         Return tally
//     End Function
