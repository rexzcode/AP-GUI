getgenv().AutoCollect = getgenv().AutoCollect or {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().AutoCollect.Config = {
    enabled = false,
    collectAmmo = true,
    collectWeapons = true,
    collectHeals = true,
    collectItems = true,
    collectDistance = 1,
    teleportHeight = 0,
    waitBetweenItems = 0.1,
    waitBetweenCycles = 5,
    returnToOriginal = true,
    autoRestart = true,
    proximityHoldDuration = 0,
    proximityMaxDistance = 9999,
    clickDetectorDelay = 0.2,
    maxItemsPerCycle = 999,
}

local originalPosition = nil
local isCollecting = false
local collectedCount = 0

local function savePosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        originalPosition = player.Character.HumanoidRootPart.CFrame
        return true
    end
    return false
end

local function returnToOriginal()
    if getgenv().AutoCollect.Config.returnToOriginal and originalPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = originalPosition
        return true
    end
    return false
end

local function teleportToItem(item)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local itemPosition

    if item:IsA("BasePart") then
        itemPosition = item.Position
    elseif item:IsA("Model") then
        local primary = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
        if primary then
            itemPosition = primary.Position
        end
    end

    if not itemPosition then return false end

    local offset = Vector3.new(0, getgenv().AutoCollect.Config.collectDistance + getgenv().AutoCollect.Config.teleportHeight, 0)
    player.Character.HumanoidRootPart.CFrame = CFrame.new(itemPosition + offset)

    return true
end

local function activateProximityPrompt(item)
    local function findPrompt(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                return child
            end
        end
        return nil
    end

    local prompt = findPrompt(item)

    if prompt then
        local originalHoldDuration = prompt.HoldDuration
        local originalMaxDistance = prompt.MaxActivationDistance

        prompt.HoldDuration = getgenv().AutoCollect.Config.proximityHoldDuration
        prompt.MaxActivationDistance = getgenv().AutoCollect.Config.proximityMaxDistance

        task.wait(0.1)

        pcall(function()
            fireproximityprompt(prompt)
        end)

        task.wait(0.2)

        prompt.HoldDuration = originalHoldDuration
        prompt.MaxActivationDistance = originalMaxDistance

        return true
    end

    return false
end

local function activateClickDetector(item)
    local function findClickDetector(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("ClickDetector") then
                return child
            end
        end
        return nil
    end

    local clickDetector = findClickDetector(item)

    if clickDetector then
        pcall(function()
            fireclickdetector(clickDetector)
        end)

        task.wait(getgenv().AutoCollect.Config.clickDetectorDelay)
        return true
    end

    return false
end

local function collectItem(item)
    if not teleportToItem(item) then
        return false
    end

    task.wait(getgenv().AutoCollect.Config.waitBetweenItems)

    if activateProximityPrompt(item) then
        return true
    end

    if activateClickDetector(item) then
        return true
    end

    return false
end

local function collectAllItems()
    if isCollecting then
        return
    end

    isCollecting = true
    collectedCount = 0

    if not savePosition() then
        isCollecting = false
        return
    end

    local itemsToCollect = {}

    if getgenv().AutoCollect.Config.collectAmmo then
        local ammoBoxes = workspace:FindFirstChild("AmmoBoxes")
        if ammoBoxes then
            for _, item in ipairs(ammoBoxes:GetChildren()) do
                table.insert(itemsToCollect, item)
            end
        end
    end

    if getgenv().AutoCollect.Config.collectWeapons then
        for _, folder in ipairs(workspace:GetChildren()) do
            local mapFolder = folder:FindFirstChild("Map")
            if mapFolder then
                local lootItems = mapFolder:FindFirstChild("LootItems")
                if lootItems then
                    for _, item in ipairs(lootItems:GetChildren()) do
                        table.insert(itemsToCollect, item)
                    end
                end
            end
        end
    end

    local maxItems = math.min(#itemsToCollect, getgenv().AutoCollect.Config.maxItemsPerCycle)
    
    for i = 1, maxItems do
        local item = itemsToCollect[i]
        if item and item.Parent then
            local success = collectItem(item)
            if success then
                collectedCount = collectedCount + 1
            end

            task.wait(getgenv().AutoCollect.Config.waitBetweenItems)
        end
    end

    returnToOriginal()
    isCollecting = false
end

local function startContinuousCollection()
    if isCollecting then
        return
    end

    getgenv().AutoCollect.Config.enabled = true

    task.spawn(function()
        while getgenv().AutoCollect.Config.enabled do
            isCollecting = true
            collectedCount = 0

            if savePosition() then
                local itemsToCollect = {}

                if getgenv().AutoCollect.Config.collectAmmo then
                    local ammoBoxes = workspace:FindFirstChild("AmmoBoxes")
                    if ammoBoxes then
                        for _, item in ipairs(ammoBoxes:GetChildren()) do
                            table.insert(itemsToCollect, item)
                        end
                    end
                end

                if getgenv().AutoCollect.Config.collectWeapons then
                    for _, folder in ipairs(workspace:GetChildren()) do
                        local mapFolder = folder:FindFirstChild("Map")
                        if mapFolder then
                            local lootItems = mapFolder:FindFirstChild("LootItems")
                            if lootItems then
                                for _, item in ipairs(lootItems:GetChildren()) do
                                    table.insert(itemsToCollect, item)
                                end
                            end
                        end
                    end
                end

                local maxItems = math.min(#itemsToCollect, getgenv().AutoCollect.Config.maxItemsPerCycle)

                for i = 1, maxItems do
                    if not getgenv().AutoCollect.Config.enabled then
                        break
                    end

                    local item = itemsToCollect[i]
                    if item and item.Parent then
                        local success = collectItem(item)
                        if success then
                            collectedCount = collectedCount + 1
                        end

                        task.wait(getgenv().AutoCollect.Config.waitBetweenItems)
                    end
                end

                returnToOriginal()
            end

            isCollecting = false

            if getgenv().AutoCollect.Config.enabled and getgenv().AutoCollect.Config.autoRestart then
                task.wait(getgenv().AutoCollect.Config.waitBetweenCycles)
            end
        end
    end)
end

local function stopCollection()
    getgenv().AutoCollect.Config.enabled = false
end

getgenv().AutoCollect.Start = startContinuousCollection
getgenv().AutoCollect.Stop = stopCollection
getgenv().AutoCollect.CollectOnce = collectAllItems
getgenv().AutoCollect.GetCollectedCount = function() return collectedCount end
getgenv().AutoCollect.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().AutoCollect.Config[key] ~= nil then
            getgenv().AutoCollect.Config[key] = value
        end
    end
end
