package persistence_tests

import "core:testing"
import "../provision"
import "../persistence"

@(test)
test_entity_getMetadata :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual, ok := persistence.entity_getMetadata(&sut, persistence.METADATAS_SUBTYPE)

    testing.expect(t, actual == "")
    testing.expect(t, !ok)
}

@(test)
test_entity_hasMetadata :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual:= persistence.entity_hasMetadata(&sut, persistence.METADATAS_SUBTYPE)

    testing.expect(t, !actual)
}


@(test)
test_entity_setMetadata :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    METADATA_VALUE :: "METADATA_VALUE"
    persistence.entity_setMetadata(&sut, persistence.METADATAS_SUBTYPE, METADATA_VALUE)

    has_actual:= persistence.entity_hasMetadata(&sut, persistence.METADATAS_SUBTYPE)
    testing.expect(t, has_actual)

    get_actual, get_ok := persistence.entity_getMetadata(&sut, persistence.METADATAS_SUBTYPE)
    testing.expect(t, get_actual == METADATA_VALUE)
    testing.expect(t, get_ok)
}

@(test)
test_entity_getCounter :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual, ok := persistence.entity_getCounter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == 0)
    testing.expect(t, !ok)
}

@(test)
test_entity_hasCounter :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual:= persistence.entity_hasCounter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, !actual)
}

@(test)
test_entity_setCounter :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    COUNTER_VALUE : i32 : 10
    persistence.entity_setCounter(&sut, persistence.COUNTERS_COLUMN, COUNTER_VALUE)

    actual, ok := persistence.entity_getCounter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == COUNTER_VALUE)
    testing.expect(t, ok)
}

@(test)
test_entity_getCounterMaximum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual := persistence.entity_getCounterMaximum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == max(i32))
}

@(test)
test_entity_setCounterMaximum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    COUNTER_MAXIMUM : i32 : 100
    persistence.entity_setCounterMaximum(&sut, persistence.COUNTERS_COLUMN, COUNTER_MAXIMUM)

    actual := persistence.entity_getCounterMaximum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == COUNTER_MAXIMUM)
}

@(test)
test_entity_getCounterMinimum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual := persistence.entity_getCounterMinimum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == min(i32))
}

@(test)
test_entity_setCounterMinimum :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    COUNTER_MINIMUM : i32 : -100

    persistence.entity_setCounterMinimum(&sut, persistence.COUNTERS_COLUMN, COUNTER_MINIMUM)

    actual := persistence.entity_getCounterMinimum(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == COUNTER_MINIMUM)
}

@(test)
test_entity_hasTag :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    TAG_NAME : provision.TAG_ID : "TAG_NAME"

    actual := persistence.entity_hasTag(&sut, TAG_NAME)

    testing.expect(t, !actual)
}

@(test)
test_entity_hasTags :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    FIRST_TAG : provision.TAG_ID : "FIRST_TAG"
    SECOND_TAG : provision.TAG_ID : "SECOND_TAG"

    actual := persistence.entity_hasTags(&sut, FIRST_TAG, SECOND_TAG)

    testing.expect(t, !actual)
}

@(test)
test_entity_hasDimension :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    DIMENSION_NAME : provision.DIMENSION_ID : "DIMENSION_NAME"

    actual:= persistence.entity_hasDimension(&sut, DIMENSION_NAME)

    testing.expect(t, !actual)
}

@(test)
test_entity_getDimension :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    DIMENSION_NAME : provision.DIMENSION_ID : "DIMENSION_NAME"

    actual, ok:= persistence.entity_getDimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == 0.0)
    testing.expect(t, !ok)
}

@(test)
test_entity_setDimension :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    DIMENSION_NAME : provision.DIMENSION_ID : "DIMENSION_NAME"
    DIMENSION_VALUE : f64 : 10.0

    persistence.entity_setDimension(&sut, DIMENSION_NAME, DIMENSION_VALUE)

    actual, ok:= persistence.entity_getDimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == DIMENSION_VALUE)
    testing.expect(t, ok)
    has_actual:= persistence.entity_hasDimension(&sut, DIMENSION_NAME)
    testing.expect(t, has_actual)
}

@(test)
test_entity_changeDimension_fail :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    DIMENSION_NAME : provision.DIMENSION_ID : "DIMENSION_NAME"
    DIMENSION_DELTA : f64 : 10.0

    persistence.entity_changeDimension(&sut, DIMENSION_NAME, DIMENSION_DELTA)

    actual, ok:= persistence.entity_getDimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == 0.0)
    testing.expect(t, !ok)
    has_actual:= persistence.entity_hasDimension(&sut, DIMENSION_NAME)
    testing.expect(t, !has_actual)
}

@(test)
test_entity_changeDimension_succeed :: proc(t: ^testing.T) {
    sut : provision.Entity_Data
    provision.entity_data_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    DIMENSION_NAME : provision.DIMENSION_ID : "DIMENSION_NAME"
    persistence.entity_setDimension(&sut, DIMENSION_NAME, 0.0)
    
    DIMENSION_DELTA : f64 : 10.0
    persistence.entity_changeDimension(&sut, DIMENSION_NAME, DIMENSION_DELTA)

    actual, ok:= persistence.entity_getDimension(&sut, DIMENSION_NAME)

    testing.expect(t, actual == DIMENSION_DELTA)
    testing.expect(t, ok)
    has_actual:= persistence.entity_hasDimension(&sut, DIMENSION_NAME)
    testing.expect(t, has_actual)
}
