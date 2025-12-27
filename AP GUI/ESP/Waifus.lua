getgenv().WaifuESP = getgenv().WaifuESP or {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().WaifuESP.Config = {
    enabled = false,
    showName = true,
    showHealth = true,
    showDistance = true,
    highlightBodies = true,
    fillColor = Color3.fromRGB(255, 0, 0),
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
    showAliveOnly = true,
    healthThreshold = 0,
    customName = "Enemy",
    nameVisible = true,
    healthVisible = true,
    distanceVisible = true,
    healthBarEnabled = false,
    colorByHealth = true,
}

local espObjects = {}

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ZombieESP"
    highlight.FillColor = getgenv().WaifuESP.Config.fillColor
    highlight.OutlineColor = getgenv().WaifuESP.Config.outlineColor
    highlight.FillTransparency = getgenv().WaifuESP.Config.fillTransparency
    highlight.OutlineTransparency = getgenv().WaifuESP.Config.outlineTransparency
    highlight.Parent = character
    return highlight
end

local function createBillboard(character, zombieHumanoid)
    local head = character:FindFirstChild("Head")
    if not head then return nil end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZombieESPBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, getgenv().WaifuESP.Config.studsOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = getgenv().WaifuESP.Config.customName
    nameLabel.TextColor3 = getgenv().WaifuESP.Config.textColor
    nameLabel.TextSize = getgenv().WaifuESP.Config.textSize
    nameLabel.Font = getgenv().WaifuESP.Config.textFont
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = getgenv().WaifuESP.Config.nameVisible
    nameLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.4, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: " .. math.floor(zombieHumanoid.Health) .. "/" .. math.floor(zombieHumanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextSize = getgenv().WaifuESP.Config.textSize - 2
    healthLabel.Font = getgenv().WaifuESP.Config.textFont
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Visible = getgenv().WaifuESP.Config.healthVisible
    healthLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = getgenv().WaifuESP.Config.textColor
    distanceLabel.TextSize = getgenv().WaifuESP.Config.textSize - 2
    distanceLabel.Font = getgenv().WaifuESP.Config.textFont
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Visible = getgenv().WaifuESP.Config.distanceVisible
    distanceLabel.Parent = billboard

    return billboard
end

local function updateESP(character, espData)
    local zombieHumanoid = character:FindFirstChild("Zombie")
    if not zombieHumanoid or not zombieHumanoid:IsA("Humanoid") then return end

    if getgenv().WaifuESP.Config.showAliveOnly and zombieHumanoid.Health <= getgenv().WaifuESP.Config.healthThreshold then
        removeESP(character)
        return
    end

    if espData.billboard then
        local healthLabel = espData.billboard:FindFirstChild("HealthLabel")
        if healthLabel then
            local healthPercent = zombieHumanoid.Health / zombieHumanoid.MaxHealth
            healthLabel.Text = "HP: " .. math.floor(zombieHumanoid.Health) .. "/" .. math.floor(zombieHumanoid.MaxHealth)

            if getgenv().WaifuESP.Config.colorByHealth then
                if healthPercent > 0.6 then
                    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.3 then
                    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            else
                healthLabel.TextColor3 = getgenv().WaifuESP.Config.textColor
            end
        end

        local distanceLabel = espData.billboard:FindFirstChild("DistanceLabel")
        if distanceLabel and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            if rootPart then
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                distanceLabel.Text = math.floor(distance) .. " studs"
                
                if getgenv().WaifuESP.Config.showOnlyInRange then
                    local inRange = distance <= getgenv().WaifuESP.Config.maxDistance
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
end

function addESP(character)
    if espObjects[character] then return end

    local zombieHumanoid = character:FindFirstChild("Zombie")
    if not zombieHumanoid or not zombieHumanoid:IsA("Humanoid") then return end

    if getgenv().WaifuESP.Config.showAliveOnly and zombieHumanoid.Health <= getgenv().WaifuESP.Config.healthThreshold then
        return
    end

    local espData = {
        character = character,
        highlight = nil,
        billboard = nil
    }

    if getgenv().WaifuESP.Config.highlightBodies then
        espData.highlight = createHighlight(character)
    end

    if getgenv().WaifuESP.Config.showName or getgenv().WaifuESP.Config.showHealth or getgenv().WaifuESP.Config.showDistance then
        espData.billboard = createBillboard(character, zombieHumanoid)
    end

    espObjects[character] = espData
end

function removeESP(character)
    local espData = espObjects[character]
    if espData then
        if espData.highlight then
            pcall(function() espData.highlight:Destroy() end)
        end
        if espData.billboard then
            pcall(function() espData.billboard:Destroy() end)
        end
        espObjects[character] = nil
    end
end

local function scanForEnemies()
    if not getgenv().WaifuESP.Config.enabled then
        for character, _ in pairs(espObjects) do
            removeESP(character)
        end
        return
    end

    local otherWaifus = workspace:FindFirstChild("OtherWaifus")
    if not otherWaifus then return end

    for _, character in ipairs(otherWaifus:GetChildren()) do
        if character:IsA("Model") and character:FindFirstChild("Zombie") then
            if not espObjects[character] then
                addESP(character)
            end
        end
    end

    for character, _ in pairs(espObjects) do
        if not character.Parent then
            removeESP(character)
        end
    end
end

local renderConnection = nil
local scanLoop = nil

local function startESP()
    if renderConnection then return end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().WaifuESP.Config.enabled then return end

        for character, espData in pairs(espObjects) do
            if character and character.Parent then
                updateESP(character, espData)
            else
                removeESP(character)
            end
        end
    end)
    
    scanLoop = task.spawn(function()
        while getgenv().WaifuESP.Config.enabled do
            scanForEnemies()
            task.wait(getgenv().WaifuESP.Config.scanInterval)
        end
    end)
end

getgenv().WaifuESP.Start = startESP

if getgenv().WaifuESP.Config.enabled then
    startESP()
end

getgenv().WaifuESP.Clear = function()
    for character, _ in pairs(espObjects) do
        removeESP(character)
    end
end

getgenv().WaifuESP.Refresh = function()
    getgenv().WaifuESP.Clear()
    scanForEnemies()
end

getgenv().WaifuESP.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().WaifuESP.Config[key] ~= nil then
            getgenv().WaifuESP.Config[key] = value
        end
    end
    getgenv().WaifuESP.Refresh()
end
