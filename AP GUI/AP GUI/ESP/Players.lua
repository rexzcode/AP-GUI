getgenv().PlayerESP = getgenv().PlayerESP or {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

getgenv().PlayerESP.Config = {
    enabled = false,
    showName = true,
    showHealth = true,
    showDistance = true,
    highlightBodies = true,
    fillColor = Color3.fromRGB(0, 150, 255),
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
    showTeam = true,
    teamBasedColors = false,
    friendColor = Color3.fromRGB(0, 255, 0),
    enemyColor = Color3.fromRGB(255, 0, 0),
    showDisplayName = true,
    showUsername = true,
    healthBarEnabled = false,
    nameVisible = true,
    healthVisible = true,
    distanceVisible = true,
}

local playerEspObjects = {}

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillColor = getgenv().PlayerESP.Config.fillColor
    highlight.OutlineColor = getgenv().PlayerESP.Config.outlineColor
    highlight.FillTransparency = getgenv().PlayerESP.Config.fillTransparency
    highlight.OutlineTransparency = getgenv().PlayerESP.Config.outlineTransparency
    highlight.Parent = character
    return highlight
end

local function createBillboard(character, humanoid, player)
    local head = character:FindFirstChild("Head")
    if not head then return nil end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESPBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, getgenv().PlayerESP.Config.studsOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local nameText = ""
    if getgenv().PlayerESP.Config.showDisplayName then
        nameText = player.DisplayName
    end
    if getgenv().PlayerESP.Config.showUsername then
        nameText = nameText .. " (@" .. player.Name .. ")"
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = nameText
    nameLabel.TextColor3 = getgenv().PlayerESP.Config.textColor
    nameLabel.TextSize = getgenv().PlayerESP.Config.textSize
    nameLabel.Font = getgenv().PlayerESP.Config.textFont
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = getgenv().PlayerESP.Config.nameVisible
    nameLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.4, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextSize = getgenv().PlayerESP.Config.textSize - 2
    healthLabel.Font = getgenv().PlayerESP.Config.textFont
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Visible = getgenv().PlayerESP.Config.healthVisible
    healthLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = getgenv().PlayerESP.Config.textColor
    distanceLabel.TextSize = getgenv().PlayerESP.Config.textSize - 2
    distanceLabel.Font = getgenv().PlayerESP.Config.textFont
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Visible = getgenv().PlayerESP.Config.distanceVisible
    distanceLabel.Parent = billboard
    
    return billboard
end

local function updatePlayerESP(character, espData, player)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or not humanoid:IsA("Humanoid") then return end

    if espData.billboard then
        local healthLabel = espData.billboard:FindFirstChild("HealthLabel")
        if healthLabel then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)

            if healthPercent > 0.6 then
                healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.3 then
                healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            else
                healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end

        local distanceLabel = espData.billboard:FindFirstChild("DistanceLabel")
        if distanceLabel and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local distance = (localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                distanceLabel.Text = math.floor(distance) .. " studs"
                
                if getgenv().PlayerESP.Config.showOnlyInRange then
                    local inRange = distance <= getgenv().PlayerESP.Config.maxDistance
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

local function addPlayerESP(player, character)
    if player == localPlayer then return end
    if playerEspObjects[character] then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or not humanoid:IsA("Humanoid") then return end
    
    local espData = {
        character = character,
        player = player,
        highlight = nil,
        billboard = nil
    }

    if getgenv().PlayerESP.Config.highlightBodies then
        espData.highlight = createHighlight(character)
    end

    if getgenv().PlayerESP.Config.showName or getgenv().PlayerESP.Config.showHealth or getgenv().PlayerESP.Config.showDistance then
        espData.billboard = createBillboard(character, humanoid, player)
    end

    playerEspObjects[character] = espData
end

local function removePlayerESP(character)
    local espData = playerEspObjects[character]
    if espData then
        if espData.highlight then
            pcall(function() espData.highlight:Destroy() end)
        end
        if espData.billboard then
            pcall(function() espData.billboard:Destroy() end)
        end
        playerEspObjects[character] = nil
    end
end

local function scanForPlayers()
    if not getgenv().PlayerESP.Config.enabled then
        for character, _ in pairs(playerEspObjects) do
            removePlayerESP(character)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = workspace:FindFirstChild(player.Name)
            if character and character:IsA("Model") and character:FindFirstChild("Humanoid") then
                if not playerEspObjects[character] then
                    addPlayerESP(player, character)
                end
            end
        end
    end

    for character, _ in pairs(playerEspObjects) do
        if not character.Parent then
            removePlayerESP(character)
        end
    end
end

local renderConnection = nil
local scanLoop = nil

local function startESP()
    if renderConnection then return end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().PlayerESP.Config.enabled then return end
        
        for character, espData in pairs(playerEspObjects) do
            if character and character.Parent then
                updatePlayerESP(character, espData, espData.player)
            else
                removePlayerESP(character)
            end
        end
    end)
    
    scanLoop = task.spawn(function()
        while getgenv().PlayerESP.Config.enabled do
            scanForPlayers()
            task.wait(getgenv().PlayerESP.Config.scanInterval)
        end
    end)
end

getgenv().PlayerESP.Start = startESP

if getgenv().PlayerESP.Config.enabled then
    startESP()
end

getgenv().PlayerESP.Clear = function()
    for character, _ in pairs(playerEspObjects) do
        removePlayerESP(character)
    end
end

getgenv().PlayerESP.Refresh = function()
    getgenv().PlayerESP.Clear()
    scanForPlayers()
end

getgenv().PlayerESP.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().PlayerESP.Config[key] ~= nil then
            getgenv().PlayerESP.Config[key] = value
        end
    end
    getgenv().PlayerESP.Refresh()
end
