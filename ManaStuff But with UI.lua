local Config = {
	WindowName = "RubyTheSilent Hub [Universal]",
	Color = Color3.fromRGB(255,128,64),
}

if game.PlaceId == 8619263259 then
	Config.WindowName = "RubyTheSilent Hub [Critical Legends]"
end

local Label_config = {
	ManaSoul = "Mana Soul",
	ManaRun = "Mana Run",
	ManaFly = "Mana Fly",
	Movement = "Movement",
	Player = "Player"
}
local variables = {
	manarunspeed = 2.75,
	manaflyspeed = 2.75,
	camspeed = 2.75,
	aladin_carpet_offset = 5,
}
local Keybinds = {
	OpenUIKeyBind = Enum.KeyCode.LeftAlt.Name
}
if isfile then
	if isfile("ManaStuff UI Labels.properties") then
		local content = readfile("ManaStuff UI Labels.properties")
		if content ~= "" then
			local lines = content:split("\n")
			for i=1,#lines do
				local index_and_value = lines[i]:split("=")
				Label_config[index_and_value[1]] = index_and_value[2]
			end
		end
	end
end
if isfile then
	if isfile("ManaStuff UI Variables.properties") then
		local content = readfile("ManaStuff UI Variables.properties")
		if content ~= "" then
			local lines = content:split("\n")
			for i=1,#lines do
				if lines[i] and lines[i] ~= "" then
					local index_and_typeandvalue = lines[i]:split("=")
					local typeandvalue = index_and_typeandvalue[2]:split(":")
					local tofuncs = {
						["string"] = tostring,
						["number"] = tonumber
					}
					variables[index_and_typeandvalue[1]] = tofuncs[typeandvalue[1]](typeandvalue[2])
				end
			end
		end
	end
end
if isfile then
	if isfile("ManaStuff UI Keybinds.properties") then
		local content = readfile("ManaStuff UI Keybinds.properties")
		if content ~= "" then
			local lines = content:split("\n")
			for i=1,#lines do
				local index_and_value = lines[i]:split("=")
				Keybinds[index_and_value[1]] = index_and_value[2]
			end
		end
	end
end

local Playerobj = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local vu = game:GetService("VirtualUser")

local cf_character_update = CFrame.new()
local currentcam_rotation_x, currentcam_rotation_y = 0, 0
local Part
local camfc
function create_aladin_carpet()
	Part = Instance.new("Part",workspace)
	Part.Name = "Floatly"
	Part.Position = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(0,game:GetService("Players").LocalPlayer.Character["Left Leg"].Size.Y+2,0)
	Part.Size = Vector3.new(10,0,10)
	Part.Anchored = true
end
--==================================[[AFHB]]==================================--
local frame = 1 / 60
local allowframeloss = false
local tossremainder = false
local AFHB_Module = function()
	local ArtificialHB = Instance.new("BindableEvent")
	local tf = 0	
	local lastframe = tick()
	local lasttick = tick()
	RunService.Stepped:Connect(function()
	    local rounddelta = tick() - lasttick
	    lasttick = tick()
		tf = tf + rounddelta
		if tf >= frame then
		    local delta = tick() - lastframe
			if allowframeloss then
				ArtificialHB:Fire(delta)
				lastframe = tick()
			else
				for i = 1, math.floor(tf / frame) do
				    local delta = tick() - lastframe
					ArtificialHB:Fire(delta)
					lastframe = tick()
				end
				lastframe = tick()
			end
			if tossremainder then
				tf = 0
			else
				tf = tf - frame * math.floor(tf / frame)
			end
		end
	end)
	RunService.RenderStepped:Connect(function()
	    local rounddelta = tick() - lasttick
	    lasttick = tick()
		tf = tf + rounddelta
		if tf >= frame then
		    local delta = tick() - lastframe
			if allowframeloss then
				ArtificialHB:Fire(delta)
				lastframe = tick()
			else
				for i = 1, math.floor(tf / frame) do
				    local delta = tick() - lastframe
					ArtificialHB:Fire(delta)
					lastframe = tick()
				end
				lastframe = tick()
			end
			if tossremainder then
				tf = 0
			else
				tf = tf - frame * math.floor(tf / frame)
			end
		end
	end)
	RunService.Heartbeat:Connect(function()
	    local rounddelta = tick() - lasttick
	    lasttick = tick()
		tf = tf + rounddelta
		if tf >= frame then
		    local delta = tick() - lastframe
			if allowframeloss then
				ArtificialHB:Fire(delta)
				lastframe = tick()
			else
				for i = 1, math.floor(tf / frame) do
				    local delta = tick() - lastframe
					ArtificialHB:Fire(delta)
					lastframe = tick()
				end
				lastframe = tick()
			end
			if tossremainder then
				tf = 0
			else
				tf = tf - frame * math.floor(tf / frame)
			end
		end
	end)
	ArtificialHB.Name = "ArtificialHeartbeat"
	return ArtificialHB
