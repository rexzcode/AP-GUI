getgenv().GunMod = getgenv().GunMod or {}

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local currentTool = nil
local childAddedConnection = nil
local childRemovedConnection = nil
local characterConnection = nil

getgenv().GunMod.Config = {
    enabled = false,
    infiniteAmmo = false,
    fireRate = 0.1,
    minFireRate = 0.001,
    maxFireRate = 1,
    autoFire = false,
    baseDamage = 10,
    minDamage = 1,
    maxDamage = 10000,
    spread = 1,
    maxSpread = 100,
    recoil = 1,
    maxRecoil = 100,
    reloadTime = 0,
    maxReloadTime = 10,
    ammoPerMag = 30,
    maxAmmo = 999999,
    limitedAmmo = false,
    shotgunReload = false,
    shellClipSpeed = 0,
    magRefillThreshold = 500,
    ammoUpdateInterval = 0.1,
    autoApply = false,
}

local function findAllGunUpvalues(gunClient)
    local foundTables = {
        mag = {},
        ammo = {},
        stats = {}
    }

    for _, func in ipairs(getgc(true)) do
        if type(func) == "function" and islclosure(func) then
            local info = debug.getinfo(func)
            if info and info.source then
                local belongsToGun = info.source:find(gunClient.Name) or
                                    info.source:find("GunClient") or
                                    info.source:find("Setting")

                if belongsToGun then
                    local upvalues = debug.getupvalues(func)
                    for index, upvalue in pairs(upvalues) do
                        if type(upvalue) == "table" then
                            if rawget(upvalue, "Mag") and not foundTables.mag[1] then
                                table.insert(foundTables.mag, {func = func, index = index, table = upvalue})
                            end

                            if rawget(upvalue, "Ammo") and rawget(upvalue, "MaxAmmo") then
                                table.insert(foundTables.ammo, {func = func, index = index, table = upvalue})
                            end

                            if rawget(upvalue, "FireRate") or rawget(upvalue, "BaseDamage") or
                               rawget(upvalue, "ReloadTime") or rawget(upvalue, "Auto") then
                                table.insert(foundTables.stats, {func = func, index = index, table = upvalue})
                            end
                        end
                    end
                end
            end
        end
    end

    return foundTables
end

local function modifyTable(func, index, modifications)
    local success = pcall(function()
        local original = debug.getupvalue(func, index)
        for key, value in pairs(modifications) do
            original[key] = value
        end
    end)

    if not success then
        local original = debug.getupvalue(func, index)
        local newTable = {}

        for key, value in pairs(original) do
            newTable[key] = value
        end

        for key, value in pairs(modifications) do
            newTable[key] = value
        end

        debug.setupvalue(func, index, newTable)
    end
end

