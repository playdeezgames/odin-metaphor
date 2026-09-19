package provision_tests

import "core:testing"
import "../provision"

@(test)
test_raw_EntityData_values :: proc(t: ^testing.T) {
    sut: provision.Entity_Data
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
    sut: provision.Entity_Data
    provision.entity_data_ctor(&sut, ENTITY_TYPE)
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

    provision.entity_data_dtor(&sut)
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