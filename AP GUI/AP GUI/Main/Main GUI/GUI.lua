warn("[AP GUI] Starting GUI initialization...")

local MacLib = getgenv().MacLib or loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

warn("[AP GUI] MacLib loaded successfully")

local Window = MacLib:Window({
    Title = "AP GUI",
    Subtitle = "AniPhobia PAID",
    Size = UDim2.fromOffset(900, 700),
    Toggle = Enum.KeyCode.RightControl,
    Color = Color3.fromRGB(125, 85, 255),
    Transparency = 0.1,
    Blurriness = 0,
    Minimize = true,
    SaveSettings = true,
    Theme = "Dark"
})

pcall(function()
    Window:SetFolder("APGUIConfigs")
end)

task.spawn(function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    
    local gui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MacLib")
    local mainFrame = gui:FindFirstChild("Main")
    
    if mainFrame then
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Size = UDim2.new(0, 20, 0, 20)
        resizeHandle.Position = UDim2.new(1, -20, 1, -20)
        resizeHandle.AnchorPoint = Vector2.new(0, 0)
        resizeHandle.BackgroundColor3 = Color3.fromRGB(125, 85, 255)
        resizeHandle.BorderSizePixel = 0
        resizeHandle.ZIndex = 1000
        resizeHandle.Parent = mainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = resizeHandle
        
        local dragging = false
        local dragStart = nil
        local startSize = nil
        
        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startSize = mainFrame.Size
            end
        end)
        
        resizeHandle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newWidth = math.max(600, startSize.X.Offset + delta.X)
                local newHeight = math.max(400, startSize.Y.Offset + delta.Y)
                mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
                resizeHandle.Position = UDim2.new(1, -20, 1, -20)
            end
        end)
    end
end)

local TabGroups = {
    Main = Window:TabGroup(),
    Combat = Window:TabGroup(),
    Visual = Window:TabGroup(),
    Misc = Window:TabGroup()
}

local Tabs = {}
local Sections = {}

Tabs.AdminDetector = TabGroups.Main:Tab({
    Name = "Admin Detector",
    Image = "rbxassetid://11963373994"
})

Tabs.AutoFarm = TabGroups.Main:Tab({
    Name = "Auto Farm",
    Image = "rbxassetid://11963373994"
})

Tabs.AutoCollect = TabGroups.Main:Tab({
    Name = "Auto Collect",
    Image = "rbxassetid://11963373994"
})

Tabs.GunMods = TabGroups.Combat:Tab({
    Name = "Gun Mods",
    Image = "rbxassetid://11963373994"
})

Tabs.BulletMods = TabGroups.Combat:Tab({
    Name = "Bullet Mods",
    Image = "rbxassetid://11963373994"
})

Tabs.CarMods = TabGroups.Misc:Tab({
    Name = "Car Mods",
    Image = "rbxassetid://11963373994"
})

Tabs.ESP = TabGroups.Visual:Tab({
    Name = "ESP",
    Image = "rbxassetid://11963373994"
})

Tabs.Settings = TabGroups.Misc:Tab({
    Name = "Settings",
    Image = "rbxassetid://11963373994"
})

warn("[AP GUI] All tabs created successfully")

Sections.AdminDetectorLeft = Tabs.AdminDetector:Section({ Side = "Left" })
Sections.AdminDetectorRight = Tabs.AdminDetector:Section({ Side = "Right" })

Sections.AutoFarmLeft = Tabs.AutoFarm:Section({ Side = "Left" })
Sections.AutoFarmRight = Tabs.AutoFarm:Section({ Side = "Right" })

Sections.AutoCollectLeft = Tabs.AutoCollect:Section({ Side = "Left" })
Sections.AutoCollectRight = Tabs.AutoCollect:Section({ Side = "Right" })

Sections.GunModsLeft = Tabs.GunMods:Section({ Side = "Left" })
Sections.GunModsRight = Tabs.GunMods:Section({ Side = "Right" })

Sections.BulletModsLeft = Tabs.BulletMods:Section({ Side = "Left" })
Sections.BulletModsRight = Tabs.BulletMods:Section({ Side = "Right" })

Sections.CarModsLeft = Tabs.CarMods:Section({ Side = "Left" })
Sections.CarModsRight = Tabs.CarMods:Section({ Side = "Right" })

Sections.ESPLeft = Tabs.ESP:Section({ Side = "Left" })
Sections.ESPRight = Tabs.ESP:Section({ Side = "Right" })

