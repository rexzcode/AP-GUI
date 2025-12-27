getgenv().BossMoney = getgenv().BossMoney or {}

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

getgenv().BossMoney.Config = {
    enabled = false,
    collectInterval = 2,
    firetouchDelay = 0.1,
    autoRestart = true,
    maxAttempts = 3,
    retryDelay = 0.5,
}

local function isMoneyPart(part)
    return part:FindFirstChild("TouchInterest") ~= nil
end

local function collectMoneyParts()
    local collected = 0
    local workspaceChildren = workspace:GetChildren()

    for _, obj in ipairs(workspaceChildren) do
        if getgenv().BossMoney.Config.enabled then
            if obj:IsA("BasePart") and isMoneyPart(obj) then
                local attempts = 0
                local success = false
                
                while attempts < getgenv().BossMoney.Config.maxAttempts and not success do
                    success = pcall(function()
                        firetouchinterest(rootPart, obj, 0)
                        task.wait(getgenv().BossMoney.Config.firetouchDelay)
                        firetouchinterest(rootPart, obj, 1)
                        collected = collected + 1
                    end)
                    
                    if not success then
                        attempts = attempts + 1
                        task.wait(getgenv().BossMoney.Config.retryDelay)
                    end
                end
            end
        end
    end
    
    return collected
end

local collectLoop = nil

local function startCollecting()
    if collectLoop then return end
    
    collectLoop = task.spawn(function()
        while getgenv().BossMoney.Config.enabled do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                character = player.Character
                rootPart = character.HumanoidRootPart
                collectMoneyParts()
            end
            task.wait(getgenv().BossMoney.Config.collectInterval)
        end
        collectLoop = nil
    end)
end

player.CharacterAdded:Connect(function(char)
    character = char
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

getgenv().BossMoney.CollectOnce = collectMoneyParts
getgenv().BossMoney.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().BossMoney.Config[key] ~= nil then
            getgenv().BossMoney.Config[key] = value
        end
    end
end
getgenv().BossMoney.Stop = function()
    getgenv().BossMoney.Config.enabled = false
end
getgenv().BossMoney.Start = function()
    getgenv().BossMoney.Config.enabled = true
    startCollecting()
end

if getgenv().BossMoney.Config.enabled then
    startCollecting()
end
