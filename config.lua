Config = {}

Config.PickingItems = {
    [1] = {
        name = "tommer",
        threshold = 80,
        max = 1,
        remove = nil,
    },
}

Config.DryingItems = {
    [1] = {
        name = "planke",
        threshold = 80,
        max = 3,
        remove = "tommer",
    },
}

Config.Blips = {
    {
        blippoint = vector3(-652.892, 5153.381, 113.752),
        blipsprite = 237,
        blipscale = 0.65,
        blipcolour = 21,
        label = "Lumber Tree"
    },
    {
        blippoint = vector3(-595.296, 5330.225, 70.314),
        blipsprite = 237,
        blipscale = 0.65,
        blipcolour = 21,
        label = "Lumber Procces"
    },
    {
        blippoint = vector3(598.859, -3123.936, 6.069),
        blipsprite = 280,
        blipscale = 0.65,
        blipcolour = 21,
        label = "Lumber Buyer"
    },

}

Config.Picking = {
    {
        zones = { 
            vector2(-650.545, 5155.948),
            vector2(-653.736, 5157.625),
            vector2(-657.039, 5153.769),
            vector2(-651.434, 5150.678),
        },
        minz = 100.0,
        maxz = 125.0,
    },
}

Config.Drying = {
    {
        zones = { 
            vector2(-600.091, 5326.776),
            vector2(-593.011, 5326.93),
            vector2(-589.944, 5336.455),
            vector2(-596.039, 5338.207),
        },
        minz = 60.0,
        maxz = 80.0,
    },
}
