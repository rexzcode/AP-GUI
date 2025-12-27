getgenv().AutoFarm = getgenv().AutoFarm or {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().AutoFarm.Config = {
    enabled = false,
    farmEnemies = true,
    heightOffset = 100,
    waitTime = 0.5,
    loopTeleport = true,
    enemyDistance = 30,
    anchorPlayer = true,
    platformStand = true,
    autoStart = false,
    selectedLocations = {},
    skipEmptyLocations = true,
    randomizeOrder = false,
    minEnemiesBeforeMove = 0,
    enemyBringDelay = 0.1,
    enemyHealthThreshold = 0,
}

local locations = {
    ["RadioStation"] = {
        {
            name = "RadioStationBuilding",
            path = "workspace['...'].Map.RadioStation.RadioStationBuilding",
            cframe = CFrame.new(1678.14, 725.44, -546.66, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(1678.14, 725.44, -546.66),
        },
    },
    ["SmallStop"] = {
        {
            name = "Arcade",
            path = "workspace['...'].Map.SmallStop.Arcade",
            cframe = CFrame.new(387.11, 216.65, -2337.22, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(387.11, 216.65, -2337.22),
        },
        {
            name = "PoolSupplies",
            path = "workspace['...'].Map.SmallStop.PoolSupplies",
            cframe = CFrame.new(433.66, 224.65, -2392.22, 0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, 0.00, -0.00),
            position = Vector3.new(433.66, 224.65, -2392.22),
        },
        {
            name = "Connor's",
            path = "workspace['...'].Map.SmallStop.Connor's",
            cframe = CFrame.new(540.21, 224.65, -2392.22, 0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, 0.00, -0.00),
            position = Vector3.new(540.21, 224.65, -2392.22),
        },
        {
            name = "PawnShop",
            path = "workspace['...'].Map.SmallStop.PawnShop",
            cframe = CFrame.new(482.71, 224.65, -2392.22, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(482.71, 224.65, -2392.22),
        },
    },
    ["Tunnel"] = {
        {
            name = "Tunnel",
            path = "workspace['...'].Map.Tunnel.Tunnel",
            cframe = CFrame.new(1416.26, 362.34, 1952.78, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(1416.26, 362.34, 1952.78),
        },
        {
            name = "Curve",
            path = "workspace['...'].Map.Tunnel.Curve",
            cframe = CFrame.new(75.76, 362.34, 2946.79, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(75.76, 362.34, 2946.79),
        },
    },
    ["Terrain"] = {
        {
            name = "NormTree",
            path = "workspace['...'].Map.Terrain.NormTree",
            cframe = CFrame.new(-3906.08, 342.11, -5724.22, 0.79, 0.05, -0.60, -0.05, 1.00, 0.02, -0.61, -0.01, -0.80),
            position = Vector3.new(-3906.08, 342.11, -5724.22),
        },
        {
            name = "Pine Tree",
            path = "workspace['...'].Map.Terrain.Pine Tree",
            cframe = CFrame.new(-1053.37, 453.69, -1788.68, -0.02, 0.01, -1.00, -0.01, 1.00, 0.01, -1.00, -0.01, 0.02),
            position = Vector3.new(-1053.37, 453.69, -1788.68),
        },
        {
            name = "Snowy Pine Tree",
            path = "workspace['...'].Map.Terrain.Snowy Pine Tree",
            cframe = CFrame.new(-176.92, 807.85, -1185.05, -0.96, 0.06, -0.28, 0.04, 1.00, 0.07, -0.28, -0.06, 0.96),
            position = Vector3.new(-176.92, 807.85, -1185.05),
        },
    },
    ["Redwood"] = {
        {
            name = "UnnamedBuilding",
            path = "workspace['...'].Map.Redwood.UnnamedBuilding",
            cframe = CFrame.new(-83.29, 225.15, -2581.22, 0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, 0.00, -0.00),
            position = Vector3.new(-83.29, 225.15, -2581.22),
        },
        {
            name = "SodaShop",
            path = "workspace['...'].Map.Redwood.SodaShop",
            cframe = CFrame.new(-94.79, 216.15, -2457.22, -0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, 0.00),
            position = Vector3.new(-94.79, 216.15, -2457.22),
        },
        {
            name = "Bakery",
            path = "workspace['...'].Map.Redwood.Bakery",
            cframe = CFrame.new(-20.79, 215.65, -2467.22, -0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, 0.00),
            position = Vector3.new(-20.79, 215.65, -2467.22),
        },
        {
            name = "Building",
            path = "workspace['...'].Map.Redwood.Building",
            cframe = CFrame.new(150.21, 223.65, -2440.72, 0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, 0.00, -0.00),
            position = Vector3.new(150.21, 223.65, -2440.72),
        },
        {
            name = "Grill",
            path = "workspace['...'].Map.Redwood.Grill",
            cframe = CFrame.new(273.71, 215.15, -2319.72, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(273.71, 215.15, -2319.72),
        },
        {
            name = "Building4",
            path = "workspace['...'].Map.Redwood.Building4",
            cframe = CFrame.new(266.21, 215.65, -2421.22, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(266.21, 215.65, -2421.22),
        },
        {
            name = "MexicanFood",
            path = "workspace['...'].Map.Redwood.MexicanFood",
            cframe = CFrame.new(258.21, 223.15, -2469.72, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(258.21, 223.15, -2469.72),
        },
        {
            name = "FireDept",
            path = "workspace['...'].Map.Redwood.FireDept",
            cframe = CFrame.new(28.21, 224.15, -2695.22, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(28.21, 224.15, -2695.22),
        },
    },
    ["TouristTown"] = {
        {
            name = "Motel",
            path = "workspace['...'].Map.TouristTown.Motel",
            cframe = CFrame.new(-1673.77, 568.10, -880.07, -0.00, 0.00, 1.00, -0.00, 1.00, 0.00, 1.00, 0.00, 0.00),
            position = Vector3.new(-1673.77, 568.10, -880.07),
        },
        {
            name = "GeneralStore",
            path = "workspace['...'].Map.TouristTown.GeneralStore",
            cframe = CFrame.new(-1491.77, 559.10, -907.58, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1491.77, 559.10, -907.58),
        },
        {
            name = "UnnamedBuilding",
            path = "workspace['...'].Map.TouristTown.UnnamedBuilding",
            cframe = CFrame.new(-1491.27, 558.60, -742.58, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(-1491.27, 558.60, -742.58),
        },
    },
    ["Town1"] = {
        {
            name = "Nobil Gas Station",
            path = "workspace['...'].Map.Town1.Nobil Gas Station",
            cframe = CFrame.new(2447.63, 242.24, -2203.02, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(2447.63, 242.24, -2203.02),
        },
        {
            name = "Building2",
            path = "workspace['...'].Map.Town1.Building2",
            cframe = CFrame.new(2758.32, 234.54, -2165.02, 0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, 0.00, -0.00),
            position = Vector3.new(2758.32, 234.54, -2165.02),
        },
        {
            name = "Building1",
            path = "workspace['...'].Map.Town1.Building1",
            cframe = CFrame.new(2721.82, 236.04, -2166.02, 0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, 0.00, -0.00),
            position = Vector3.new(2721.82, 236.04, -2166.02),
        },
        {
            name = "Bestseller Video",
            path = "workspace['...'].Map.Town1.Bestseller Video",
            cframe = CFrame.new(2727.32, 226.54, -2241.02, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(2727.32, 226.54, -2241.02),
        },
        {
            name = "Building5",
            path = "workspace['...'].Map.Town1.Building5",
            cframe = CFrame.new(2832.82, 223.54, -2040.52, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(2832.82, 223.54, -2040.52),
        },
        {
            name = "Building4",
            path = "workspace['...'].Map.Town1.Building4",
            cframe = CFrame.new(2793.32, 218.54, -2040.02, 0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, -0.00),
            position = Vector3.new(2793.32, 218.54, -2040.02),
        },
    },
    ["MilitaryCheckpoint"] = {
        {
            name = "UnnamedBuilding",
            path = "workspace['...'].Map.MilitaryCheckpoint.UnnamedBuilding",
            cframe = CFrame.new(2045.61, 574.56, 1025.80, -0.50, 0.00, -0.87, 0.00, 1.00, 0.00, -0.87, -0.00, 0.50),
            position = Vector3.new(2045.61, 574.56, 1025.80),
        },
        {
            name = "WaffleHut",
            path = "workspace['...'].Map.MilitaryCheckpoint.WaffleHut",
            cframe = CFrame.new(2115.05, 577.56, 1216.07, -0.87, 0.00, 0.50, 0.00, 1.00, 0.00, 0.50, -0.00, 0.87),
            position = Vector3.new(2115.05, 577.56, 1216.07),
        },
        {
            name = "GunStore",
            path = "workspace['...'].Map.MilitaryCheckpoint.GunStore",
            cframe = CFrame.new(2150.69, 572.06, 902.78, -0.50, 0.00, -0.87, 0.00, 1.00, 0.00, -0.87, -0.00, 0.50),
            position = Vector3.new(2150.69, 572.06, 902.78),
        },
        {
            name = "CarDealership",
            path = "workspace['...'].Map.MilitaryCheckpoint.CarDealership",
            cframe = CFrame.new(2265.04, 558.81, 1053.84, -0.87, 0.00, 0.50, 0.00, 1.00, 0.00, 0.50, -0.00, 0.87),
            position = Vector3.new(2265.04, 558.81, 1053.84),
        },
    },
    ["StMarryHospital"] = {
        {
            name = "Hospital",
            path = "workspace['...'].Map.StMarryHospital.Hospital",
            cframe = CFrame.new(-652.25, 360.59, 2052.79, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-652.25, 360.59, 2052.79),
        },
    },
    ["BigCity"] = {
        {
            name = "UnnamedBuilding",
            path = "workspace['...'].Map.BigCity.UnnamedBuilding",
            cframe = CFrame.new(-1416.75, 371.84, 1294.30, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-1416.75, 371.84, 1294.30),
        },
        {
            name = "Building",
            path = "workspace['...'].Map.BigCity.Building",
            cframe = CFrame.new(-1599.25, 371.84, 1354.30, -0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, -0.00, 0.00),
            position = Vector3.new(-1599.25, 371.84, 1354.30),
        },
        {
            name = "CorpBuilding1",
            path = "workspace['...'].Map.BigCity.CorpBuilding1",
            cframe = CFrame.new(-1288.25, 360.59, 1378.29, -0.00, 0.00, 1.00, -0.00, 1.00, 0.00, 1.00, 0.00, 0.00),
            position = Vector3.new(-1288.25, 360.59, 1378.29),
        },
        {
            name = "FallenBuilding",
            path = "workspace['...'].Map.BigCity.FallenBuilding",
            cframe = CFrame.new(-1116.44, 363.16, 1318.31, -0.42, 0.00, -0.91, 0.00, 1.00, 0.00, -0.91, -0.00, 0.42),
            position = Vector3.new(-1116.44, 363.16, 1318.31),
        },
        {
            name = "CorpBuilding3",
            path = "workspace['...'].Map.BigCity.CorpBuilding3",
            cframe = CFrame.new(-910.25, 360.84, 1331.30, -0.00, 0.00, 1.00, -0.00, 1.00, 0.00, 1.00, 0.00, 0.00),
            position = Vector3.new(-910.25, 360.84, 1331.30),
        },
        {
            name = "PrimColor",
            path = "workspace['...'].Map.BigCity.PrimColor",
            cframe = CFrame.new(-2075.43, 367.84, 1335.80, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-2075.43, 367.84, 1335.80),
        },
        {
            name = "GeekMart",
            path = "workspace['...'].Map.BigCity.GeekMart",
            cframe = CFrame.new(-1599.25, 374.84, 1592.30, -0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, -0.00, 0.00),
            position = Vector3.new(-1599.25, 374.84, 1592.30),
        },
        {
            name = "Building2",
            path = "workspace['...'].Map.BigCity.Building2",
            cframe = CFrame.new(-1033.75, 404.34, 1402.79, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1033.75, 404.34, 1402.79),
        },
        {
            name = "SniperNestBuilding",
            path = "workspace['...'].Map.BigCity.SniperNestBuilding",
            cframe = CFrame.new(-1232.25, 360.59, 1585.79, -0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, -0.00, 0.00),
            position = Vector3.new(-1232.25, 360.59, 1585.79),
        },
        {
            name = "PrimaryColor",
            path = "workspace['...'].Map.BigCity.PrimaryColor",
            cframe = CFrame.new(-2003.25, 369.84, 1404.30, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-2003.25, 369.84, 1404.30),
        },
        {
            name = "OffbrandCVSlo",
            path = "workspace['...'].Map.BigCity.OffbrandCVSlo",
            cframe = CFrame.new(-1041.25, 360.59, 1609.29, -0.00, 0.00, 1.00, -0.00, 1.00, 0.00, 1.00, 0.00, 0.00),
            position = Vector3.new(-1041.25, 360.59, 1609.29),
        },
        {
            name = "CorpBuilding2",
            path = "workspace['...'].Map.BigCity.CorpBuilding2",
            cframe = CFrame.new(-949.75, 367.34, 1796.79, -0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, 0.00),
            position = Vector3.new(-949.75, 367.34, 1796.79),
        },
        {
            name = "Building1",
            path = "workspace['...'].Map.BigCity.Building1",
            cframe = CFrame.new(-1041.25, 379.34, 1769.29, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1041.25, 379.34, 1769.29),
        },
        {
            name = "AuroraNightclub",
            path = "workspace['...'].Map.BigCity.AuroraNightclub",
            cframe = CFrame.new(-1416.25, 382.34, 1715.80, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1416.25, 382.34, 1715.80),
        },
        {
            name = "ClamGasSttion",
            path = "workspace['...'].Map.BigCity.ClamGasSttion",
            cframe = CFrame.new(-2072.25, 380.84, 1852.31, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-2072.25, 380.84, 1852.31),
        },
        {
            name = "PartialFoods",
            path = "workspace['...'].Map.BigCity.PartialFoods",
            cframe = CFrame.new(-1904.24, 362.83, 2166.30, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1904.24, 362.83, 2166.30),
        },
        {
            name = "EmptyBuilding",
            path = "workspace['...'].Map.BigCity.EmptyBuilding",
            cframe = CFrame.new(-2054.74, 378.33, 2166.30, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-2054.74, 378.33, 2166.30),
        },
        {
            name = "Bennys",
            path = "workspace['...'].Map.BigCity.Bennys",
            cframe = CFrame.new(-2154.74, 362.83, 2166.30, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-2154.74, 362.83, 2166.30),
        },
        {
            name = "Building1Labeled",
            path = "workspace['...'].Map.BigCity.Building1Labeled",
            cframe = CFrame.new(-689.75, 439.34, 1305.79, -0.00, 0.00, -1.00, 0.00, 1.00, 0.00, -1.00, -0.00, 0.00),
            position = Vector3.new(-689.75, 439.34, 1305.79),
        },
        {
            name = "Building3",
            path = "workspace['...'].Map.BigCity.Building3",
            cframe = CFrame.new(-847.25, 379.34, 1580.29, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-847.25, 379.34, 1580.29),
        },
        {
            name = "Building4",
            path = "workspace['...'].Map.BigCity.Building4",
            cframe = CFrame.new(-515.25, 409.23, 1511.28, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-515.25, 409.23, 1511.28),
        },
        {
            name = "FirebirdPD",
            path = "workspace['...'].Map.BigCity.FirebirdPD",
            cframe = CFrame.new(-713.25, 360.59, 1712.79, -0.00, 0.00, 1.00, -0.00, 1.00, 0.00, 1.00, 0.00, 0.00),
            position = Vector3.new(-713.25, 360.59, 1712.79),
        },
    },
    ["Mall"] = {
        {
            name = "MallBuilding",
            path = "workspace['...'].Map.Mall.MallBuilding",
            cframe = CFrame.new(-1046.23, 360.59, 2292.80, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-1046.23, 360.59, 2292.80),
        },
        {
            name = "Shop2",
            path = "workspace['...'].Map.Mall.Shop2",
            cframe = CFrame.new(-1224.75, 392.84, 2275.30, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-1224.75, 392.84, 2275.30),
        },
        {
            name = "Shop1",
            path = "workspace['...'].Map.Mall.Shop1",
            cframe = CFrame.new(-1224.75, 370.84, 2275.30, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-1224.75, 370.84, 2275.30),
        },
        {
            name = "Shop3",
            path = "workspace['...'].Map.Mall.Shop3",
            cframe = CFrame.new(-1496.76, 392.84, 2275.30, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-1496.76, 392.84, 2275.30),
        },
        {
            name = "NormalTree",
            path = "workspace['...'].Map.Mall.NormalTree",
            cframe = CFrame.new(-1527.57, 381.54, 2373.03, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1527.57, 381.54, 2373.03),
        },
        {
            name = "Island",
            path = "workspace['...'].Map.Mall.Island",
            cframe = CFrame.new(-1495.76, 362.84, 2370.30, -1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, 1.00),
            position = Vector3.new(-1495.76, 362.84, 2370.30),
        },
        {
            name = "Model",
            path = "workspace['...'].Map.Mall.Model",
            cframe = CFrame.new(-1319.25, 371.84, 2384.30, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-1319.25, 371.84, 2384.30),
        },
    },
    ["Camp"] = {
        {
            name = "Cabin",
            path = "workspace['...'].Map.Camp.Cabin",
            cframe = CFrame.new(147.32, 376.84, 864.14, -0.82, 0.00, -0.57, 0.00, 1.00, 0.00, -0.57, -0.00, 0.82),
            position = Vector3.new(147.32, 376.84, 864.14),
        },
    },
    ["Farm"] = {
        {
            name = "Barn",
            path = "workspace['...'].Map.Farm.Barn",
            cframe = CFrame.new(-2748.05, 238.65, -4595.73, -0.00, 0.00, 1.00, 0.00, 1.00, 0.00, 1.00, -0.00, 0.00),
            position = Vector3.new(-2748.05, 238.65, -4595.73),
        },
        {
            name = "Bumker",
            path = "workspace['...'].Map.Farm.Bumker",
            cframe = CFrame.new(-3009.30, 158.65, -4755.73, 1.00, 0.00, 0.00, 0.00, 1.00, 0.00, -0.00, -0.00, -1.00),
            position = Vector3.new(-3009.30, 158.65, -4755.73),
        },
    },
}

local totalLocations = 0
local isRunning = false
local enemyFarmRunning = false

for _, landmarks in pairs(locations) do
    totalLocations = totalLocations + #landmarks
end

local function teleportTo(position)
    local character = player.Character
    if not character then return false end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    local targetPos = Vector3.new(position.X, position.Y + getgenv().AutoFarm.Config.heightOffset, position.Z)
    humanoidRootPart.CFrame = CFrame.new(targetPos)

    return true
end

local function countEnemiesNearby()
    local otherWaifus = workspace:FindFirstChild("OtherWaifus")
    if not otherWaifus then return 0 end
    
    local count = 0
    for _, enemy in ipairs(otherWaifus:GetChildren()) do
        if enemy:IsA("Model") then
            local zombieHumanoid = enemy:FindFirstChild("Zombie")
            if zombieHumanoid and zombieHumanoid.Health > getgenv().AutoFarm.Config.enemyHealthThreshold then
                count = count + 1
            end
        end
    end
    return count
end

local function bringEnemiesToPlayer()
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local otherWaifus = workspace:FindFirstChild("OtherWaifus")
    if not otherWaifus then return end

    local enemyCount = 0
    local lookVector = humanoidRootPart.CFrame.LookVector

    for _, enemy in ipairs(otherWaifus:GetChildren()) do
        if enemy:IsA("Model") then
            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
            local zombieHumanoid = enemy:FindFirstChild("Zombie")

            if enemyRoot and zombieHumanoid and zombieHumanoid.Health > getgenv().AutoFarm.Config.enemyHealthThreshold then
                local targetPosition = humanoidRootPart.Position + (lookVector * getgenv().AutoFarm.Config.enemyDistance)
                enemyRoot.CFrame = CFrame.new(targetPosition)
                enemyCount = enemyCount + 1
            end
        end
    end

    return enemyCount
end

local enemyBringLoop = nil
local anchorLoop = nil

local function startAutoFarmLoops()
    if enemyBringLoop then return end
    
    enemyBringLoop = task.spawn(function()
        while getgenv().AutoFarm.Config.enabled do
            if getgenv().AutoFarm.Config.farmEnemies and enemyFarmRunning then
                bringEnemiesToPlayer()
            end
            task.wait(getgenv().AutoFarm.Config.enemyBringDelay)
        end
        enemyBringLoop = nil
    end)

    anchorLoop = task.spawn(function()
        while getgenv().AutoFarm.Config.enabled do
            if isRunning then
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")

                    if humanoidRootPart and humanoid then
                        if getgenv().AutoFarm.Config.anchorPlayer then
                            humanoidRootPart.Anchored = true
                        end
                        if getgenv().AutoFarm.Config.platformStand then
                            humanoid.PlatformStand = true
                        end
                    end
                end
            else
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")

                    if humanoidRootPart and humanoid then
                        humanoidRootPart.Anchored = false
                        humanoid.PlatformStand = false
                    end
                end
            end
            task.wait(0.1)
        end
        anchorLoop = nil
    end)
end

local function getLocationsList()
    local selectedLocs = getgenv().AutoFarm.Config.selectedLocations
    if #selectedLocs > 0 then
        local filteredLocs = {}
        for _, locName in ipairs(selectedLocs) do
            if locations[locName] then
                filteredLocs[locName] = locations[locName]
            end
        end
        return filteredLocs
    end
    return locations
end

local function startTeleporting()
    if isRunning then return end

    isRunning = true
    enemyFarmRunning = true
    
    startAutoFarmLoops()

    task.spawn(function()
        local teleportCount = 0

        while getgenv().AutoFarm.Config.enabled and isRunning do
            local locsList = getLocationsList()
            
            local orderedLocs = {}
            for name, _ in pairs(locsList) do
                table.insert(orderedLocs, name)
            end
            
            if getgenv().AutoFarm.Config.randomizeOrder then
                for i = #orderedLocs, 2, -1 do
                    local j = math.random(1, i)
                    orderedLocs[i], orderedLocs[j] = orderedLocs[j], orderedLocs[i]
                end
            end
            
            for _, locationName in ipairs(orderedLocs) do
                if not getgenv().AutoFarm.Config.enabled or not isRunning then break end
                
                local landmarks = locsList[locationName]

                for i, landmark in ipairs(landmarks) do
                    if not getgenv().AutoFarm.Config.enabled or not isRunning then break end
                    
                    if getgenv().AutoFarm.Config.skipEmptyLocations then
                        local enemyCount = countEnemiesNearby()
                        if enemyCount < getgenv().AutoFarm.Config.minEnemiesBeforeMove then
                            continue
                        end
                    end

                    teleportCount = teleportCount + 1
                    local success = teleportTo(landmark.position)

                    if success then
                        bringEnemiesToPlayer()
                    end

                    task.wait(getgenv().AutoFarm.Config.waitTime)
                end
            end

            if not getgenv().AutoFarm.Config.loopTeleport then
                isRunning = false
                enemyFarmRunning = false
                break
            else
                teleportCount = 0
            end
        end

        isRunning = false
        enemyFarmRunning = false
    end)
end

local function stopTeleporting()
    isRunning = false
    enemyFarmRunning = false
    getgenv().AutoFarm.Config.enabled = false

    task.wait(0.2)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")

        if humanoidRootPart and humanoid then
            humanoidRootPart.Anchored = false
            humanoid.PlatformStand = false
        end
    end
end

getgenv().AutoFarm.Start = startTeleporting
getgenv().AutoFarm.Stop = stopTeleporting
getgenv().AutoFarm.GetLocations = function() return locations end
getgenv().AutoFarm.GetLocationNames = function()
    local names = {}
    for name, _ in pairs(locations) do
        table.insert(names, name)
    end
    return names
end
getgenv().AutoFarm.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().AutoFarm.Config[key] ~= nil then
            getgenv().AutoFarm.Config[key] = value
        end
    end
end

if getgenv().AutoFarm.Config.autoStart then
    startTeleporting()
end
