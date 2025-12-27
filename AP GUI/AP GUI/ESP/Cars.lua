getgenv().CarESP = getgenv().CarESP or {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

getgenv().CarESP.Config = {
    enabled = false,
    showName = true,
    showHealth = true,
    showDistance = true,
    highlightBodies = true,
    fillColor = Color3.fromRGB(0, 255, 0),
    outlineColor = Color3.fromRGB(255, 255, 255),
    fillTransparency = 0.5,
    outlineTransparency = 0,
    textColor = Color3.fromRGB(255, 255, 255),
    textSize = 14,
    textFont = 2,
    maxDistance = 9999,
    showOnlyInRange = false,
    scanInterval = 0.5,
    studsOffset = 5,
    showHealthBar = true,
    healthBarColor = Color3.fromRGB(0, 255, 0),
    nameVisible = true,
    healthVisible = true,
    distanceVisible = true,
}

local carEspObjects = {}

local function createHighlight(car)
    local highlight = Instance.new("Highlight")
    highlight.Name = "CarESP"
    highlight.FillColor = getgenv().CarESP.Config.fillColor
    highlight.OutlineColor = getgenv().CarESP.Config.outlineColor
    highlight.FillTransparency = getgenv().CarESP.Config.fillTransparency
    highlight.OutlineTransparency = getgenv().CarESP.Config.outlineTransparency
    highlight.Parent = car
    return highlight
end

local function getCarHealth(car)
    local stats = car:FindFirstChild("Stats")
    if stats then
        local health = stats:FindFirstChild("Health")
        if health then
            return health.Value, stats:FindFirstChild("MaxHealth") and stats.MaxHealth.Value or health.Value
        end
    end
    return nil, nil
end

local function createBillboard(car)
    local primaryPart = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return nil end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CarESPBillboard"
    billboard.Adornee = primaryPart
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, getgenv().CarESP.Config.studsOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = primaryPart

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = car.Name
    nameLabel.TextColor3 = getgenv().CarESP.Config.textColor
    nameLabel.TextSize = getgenv().CarESP.Config.textSize
    nameLabel.Font = getgenv().CarESP.Config.textFont
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = getgenv().CarESP.Config.nameVisible
    nameLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "Health: N/A"
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextSize = getgenv().CarESP.Config.textSize - 2
    healthLabel.Font = getgenv().CarESP.Config.textFont
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Visible = getgenv().CarESP.Config.healthVisible
    healthLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = getgenv().CarESP.Config.textColor
    distanceLabel.TextSize = getgenv().CarESP.Config.textSize - 2
    distanceLabel.Font = getgenv().CarESP.Config.textFont
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Visible = getgenv().CarESP.Config.distanceVisible
    distanceLabel.Parent = billboard

    return billboard
end

local function updateCarESP(car, espData)
    if espData.billboard then
        local healthLabel = espData.billboard:FindFirstChild("HealthLabel")
        if healthLabel then
            local health, maxHealth = getCarHealth(car)
            if health then
                local healthPercent = health / maxHealth
                healthLabel.Text = "Health: " .. math.floor(health) .. "/" .. math.floor(maxHealth)

                if healthPercent > 0.6 then
                    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.3 then
                    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            else
                healthLabel.Text = "Health: N/A"
                healthLabel.TextColor3 = Color3.fromRGB(128, 128, 128)
            end
        end

        local distanceLabel = espData.billboard:FindFirstChild("DistanceLabel")
        if distanceLabel and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local primaryPart = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                local distance = (localPlayer.Character.HumanoidRootPart.Position - primaryPart.Position).Magnitude
                distanceLabel.Text = math.floor(distance) .. " studs"
                
                if getgenv().CarESP.Config.showOnlyInRange then
                    local inRange = distance <= getgenv().CarESP.Config.maxDistance
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

local function addCarESP(car)
    if carEspObjects[car] then return end
    if not car:IsA("Model") then return end

    local espData = {
        car = car,
        highlight = nil,
        billboard = nil
    }

    if getgenv().CarESP.Config.highlightBodies then
        espData.highlight = createHighlight(car)
    end

    if getgenv().CarESP.Config.showName or getgenv().CarESP.Config.showHealth or getgenv().CarESP.Config.showDistance then
        espData.billboard = createBillboard(car)
    end

    carEspObjects[car] = espData
end

local function removeCarESP(car)
    local espData = carEspObjects[car]
    if espData then
        if espData.highlight then
            pcall(function() espData.highlight:Destroy() end)
        end
        if espData.billboard then
            pcall(function() espData.billboard:Destroy() end)
        end
        carEspObjects[car] = nil
    end
end

local function scanForCars()
    if not getgenv().CarESP.Config.enabled then
        for car, _ in pairs(carEspObjects) do
            removeCarESP(car)
        end
        return
    end

    local carsFolder = workspace:FindFirstChild("Cars")
    if not carsFolder then return end

    for _, car in ipairs(carsFolder:GetChildren()) do
        if car:IsA("Model") then
            if not carEspObjects[car] then
                addCarESP(car)
            end
        end
    end

    for car, _ in pairs(carEspObjects) do
        if not car.Parent then
            removeCarESP(car)
        end
    end
end

local renderConnection = nil
local scanLoop = nil

local function startESP()
    if renderConnection then return end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().CarESP.Config.enabled then return end

        for car, espData in pairs(carEspObjects) do
            if car and car.Parent then
                updateCarESP(car, espData)
            else
                removeCarESP(car)
            end
        end
    end)
    
    scanLoop = task.spawn(function()
        while getgenv().CarESP.Config.enabled do
            scanForCars()
            task.wait(getgenv().CarESP.Config.scanInterval)
        end
    end)
end

getgenv().CarESP.Start = startESP

if getgenv().CarESP.Config.enabled then
    startESP()
end

getgenv().CarESP.Clear = function()
    for car, _ in pairs(carEspObjects) do
        removeCarESP(car)
    end
end

getgenv().CarESP.Refresh = function()
    getgenv().CarESP.Clear()
    scanForCars()
end

getgenv().CarESP.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().CarESP.Config[key] ~= nil then
            getgenv().CarESP.Config[key] = value
        end
    end
    getgenv().CarESP.Refresh()
end
