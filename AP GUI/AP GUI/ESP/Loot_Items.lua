getgenv().LootESP = getgenv().LootESP or {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

getgenv().LootESP.Config = {
    enabled = false,
    showName = true,
    showDistance = true,
    showType = true,
    highlightBodies = true,
    gunColor = Color3.fromRGB(255, 165, 0),
    itemColor = Color3.fromRGB(138, 43, 226),
    outlineColor = Color3.fromRGB(255, 255, 255),
    fillTransparency = 0.5,
    outlineTransparency = 0,
    textColor = Color3.fromRGB(255, 255, 255),
    textSize = 14,
    textFont = 2,
    maxDistance = 9999,
    showOnlyInRange = false,
    scanInterval = 0.5,
    studsOffset = 2,
    filterGuns = false,
    filterItems = false,
    customColors = {},
    nameVisible = true,
    typeVisible = true,
    distanceVisible = true,
}

local lootEspObjects = {}

local function getLootType(item)
    if item:IsA("MeshPart") then
        return "GUN", getgenv().LootESP.Config.gunColor
    elseif item:IsA("UnionOperation") then
        return "ITEM", getgenv().LootESP.Config.itemColor
    else
        return "LOOT", getgenv().LootESP.Config.itemColor
    end
end

local function createHighlight(item, color)
    local highlight = Instance.new("Highlight")
    highlight.Name = "LootESP"
    highlight.FillColor = color
    highlight.OutlineColor = getgenv().LootESP.Config.outlineColor
    highlight.FillTransparency = getgenv().LootESP.Config.fillTransparency
    highlight.OutlineTransparency = getgenv().LootESP.Config.outlineTransparency
    highlight.Parent = item
    return highlight
end

local function createBillboard(item, lootType, itemName)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LootESPBillboard"
    billboard.Adornee = item
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, getgenv().LootESP.Config.studsOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = item

    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "TypeLabel"
    typeLabel.Size = UDim2.new(1, 0, 0.33, 0)
    typeLabel.Position = UDim2.new(0, 0, 0, 0)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = lootType
    typeLabel.TextColor3 = getgenv().LootESP.Config.textColor
    typeLabel.TextSize = getgenv().LootESP.Config.textSize
    typeLabel.Font = getgenv().LootESP.Config.textFont
    typeLabel.TextStrokeTransparency = 0.5
    typeLabel.Visible = getgenv().LootESP.Config.typeVisible
    typeLabel.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.33, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = itemName
    nameLabel.TextColor3 = getgenv().LootESP.Config.textColor
    nameLabel.TextSize = getgenv().LootESP.Config.textSize - 2
    nameLabel.Font = getgenv().LootESP.Config.textFont
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = getgenv().LootESP.Config.nameVisible
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = getgenv().LootESP.Config.textColor
    distanceLabel.TextSize = getgenv().LootESP.Config.textSize - 2
    distanceLabel.Font = getgenv().LootESP.Config.textFont
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Visible = getgenv().LootESP.Config.distanceVisible
    distanceLabel.Parent = billboard

    return billboard
end

local function updateLootESP(item, espData)
    if espData.billboard then
        local distanceLabel = espData.billboard:FindFirstChild("DistanceLabel")
        if distanceLabel and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (localPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude
            distanceLabel.Text = math.floor(distance) .. " studs"
            
            if getgenv().LootESP.Config.showOnlyInRange then
                local inRange = distance <= getgenv().LootESP.Config.maxDistance
                if espData.highlight then
                    espData.highlight.Enabled = inRange
                end
                if espData.billboard then
                    espData.billboard.Enabled = inRange
                end
            end
        end
    end
end

local function addLootESP(item)
    if lootEspObjects[item] then return end
    if not item:IsA("BasePart") then return end

    local lootType, color = getLootType(item)
    
    if getgenv().LootESP.Config.filterGuns and lootType == "GUN" then return end
    if getgenv().LootESP.Config.filterItems and lootType == "ITEM" then return end
    
    if getgenv().LootESP.Config.customColors[item.Name] then
        color = getgenv().LootESP.Config.customColors[item.Name]
    end

    local espData = {
        item = item,
        lootType = lootType,
        highlight = nil,
        billboard = nil
    }

    if getgenv().LootESP.Config.highlightBodies then
        espData.highlight = createHighlight(item, color)
    end

    if getgenv().LootESP.Config.showName or getgenv().LootESP.Config.showDistance or getgenv().LootESP.Config.showType then
        espData.billboard = createBillboard(item, lootType, item.Name)
    end

    lootEspObjects[item] = espData
end

local function removeLootESP(item)
    local espData = lootEspObjects[item]
    if espData then
        if espData.highlight then
            pcall(function() espData.highlight:Destroy() end)
        end
        if espData.billboard then
            pcall(function() espData.billboard:Destroy() end)
        end
        lootEspObjects[item] = nil
    end
end

local function scanForLoot()
    if not getgenv().LootESP.Config.enabled then
        for item, _ in pairs(lootEspObjects) do
            removeLootESP(item)
        end
        return
    end

    for _, folder in ipairs(workspace:GetChildren()) do
        local mapFolder = folder:FindFirstChild("Map")
        if mapFolder then
            local lootItems = mapFolder:FindFirstChild("LootItems")
            if lootItems then
                for _, item in ipairs(lootItems:GetChildren()) do
                    if item:IsA("BasePart") then
                        if not lootEspObjects[item] then
                            addLootESP(item)
                        end
                    end
                end
            end
        end
    end

    for item, _ in pairs(lootEspObjects) do
        if not item.Parent then
            removeLootESP(item)
        end
    end
end

local renderConnection = nil
local scanLoop = nil

local function startESP()
    if renderConnection then return end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().LootESP.Config.enabled then return end

        for item, espData in pairs(lootEspObjects) do
            if item and item.Parent then
                updateLootESP(item, espData)
            else
                removeLootESP(item)
            end
        end
    end)
    
    scanLoop = task.spawn(function()
        while getgenv().LootESP.Config.enabled do
            scanForLoot()
            task.wait(getgenv().LootESP.Config.scanInterval)
        end
    end)
end

getgenv().LootESP.Start = startESP

if getgenv().LootESP.Config.enabled then
    startESP()
end

getgenv().LootESP.Clear = function()
    for item, _ in pairs(lootEspObjects) do
        removeLootESP(item)
    end
end

getgenv().LootESP.Refresh = function()
    getgenv().LootESP.Clear()
    scanForLoot()
end

getgenv().LootESP.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().LootESP.Config[key] ~= nil then
            getgenv().LootESP.Config[key] = value
        end
    end
    getgenv().LootESP.Refresh()
end