Sections.SettingsLeft = Tabs.Settings:Section({ Side = "Left" })
Sections.SettingsRight = Tabs.Settings:Section({ Side = "Right" })

warn("[AP GUI] All sections created successfully. Building UI controls...")

Sections.AdminDetectorLeft:Header({ Text = "Admin Detector" })

Sections.AdminDetectorLeft:Toggle({
    Name = "Enable Admin Detector",
    Default = false,
    Callback = function(Value)
        if getgenv().AdminDetector then
            getgenv().AdminDetector.Config.enabled = Value
            if Value and getgenv().AdminDetector.Start then
                getgenv().AdminDetector.Start()
            end
        end
    end
}, "AdminDetectorEnabled")

Sections.AdminDetectorLeft:Toggle({
    Name = "Auto Server Hop",
    Default = false,
    Callback = function(Value)
        if getgenv().AdminDetector then
            getgenv().AdminDetector.Config.autoServerHop = Value
        end
    end
}, "AdminDetectorAutoHop")

Sections.AdminDetectorLeft:Toggle({
    Name = "Show Notifications",
    Default = false,
    Callback = function(Value)
        if getgenv().AdminDetector then
            getgenv().AdminDetector.Config.showNotification = Value
        end
    end
}, "AdminDetectorNotif")

Sections.AdminDetectorLeft:Toggle({
    Name = "Play Alert Sound",
    Default = false,
    Callback = function(Value)
        if getgenv().AdminDetector then
            getgenv().AdminDetector.Config.playSound = Value
        end
    end
}, "AdminDetectorSound")

Sections.AdminDetectorRight:Header({ Text = "Settings" })

Sections.AdminDetectorRight:Slider({
    Name = "Sound Volume",
    Default = 0.5,
    Minimum = 0,
    Maximum = 1,
    DisplayMethod = "Percent",
    Precision = 2,
    Callback = function(Value)
        if getgenv().AdminDetector then
            getgenv().AdminDetector.Config.soundVolume = Value
        end
    end
}, "AdminDetectorVolume")

Sections.AdminDetectorRight:Slider({
    Name = "Check Interval",
    Default = 30,
    Minimum = 5,
    Maximum = 120,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().AdminDetector then
            getgenv().AdminDetector.Config.checkInterval = Value
        end
    end
}, "AdminDetectorInterval")

warn("[AP GUI] Admin Detector controls loaded!")

Sections.AdminDetectorRight:Button({
    Name = "Manual Server Hop",
    Callback = function()
        if getgenv().AdminDetector and getgenv().AdminDetector.ManualServerHop then
            getgenv().AdminDetector.ManualServerHop()
        end
    end
})

Sections.AdminDetectorRight:Button({
    Name = "Clear Detected Admins",
    Callback = function()
        if getgenv().AdminDetector and getgenv().AdminDetector.ClearDetected then
            getgenv().AdminDetector.ClearDetected()
            Window:Notify({
                Title = "Admin Detector",
                Description = "Cleared detected admins list",
                Lifetime = 3
            })
        end
    end
})

warn("[AP GUI] Starting Auto Farm section...")

Sections.AutoFarmLeft:Header({ Text = "Auto Farm" })

Sections.AutoFarmLeft:Toggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.enabled = Value
            if Value then
                getgenv().AutoFarm.Start()
            else
                getgenv().AutoFarm.Stop()
            end
        end
    end
}, "AutoFarmEnabled")

Sections.AutoFarmLeft:Toggle({
    Name = "Farm Enemies",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.farmEnemies = Value
        end
    end
}, "AutoFarmEnemies")

Sections.AutoFarmLeft:Toggle({
    Name = "Loop Teleport",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.loopTeleport = Value
        end
    end
}, "AutoFarmLoop")

Sections.AutoFarmLeft:Toggle({
    Name = "Anchor Player",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.anchorPlayer = Value
        end
    end
}, "AutoFarmAnchor")

Sections.AutoFarmLeft:Toggle({
    Name = "Skip Empty Locations",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.skipEmptyLocations = Value
        end
    end
}, "AutoFarmSkipEmpty")

Sections.AutoFarmRight:Header({ Text = "Farm Settings" })

Sections.AutoFarmRight:Slider({
    Name = "Height Offset",
    Default = 100,
    Minimum = 0,
    Maximum = 500,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.heightOffset = Value
        end
    end
}, "AutoFarmHeight")

