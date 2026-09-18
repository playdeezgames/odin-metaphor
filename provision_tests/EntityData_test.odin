package provision_tests

import "core:testing"
import "../provision"

@(test)
test_raw_EntityData_values :: proc(t: ^testing.T) {
    sut: provision.EntityData
    testing.expect(t, sut.entityType == "")
    testing.expect(t, len(sut.metadatas) == 0)
    testing.expect(t, len(sut.counters) == 0)
    testing.expect(t, len(sut.counterMinimums) == 0)
    testing.expect(t, len(sut.counterMaximums) == 0)
    testing.expect(t, len(sut.dimensions) == 0)
    testing.expect(t, len(sut.dimensionMinimums) == 0)
    testing.expect(t, len(sut.dimensionMaximums) == 0)
    testing.expect(t, len(sut.tags) == 0)
    testing.expect(t, len(sut.yokes) == 0)
    testing.expect(t, len(sut.yokages) == 0)
}

@(test)
test_entityData_ctor_dtor :: proc(t: ^testing.T) {
    ENTITY_TYPE :: "ENTITY_TYPE"
    sut: provision.EntityData
    provision.entityData_ctor(&sut, ENTITY_TYPE)
    testing.expect(t, sut.entityType == ENTITY_TYPE)
    testing.expect(t, len(sut.metadatas) == 0)
    testing.expect(t, len(sut.counters) == 0)
    testing.expect(t, len(sut.counterMinimums) == 0)
    testing.expect(t, len(sut.counterMaximums) == 0)
    testing.expect(t, len(sut.dimensions) == 0)
    testing.expect(t, len(sut.dimensionMinimums) == 0)
    testing.expect(t, len(sut.dimensionMaximums) == 0)
    testing.expect(t, len(sut.tags) == 0)
    testing.expect(t, len(sut.yokes) == 0)
    testing.expect(t, len(sut.yokages) == 0)

    provision.entityData_dtor(&sut)
    testing.expect(t, sut.entityType == "")
    testing.expect(t, len(sut.metadatas) == 0)
    testing.expect(t, len(sut.counters) == 0)
    testing.expect(t, len(sut.counterMinimums) == 0)
    testing.expect(t, len(sut.counterMaximums) == 0)
    testing.expect(t, len(sut.dimensions) == 0)
    testing.expect(t, len(sut.dimensionMinimums) == 0)
    testing.expect(t, len(sut.dimensionMaximums) == 0)
    testing.expect(t, len(sut.tags) == 0)
    testing.expect(t, len(sut.yokes) == 0)
    testing.expect(t, len(sut.yokages) == 0)
}