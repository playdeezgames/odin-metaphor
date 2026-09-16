package persistence

import "../provision"

VERB_ID :: distinct provision.ENTITY_ID

Verb :: distinct MetaphorEntity(VERB_ID)

VerbInitializer :: distinct proc(^Verb)

// Friend Class Verb
//     Inherits MetaphorEntity
//     Implements IVerb

//     Private Sub New(world As IWorld, data As WorldData, verbId As Guid)
//         MyBase.New(world, data, verbId)
//     End Sub

//     Protected Overrides ReadOnly Property Data As EntityData
//         Get
//             Return _data.Entities(EntityId)
//         End Get
//     End Property

verb_remove :: proc(entity: ^Verb) {
    if entity == nil || entity.entityData == nil {
        return
    }
    //TODO
    //         _data.Entities.Remove(EntityId)
}

//     Friend Shared Function Create(world As IWorld, data As WorldData, verbId As Guid) As IVerb
//         Return New Verb(world, data, verbId)
//     End Function
// End Class
