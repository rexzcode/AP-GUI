-- Get the key from global variable (set by the wrapper loadstring)
local key = getgenv().__APGUI_KEY

-- Clear the key from global for security
getgenv().__APGUI_KEY = nil

getgenv().APLoader = getgenv().APLoader or {}

if getgenv().APLoader.Loaded then
    warn("AP GUI is already loaded!")
    return
end

getgenv().APLoader.Version = "1.0.0"
getgenv().APLoader.GitHub = "https://raw.githubusercontent.com/rexzcode/AP-GUI/refs/heads/main/AP%20GUI"
getgenv().APLoader.KeyServerURL = "http://localhost:5000"

local function generateHWID()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    return tostring(hwid)
end

local function validateKey(key)
    if not key or key == "" then
        return false, "No key provided. Get a key from the website!"
    end
    
    local hwid = generateHWID()
    warn("[AP GUI] Validating key...")
    warn("[AP GUI] Key: " .. key:sub(1, 16) .. "...")
    warn("[AP GUI] HWID: " .. hwid)
    warn("[AP GUI] Server URL: " .. getgenv().APLoader.KeyServerURL)
    
    local HttpService = game:GetService("HttpService")
    
    -- Try to connect to server
    local success, result = pcall(function()
        local jsonPayload = HttpService:JSONEncode({
            key = key,
            hwid = hwid
        })
        
        warn("[AP GUI] Sending validation request...")
        
        local response = request({
            Url = getgenv().APLoader.KeyServerURL .. "/validate_key",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonPayload
        })
        
        warn("[AP GUI] Status Code: " .. tostring(response.StatusCode))
        warn("[AP GUI] Got response: " .. response.Body:sub(1, 100))
        
        if not response.Success then
            error("HTTP request failed: " .. response.StatusMessage)
        end
        
        return HttpService:JSONDecode(response.Body)
    end)
    
    if not success then
        warn("[AP GUI] ✗ Connection error: " .. tostring(result))
        return false, "Failed to connect to key server!\n\nError: " .. tostring(result) .. "\n\nMake sure:\n1. Python server is running\n2. Check console for details"
    end
    
    if result.valid then
        warn("[AP GUI] ✓ Key validated successfully!")
        return true
    else
        local errorMsg = result.error or "Invalid key"
        warn("[AP GUI] ✗ Key validation failed: " .. errorMsg)
        return false, errorMsg
    end
end

local isValid, errorMsg = validateKey(key)

if not isValid then
    warn("=" .. string.rep("=", 58))
    warn("  AP GUI - KEY VALIDATION FAILED")
    warn("=" .. string.rep("=", 58))
    warn("  Error: " .. (errorMsg or "Invalid key"))
    warn("  ")
    warn("  Don't try to skid the script!")
    warn("  Get a valid key from: YOUR_WEBSITE_URL")
    warn("=" .. string.rep("=", 58))
    return
end

warn("=" .. string.rep("=", 58))
warn("  AP GUI - KEY VALIDATED")
warn("=" .. string.rep("=", 58))
warn("  Starting script loader...")
warn("=" .. string.rep("=", 58))

local function loadScript(path)
    local url = getgenv().APLoader.GitHub .. path
    warn("Loading: " .. url)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("HTTP GET failed for: " .. path)
        warn("Error: " .. tostring(result))
        return nil
    end
    
    warn("Got response, length: " .. #result)
    
    local func, loadErr = loadstring(result)
    if not func then
        warn("loadstring failed for: " .. path)
        warn("Error: " .. tostring(loadErr))
        return nil
    end
    
    local execSuccess, execResult = pcall(func)
    if not execSuccess then
        warn("Execution failed for: " .. path)
        warn("Error: " .. tostring(execResult))
        return nil
    end
    
    warn("Successfully loaded: " .. path)
    return execResult
end

getgenv().APLoader.Status = "Loading MacLib UI Library..."
getgenv().MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

getgenv().APLoader.Status = "Loading Backend Modules..."

loadScript("/Auto/Admin_Detector.lua")
task.wait(0.2)
loadScript("/Auto/Auto_Collect_Items.lua")
task.wait(0.2)
loadScript("/Auto/Auto_Farm.lua")
task.wait(0.2)
loadScript("/Auto/Grab_Boss_Money.lua")
task.wait(0.2)

loadScript("/Car%20Mod/Car_Mod.lua")
task.wait(0.2)

loadScript("/ESP/Ammo_Boxes.lua")
task.wait(0.2)
loadScript("/ESP/Cars.lua")
task.wait(0.2)
loadScript("/ESP/Loot_Items.lua")
task.wait(0.2)
loadScript("/ESP/Players.lua")
task.wait(0.2)
loadScript("/ESP/Waifus.lua")
task.wait(0.2)

loadScript("/Gun%20Mod/Bullet_Physics.Silent_Aim.lua")
task.wait(0.2)
loadScript("/Gun%20Mod/Multi_Setting.lua")
task.wait(0.2)

loadScript("/Main/Main%20Lua/Main.lua")
task.wait(0.5)

getgenv().APLoader.Status = "Initializing GUI..."
loadScript("/Main/Main%20GUI/GUI.lua")

getgenv().APLoader.Loaded = true
getgenv().APLoader.Status = "Loaded Successfully!"

