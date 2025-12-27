getgenv().AmmoESP = getgenv().AmmoESP or {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

getgenv().AmmoESP.Config = {
    enabled = false,
    showName = true,
    showDistance = true,
    highlightBodies = true,
    fillColor = Color3.fromRGB(255, 255, 0),
    outlineColor = Color3.fromRGB(255, 255, 255),
    fillTransparency = 0.5,
    outlineTransparency = 0,
    textColor = Color3.fromRGB(255, 255, 255),
    textSize = 14,
    textFont = 2,
    maxDistance = 9999,
    showOnlyInRange = false,
    scanInterval = 0.5,
    studsOffset = 3,
    customName = "Ammo Box",
    nameVisible = true,
    distanceVisible = true,
}

local ammoEspObjects = {}

local function createHighlight(ammoBox)
    local highlight = Instance.new("Highlight")
    highlight.Name = "AmmoESP"
    highlight.FillColor = getgenv().AmmoESP.Config.fillColor
    highlight.OutlineColor = getgenv().AmmoESP.Config.outlineColor
    highlight.FillTransparency = getgenv().AmmoESP.Config.fillTransparency
    highlight.OutlineTransparency = getgenv().AmmoESP.Config.outlineTransparency
    highlight.Parent = ammoBox
    return highlight
end

local function createBillboard(ammoBox)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AmmoESPBillboard"
    billboard.Adornee = ammoBox
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, getgenv().AmmoESP.Config.studsOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ammoBox

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = getgenv().AmmoESP.Config.customName
    nameLabel.TextColor3 = getgenv().AmmoESP.Config.textColor
    nameLabel.TextSize = getgenv().AmmoESP.Config.textSize
    nameLabel.Font = getgenv().AmmoESP.Config.textFont
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = getgenv().AmmoESP.Config.nameVisible
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = getgenv().AmmoESP.Config.textColor
    distanceLabel.TextSize = getgenv().AmmoESP.Config.textSize - 2
    distanceLabel.Font = getgenv().AmmoESP.Config.textFont
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Visible = getgenv().AmmoESP.Config.distanceVisible
    distanceLabel.Parent = billboard

    return billboard
end

local function updateAmmoESP(ammoBox, espData)
    if espData.billboard then
        local distanceLabel = espData.billboard:FindFirstChild("DistanceLabel")
        if distanceLabel and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (localPlayer.Character.HumanoidRootPart.Position - ammoBox.Position).Magnitude
            distanceLabel.Text = math.floor(distance) .. " studs"
            
            if getgenv().AmmoESP.Config.showOnlyInRange then
                local inRange = distance <= getgenv().AmmoESP.Config.maxDistance
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

local function addAmmoESP(ammoBox)
    if ammoEspObjects[ammoBox] then return end

    local espData = {
        ammoBox = ammoBox,
        highlight = nil,
        billboard = nil
    }

    if getgenv().AmmoESP.Config.highlightBodies then
        espData.highlight = createHighlight(ammoBox)
    end

    if getgenv().AmmoESP.Config.showName or getgenv().AmmoESP.Config.showDistance then
        espData.billboard = createBillboard(ammoBox)
    end

    ammoEspObjects[ammoBox] = espData
end

local function removeAmmoESP(ammoBox)
    local espData = ammoEspObjects[ammoBox]
    if espData then
        if espData.highlight then
            pcall(function() espData.highlight:Destroy() end)
        end
        if espData.billboard then
            pcall(function() espData.billboard:Destroy() end)
        end
        ammoEspObjects[ammoBox] = nil
    end
end

local function scanForAmmoBoxes()
    if not getgenv().AmmoESP.Config.enabled then
        for ammoBox, _ in pairs(ammoEspObjects) do
            removeAmmoESP(ammoBox)
        end
        return
    end

    local ammoBoxesFolder = workspace:FindFirstChild("AmmoBoxes")
    if not ammoBoxesFolder then return end

    for _, ammoBox in ipairs(ammoBoxesFolder:GetChildren()) do
        if not ammoEspObjects[ammoBox] then
            addAmmoESP(ammoBox)
        end
    end

    for ammoBox, _ in pairs(ammoEspObjects) do
        if not ammoBox.Parent then
            removeAmmoESP(ammoBox)
        end
    end
end

local renderConnection = nil
local scanLoop = nil

local function startESP()
    if renderConnection then return end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().AmmoESP.Config.enabled then return end

        for ammoBox, espData in pairs(ammoEspObjects) do
            if ammoBox and ammoBox.Parent then
                updateAmmoESP(ammoBox, espData)
            else
                removeAmmoESP(ammoBox)
            end
        end
    end)
    
    scanLoop = task.spawn(function()
        while getgenv().AmmoESP.Config.enabled do
            scanForAmmoBoxes()
            task.wait(getgenv().AmmoESP.Config.scanInterval)
        end
    end)
end

getgenv().AmmoESP.Start = startESP

if getgenv().AmmoESP.Config.enabled then
    startESP()
end

getgenv().AmmoESP.Clear = function()
    for ammoBox, _ in pairs(ammoEspObjects) do
        removeAmmoESP(ammoBox)
    end
end

getgenv().AmmoESP.Refresh = function()
    getgenv().AmmoESP.Clear()
    scanForAmmoBoxes()
end

getgenv().AmmoESP.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().AmmoESP.Config[key] ~= nil then
            getgenv().AmmoESP.Config[key] = value
        end
    end
    getgenv().AmmoESP.Refresh()
end
