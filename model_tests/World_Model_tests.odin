package model_tests

import "core:testing"
import "../model"
import "../provision"

@(test)
test_world_model_initialize :: proc(t: ^testing.T) {
    world_data: provision.World_Data
    provision.world_data_init(&world_data, "")
    defer provision.world_data_destroy(&world_data)

    sut:model.World_Model
    model.world_model_initialize(&sut, &world_data, true)

    testing.expect(t, sut.world == &world_data)
    testing.expect(t, sut.quittable)
}

@(test)
test_world_model_is_quittable :: proc(t: ^testing.T) {
    world_data: provision.World_Data
    provision.world_data_init(&world_data, "")
    defer provision.world_data_destroy(&world_data)

    sut:model.World_Model
    model.world_model_initialize(&sut, &world_data, true)

    actual := model.world_model_is_quittable(&sut)

    testing.expect(t, actual)
}