end
--==================================[[AFHB]]==================================--

function fill_decimal(string_decimal)
	local numbers = string_decimal:split(".")
	if #numbers == 2 then
		if numbers[2]:len() ~= 2 then
			if numbers[2]:len() > 2 then
				numbers[2] = numbers[2]:sub(1,2)
			else
				local newdecimal = ""
				while numbers[2]:len() < 2 do
					newdecimal = newdecimal .. numbers[2] .. "0"
				end
			end
		end
		return numbers[1] .. "." .. numbers[2]
	end
	return "00.00"
end

local ArtificialHB = AFHB_Module()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()

local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))
Window:Toggle(false)

local Tab1 = Window:CreateTab("Main")
local CEV = Window:CreateTab("Artificial Heartbeat Settings")
local Tab2 = Window:CreateTab("UI Settings")

local movement = Tab1:CreateSection(Label_config.Movement)
local player = Tab1:CreateSection(Label_config.Player)
local Event = CEV:CreateSection("Artificial Heartbeat")
local UI_1 = Tab2:CreateSection("Menu")
local UI_2 = Tab2:CreateSection("Background")

local ManaRun = movement:CreateToggle(Label_config.ManaRun, false, function()
	if Playerobj.Character then
		cf_character_update = Playerobj.Character:GetPrimaryPartCFrame()
	end
end)
local ManaFly = movement:CreateToggle(Label_config.ManaFly, false, function()
	if Playerobj.Character then
		cf_character_update = Playerobj.Character:GetPrimaryPartCFrame()
	end
end)
local ManaSoul = player:CreateToggle(Label_config.ManaSoul, false, function()end)
local Anti_AFK = player:CreateToggle("Anti-AFK", true, function()end)
Playerobj.Idled:Connect(function()
	if Anti_AFK:GetState() then
    	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		printconsole("Mouse Hold Down!")
		local starttick = tick()
		local current_tick = 0
    	while current_tick >= 1 do
			current_tick = tick() - starttick
			ArtificialHB.Event:Wait()
		end
    	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		printconsole("Mouse Released!")
	end
end)
local observe = player:CreateToggle("Observe", false, function(State)
	camfc = workspace.CurrentCamera.CFrame
	currentcam_rotation_x, currentcam_rotation_y = 0, 0
	local PlayerModule = require(Playerobj.PlayerScripts:WaitForChild("PlayerModule"))
	local Controls = PlayerModule:GetControls()
	if not State then
		Controls:Enable()
	else
		Controls:Disable()
	end
end)
local aladin_carpet = player:CreateToggle("Aladin Carpet", false, function()end)
ManaSoul:CreateKeybind(Enum.KeyCode.P.Name)
ManaFly:CreateKeybind(Enum.KeyCode.K.Name)
ManaRun:CreateKeybind(Enum.KeyCode.M.Name)
local Toggle4 = UI_1:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)

