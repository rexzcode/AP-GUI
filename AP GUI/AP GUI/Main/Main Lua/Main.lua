getgenv().APMain = getgenv().APMain or {}

getgenv().APMain.Config = {
    autoLoadModules = false,
    modules = {
        AdminDetector = false,
        AutoCollect = false,
        AutoFarm = false,
        BossMoney = false,
        CarMod = false,
        AmmoESP = false,
        CarESP = false,
        LootESP = false,
        PlayerESP = false,
        WaifuESP = false,
        BulletMod = false,
        GunMod = false,
    },
    loadOrder = {
        "AdminDetector",
        "CarMod",
        "BulletMod",
        "GunMod",
        "AmmoESP",
        "CarESP",
        "LootESP",
        "PlayerESP",
        "WaifuESP",
        "AutoCollect",
        "AutoFarm",
        "BossMoney",
    },
    initDelay = 0.5,
    moduleLoadDelay = 0.1,
    safeMode = false,
}

local loadedModules = {}

local function loadModule(moduleName)
    if loadedModules[moduleName] then
        return true
    end
    
    local success = pcall(function()
        task.wait(getgenv().APMain.Config.moduleLoadDelay)
    end)
    
    if success then
        loadedModules[moduleName] = true
        return true
    else
        return false
    end
end

local function initializeModules()
    task.wait(getgenv().APMain.Config.initDelay)
    
    for _, moduleName in ipairs(getgenv().APMain.Config.loadOrder) do
        if getgenv().APMain.Config.modules[moduleName] then
            loadModule(moduleName)
        end
    end
end

getgenv().APMain.LoadModule = function(moduleName)
    if not getgenv().APMain.Config.modules[moduleName] then
        return false
    end
    return loadModule(moduleName)
end

getgenv().APMain.UnloadModule = function(moduleName)
    if loadedModules[moduleName] then
        loadedModules[moduleName] = nil
        
        if moduleName == "AdminDetector" and getgenv().AdminDetector then
            getgenv().AdminDetector.Config.enabled = false
        elseif moduleName == "AutoCollect" and getgenv().AutoCollect then
            getgenv().AutoCollect.Stop()
        elseif moduleName == "AutoFarm" and getgenv().AutoFarm then
            getgenv().AutoFarm.Stop()
        elseif moduleName == "BossMoney" and getgenv().BossMoney then
            getgenv().BossMoney.Stop()
        elseif moduleName == "CarMod" and getgenv().CarMod then
            getgenv().CarMod.Config.enabled = false
        elseif moduleName == "AmmoESP" and getgenv().AmmoESP then
            getgenv().AmmoESP.Config.enabled = false
            getgenv().AmmoESP.Clear()
        elseif moduleName == "CarESP" and getgenv().CarESP then
            getgenv().CarESP.Config.enabled = false
            getgenv().CarESP.Clear()
        elseif moduleName == "LootESP" and getgenv().LootESP then
            getgenv().LootESP.Config.enabled = false
            getgenv().LootESP.Clear()
        elseif moduleName == "PlayerESP" and getgenv().PlayerESP then
            getgenv().PlayerESP.Config.enabled = false
            getgenv().PlayerESP.Clear()
        elseif moduleName == "WaifuESP" and getgenv().WaifuESP then
            getgenv().WaifuESP.Config.enabled = false
            getgenv().WaifuESP.Clear()
        elseif moduleName == "BulletMod" and getgenv().BulletMod then
            getgenv().BulletMod.Config.enabled = false
        elseif moduleName == "GunMod" and getgenv().GunMod then
            getgenv().GunMod.Config.enabled = false
        end
        
        return true
    end
    return false
end

getgenv().APMain.ReloadModule = function(moduleName)
    getgenv().APMain.UnloadModule(moduleName)
    task.wait(0.5)
    return getgenv().APMain.LoadModule(moduleName)
end

