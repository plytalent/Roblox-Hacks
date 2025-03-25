local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootpart = Character.HumanoidRootPart
local cf_of_hrp = CFrame.new()
LocalPlayer.CharacterAdded:Connect(function(newcharacter)
    Character = newcharacter
    while Character.PrimaryPart == nil do
        RunService.Stepped:Wait()
    end
    cf_of_hrp = Character:GetPrimaryPartCFrame()
    rootpart = Character.HumanoidRootPart
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local getgenv = getgenv or function() if not _G.getgenv then print("Create getgenv Tables")_G.getgenv = {} end return _G.getgenv end
local env = getgenv()
local Drawing_Exist = pcall(function() Drawing.new("Text"):Remove() end)
function worldpoint_to_viewpoint(pos)
    local pos, in_fov = workspace.CurrentCamera:WorldToViewportPoint(pos)
    return {Vector2.new(pos.X,pos.Y),in_fov}
end
if Drawing_Exist then
    function synTextLabel()
        if not env._Drawing then
            env._Drawing = {}
        end
        local TextLabel = Drawing.new("Text")
        env._Drawing[#env._Drawing+1] = TextLabel
        TextLabel.Text = "Place"
        TextLabel.Size = 24
        TextLabel.Center = true
        TextLabel.Outline = true
        TextLabel.Color = Color3.new(255/255, 0/255, 0/255)
        TextLabel.OutlineColor = Color3.new(0, 0, 0)
        return TextLabel
    end
    local Visualize = env.Visualize
    env.Enable_Visualize = false
    if not Visualize then 
        Visualize = synTextLabel()
        env.Visualize = Visualize
    else
        RunService:UnbindFromRenderStep("Visualize CF_hrp_point")
    end     
    RunService:BindToRenderStep("Visualize CF_hrp_point", 0,function()
        local cf_p = cf_of_hrp.p
        local point_fov = worldpoint_to_viewpoint(cf_p)
        Visualize.Text = string.format("Current Point: [X: %.2f][Y: %.2f][Z: %.2f]",cf_p.X,cf_p.Y,cf_p.Z)
        Visualize.Position = pos_and_infov[1]
        Visualize.Visible = in_fov[2] and env.Enable_Visualize
    end)
else
    function synTextLabel()
        if not env._Drawing then
            env._Drawing = {}
        end
        local TextLabel = {}
        env._Drawing[#env._Drawing+1] = TextLabel
        TextLabel.Text = "Place"
        TextLabel.Size = 24
        TextLabel.Center = true
        TextLabel.Outline = true
        TextLabel.Color = Color3.new(255/255, 0/255, 0/255)
        TextLabel.OutlineColor = Color3.new(0, 0, 0)
        return TextLabel
    end
end
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

local MovementModeDropdown = Tabs.Main:AddDropdown("MovementMode",
    Title = "ManaFly/Run Type",
    Values = {"Positioning", "Velocity"},
    Default = {"Positioning"},
)
MovementModeDropdown:OnChanged(function(Value)
    env.MovementMode = Value
end)

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
    if Character.PrimaryPart then
        cf_of_hrp = Character:GetPrimaryPartCFrame()
    end
end)

ManaSoulKey:OnClick(function()
    Options.NoClip:SetValue(not Options.NoClip.Value)
end)

ManaFlyKey:OnClick(function()
    Options.Fly:SetValue(not Options.Fly.Value)
    if Character.PrimaryPart then
        cf_of_hrp = Character:GetPrimaryPartCFrame()
    end
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
    --// dummy Function
end
function env.InputEnded_Callback(input,gameProcessed)
    --// dummy Function
end
--// Variables
local delta = tick()
local leftorright,backorforward = 0,0
local targetCF
local anti_grav = 2.9
RunService.Stepped:Connect(function()
	local _delta = tick()-delta
	delta = tick()
	if math.abs((cf_of_hrp.Position.Y+1.45) - rootpart.Position.Y) > 0.0001 then
		print((cf_of_hrp.Position.Y+1.45) - rootpart.Position.Y)
		anti_grav = (cf_of_hrp.Position.Y+1.45) - rootpart.Position.Y
	end
	if _delta >= (1/60)*0.99 or env.MovementMode == "Velocity" then
		if Options.Fly.Value or Options.Speed.Value then
			local rx,ry,rz = workspace.CurrentCamera.CFrame:ToOrientation()
			targetCF = CFrame.new(0,0,0)*CFrame.Angles(0,ry,0)
			if Options.Fly.Value then
				targetCF = targetCF * CFrame.Angles(rx,0,0)
			end
			if Options.Speed.Value and env.MovementMode == "Positioning" and Character.PrimaryPart then
				cf_of_hrp = Character:GetPrimaryPartCFrame()
			end
			cf_of_hrp = (CFrame.new(cf_of_hrp.p) * targetCF)*CFrame.new(movement_dir_x, 0, movement_dir_z)
			if Character ~= nil then
				if env.MovementMode == "Positioning" and Character.PrimaryPart then
					Character:SetPrimaryPartCFrame(cf_of_hrp)
					if Options.Fly.Value then
						rootpart.Velocity = Vector3.new(0,0,0)
					end
				elseif env.MovementMode == "Velocity" then
					local Intensity = (rootpart.Position - cf_of_hrp.Position).Magnitude
					local lk = Vector3.new(0,0,0)
					if Intensity < 10 then
						lk = (cf_of_hrp.Position - rootpart.Position).Unit*(Intensity*10)
					else
						lk = (cf_of_hrp.Position - rootpart.Position).Unit*(Intensity*Intensity)
					end
					
					local target_velocity = lk
					local yv = target_velocity.Y + anti_grav
					if Options.Speed.Value then
						yv = rootpart.Velocity.y
					end
					rootpart.Velocity = Vector3.new(target_velocity.X, yv , target_velocity.Z)
				end
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
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Manastuff Hub")
SaveManager:SetFolder("Manastuff Hub/"..tostring(game.PlaceId))
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
