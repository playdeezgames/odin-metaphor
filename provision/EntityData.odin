package provision

import "core:encoding/uuid"

UNIT :: distinct struct{}
STRING_SET :: distinct map[string]UNIT
UUID_SET :: distinct map[uuid.Identifier]UNIT

EntityData :: struct {
    entityType: string,
    metadatas: map[string]string,
    counters: map[string]i32,
    counterMinimums: map[string]i32,
    counterMaximums: map[string]i32,
    dimensions: map[string]f64,
    dimensionMinimums: map[string]f64,
    dimensionMaximums: map[string]f64,
    tags: STRING_SET,
    yokes: map[string]uuid.Identifier,
    yokages: map[string]UUID_SET
}
