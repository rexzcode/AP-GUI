getgenv().CarMod = getgenv().CarMod or {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

getgenv().CarMod.Config = {
    enabled = false,
    maxSpeed = 300,
    minSpeed = 50,
    turnRadius = 45,
    minTurnRadius = 10,
    maxTurnRadius = 100,
    infiniteHealth = true,
    healthAmount = 999999,
    autoFlip = true,
    flipForce = 10000,
    flipPower = 5000,
    flipDamping = 1000,
    noCollision = false,
    autoRepair = true,
    repairInterval = 0.5,
    flipThreshold = 0.1,
    applyOnEnter = true,
    restoreOnExit = true,
}

local currentVehicle = nil
local currentStats = nil
local originalStats = {}

local function findCarStats(vehicleSeat)
    local current = vehicleSeat.Parent
    
    while current and current ~= workspace do
        local stats = current:FindFirstChild("Stats")
        if stats then
            return stats
        end
        current = current.Parent
    end
    
    return nil
end

local function modifyCarStats(stats)
    if not stats then return false end
    
    if not originalStats[stats] then
        originalStats[stats] = {
            MaxSpeed = stats.MaxSpeed.Value,
            TurnRadius = stats.TurnRadius.Value,
            Health = stats.Health.Value,
        }
    end
    
    pcall(function()
        stats.MaxSpeed.Value = getgenv().CarMod.Config.maxSpeed
        stats.TurnRadius.Value = getgenv().CarMod.Config.turnRadius
        
        if getgenv().CarMod.Config.infiniteHealth then
            stats.Health.Value = getgenv().CarMod.Config.healthAmount
        end
    end)
    
    return true
end

local function restoreCarStats(stats)
    if not stats or not originalStats[stats] then return end
    
    pcall(function()
        local original = originalStats[stats]
        stats.MaxSpeed.Value = original.MaxSpeed
        stats.TurnRadius.Value = original.TurnRadius
        stats.Health.Value = original.Health
    end)
    
    originalStats[stats] = nil
end

local function applyInstantFlip(vehicleSeat)
    if not getgenv().CarMod.Config.autoFlip then return end
    
    local flip = vehicleSeat:FindFirstChild("Flip")
    if not flip then return end
    
    local lookVector = (vehicleSeat.CFrame * CFrame.Angles(math.rad(90), 0, 0)).LookVector
    
    if lookVector.Y <= getgenv().CarMod.Config.flipThreshold then
        flip.MaxTorque = Vector3.new(getgenv().CarMod.Config.flipForce, 0, getgenv().CarMod.Config.flipForce)
        flip.P = getgenv().CarMod.Config.flipPower
        flip.D = getgenv().CarMod.Config.flipDamping
        
        task.wait(0.5)
        
        flip.MaxTorque = Vector3.new(0, 0, 0)
        flip.P = 0
        flip.D = 0
    end
end

local function handleCollision(car)
    if not car then return end
    
    for _, part in ipairs(car:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                if getgenv().CarMod.Config.noCollision then
                    part.CanCollide = false
                else
                    if part.Name:lower():find("wheel") or part.Name:lower():find("tire") then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
end

local function onCharacterSeated(humanoid)
    if humanoid.Sit and humanoid.SeatPart then
        local vehicleSeat = humanoid.SeatPart
        
        if vehicleSeat:IsA("VehicleSeat") or vehicleSeat.Name == "VehicleSeat" then
            local stats = findCarStats(vehicleSeat)
            
            if stats then
                currentVehicle = vehicleSeat.Parent
                currentStats = stats
                
                if getgenv().CarMod.Config.enabled and getgenv().CarMod.Config.applyOnEnter then
                    modifyCarStats(stats)
                    handleCollision(currentVehicle)
                end
            end
        end
    else
        if currentStats and getgenv().CarMod.Config.restoreOnExit then
            restoreCarStats(currentStats)
            currentVehicle = nil
            currentStats = nil
        end
    end
end

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Seated:Connect(function()
        onCharacterSeated(humanoid)
    end)
    
    if humanoid.Sit and humanoid.SeatPart then
        onCharacterSeated(humanoid)
    end
end

local characterConnection = nil
local maintenanceLoop = nil

local function startCarMod()
    if characterConnection then return end
    
    if player.Character then
        setupCharacter(player.Character)
    end

    characterConnection = player.CharacterAdded:Connect(setupCharacter)

    maintenanceLoop = task.spawn(function()
    while true do
        if getgenv().CarMod.Config.enabled and currentStats and getgenv().CarMod.Config.infiniteHealth and getgenv().CarMod.Config.autoRepair then
            pcall(function()
                if currentStats.Health.Value < getgenv().CarMod.Config.healthAmount then
                    currentStats.Health.Value = getgenv().CarMod.Config.healthAmount
                end
            end)
        end
        
        if getgenv().CarMod.Config.enabled and currentVehicle and getgenv().CarMod.Config.autoFlip then
            local vehicleSeat = currentVehicle:FindFirstChild("VehicleSeat")
            if vehicleSeat then
                applyInstantFlip(vehicleSeat)
            end
        end
        
        task.wait(getgenv().CarMod.Config.repairInterval)
    end
    end)
end

getgenv().CarMod.Start = startCarMod

if getgenv().CarMod.Config.enabled then
    startCarMod()
end

getgenv().CarMod.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().CarMod.Config[key] ~= nil then
            getgenv().CarMod.Config[key] = value
        end
    end
    
    if currentStats and getgenv().CarMod.Config.enabled then
        modifyCarStats(currentStats)
        if currentVehicle then
            handleCollision(currentVehicle)
        end
    end
end

getgenv().CarMod.GetCurrentVehicle = function()
    return currentVehicle
end

getgenv().CarMod.GetCurrentStats = function()
    return currentStats
end

getgenv().CarMod.ForceApply = function()
    if currentStats then
        modifyCarStats(currentStats)
        if currentVehicle then
            handleCollision(currentVehicle)
        end
    end
end

getgenv().CarMod.ForceRestore = function()
    if currentStats then
        restoreCarStats(currentStats)
    end
end
