package persistence_tests

import "core:testing"
import "../provision"
import "../persistence"

@(test)
test_entity_get_metadata :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    actual, ok := persistence.entity_get_metadata(&sut, persistence.METADATAS_SUBTYPE)

    testing.expect(t, actual == "")
    testing.expect(t, !ok)
}

@(test)
test_entity_has_metadata :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    actual:= persistence.entity_has_metadata(&sut, persistence.METADATAS_SUBTYPE)

    testing.expect(t, !actual)
}


@(test)
test_entity_set_metadata :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    METADATA_VALUE :: "METADATA_VALUE"
    persistence.entity_set_metadata(&sut, persistence.METADATAS_SUBTYPE, METADATA_VALUE)

    has_actual:= persistence.entity_has_metadata(&sut, persistence.METADATAS_SUBTYPE)
    testing.expect(t, has_actual)

    get_actual, get_ok := persistence.entity_get_metadata(&sut, persistence.METADATAS_SUBTYPE)
    testing.expect(t, get_actual == METADATA_VALUE)
    testing.expect(t, get_ok)
}

@(test)
test_entity_get_counter :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    actual, ok := persistence.entity_get_counter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == 0)
    testing.expect(t, !ok)
}

@(test)
test_entity_has_counter :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    actual:= persistence.entity_has_counter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, !actual)
}

@(test)
test_entity_set_counter :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    COUNTER_VALUE : i32 : 10
    persistence.entity_set_counter(&sut, persistence.COUNTERS_COLUMN, COUNTER_VALUE)

    actual, ok := persistence.entity_get_counter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == COUNTER_VALUE)
    testing.expect(t, ok)
}

@(test)
test_entity_get_counter_maximum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    actual := persistence.entity_get_counter_maximum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == max(i32))
}

@(test)
test_entity_set_counter_maximum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    COUNTER_MAXIMUM : i32 : 100
    persistence.entity_set_counter_maximum(&sut, persistence.COUNTERS_COLUMN, COUNTER_MAXIMUM)

    actual := persistence.entity_get_counter_maximum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == COUNTER_MAXIMUM)
}

@(test)
test_entity_get_counter_minimum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    actual := persistence.entity_get_counter_minimum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == min(i32))
}

@(test)
test_entity_set_counter_minimum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    COUNTER_MINIMUM : i32 : -100

    persistence.entity_set_counter_minimum(&sut, persistence.COUNTERS_COLUMN, COUNTER_MINIMUM)

    actual := persistence.entity_get_counter_minimum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == COUNTER_MINIMUM)
}

@(test)
test_entity_has_tag :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    TAG_NAME : provision.Tag_Id : "TAG_NAME"

    actual := persistence.entity_has_tag(&sut, TAG_NAME)

    testing.expect(t, !actual)
}

@(test)
test_entity_has_tags :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    FIRST_TAG : provision.Tag_Id : "FIRST_TAG"
    SECOND_TAG : provision.Tag_Id : "SECOND_TAG"

    actual := persistence.entity_has_tags(&sut, FIRST_TAG, SECOND_TAG)

    testing.expect(t, !actual)
}

@(test)
test_entity_has_dimension :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"

    actual:= persistence.entity_has_dimension(&sut, DIMENSION_NAME)

    testing.expect(t, !actual)
}

@(test)
test_entity_get_dimension :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"

    actual, ok:= persistence.entity_get_dimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == 0.0)
    testing.expect(t, !ok)
}

@(test)
test_entity_set_dimension :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"
    DIMENSION_VALUE : f64 : 10.0

    persistence.entity_set_dimension(&sut, DIMENSION_NAME, DIMENSION_VALUE)

    actual, ok:= persistence.entity_get_dimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == DIMENSION_VALUE)
    testing.expect(t, ok)
    has_actual:= persistence.entity_has_dimension(&sut, DIMENSION_NAME)
    testing.expect(t, has_actual)
}

@(test)
test_entity_change_dimension_fail :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"
    DIMENSION_DELTA : f64 : 10.0

    persistence.entity_change_dimension(&sut, DIMENSION_NAME, DIMENSION_DELTA)

    actual, ok:= persistence.entity_get_dimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == 0.0)
    testing.expect(t, !ok)
    has_actual:= persistence.entity_has_dimension(&sut, DIMENSION_NAME)
    testing.expect(t, !has_actual)
}

@(test)
test_entity_change_dimension_succeed :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"
    persistence.entity_set_dimension(&sut, DIMENSION_NAME, 0.0)
    
    DIMENSION_DELTA : f64 : 10.0
    persistence.entity_change_dimension(&sut, DIMENSION_NAME, DIMENSION_DELTA)

    actual, ok:= persistence.entity_get_dimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == DIMENSION_DELTA)
    testing.expect(t, ok)
    has_actual:= persistence.entity_has_dimension(&sut, DIMENSION_NAME)
    testing.expect(t, has_actual)
}

@(test)
test_entity_get_dimension_minimum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"
    actual := persistence.entity_get_dimension_minimum(&sut, DIMENSION_NAME)

    testing.expect(t, actual == min(f64))
}

@(test)
test_entity_get_dimension_maximum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_init(&sut, persistence.ENTITY_TYPES_CHARACTER)
    defer provision.entity_data_destroy(&sut)

    DIMENSION_NAME : provision.Dimension_Id : "DIMENSION_NAME"
    actual := persistence.entity_get_dimension_maximum(&sut, DIMENSION_NAME)

    testing.expect(t, actual == max(f64))
}