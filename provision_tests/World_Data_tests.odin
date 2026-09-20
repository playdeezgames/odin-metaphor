package provision_tests

import "core:testing"
import "../provision"

@(test)
test_raw_world_data_values :: proc(t: ^testing.T) {
    sut: provision.World_Data

    testing.expect(t, sut.entity_type == "")
    testing.expect(t, len(sut.metadatas) == 0)
    testing.expect(t, len(sut.counters) == 0)
    testing.expect(t, len(sut.counter_minimums) == 0)
    testing.expect(t, len(sut.counter_maximums) == 0)
    testing.expect(t, len(sut.dimensions) == 0)
    testing.expect(t, len(sut.dimension_minimums) == 0)
    testing.expect(t, len(sut.dimension_maximums) == 0)
    testing.expect(t, len(sut.tags) == 0)
    testing.expect(t, len(sut.yokes) == 0)
    testing.expect(t, len(sut.yokages) == 0)
    testing.expect(t, len(sut.entities) == 0)
    testing.expect(t, len(sut.messages) == 0)
}

@(test)
test_world_data_init_destroy :: proc(t: ^testing.T) {
    sut: provision.World_Data
    ENTITY_TYPE :: "ENTITY_TYPE"

    provision.world_data_init(&sut, ENTITY_TYPE)
    testing.expect(t, sut.entity_type == ENTITY_TYPE)
    testing.expect(t, len(sut.metadatas) == 0)
    testing.expect(t, len(sut.counters) == 0)
    testing.expect(t, len(sut.counter_minimums) == 0)
    testing.expect(t, len(sut.counter_maximums) == 0)
    testing.expect(t, len(sut.dimensions) == 0)
    testing.expect(t, len(sut.dimension_minimums) == 0)
    testing.expect(t, len(sut.dimension_maximums) == 0)
    testing.expect(t, len(sut.tags) == 0)
    testing.expect(t, len(sut.yokes) == 0)
    testing.expect(t, len(sut.yokages) == 0)
    testing.expect(t, len(sut.entities) == 0)
    testing.expect(t, len(sut.messages) == 0)

    provision.world_data_destroy(&sut)
    testing.expect(t, sut.entity_type == "")
    testing.expect(t, len(sut.metadatas) == 0)
    testing.expect(t, len(sut.counters) == 0)
    testing.expect(t, len(sut.counter_minimums) == 0)
    testing.expect(t, len(sut.counter_maximums) == 0)
    testing.expect(t, len(sut.dimensions) == 0)
    testing.expect(t, len(sut.dimension_minimums) == 0)
    testing.expect(t, len(sut.dimension_maximums) == 0)
    testing.expect(t, len(sut.tags) == 0)
    testing.expect(t, len(sut.yokes) == 0)
    testing.expect(t, len(sut.yokages) == 0)
    testing.expect(t, len(sut.entities) == 0)
    testing.expect(t, len(sut.messages) == 0)
}