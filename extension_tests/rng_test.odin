package extension_tests

import "core:testing"
import "../extension"

@(test)
test_rng_roll_dice :: proc(t: ^testing.T) {
    THEORIES : []struct {
        given: string,
        expected_result: int,
        expected_ok : bool
    } : {
        {"", 0, false},
        {"1d1", 1, true},
        {"1D1", 1, true},
        {"1D1+1d1", 2, true}
    }
    for theory in THEORIES {
        actual, ok: = extension.rng_roll_dice(theory.given)
        testing.expect(t, actual == theory.expected_result)
        testing.expect(t, ok == theory.expected_ok)
    }
}