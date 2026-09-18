package persistence

import "core:testing"
import "../provision"

@(test)
test_entity_getMetadata :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual, ok := entity_getMetadata(&sut, METADATAS_SUBTYPE)

    testing.expect(t, actual == "")
    testing.expect(t, !ok)
}

@(test)
test_entity_hasMetadata :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual:= entity_hasMetadata(&sut, METADATAS_SUBTYPE)

    testing.expect(t, !actual)
}


@(test)
test_entity_setMetadata :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    METADATA_VALUE :: "METADATA_VALUE"
    entity_setMetadata(&sut, METADATAS_SUBTYPE, METADATA_VALUE)

    has_actual:= entity_hasMetadata(&sut, METADATAS_SUBTYPE)
    testing.expect(t, has_actual)

    get_actual, get_ok := entity_getMetadata(&sut, METADATAS_SUBTYPE)
    testing.expect(t, get_actual == METADATA_VALUE)
    testing.expect(t, get_ok)
}

@(test)
test_entity_getCounter :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual, ok := entity_getCounter(&sut, COUNTERS_COLUMN)

    testing.expect(t, actual == 0)
    testing.expect(t, !ok)
}

@(test)
test_entity_hasCounter :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual:= entity_hasCounter(&sut, COUNTERS_COLUMN)

    testing.expect(t, !actual)
}

