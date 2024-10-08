Config = {}

Config.UseableItems = true -- Set to false if you want to use commands instead of usable items


Config.PaymentPerPaper = 10 -- Payment per newspaper delivered 

Config.DeliveryPoints = {
    {x = 893.2, y = -540.61, z = 58.51}, -- Residential house
    {x = 862.61, y = -509.79, z = 57.33}, -- Residential house
    {x = 844.81, y = -564.69, z = 57.71}, -- Residential house
}

Config.PickupPoint = {x = -590.93, y = -912.62, z = 23.88} -- Start and finish location 


Config.Locations = {
    ["main"] = {
        label = "Weazle News HQ",
        coords = vector4(-597.89, -929.95, 24.0, 271.5),
    },
    ["inside"] = {
        label = "Weazle News HQ Inside",
        coords = vector4(-77.46, -833.77, 243.38, 67.5),
    },
    ["outside"] = {
        label = "Weazle News HQ Outside",
        coords = vector4(-598.25, -929.86, 23.86, 86.5),
    },
    ["vehicle"] = {
        label = "Vehicle Storage",
        coords = vector4(-552.24, -925.61, 23.86, 242.5),
    },
    ["heli"] = {
        label = "Helicopter Storage",
        coords = vector4(-583.08, -930.55, 36.83, 89.26),
    }
}

Config.Vehicles = {
    -- Grade 0
    [0] = {
        ["rumpo"] = "Rumpo",
    },
    -- Grade 1
    [1] = {
        ["rumpo"] = "Rumpo",

    },
    -- Grade 2
    [2] = {
        ["rumpo"] = "Rumpo",
    },
    -- Grade 3
    [3] = {
        ["rumpo"] = "Rumpo",
    },
    -- Grade 4
    [4] = {
        ["rumpo"] = "Rumpo",
    }
}

Config.Helicopters = {
    -- Grade 0
    [0] = {
        ["frogger"] = "Frogger",
    },
    -- Grade 1
    [1] = {
        ["frogger"] = "Frogger",

    },
    -- Grade 2
    [2] = {
        ["frogger"] = "Frogger",
    },
    -- Grade 3
    [3] = {
        ["frogger"] = "Frogger",
    },
    -- Grade 4
    [4] = {
        ["frogger"] = "Frogger",
    }
}

Config.VehicleItems = {
    [1] = {
        name = "newscam",
        amount = 1,
        info = {},
    },
    [2] = {
        name = "newsmic",
        amount = 1,
        info = {},
    },
    [3] = {
        name = "newsbmic",
        amount = 1,
        info = {},
    },
}
