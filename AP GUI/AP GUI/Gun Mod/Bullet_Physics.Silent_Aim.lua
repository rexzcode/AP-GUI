getgenv().BulletMod = getgenv().BulletMod or {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

getgenv().BulletMod.Config = {
    enabled = false,
    infiniteRange = false,
    maxDistance = 999999,
    lifetime = 999999,
    penetrateWalls = false,
    penetrateEnemies = false,
    noGravity = false,
    bulletSpeed = 1300,
    minBulletSpeed = 1300,
    maxBulletSpeed = 50000,
    silentAim = false,
    aimFOV = 500,
    minAimFOV = 50,
    maxAimFOV = 1000,
    selectedBodyParts = {"Head"},
    predictMovement = false,
    predictionMultiplier = 1,
    autoShoot = false,
    ignoreTeammates = true,
    ignoreFriends = true,
    targetSelection = "closest",
    showFOVCircle = false,
    fovCircleColor = Color3.fromRGB(255, 255, 255),
    fovCircleTransparency = 0.5,
    wallCheckEnabled = false,
}

local bodyPartCycleIndex = 1

local bodyPartAliases = {
    ["Torso"] = {"Torso", "UpperTorso", "LowerTorso"},
    ["Left Arm"] = {"Left Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand"},
    ["Right Arm"] = {"Right Arm", "RightUpperArm", "RightLowerArm", "RightHand"},
    ["Left Leg"] = {"Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
    ["Right Leg"] = {"Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"},
    ["Head"] = {"Head"},
    ["HumanoidRootPart"] = {"HumanoidRootPart"}
}

local function findBodyPart(character, partName)
    local aliases = bodyPartAliases[partName]
    if aliases then
        for _, alias in ipairs(aliases) do
            local part = character:FindFirstChild(alias)
            if part then
                return part
            end
        end
    end
    return character:FindFirstChild(partName)
end

local function findNearestEnemy()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPos = player.Character.HumanoidRootPart.Position
    local nearest = nil
    local nearestDist = getgenv().BulletMod.Config.aimFOV
    
    local otherWaifus = workspace:FindFirstChild("OtherWaifus")
    if otherWaifus then
        for _, enemy in ipairs(otherWaifus:GetChildren()) do
            if enemy:IsA("Model") then
                local humanoid = enemy:FindFirstChild("Zombie")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    local distance = (myPos - rootPart.Position).Magnitude
                    if distance < nearestDist then
                        nearest = enemy
                        nearestDist = distance
                    end
                end
            end
        end
    end
    
    return nearest
end

local function findHighestHealthEnemy()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPos = player.Character.HumanoidRootPart.Position
    local target = nil
    local highestHealth = 0
    
    local otherWaifus = workspace:FindFirstChild("OtherWaifus")
    if otherWaifus then
        for _, enemy in ipairs(otherWaifus:GetChildren()) do
            if enemy:IsA("Model") then
                local humanoid = enemy:FindFirstChild("Zombie")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    local distance = (myPos - rootPart.Position).Magnitude
                    if distance < getgenv().BulletMod.Config.aimFOV and humanoid.Health > highestHealth then
                        target = enemy
                        highestHealth = humanoid.Health
                    end
                end
            end
        end
    end
    
    return target
end

local function findLowestHealthEnemy()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPos = player.Character.HumanoidRootPart.Position
    local target = nil
    local lowestHealth = math.huge
    
    local otherWaifus = workspace:FindFirstChild("OtherWaifus")
    if otherWaifus then
        for _, enemy in ipairs(otherWaifus:GetChildren()) do
            if enemy:IsA("Model") then
                local humanoid = enemy:FindFirstChild("Zombie")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    local distance = (myPos - rootPart.Position).Magnitude
                    if distance < getgenv().BulletMod.Config.aimFOV and humanoid.Health < lowestHealth then
                        target = enemy
                        lowestHealth = humanoid.Health
                    end
                end
            end
        end
    end
    
    return target
end

local function findTarget()
    if getgenv().BulletMod.Config.targetSelection == "closest" then
        return findNearestEnemy()
    elseif getgenv().BulletMod.Config.targetSelection == "highest_health" then
        return findHighestHealthEnemy()
    elseif getgenv().BulletMod.Config.targetSelection == "lowest_health" then
        return findLowestHealthEnemy()
    else
        return findNearestEnemy()
    end
end

local function getTargetPosition(enemy)
    if not enemy then return nil end
    
    local targetPart
    local selectedParts = getgenv().BulletMod.Config.selectedBodyParts
    
    if selectedParts and #selectedParts > 0 then
        local partName = selectedParts[bodyPartCycleIndex]
        targetPart = findBodyPart(enemy, partName)
        
        bodyPartCycleIndex = bodyPartCycleIndex + 1
        if bodyPartCycleIndex > #selectedParts then
            bodyPartCycleIndex = 1
        end
    end
    
    if not targetPart then
        targetPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
    end
    
    if targetPart and getgenv().BulletMod.Config.predictMovement then
        local velocity = targetPart.Velocity
        local distance = (player.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
        local travelTime = distance / getgenv().BulletMod.Config.bulletSpeed
        local predictedPos = targetPart.Position + (velocity * travelTime * getgenv().BulletMod.Config.predictionMultiplier)
        return predictedPos
    end
    
    return targetPart and targetPart.Position or nil
end

local function isEnemy(instance)
    local parent = instance.Parent
    while parent do
        if parent.Name == "OtherWaifus" then
            return true
        end
        parent = parent.Parent
    end
    return false
end

local fastCastModule = ReplicatedStorage.Modules.FastCastRedux
local FastCast = require(fastCastModule)

local oldFire = nil
local hookSetup = false

local function setupHook()
    if hookSetup then return end
    hookSetup = true
    
    oldFire = FastCast.Fire

    FastCast.Fire = function(caster, origin, direction, velocity, behavior)
        if not getgenv().BulletMod.Config.enabled then
            return oldFire(caster, origin, direction, velocity, behavior)
        end
        
        if not behavior then
            behavior = FastCast.newBehavior()
        end
        
        if getgenv().BulletMod.Config.infiniteRange then
            behavior.MaxDistance = getgenv().BulletMod.Config.maxDistance
            behavior.Lifetime = getgenv().BulletMod.Config.lifetime
        end
        
        if getgenv().BulletMod.Config.noGravity then
            behavior.Acceleration = Vector3.new(0, 0, 0)
        end
        
        if getgenv().BulletMod.Config.bulletSpeed > getgenv().BulletMod.Config.minBulletSpeed then
            if type(velocity) == "number" then
                velocity = getgenv().BulletMod.Config.bulletSpeed
            elseif typeof(velocity) == "Vector3" then
                velocity = velocity.Unit * getgenv().BulletMod.Config.bulletSpeed
            end
        end
        
        if getgenv().BulletMod.Config.penetrateWalls or getgenv().BulletMod.Config.penetrateEnemies then
            behavior.CanPenetrateFunction = function(cast, rayOrigin, rayDir, rayResult, segmentVel, cosmeticBullet)
                local hitInstance = rayResult.Instance
                
                local enemyHit = isEnemy(hitInstance)
                
                if enemyHit then
                    return getgenv().BulletMod.Config.penetrateEnemies
                else
                    return getgenv().BulletMod.Config.penetrateWalls
                end
            end
        end
        
        if getgenv().BulletMod.Config.silentAim then
            local target = findTarget()
            if target then
                local targetPos = getTargetPosition(target)
                if targetPos then
                    local newDirection = (targetPos - origin).Unit
                    direction = newDirection
                    
                    if typeof(velocity) == "Vector3" then
                        velocity = newDirection * velocity.Magnitude
                    end
                end
            end
        end
        
        return oldFire(caster, origin, direction, velocity, behavior)
    end
end

getgenv().BulletMod.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().BulletMod.Config[key] ~= nil then
            getgenv().BulletMod.Config[key] = value
        end
    end
end

getgenv().BulletMod.GetTarget = findTarget
getgenv().BulletMod.GetTargetPosition = function()
    local target = findTarget()
    if target then
        return getTargetPosition(target)
    end
    return nil
end

getgenv().BulletMod.GetCurrentBodyPartIndex = function()
    return bodyPartCycleIndex
end

getgenv().BulletMod.GetNextBodyPart = function()
    local selectedParts = getgenv().BulletMod.Config.selectedBodyParts
    if selectedParts and #selectedParts > 0 then
        return selectedParts[bodyPartCycleIndex]
    end
    return "None"
end

getgenv().BulletMod.ResetBodyPartCycle = function()
    bodyPartCycleIndex = 1
end

getgenv().BulletMod.Start = function()
    if getgenv().BulletMod.Config.enabled then
        setupHook()
    end
end

if getgenv().BulletMod.Config.enabled then
    setupHook()
end