local Toggle7 = UI_1:CreateToggle("TASTE THE RAINBOW", nil, function(State)
	if State then
		Window:ChangeColor(Config.Color)
	end
end)
Toggle4:CreateKeybind(Keybinds.OpenUIKeyBind, function(Key)
	Keybinds.OpenUIKeyBind = Enum.KeyCode[Key].Name
end)
local Slider1 = movement:CreateSlider(Label_config.ManaRun.." Multiplier", 0, 300, variables.manarunspeed*100, false, function(x)
	variables.manarunspeed = (x/100)
	if x == 0 then
		variables.manarunspeed = 0
	end
end)
local Slider2 = movement:CreateSlider(Label_config.ManaFly.." Multiplier", 0, 300, variables.manaflyspeed*100, false, function(x)
	variables.manaflyspeed = (x/100)
	if x == 0 then
		variables.manaflyspeed = 0
	end
end)
local Slider2 = player:CreateSlider("Observe Speed Multiplier", 0, 300, variables.camspeed*100, false, function(x)
	variables.camspeed = (x/100)
	if x == 0 then
		variables.camspeed = 0
	end
end)
local Slider2 = player:CreateSlider("Aladin Carpet Offset", -10, 10, variables.aladin_carpet_offset, false, function(x)
	variables.aladin_carpet_offset = x
end)
local Colorpicker3 = UI_1:CreateColorpicker("UI Color", function(Color)
	Config.Color = Color
	Window:ChangeColor(Color)
end)
-- credits to jan for patterns
local Dropdown3 = UI_2:CreateDropdown("Image", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name)
	if Name == "Default" then
		Window:SetBackground("2151741365")
	elseif Name == "Hearts" then
		Window:SetBackground("6073763717")
	elseif Name == "Abstract" then
		Window:SetBackground("6073743871")
	elseif Name == "Hexagon" then
		Window:SetBackground("6073628839")
	elseif Name == "Circles" then
		Window:SetBackground("6071579801")
	elseif Name == "Lace With Flowers" then
		Window:SetBackground("6071575925")
	elseif Name == "Floral" then
		Window:SetBackground("5553946656")
	end
end)
local Warning = Event:CreateLabel("WARN: DO NOT ENABLE Toss Remainder")
local Label1 = Event:CreateLabel("Current Event Frame")
local Label2 = Event:CreateLabel("Current Event Frame Time: -NaN(%ind) ms")
local Slider5 = Event:CreateSlider("Event Frame Time",1,200,60,false, function(Value)
	frame = 1/Value
	local stringtime = fill_decimal(string.format("%.2f",(frame*1000)))
	Label2:UpdateText(string.format("Current Event Frame Time: %s ms",stringtime))
end)
local Toggle5 = Event:CreateToggle("Allow Frame Lost", false, function(State)
	allowframeloss = State
end)
local Toggle6 = Event:CreateToggle("Toss Remaind Frame Time", false, function(State)
	tossremainder = State
end)
local Colorpicker4 = UI_2:CreateColorpicker("Color", function(Color)
	Window:SetBackgroundColor(Color)
end)
local Slider3 = UI_2:CreateSlider("Transparency",0,1,0,false, function(Value)
	Window:SetBackgroundTransparency(Value)
end)
local Slider4 = UI_2:CreateSlider("Tile Scale",0,1,1,false, function(Value)
	Window:SetTileScale(Value)
end)
local SaveButton = UI_2:CreateButton("Save Variables Values", function()
	if writefile then
		local new_file_content = ""
		local new_keybind_file_content = ""
		for index, value in pairs(variables) do
			new_file_content = string.format("%s\n%s=%s:%s",new_file_content,index,typeof(value),tostring(value))
		end
		for index, value in pairs(Keybinds) do
			new_keybind_file_content = string.format("%s\n%s=%s",new_keybind_file_content,index,tostring(value))
		end
		writefile("ManaStuff UI Variables.properties",new_file_content)
	end
end)
RunService.Stepped:Connect(function()
	if ManaSoul:GetState() then
		local Character = Playerobj.Character
        if Character then
		    for _,v in pairs(Character:GetDescendants())do
		    	if v:IsA("BasePart") then
		    		v.CanCollide =  false
		    	end
		    end
        end
	end
end)

RunService:BindToRenderStep("Update Camera",Enum.RenderPriority.Camera.Value+1,function()
	if observe:GetState() then
		local leftorright,upordown,backorforward = 0,0,0
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			backorforward = backorforward + variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			backorforward = backorforward - variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			leftorright = leftorright + variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			leftorright = leftorright - variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.Q) then
			upordown = upordown + variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.E) then
			upordown = upordown - variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.R) then
			currentcam_rotation_x = currentcam_rotation_x + variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.T) then
			currentcam_rotation_x = currentcam_rotation_x - variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.F) then
			currentcam_rotation_y = currentcam_rotation_y + variables.camspeed
		end
		if UIS:IsKeyDown(Enum.KeyCode.G) then
			currentcam_rotation_y = currentcam_rotation_y - variables.camspeed
		end
		camfc = CFrame.new(camfc * CFrame.new(leftorright,upordown,backorforward).Position) * CFrame.Angles(0,math.rad(currentcam_rotation_y),0) * CFrame.Angles(math.rad(currentcam_rotation_x),0,0)
		workspace.CurrentCamera.CFrame = camfc
	end