Sections.AutoFarmRight:Slider({
    Name = "Enemy Distance",
    Default = 30,
    Minimum = 5,
    Maximum = 100,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.enemyDistance = Value
        end
    end
}, "AutoFarmEnemyDist")

Sections.AutoFarmRight:Slider({
    Name = "Wait Time",
    Default = 0.5,
    Minimum = 0.1,
    Maximum = 5,
    DisplayMethod = "Value",
    Precision = 1,
    Callback = function(Value)
        if getgenv().AutoFarm then
            getgenv().AutoFarm.Config.waitTime = Value
        end
    end
}, "AutoFarmWait")

Sections.AutoFarmRight:Dropdown({
    Name = "Select Locations",
    Search = true,
    Multi = true,
    Required = false,
    Options = {"RadioStation", "SmallStop", "Tunnel", "Terrain", "Redwood", "TouristTown", "Town1", "MilitaryCheckpoint", "StMarryHospital", "BigCity", "Mall", "Camp", "Farm"},
    Default = {},
    Callback = function(Value)
        if getgenv().AutoFarm then
            local selected = {}
            for location, state in pairs(Value) do
                if state then
                    table.insert(selected, location)
                end
            end
            getgenv().AutoFarm.Config.selectedLocations = selected
        end
    end
}, "AutoFarmLocations")

warn("[AP GUI] Starting Auto Collect section...")

Sections.AutoCollectLeft:Header({ Text = "Auto Collect" })

Sections.AutoCollectLeft:Toggle({
    Name = "Enable Auto Collect",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoCollect then
            if Value then
                getgenv().AutoCollect.Start()
            else
                getgenv().AutoCollect.Stop()
            end
        end
    end
}, "AutoCollectEnabled")

Sections.AutoCollectLeft:Toggle({
    Name = "Collect Ammo",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoCollect then
            getgenv().AutoCollect.Config.collectAmmo = Value
        end
    end
}, "AutoCollectAmmo")

Sections.AutoCollectLeft:Toggle({
    Name = "Collect Weapons",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoCollect then
            getgenv().AutoCollect.Config.collectWeapons = Value
        end
    end
}, "AutoCollectWeapons")

Sections.AutoCollectLeft:Toggle({
    Name = "Return to Original Position",
    Default = false,
    Callback = function(Value)
        if getgenv().AutoCollect then
            getgenv().AutoCollect.Config.returnToOriginal = Value
        end
    end
}, "AutoCollectReturn")

Sections.AutoCollectRight:Header({ Text = "Collect Settings" })

Sections.AutoCollectRight:Slider({
    Name = "Collect Distance",
    Default = 1,
    Minimum = 0,
    Maximum = 10,
    DisplayMethod = "Value",
    Precision = 1,
    Callback = function(Value)
        if getgenv().AutoCollect then
            getgenv().AutoCollect.Config.collectDistance = Value
        end
    end
}, "AutoCollectDist")

Sections.AutoCollectRight:Slider({
    Name = "Wait Between Items",
    Default = 0.1,
    Minimum = 0,
    Maximum = 1,
    DisplayMethod = "Value",
    Precision = 2,
    Callback = function(Value)
        if getgenv().AutoCollect then
            getgenv().AutoCollect.Config.waitBetweenItems = Value
        end
    end
}, "AutoCollectWaitItems")

Sections.AutoCollectRight:Slider({
    Name = "Wait Between Cycles",
    Default = 5,
    Minimum = 1,
    Maximum = 30,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().AutoCollect then
            getgenv().AutoCollect.Config.waitBetweenCycles = Value
        end
    end
}, "AutoCollectWaitCycles")

Sections.AutoCollectRight:Button({
    Name = "Collect Once",
    Callback = function()
        if getgenv().AutoCollect and getgenv().AutoCollect.CollectOnce then
            getgenv().AutoCollect.CollectOnce()
        end
    end
})

warn("[AP GUI] Auto Collect section complete!")

Sections.GunModsLeft:Header({ Text = "Gun Modifications" })

Sections.GunModsLeft:Toggle({
    Name = "Enable Gun Mods",
    Default = false,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.enabled = Value
            if Value and getgenv().GunMod.Start then
                getgenv().GunMod.Start()
            end
        end
    end
}, "GunModEnabled")

