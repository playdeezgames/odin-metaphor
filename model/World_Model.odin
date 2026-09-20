package model

import "../provision"

World_Model :: struct {
    world: provision.World_Data,
    quittable: bool
}

world_model_initialize :: proc(model: ^World_Model, world: ^provision.World_Data, quittable:bool) {
    model.world = world^
    model.quittable = quittable
}

world_model_is_quittable :: proc(model: ^World_Model) -> bool {
    return model.quittable
}

//     Public ReadOnly Property Messages As IEnumerable(Of IMessage) Implements IWorldModel.Messages
//         Get
//             Return Entity.Messages
//         End Get
//     End Property

//     Public ReadOnly Property Location As ILocationModel Implements IWorldModel.Location
//         Get
//             Return LocationModel.Create(Entity.Avatar.Location)
//         End Get
//     End Property

//     Public ReadOnly Property Avatar As IAvatarModel Implements IWorldModel.Avatar
//         Get
//             Return AvatarModel.Create(Entity.Avatar)
//         End Get
//     End Property

//     Public ReadOnly Property Ad As IAdModel Implements IWorldModel.Ad
//         Get
//             Return AdModel.Create(Entity)
//         End Get
//     End Property

//     Public Sub Embark(chosenName As String) Implements IWorldModel.Embark
//         Abandon()
//         Entity.Initialize(chosenName, (5, 4))
//     End Sub

//     Public Sub Abandon() Implements IWorldModel.Abandon
//         Entity.Clear()
//     End Sub

//     Public Shared Async Function Create(quittable As Boolean, persister As IPersister) As Task(Of IWorldModel)
//         Dim entity As IWorld
//         Try
//             entity = Await Metaphor.Persistence.World.Load(SAVE_FILENAME, persister)
//         Catch ex As Exception
//             entity = Metaphor.Persistence.World.Create(New Provision.WorldData With {.EntityType = EntityTypes.WORLD_ENTITY}, persister)
//         End Try
//         Return New WorldModel(entity, quittable)
//     End Function
// End Class