end)

RunService:BindToRenderStep("Update UI",1,function()
	if Toggle7:GetState() then
		Window:ChangeColor(Color3.fromHSV(tick() * 128 % 255/255, 1, 0.75))
		Window:SetBackgroundColor(Color3.fromHSV(tick() * 128 % 255/255, 1, 0.5))
	elseif Toggle7:GetState() == false then
		Window:ChangeColor(Config.Color)
	end
	if ManaFly:GetState() then
		local Character = Playerobj.Character
		if game.PlaceId == 4691401390 then
			if workspace:FindFirstChild'Players' then
				Character = workspace.Players:FindFirstChild(Playerobj.Name);
			end
		end
        if Character ~= nil then
			if Character.PrimaryPart then
            	Character:SetPrimaryPartCFrame(cf_character_update)
				Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
			end
		end
	end
end)
ArtificialHB.Event:Connect(function(d)
	Label1:UpdateText(string.format("Frame:%s",fill_decimal(string.format("%.2f",1/d))))
	if ManaFly:GetState() then
		local Character = Playerobj.Character
		if game.PlaceId == 4691401390 then
			if workspace:FindFirstChild'Players' then
				Character = workspace.Players:FindFirstChild(Playerobj.Name);
			end
		end
        if Character ~= nil then
			if Character:FindFirstChild("HumanoidRootPart") then
				local leftorright,backorforward = 0,0
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					backorforward = backorforward + variables.manaflyspeed
				end
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					backorforward = backorforward - variables.manaflyspeed
				end
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					leftorright = leftorright + variables.manaflyspeed
				end
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					leftorright = leftorright - variables.manaflyspeed
				end
				local targetCF = workspace.CurrentCamera.CFrame
				local rx,ry,_ = targetCF:ToOrientation()
				targetCF = CFrame.new(0,0,0)*CFrame.Angles(0,ry,0) *CFrame.Angles(rx,0,0)
            	cf_character_update = (CFrame.new(cf_character_update.Position) * targetCF)*CFrame.new(leftorright,0,backorforward)
			end
		end
	elseif ManaRun:GetState() then
		local Character = Playerobj.Character
		if game.PlaceId == 4691401390 then
			if workspace:FindFirstChild'Players' then
				Character = workspace.Players:FindFirstChild(Player.Name);
			end
		end
		if Character then
			local leftorright,backorforward = 0,0
        	if UIS:IsKeyDown(Enum.KeyCode.S) then
        	    backorforward = backorforward + variables.manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.W) then
        	    backorforward = backorforward - variables.manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.D) then
        	    leftorright = leftorright + variables.manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.A) then
        	    leftorright = leftorright - variables.manarunspeed
        	end
			local targetCF = workspace.CurrentCamera.CFrame
			local _, ry, _ = targetCF:ToOrientation()
			if Character.PrimaryPart then
				if aladin_carpet:GetState() then
					Part.CFrame = (CFrame.new(Character:GetPrimaryPartCFrame().Position)*CFrame.Angles(0,ry,0)) * CFrame.new(leftorright,0,backorforward)
				end
				Character:SetPrimaryPartCFrame((CFrame.new(Character:GetPrimaryPartCFrame().Position)*CFrame.Angles(0,ry,0)) * CFrame.new(leftorright,0,backorforward))
			end
		end
	end
	if aladin_carpet:GetState() then
		if not Part then
			create_aladin_carpet()
		end
		if not Part.Parent then
			create_aladin_carpet()
		end
		Part.Name = "Floatly"
		Part.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-variables.aladin_carpet_offset,0)
		Part.Size = Vector3.new(10,0,10)
		Part.Anchored = true
	end
end)

function tablefind(tb,value)
	for _,v in pairs(tb) do
		if v == value then
			return true
		end
	end
	return false