getgenv().APMain.GetLoadedModules = function()
    local loaded = {}
    for name, _ in pairs(loadedModules) do
        table.insert(loaded, name)
    end
    return loaded
end

getgenv().APMain.UpdateConfig = function(newConfig)
    for key, value in pairs(newConfig) do
        if getgenv().APMain.Config[key] ~= nil then
            getgenv().APMain.Config[key] = value
        end
    end
end

getgenv().APMain.GetAllConfigs = function()
    local configs = {
        Main = getgenv().APMain.Config,
    }
    
    if getgenv().AdminDetector then
        configs.AdminDetector = getgenv().AdminDetector.Config
    end
    if getgenv().AutoCollect then
        configs.AutoCollect = getgenv().AutoCollect.Config
    end
    if getgenv().AutoFarm then
        configs.AutoFarm = getgenv().AutoFarm.Config
    end
    if getgenv().BossMoney then
        configs.BossMoney = getgenv().BossMoney.Config
    end
    if getgenv().CarMod then
        configs.CarMod = getgenv().CarMod.Config
    end
    if getgenv().AmmoESP then
        configs.AmmoESP = getgenv().AmmoESP.Config
    end
    if getgenv().CarESP then
        configs.CarESP = getgenv().CarESP.Config
    end
    if getgenv().LootESP then
        configs.LootESP = getgenv().LootESP.Config
    end
    if getgenv().PlayerESP then
        configs.PlayerESP = getgenv().PlayerESP.Config
    end
    if getgenv().WaifuESP then
        configs.WaifuESP = getgenv().WaifuESP.Config
    end
    if getgenv().BulletMod then
        configs.BulletMod = getgenv().BulletMod.Config
    end
    if getgenv().GunMod then
        configs.GunMod = getgenv().GunMod.Config
    end
    
    return configs
end

getgenv().APMain.SaveConfig = function()
    local configs = getgenv().APMain.GetAllConfigs()
    return game:GetService("HttpService"):JSONEncode(configs)
end

getgenv().APMain.LoadConfig = function(configJson)
    local success, configs = pcall(function()
        return game:GetService("HttpService"):JSONDecode(configJson)
    end)
    
    if not success then
        return false
    end
    
    for moduleName, config in pairs(configs) do
        if moduleName == "Main" then
            getgenv().APMain.UpdateConfig(config)
        elseif moduleName == "AdminDetector" and getgenv().AdminDetector then
            getgenv().AdminDetector.UpdateConfig(config)
        elseif moduleName == "AutoCollect" and getgenv().AutoCollect then
            getgenv().AutoCollect.UpdateConfig(config)
        elseif moduleName == "AutoFarm" and getgenv().AutoFarm then
            getgenv().AutoFarm.UpdateConfig(config)
        elseif moduleName == "BossMoney" and getgenv().BossMoney then
            getgenv().BossMoney.UpdateConfig(config)
        elseif moduleName == "CarMod" and getgenv().CarMod then
            getgenv().CarMod.UpdateConfig(config)
        elseif moduleName == "AmmoESP" and getgenv().AmmoESP then
            getgenv().AmmoESP.UpdateConfig(config)
        elseif moduleName == "CarESP" and getgenv().CarESP then
            getgenv().CarESP.UpdateConfig(config)
        elseif moduleName == "LootESP" and getgenv().LootESP then
            getgenv().LootESP.UpdateConfig(config)
        elseif moduleName == "PlayerESP" and getgenv().PlayerESP then
            getgenv().PlayerESP.UpdateConfig(config)
        elseif moduleName == "WaifuESP" and getgenv().WaifuESP then
            getgenv().WaifuESP.UpdateConfig(config)
        elseif moduleName == "BulletMod" and getgenv().BulletMod then
            getgenv().BulletMod.UpdateConfig(config)
        elseif moduleName == "GunMod" and getgenv().GunMod then
            getgenv().GunMod.UpdateConfig(config)
        end
    end
    
    return true
end

if getgenv().APMain.Config.autoLoadModules then
    initializeModules()
end
