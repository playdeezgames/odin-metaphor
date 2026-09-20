package provision_tests

import "core:testing"
import "../provision"

@(test)
test_raw_message_data_values :: proc(t: ^testing.T) {
    sut: provision.Message_Data

    testing.expect(t, sut.text == "")
    testing.expect(t, len(sut.hints) == 0)
}

@(test)
test_message_data_init_destroy :: proc(t: ^testing.T) {
    sut: provision.Message_Data

    provision.message_data_init(&sut)
    testing.expect(t, sut.text == "")
    testing.expect(t, len(sut.hints) == 0)

    provision.message_data_destroy(&sut)
    testing.expect(t, sut.text == "")
    testing.expect(t, len(sut.hints) == 0)
}