end
if game.PlaceId == 8619263259 then
	local target = nil
	local targets = {}
	if not variables.safe_offset_cf_x then
		variables.safe_offset_cf_x = 0
	end
	if not variables.safe_offset_cf_y then
		variables.safe_offset_cf_y = 85
	end
	if not variables.safe_offset_cf_z then
		variables.safe_offset_cf_z = 0
	end
	for _,zone in pairs(workspace.Enemies:GetChildren()) do
		for _, enemy in pairs(zone:GetChildren()) do
			if enemy:IsA("Model") and enemy:FindFirstChild("Model") then
				if not tablefind(targets,enemy.Model.Value.Name) then
					targets[#targets+1] = enemy.Model.Value.Name
				end
			end
		end
	end
	table.sort(targets)
	local Critical_Legends_Tab = Window:CreateTab("Critical Legends")
	local AutoFarmSection = Critical_Legends_Tab:CreateSection("Auto Farm")
	local TargetHealth = AutoFarmSection:CreateLabel("Target Health: 0/0")
	local Slider6 = AutoFarmSection:CreateSlider("OffsetX", -150, 150, variables.safe_offset_cf_x, false, function(Value)
		variables.safe_offset_cf_x = Value
	end)
	local Slider7 = AutoFarmSection:CreateSlider("OffsetY", -150, 150, variables.safe_offset_cf_y, false, function(Value)
		variables.safe_offset_cf_y = Value
	end)
	local Slider8 = AutoFarmSection:CreateSlider("OffsetZ", -150, 150, variables.safe_offset_cf_z, false, function(Value)
		variables.safe_offset_cf_z = Value
	end)
	local AutoFarm_Toggle = AutoFarmSection:CreateToggle("AutoFarm", false,function()end)
	local AutoOrb_Toggle = AutoFarmSection:CreateToggle("AutoOrb", false,function()end)
	local Dropdown = AutoFarmSection:CreateDropdown("Targets", targets, function(Name)
		for _, model in pairs(workspace.Enemies:GetDescendants()) do
			if model:IsA("ObjectValue") then
				if model.Value.Name == Name then
					target = model.Parent
				end
			end
		end
	end)
	ArtificialHB.Event:Connect(function()
		if AutoOrb_Toggle:GetState() or AutoFarm_Toggle:GetState() then
			if workspace:FindFirstChild("CombatFolder") then
				if workspace.CombatFolder:FindFirstChild(Playerobj.Name) then
					if Playerobj.Character:FindFirstChild("Combat Border") then
						Playerobj.Character["Combat Border"]:Destroy()
					end
					local models = workspace.CombatFolder[Playerobj.Name]:GetChildren()
					if #models > 0 then
						for i=1, 128 do
							coroutine.resume(coroutine.create(function()
								local index = i
								local s,err = pcall(function()
									if models[index] then
										if models[index]:FindFirstChild("Base") then
											local part = models[index].Base
											firetouchinterest(part,Playerobj.Character.HumanoidRootPart,1)
											firetouchinterest(part,Playerobj.Character.HumanoidRootPart,0)
										end
									end
								end)
								if not s then
									rconsoleerror(err)
								end
							end))
						end
					end
				end
			end
		end
		if AutoFarm_Toggle:GetState() then
			if target then
				local CBF = workspace:FindFirstChild("CombatFolder")
				if CBF then
					if CBF:FindFirstChild("Owner") then
						if CBF.Owner.Value then
							if CBF.Owner.Value:FindFirstChild("Health") then
								TargetHealth:UpdateText(string.format("Target Health: %.2f/%.2f", CBF.Owner.Value.Health.Value, CBF.Owner.Value.MaxHealth.Value))
							end
						end
					else
						TargetHealth:UpdateText(string.format("Target Health: 0/0"))
					end
					if CBF:FindFirstChild(Playerobj.Name) then
						Playerobj.Character.HumanoidRootPart.CFrame = target.EnemyLocation.CFrame * CFrame.new(variables.safe_offset_cf_x, variables.safe_offset_cf_y, variables.safe_offset_cf_z)
						Playerobj.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
						Playerobj.Character.HumanoidRootPart.Anchored = false
					else
						Playerobj.Character.HumanoidRootPart.CFrame = target.EnemyLocation.CFrame * CFrame.new(0,10,0)
						Playerobj.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
						Playerobj.Character.HumanoidRootPart.Anchored = false
					end
				else
					Playerobj.Character.HumanoidRootPart.CFrame = target.EnemyLocation.CFrame * CFrame.new(0,10,0)
					Playerobj.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
					Playerobj.Character.HumanoidRootPart.Anchored = false
				end
			end
		end
	end)
end
Colorpicker3:UpdateColor(Config.Color)
Dropdown3:SetOption("Abstract")
Colorpicker4:UpdateColor(Color3.new(1,1,1))
ArtificialHB:Fire(0)
ArtificialHB.Event:Wait()
Toggle4:SetState(true)