Sections.GunModsLeft:Toggle({
    Name = "Infinite Ammo",
    Default = false,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.infiniteAmmo = Value
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModInfAmmo")

Sections.GunModsLeft:Toggle({
    Name = "Auto Fire",
    Default = false,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.autoFire = Value
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModAutoFire")

Sections.GunModsLeft:Toggle({
    Name = "No Recoil",
    Default = false,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.recoil = Value and 0 or 1
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModNoRecoil")

Sections.GunModsLeft:Toggle({
    Name = "No Spread",
    Default = false,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.spread = Value and 0 or 1
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModNoSpread")

Sections.GunModsRight:Header({ Text = "Gun Stats" })

Sections.GunModsRight:Slider({
    Name = "Fire Rate",
    Default = 0.01,
    Minimum = 0.001,
    Maximum = 1,
    DisplayMethod = "Value",
    Precision = 3,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.fireRate = Value
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModFireRate")

Sections.GunModsRight:Slider({
    Name = "Base Damage",
    Default = 1000,
    Minimum = 1,
    Maximum = 10000,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.baseDamage = Value
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModDamage")

Sections.GunModsRight:Slider({
    Name = "Ammo Per Mag",
    Default = 999,
    Minimum = 1,
    Maximum = 9999,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().GunMod then
            getgenv().GunMod.Config.ammoPerMag = Value
            if getgenv().GunMod.ReapplyMods then
                getgenv().GunMod.ReapplyMods()
            end
        end
    end
}, "GunModAmmoMag")

Sections.GunModsRight:Button({
    Name = "Force Apply Mods",
    Callback = function()
        if getgenv().GunMod and getgenv().GunMod.ForceApply then
            getgenv().GunMod.ForceApply()
            Window:Notify({
                Title = "Gun Mods",
                Description = "Force applied gun modifications",
                Lifetime = 3
            })
        end
    end
})

warn("[AP GUI] Gun Mods section complete!")

Sections.BulletModsLeft:Header({ Text = "Bullet Physics" })

Sections.BulletModsLeft:Toggle({
    Name = "Enable Bullet Mods",
    Default = false,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.enabled = Value
            if Value and getgenv().BulletMod.Start then
                getgenv().BulletMod.Start()
            end
        end
    end
}, "BulletModEnabled")

Sections.BulletModsLeft:Toggle({
    Name = "Infinite Range",
    Default = false,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.infiniteRange = Value
        end
    end
}, "BulletModInfRange")

Sections.BulletModsLeft:Toggle({
    Name = "Penetrate Walls",
    Default = false,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.penetrateWalls = Value
        end
    end
}, "BulletModPenWalls")

Sections.BulletModsLeft:Toggle({
    Name = "Penetrate Enemies",
    Default = false,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.penetrateEnemies = Value
        end
    end
}, "BulletModPenEnemies")

Sections.BulletModsLeft:Toggle({
    Name = "No Gravity",
    Default = false,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.noGravity = Value
        end
    end
}, "BulletModNoGrav")

Sections.BulletModsRight:Header({ Text = "Silent Aim" })

Sections.BulletModsRight:Toggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.silentAim = Value
        end
    end
}, "BulletModSilentAim")

Sections.BulletModsRight:Dropdown({
    Name = "Target Body Parts (Cycles)",
    Multi = true,
    Required = false,
    Options = {
        "Head",
        "Torso",
        "HumanoidRootPart",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg"
    },
    Default = {"Head"},
    Callback = function(Value)
        if getgenv().BulletMod then
            local selectedParts = {}
            for partName, isSelected in pairs(Value) do
                if isSelected then
                    table.insert(selectedParts, partName)
                end
            end
            if #selectedParts > 0 then
                getgenv().BulletMod.Config.selectedBodyParts = selectedParts
            else
                getgenv().BulletMod.Config.selectedBodyParts = {"Head"}
            end
            if getgenv().BulletMod.ResetBodyPartCycle then
                getgenv().BulletMod.ResetBodyPartCycle()
            end
        end
    end
}, "BulletModBodyParts")

Sections.BulletModsRight:Paragraph({
    Header = "Body Part Cycling",
    Body = "Each bullet will cycle through your selected body parts in order. Works with both R6 and R15 characters automatically. Perfect for bypassing armor!"
})

Sections.BulletModsRight:Button({
    Name = "Reset Body Part Cycle",
    Callback = function()
        if getgenv().BulletMod and getgenv().BulletMod.ResetBodyPartCycle then
            getgenv().BulletMod.ResetBodyPartCycle()
            Window:Notify({
                Title = "Bullet Mods",
                Description = "Body part cycle reset to start.",
                Lifetime = 2
            })
        end
    end
})

Sections.BulletModsRight:Slider({
    Name = "Bullet Speed",
    Default = 10000,
    Minimum = 1300,
    Maximum = 50000,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.bulletSpeed = Value
        end
    end
}, "BulletModSpeed")

Sections.BulletModsRight:Slider({
    Name = "Aim FOV",
    Default = 500,
    Minimum = 50,
    Maximum = 1000,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.aimFOV = Value
        end
    end
}, "BulletModFOV")

Sections.BulletModsRight:Dropdown({
    Name = "Target Selection",
    Search = false,
    Multi = false,
    Required = true,
    Options = {"closest", "highest_health", "lowest_health"},
    Default = 1,
    Callback = function(Value)
        if getgenv().BulletMod then
            getgenv().BulletMod.Config.targetSelection = Value
        end
    end
}, "BulletModTarget")

warn("[AP GUI] Bullet Mods section complete!")

warn("[AP GUI] Loading Car Mod controls...")

local carModSuccess, carModError = pcall(function()

Sections.CarModsLeft:Header({ Text = "Car Modifications" })

Sections.CarModsLeft:Toggle({
    Name = "Enable Car Mods",
    Default = false,
    Callback = function(Value)
        if getgenv().CarMod then
            getgenv().CarMod.Config.enabled = Value
            if Value and getgenv().CarMod.Start then
                getgenv().CarMod.Start()
            end
        end
    end
}, "CarModEnabled")

Sections.CarModsLeft:Toggle({
    Name = "Infinite Health",
    Default = false,
    Callback = function(Value)
        if getgenv().CarMod then
            getgenv().CarMod.Config.infiniteHealth = Value
        end
    end
}, "CarModInfHealth")

Sections.CarModsLeft:Toggle({
    Name = "Auto Flip",
    Default = false,
    Callback = function(Value)
        if getgenv().CarMod then
            getgenv().CarMod.Config.autoFlip = Value
        end
    end
}, "CarModAutoFlip")

Sections.CarModsLeft:Toggle({
    Name = "No Collision",
    Default = false,
    Callback = function(Value)
        if getgenv().CarMod then
            getgenv().CarMod.Config.noCollision = Value
        end
    end
}, "CarModNoCollision")

Sections.CarModsRight:Header({ Text = "Car Stats" })

Sections.CarModsRight:Slider({
    Name = "Max Speed",
    Default = 300,
    Minimum = 50,
    Maximum = 1000,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().CarMod then
            getgenv().CarMod.Config.maxSpeed = Value
        end
    end
}, "CarModSpeed")

Sections.CarModsRight:Slider({
    Name = "Turn Radius",
    Default = 45,
    Minimum = 10,
    Maximum = 100,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        if getgenv().CarMod then
            getgenv().CarMod.Config.turnRadius = Value
        end
    end
}, "CarModTurn")

Sections.CarModsRight:Button({
    Name = "Force Apply Mods",
    Callback = function()
        if getgenv().CarMod and getgenv().CarMod.ForceApply then
            getgenv().CarMod.ForceApply()
            Window:Notify({
                Title = "Car Mods",
                Description = "Force applied car modifications",
                Lifetime = 3
            })
        end
    end
})

end)

if not carModSuccess then
    warn("[AP GUI ERROR] Failed to load Car Mod controls: " .. tostring(carModError))
else
    warn("[AP GUI] Car Mod controls loaded successfully!")
end

warn("[AP GUI] Loading ESP controls...")

local espSuccess, espError = pcall(function()

Sections.ESPLeft:Header({ Text = "Enemy ESP (Waifus)" })

Sections.ESPLeft:Toggle({
    Name = "Enable Enemy ESP",
    Default = false,
    Callback = function(Value)
        if getgenv().WaifuESP then
            getgenv().WaifuESP.Config.enabled = Value
            if Value and getgenv().WaifuESP.Start then
                getgenv().WaifuESP.Start()
            elseif not Value then
                getgenv().WaifuESP.Clear()
            end
        end
    end
}, "WaifuESPEnabled")

Sections.ESPLeft:Toggle({
    Name = "Show Name",
    Default = false,
    Callback = function(Value)
        if getgenv().WaifuESP then
            getgenv().WaifuESP.Config.showName = Value
            getgenv().WaifuESP.Config.nameVisible = Value
            if getgenv().WaifuESP.Refresh then
                getgenv().WaifuESP.Refresh()
            end
        end
    end
}, "WaifuESPName")

Sections.ESPLeft:Toggle({
    Name = "Show Health",
    Default = false,
    Callback = function(Value)
        if getgenv().WaifuESP then
            getgenv().WaifuESP.Config.showHealth = Value
            getgenv().WaifuESP.Config.healthVisible = Value
            if getgenv().WaifuESP.Refresh then
                getgenv().WaifuESP.Refresh()
            end
        end
    end
}, "WaifuESPHealth")

Sections.ESPLeft:Toggle({
    Name = "Show Distance",
    Default = false,
    Callback = function(Value)
        if getgenv().WaifuESP then
            getgenv().WaifuESP.Config.showDistance = Value
            getgenv().WaifuESP.Config.distanceVisible = Value
            if getgenv().WaifuESP.Refresh then
                getgenv().WaifuESP.Refresh()
            end
        end
    end
}, "WaifuESPDistance")

Sections.ESPLeft:Colorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Alpha = 0.5,
    Callback = function(Color, Alpha)
        if getgenv().WaifuESP then
            getgenv().WaifuESP.Config.fillColor = Color
            getgenv().WaifuESP.Config.fillTransparency = Alpha
            if getgenv().WaifuESP.Refresh then
                getgenv().WaifuESP.Refresh()
            end
        end
    end
}, "WaifuESPColor")

Sections.ESPLeft:Divider()

Sections.ESPLeft:Header({ Text = "Player ESP" })

Sections.ESPLeft:Toggle({
    Name = "Enable Player ESP",
    Default = false,
    Callback = function(Value)
        if getgenv().PlayerESP then
            getgenv().PlayerESP.Config.enabled = Value
            if Value and getgenv().PlayerESP.Start then
                getgenv().PlayerESP.Start()
            elseif not Value then
                getgenv().PlayerESP.Clear()
            end
        end
    end
}, "PlayerESPEnabled")

Sections.ESPLeft:Colorpicker({
    Name = "Player ESP Color",
    Default = Color3.fromRGB(0, 150, 255),
    Alpha = 0.5,
    Callback = function(Color, Alpha)
        if getgenv().PlayerESP then
            getgenv().PlayerESP.Config.fillColor = Color
            getgenv().PlayerESP.Config.fillTransparency = Alpha
            if getgenv().PlayerESP.Refresh then
                getgenv().PlayerESP.Refresh()
            end
        end
    end
}, "PlayerESPColor")

Sections.ESPRight:Header({ Text = "Item ESP" })

Sections.ESPRight:Toggle({
    Name = "Enable Loot ESP",
    Default = false,
    Callback = function(Value)
        if getgenv().LootESP then
            getgenv().LootESP.Config.enabled = Value
            if Value and getgenv().LootESP.Start then
                getgenv().LootESP.Start()
            elseif not Value then
                getgenv().LootESP.Clear()
            end
        end
    end
}, "LootESPEnabled")

Sections.ESPRight:Toggle({
    Name = "Enable Ammo ESP",
    Default = false,
    Callback = function(Value)
        if getgenv().AmmoESP then
            getgenv().AmmoESP.Config.enabled = Value
            if Value and getgenv().AmmoESP.Start then
                getgenv().AmmoESP.Start()
            elseif not Value then
                getgenv().AmmoESP.Clear()
            end
        end
    end
}, "AmmoESPEnabled")

Sections.ESPRight:Toggle({
    Name = "Enable Car ESP",
    Default = false,
    Callback = function(Value)
        if getgenv().CarESP then
            getgenv().CarESP.Config.enabled = Value
            if Value and getgenv().CarESP.Start then
                getgenv().CarESP.Start()
            elseif not Value then
                getgenv().CarESP.Clear()
            end
        end
    end
}, "CarESPEnabled")

Sections.ESPRight:Divider()

Sections.ESPRight:Button({
    Name = "Refresh All ESP",
    Callback = function()
        if getgenv().WaifuESP and getgenv().WaifuESP.Refresh then
            getgenv().WaifuESP.Refresh()
        end
        if getgenv().PlayerESP and getgenv().PlayerESP.Refresh then
            getgenv().PlayerESP.Refresh()
        end
        if getgenv().LootESP and getgenv().LootESP.Refresh then
            getgenv().LootESP.Refresh()
        end
        if getgenv().AmmoESP and getgenv().AmmoESP.Refresh then
            getgenv().AmmoESP.Refresh()
        end
        if getgenv().CarESP and getgenv().CarESP.Refresh then
            getgenv().CarESP.Refresh()
        end
        Window:Notify({
            Title = "ESP",
            Description = "Refreshed all ESP modules",
            Lifetime = 3
        })
    end
})

Sections.ESPRight:Button({
    Name = "Clear All ESP",
    Callback = function()
        if getgenv().WaifuESP and getgenv().WaifuESP.Clear then
            getgenv().WaifuESP.Clear()
        end
        if getgenv().PlayerESP and getgenv().PlayerESP.Clear then
            getgenv().PlayerESP.Clear()
        end
        if getgenv().LootESP and getgenv().LootESP.Clear then
            getgenv().LootESP.Clear()
        end
        if getgenv().AmmoESP and getgenv().AmmoESP.Clear then
            getgenv().AmmoESP.Clear()
        end
        if getgenv().CarESP and getgenv().CarESP.Clear then
            getgenv().CarESP.Clear()
        end
        Window:Notify({
            Title = "ESP",
            Description = "Cleared all ESP modules",
            Lifetime = 3
        })
    end
})

end)

if not espSuccess then
    warn("[AP GUI ERROR] Failed to load ESP controls: " .. tostring(espError))
else
    warn("[AP GUI] ESP controls loaded successfully!")
end

warn("[AP GUI] Loading Settings controls...")

local settingsSuccess, settingsError = pcall(function()

Sections.SettingsLeft:Header({ Text = "Configuration" })

pcall(function()
    Tabs.Settings:InsertConfigSection("Left")
end)

Sections.SettingsRight:Header({ Text = "Information" })

local version = "Unknown"
if getgenv().APLoader and getgenv().APLoader.Version then
    version = tostring(getgenv().APLoader.Version)
end

local status = "Unknown"
if getgenv().APLoader and getgenv().APLoader.Status then
    status = tostring(getgenv().APLoader.Status)
end

Sections.SettingsRight:Paragraph({
    Header = "AP GUI",
    Body = "Version " .. version .. "\n\nAdvanced AniPhobia PAID Version"
})

Sections.SettingsRight:Divider()

Sections.SettingsRight:Label({
    Text = "Status: " .. status
})

Sections.SettingsRight:Button({
    Name = "Unload GUI",
    Callback = function()
        Window:Dialog({
            Title = "Unload GUI",
            Description = "Are you sure you want to unload AP GUI? This will disable all features.",
            Buttons = {
                {
                    Name = "Confirm",
                    Callback = function()
                        if getgenv().AdminDetector then getgenv().AdminDetector.Config.enabled = false end
                        if getgenv().AutoCollect then getgenv().AutoCollect.Stop() end
                        if getgenv().AutoFarm then getgenv().AutoFarm.Stop() end
                        if getgenv().BossMoney then getgenv().BossMoney.Stop() end
                        if getgenv().CarMod then getgenv().CarMod.Config.enabled = false end
                        if getgenv().AmmoESP then getgenv().AmmoESP.Clear() end
                        if getgenv().CarESP then getgenv().CarESP.Clear() end
                        if getgenv().LootESP then getgenv().LootESP.Clear() end
                        if getgenv().PlayerESP then getgenv().PlayerESP.Clear() end
                        if getgenv().WaifuESP then getgenv().WaifuESP.Clear() end
                        if getgenv().BulletMod then getgenv().BulletMod.Config.enabled = false end
                        if getgenv().GunMod then getgenv().GunMod.Config.enabled = false end
                        
                        Window:Notify({
                            Title = "AP GUI",
                            Description = "All features disabled. Close the GUI manually.",
                            Lifetime = 5
                        })
                    end
                },
                {
                    Name = "Cancel"
                }
            }
        })
    end
})

end)

if not settingsSuccess then
    warn("[AP GUI ERROR] Failed to load Settings controls: " .. tostring(settingsError))
else
    warn("[AP GUI] Settings controls loaded successfully!")
end

Window:Notify({
    Title = "AP GUI Loaded",
    Description = "Welcome to AP GUI! All features are ready to use.",
    Lifetime = 5
})

warn("[AP GUI] GUI fully initialized. All tabs and sections loaded successfully!")

