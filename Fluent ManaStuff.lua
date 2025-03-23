local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local MANAFLY = CFrame.new()
LocalPlayer.CharacterAdded:Connect(function(newcharacter)
    Character = newcharacter
    MANAFLY = Character:GetPrimaryPartCFrame()
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local env = getgenv()

local Window = Fluent:CreateWindow({
    Title = "ManaStuff",
    SubTitle = "by RubyTheSilent",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.J -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Movements", Icon = "chevrons-up" }),
    Keybinds = Window:AddTab({ Title = "Keybinds", Icon = "keyboard" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local movement_dir_z, movement_dir_x = 0, 0

local Options = Fluent.Options

local ManaSoulToggle = Tabs.Main:AddToggle("NoClip", {
    Title = "ManaSoul",
    Default = false
})
local ManaFlyToggle = Tabs.Main:AddToggle("Fly", {
    Title = "ManaFly",
    SubTitle = "(In Gaia)",
    Default = false
})
local ManaRunToggle = Tabs.Main:AddToggle("Speed", {
    Title = "ManaRun",
    Default = false
})
local ManaSpeed = Tabs.Main:AddSlider("MovementSpeed", {
    Title = "Mana Speed",
    Description = "Speed For Both ManaFly/Run",
    Default = 250,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        local v = Value/100
        movement_dir_z, movement_dir_x = 0, 0
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            movement_dir_z = movement_dir_z + v
        end
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            movement_dir_z = movement_dir_z - v
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            movement_dir_x = movement_dir_x + v
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            movement_dir_x = movement_dir_x - v
        end
    end
})

local ManaSoulKey = Tabs.Keybinds:AddKeybind("ManaSoulKeyBind", {
    Title = "ManaSoul Key",
    Mode = "Toggle",
    Default = "P",
})
local ManaFlyKey = Tabs.Keybinds:AddKeybind("ManaFlyKeyBind", {
    Title = "ManaFly Key",
    Mode = "Toggle",
    Default = "K",
})
local ManaRunKey = Tabs.Keybinds:AddKeybind("ManaFlyKeyBind", {
    Title = "ManaRun Key",
    Mode = "Toggle",
    Default = "M",
})

ManaFlyToggle:OnChanged(function()
    MANAFLY = Character:GetPrimaryPartCFrame()
end)

ManaSoulKey:OnClick(function()
    Options.NoClip:SetValue(not Options.NoClip.Value)
end)

ManaFlyKey:OnClick(function()
    Options.Fly:SetValue(not Options.Fly.Value)
    MANAFLY = Character:GetPrimaryPartCFrame()
    movement_dir_z, movement_dir_x = 0, 0
    local change = (Options.MovementSpeed.Value / 100)
    if UIS:IsKeyDown(Enum.KeyCode.S) then
        movement_dir_z = movement_dir_z + change
    end
    if UIS:IsKeyDown(Enum.KeyCode.W) then
        movement_dir_z = movement_dir_z - change
    end
    if UIS:IsKeyDown(Enum.KeyCode.D) then
        movement_dir_x = movement_dir_x + change
    end
    if UIS:IsKeyDown(Enum.KeyCode.A) then
        movement_dir_x = movement_dir_x - change
    end
end)

ManaRunKey:OnClick(function()
    Options.Speed:SetValue(not Options.Speed.Value)
    movement_dir_z, movement_dir_x = 0, 0
    local change = (Options.MovementSpeed.Value / 100)
    if UIS:IsKeyDown(Enum.KeyCode.S) then
        movement_dir_z = movement_dir_z + change
    end
    if UIS:IsKeyDown(Enum.KeyCode.W) then
        movement_dir_z = movement_dir_z - change
    end
    if UIS:IsKeyDown(Enum.KeyCode.D) then
        movement_dir_x = movement_dir_x + change
    end
    if UIS:IsKeyDown(Enum.KeyCode.A) then
        movement_dir_x = movement_dir_x - change
    end
end)
getgenv().Manastuff_NoClip_EV = RunService.Stepped:Connect(function()
    if Options.NoClip.Value then
        if Character then
            for _,v in pairs(Character:GetDescendants())do
                if v:IsA("BasePart") then
                    v.CanCollide =  false
                end
            end
        end
    end
end)
function env.InputBegan_Callback(input,gameProcessed)
    
end
function env.InputEnded_Callback(input,gameProcessed)
    
end
--// Variables
local framelimit = 60
local localposition = CFrame.new()
local delta = tick()
local delta2 = tick()
local leftorright,backorforward = 0,0
local targetCF
RunService.Stepped:Connect(function()
    if Options.Fly.Value then
        if (tick()-delta) >= 1/60 then
            targetCF = workspace.CurrentCamera.CFrame
			local rx,ry,rz = targetCF:ToOrientation()
			targetCF = CFrame.new(0,0,0)*CFrame.Angles(0,ry,0) *CFrame.Angles(rx,0,0)
            MANAFLY = (CFrame.new(MANAFLY.p) * targetCF)*CFrame.new(movement_dir_x, 0, movement_dir_z)
            if Character ~= nil then
                Character:SetPrimaryPartCFrame(MANAFLY)
                Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    elseif Options.Speed.Value and Character then
        if (tick()-delta) >= 1/60 then
            delta = tick()
            targetCF = workspace.CurrentCamera.CFrame
            local rx,ry,rz = targetCF:ToOrientation()
            targetCF = (CFrame.new(Character:GetPrimaryPartCFrame().p)*CFrame.Angles(0,ry,0)) * CFrame.new(movement_dir_x, 0, movement_dir_z)
            
            if Character ~= nil then
                Character:SetPrimaryPartCFrame(targetCF)
            end
        end
    end
end)
UIS.InputBegan:Connect(function(input,gameProcessed)
    local k = input.KeyCode.Name:lower()
    if k == "w" then
        movement_dir_z = movement_dir_z - (Options.MovementSpeed.Value / 100)
    elseif k == "s" then
        movement_dir_z = movement_dir_z + (Options.MovementSpeed.Value / 100)
    elseif k == "a" then
        movement_dir_x = movement_dir_x - (Options.MovementSpeed.Value / 100)
    elseif k == "d" then
        movement_dir_x = movement_dir_x + (Options.MovementSpeed.Value / 100)
    end
    getgenv().InputBegan_Callback(input,gameProcessed)
end)
UIS.InputEnded:Connect(function(input,gameProcessed)
    local k = input.KeyCode.Name:lower()
    if k == "w" then
        movement_dir_z = movement_dir_z + (Options.MovementSpeed.Value / 100)
    elseif k == "s" then
        movement_dir_z = movement_dir_z - (Options.MovementSpeed.Value / 100)
    elseif k == "a" then
        movement_dir_x = movement_dir_x + (Options.MovementSpeed.Value / 100)
    elseif k == "d" then
        movement_dir_x = movement_dir_x - (Options.MovementSpeed.Value / 100)
    end
    getgenv().InputEnded_Callback(input,gameProcessed)
end)

Fluent:Notify({
    Title = "ManaStuff MainModule Loaded",
    Content = "The Main Script has been loaded.",
    Duration = 8
})

Fluent:Notify({
    Title = "SubModule",
    Content = "Try To Load SubModule",
    Duration = 8
})
local s, err =  pcall(function()
    local map_place_name_id = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/map.json"))
    local placename = ""
    for map_name, array_of_ids in pairs(map_place_name_id) do
        print(map_name,array_of_ids)
        if table.find(array_of_ids,tostring(game.PlaceId)) then
            placename = map_name
            break
        end
    end
    if placename ~= "" then
        sub_module_source = game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/"..placename.."_module.lua")
        local _s, sub_module_init = pcall(loadstring(sub_module_source))
        if _s then
            if sub_module_init then 
                local _s, e = pcall(sub_module_init,HttpService, RunService, UIS, Players, Fluent, Options, SaveManager, InterfaceManager, Window, Tabs, getgenv())
                if _s then
                    Fluent:Notify({
                        Title = "SubModule",
                        Content = "SubModule Has Been Loaded",
                        Duration = 8
                    })
                else
                    print(e)
                    Fluent:Notify({
                        Title = "SubModule",
                        Content = "Internal Error",
                        Duration = 8
                    })
                end
            else
                Fluent:Notify({
                    Title = "SubModule",
                    Content = "Missing Init Function",
                    Duration = 8
                })
            end
        else
            print(sub_module_init)
        end
    else
        Fluent:Notify({
            Title = "SubModule",
            Content = "No SubModule Has Been Found For This Place",
            SubContent = "PlaceID: "..tostring(game.PlaceId),
            Duration = 8
        })
    end
end)
if not s then
    print(err)
    Fluent:Notify({
        Title = "SubModule",
        Content = "Failed To Load SubModule",
        SubContent = err,
        Duration = 8
    })
end
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Manastuff Hub")
SaveManager:SetFolder("Manastuff Hub/"..tostring(game.PlaceId))

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