local function setupGunMods(tool)
    if not getgenv().GunMod.Config.enabled then return end
    
    local valueFolder = tool:FindFirstChild("ValueFolder")
    local mag, ammoDisplay

    if valueFolder then
        local folder1 = valueFolder:FindFirstChild("1")
        if folder1 then
            mag = folder1:FindFirstChild("Mag")
            ammoDisplay = folder1:FindFirstChild("Ammo")
        end
    end

    local gunClient = tool:FindFirstChild("GunClient")
    if not gunClient then return end

    local tables = findAllGunUpvalues(gunClient)

    local statsModified = false
    for _, data in ipairs(tables.stats) do
        pcall(function()
            modifyTable(data.func, data.index, {
                FireRate = getgenv().GunMod.Config.fireRate,
                Auto = getgenv().GunMod.Config.autoFire,
                BaseDamage = getgenv().GunMod.Config.baseDamage,
                Spread = getgenv().GunMod.Config.spread,
                Recoil = getgenv().GunMod.Config.recoil,
                ReloadTime = getgenv().GunMod.Config.reloadTime,
                AmmoPerMag = getgenv().GunMod.Config.ammoPerMag,
                MaxAmmo = getgenv().GunMod.Config.maxAmmo,
                LimitedAmmoEnabled = getgenv().GunMod.Config.limitedAmmo,
                ShotgunReload = getgenv().GunMod.Config.shotgunReload,
                ShellClipinSpeed = getgenv().GunMod.Config.shellClipSpeed,
            })
            statsModified = true
        end)
    end

    if #tables.mag > 0 then
        for _, magData in ipairs(tables.mag) do
            task.spawn(function()
                while currentTool == tool and getgenv().GunMod.Config.enabled do
                    if getgenv().GunMod.Config.infiniteAmmo then
                        local shouldRefill = true
                        if mag then
                            shouldRefill = mag.Value <= getgenv().GunMod.Config.magRefillThreshold
                        end

                        if shouldRefill then
                            pcall(function()
                                modifyTable(magData.func, magData.index, {Mag = getgenv().GunMod.Config.ammoPerMag})
                            end)
                        end
                    end
                    task.wait(getgenv().GunMod.Config.ammoUpdateInterval)
                end
            end)
        end
    end

    if #tables.ammo > 0 then
        for _, ammoData in ipairs(tables.ammo) do
            task.spawn(function()
                while currentTool == tool and getgenv().GunMod.Config.enabled do
                    if getgenv().GunMod.Config.infiniteAmmo then
                        pcall(function()
                            modifyTable(ammoData.func, ammoData.index, {
                                Ammo = getgenv().GunMod.Config.maxAmmo,
                                MaxAmmo = getgenv().GunMod.Config.maxAmmo
                            })
                        end)
                    end
                    task.wait(getgenv().GunMod.Config.ammoUpdateInterval)
                end
            end)
        end
    end

    if mag then
        task.spawn(function()
            while currentTool == tool and getgenv().GunMod.Config.enabled do
                if getgenv().GunMod.Config.infiniteAmmo then
                    pcall(function() mag.Value = getgenv().GunMod.Config.ammoPerMag end)
                end
                task.wait(0.5)
            end
        end)
    end

    if ammoDisplay then
        task.spawn(function()
            while currentTool == tool and getgenv().GunMod.Config.enabled do
                if getgenv().GunMod.Config.infiniteAmmo then
                    pcall(function() ammoDisplay.Value = getgenv().GunMod.Config.maxAmmo end)
                end
                task.wait(0.5)
            end
        end)
    end
end

local function onToolEquipped(tool)
    if tool:IsA("Tool") and getgenv().GunMod.Config.enabled then
        currentTool = tool
        task.wait(0.2)
        setupGunMods(tool)
    end
end

local function onToolUnequipped()
    currentTool = nil
end

local function disconnectConnections()
    if childAddedConnection then
        childAddedConnection:Disconnect()
        childAddedConnection = nil
    end
    if childRemovedConnection then
        childRemovedConnection:Disconnect()
        childRemovedConnection = nil
    end
end

local function setupCharacterConnections(char)
    if not char then return end
    
    disconnectConnections()
    character = char
    currentTool = nil
    
    childAddedConnection = char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            onToolEquipped(child)
        end
    end)

    childRemovedConnection = char.ChildRemoved:Connect(function(child)
        if child == currentTool then
            onToolUnequipped()
        end
    end)

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            onToolEquipped(child)
            break
        end
    end
end

local function startGunMod()
    if not getgenv().GunMod.Config.enabled then return end
    
    if characterConnection then
        characterConnection:Disconnect()
    end
    
    characterConnection = player.CharacterAdded:Connect(function(char)
        if getgenv().GunMod.Config.enabled then
            task.wait(0.5)
            setupCharacterConnections(char)
        end
    end)
    
    if player.Character then
        setupCharacterConnections(player.Character)
    end
end

getgenv().GunMod.Start = startGunMod

if getgenv().GunMod.Config.enabled then
    startGunMod()
end

getgenv().GunMod.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().GunMod.Config[key] ~= nil then
            getgenv().GunMod.Config[key] = value
        end
    end
    if currentTool then
        setupGunMods(currentTool)
    end
end

getgenv().GunMod.ForceApply = function()
    if currentTool and getgenv().GunMod.Config.enabled then
        setupGunMods(currentTool)
    end
end

getgenv().GunMod.ReapplyMods = function()
    if currentTool and getgenv().GunMod.Config.enabled then
        setupGunMods(currentTool)
    end
end

getgenv().GunMod.GetCurrentTool = function()
    return currentTool
end
