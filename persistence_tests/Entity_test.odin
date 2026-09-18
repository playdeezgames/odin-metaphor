package persistence_tests

import "core:testing"
import "../provision"
import "../persistence"

@(test)
test_entity_getMetadata :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual, ok := persistence.entity_getMetadata(&sut, persistence.METADATAS_SUBTYPE)

    testing.expect(t, actual == "")
    testing.expect(t, !ok)
}

@(test)
test_entity_hasMetadata :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual:= persistence.entity_hasMetadata(&sut, persistence.METADATAS_SUBTYPE)

    testing.expect(t, !actual)
}


@(test)
test_entity_setMetadata :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
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
    sut : provision.EntityData
    provision.entityData_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual, ok := persistence.entity_getCounter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, actual == 0)
    testing.expect(t, !ok)
}

@(test)
test_entity_hasCounter :: proc(t: ^testing.T) {
    sut : provision.EntityData
    provision.entityData_ctor(&sut, persistence.ENTITYTYPES_CHARACTER)
    defer provision.entityData_dtor(&sut)

    actual:= persistence.entity_hasCounter(&sut, persistence.COUNTERS_COLUMN)

    testing.expect(t, !actual)
}

