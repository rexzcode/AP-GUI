getgenv().AdminDetector = getgenv().AdminDetector or {}

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

getgenv().AdminDetector.Config = {
    enabled = false,
    autoServerHop = false,
    showNotification = true,
    playSound = true,
    soundVolume = 0.5,
    checkInterval = 30,
    notificationDuration = 10,
    soundId = "rbxassetid://9125402735",
    detectOnJoin = true,
    periodicCheck = true,
    customRoles = {},
}

local GROUP_ID = 10668871
local PLACE_ID = game.PlaceId

local ADMIN_ROLES = {
    "Trial-admin",
    "Admin",
    "Comm. Manager",
    "Dev",
    "CoOwner",
    "Owner"
}

local detectedAdmins = {}
local adminRoleIds = {}

local function sendNotification(title, text, duration)
    if not getgenv().AdminDetector.Config.showNotification then return end
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or getgenv().AdminDetector.Config.notificationDuration,
            Icon = "rbxassetid://2541869220"
        })
    end)
end

local function playAlertSound()
    if not getgenv().AdminDetector.Config.playSound then return end
    
    local sound = Instance.new("Sound")
    sound.SoundId = getgenv().AdminDetector.Config.soundId
    sound.Volume = getgenv().AdminDetector.Config.soundVolume
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 3)
end

local function serverHop()
    sendNotification(
        "ADMIN DETECTED",
        "Server hopping to avoid admin...",
        5
    )
    
    local servers = HttpService:JSONDecode(game:HttpGet(
        string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PLACE_ID)
    ))
    
    if servers and servers.data then
        for _, server in ipairs(servers.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, Players.LocalPlayer)
                return
            end
        end
    end
    
    TeleportService:Teleport(PLACE_ID, Players.LocalPlayer)
end

local function getGroupRoles()
    local success, result = pcall(function()
        local url = string.format("https://groups.roblox.com/v1/groups/%d/roles", GROUP_ID)
        local response = HttpService:JSONDecode(game:HttpGet(url))
        return response.roles
    end)
    
    if success and result then
        return result
    else
        return nil
    end
end

local function getUsersInRole(roleId, cursor)
    cursor = cursor or ""
    
    local success, result = pcall(function()
        local url = string.format(
            "https://groups.roblox.com/v1/groups/%d/roles/%d/users?limit=100&sortOrder=Asc&cursor=%s",
            GROUP_ID,
            roleId,
            cursor
        )
        local response = HttpService:JSONDecode(game:HttpGet(url))
        return response
    end)
    
    if success and result then
        return result
    else
        return nil
    end
end

local function buildAdminList()
    local roles = getGroupRoles()
    if not roles then
        return false
    end
    
    local allRoles = {}
    for _, role in ipairs(ADMIN_ROLES) do
        table.insert(allRoles, role)
    end
    for _, customRole in ipairs(getgenv().AdminDetector.Config.customRoles) do
        table.insert(allRoles, customRole)
    end
    
    for _, role in ipairs(roles) do
        for _, adminRoleName in ipairs(allRoles) do
            if role.name == adminRoleName then
                table.insert(adminRoleIds, {
                    id = role.id,
                    name = role.name
                })
            end
        end
    end
    
    if #adminRoleIds == 0 then
        return false
    end
    
    local adminList = {}
    
    for _, roleInfo in ipairs(adminRoleIds) do
        local cursor = ""
        local hasMore = true
        
        while hasMore do
            local response = getUsersInRole(roleInfo.id, cursor)
            
            if response and response.data then
                for _, user in ipairs(response.data) do
                    adminList[user.userId] = {
                        username = user.username,
                        userId = user.userId,
                        role = roleInfo.name
                    }
                end
                
                if response.nextPageCursor and response.nextPageCursor ~= "" then
                    cursor = response.nextPageCursor
                else
                    hasMore = false
                end
            else
                hasMore = false
            end
            
            task.wait(0.1)
        end
    end
    
    return adminList
end

local function isAdmin(player, adminList)
    return adminList[player.UserId] ~= nil
end

local function onAdminDetected(player, adminInfo)
    if detectedAdmins[player.UserId] then return end
    
    detectedAdmins[player.UserId] = true
    
    local message = string.format(
        "ADMIN IN SERVER\n%s (@%s)\nRole: %s",
        player.DisplayName,
        player.Name,
        adminInfo.role
    )
    
    sendNotification("ADMIN DETECTED", message, 15)
    playAlertSound()
    
    if getgenv().AdminDetector.Config.autoServerHop then
        task.wait(2)
        serverHop()
    end
end

local function checkAllPlayers(adminList)
    if not adminList then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if isAdmin(player, adminList) then
                local adminInfo = adminList[player.UserId]
                onAdminDetected(player, adminInfo)
            end
        end
    end
end

local function startScanning()
    local adminList = buildAdminList()
    
    if not adminList then
        return
    end
    
    if getgenv().AdminDetector.Config.detectOnJoin then
        checkAllPlayers(adminList)
    end
    
    Players.PlayerAdded:Connect(function(player)
        if not getgenv().AdminDetector.Config.enabled then return end
        
        task.wait(1)
        
        if isAdmin(player, adminList) then
            local adminInfo = adminList[player.UserId]
            onAdminDetected(player, adminInfo)
        end
    end)
    
    if getgenv().AdminDetector.Config.periodicCheck then
        task.spawn(function()
            while getgenv().AdminDetector.Config.enabled do
                task.wait(getgenv().AdminDetector.Config.checkInterval)
                checkAllPlayers(adminList)
            end
        end)
    end
end

getgenv().AdminDetector.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().AdminDetector.Config[key] ~= nil then
            getgenv().AdminDetector.Config[key] = value
        end
    end
end

getgenv().AdminDetector.GetDetectedAdmins = function()
    return detectedAdmins
end

getgenv().AdminDetector.ClearDetected = function()
    detectedAdmins = {}
end

getgenv().AdminDetector.ManualServerHop = function()
    serverHop()
end

getgenv().AdminDetector.Start = function()
    if getgenv().AdminDetector.Config.enabled then
        startScanning()
    end
end

if getgenv().AdminDetector.Config.enabled then
    startScanning()
end
