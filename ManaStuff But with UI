local Config = {
    WindowName = "RubyTheSilent Hub [Universal]",
	Color = Color3.fromRGB(255,128,64),
	Keybind = Enum.KeyCode.RightShift
}

local Label_config = {
	ManaSoul = "Mana Soul",
	ManaRun = "Mana Run",
	ManaFly = "Mana Fly",
	Movement = "Movement",
	Player = "Player"
}

local Playerobj = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local manaflypos = nil
--==================================[[AFHB]]==================================--
local frame = 1 / 60
local allowframeloss = false
local tossremainder = false
local AFHB_Module = function()
	local ArtificialHB = Instance.new("BindableEvent")
	local tf = 0	
	local lastframe = tick()
	local lasttick = tick()
	game:GetService("RunService").Stepped:Connect(function()
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
	game:GetService("RunService").RenderStepped:Connect(function()
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
	game:GetService("RunService").Heartbeat:Connect(function()
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

local ArtificialHB = AFHB_Module()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local Tab1 = Window:CreateTab("Main")
local CEV = Window:CreateTab("Artificial Heartbeat Settings")
local Tab2 = Window:CreateTab("UI Settings")

local movement = Tab1:CreateSection(Label_config.Movement)
local player = Tab1:CreateSection(Label_config.Player)

local Event = CEV:CreateSection("Artificial Heartbeat")

local UI_1 = Tab2:CreateSection("Menu")
local UI_2 = Tab2:CreateSection("Background")

local manarunspeed = 2.75
local manaflyspeed = 2.75

local ManaRun = movement:CreateToggle(Label_config.ManaRun, false, function(State)
end)
local ManaFly = movement:CreateToggle(Label_config.ManaFly, false, function(State)
	if Playerobj.Character then
		manaflypos = Playerobj.Character:GetPrimaryPartCFrame()
	end
end)
local ManaSoul = player:CreateToggle(Label_config.ManaSoul, false, function(State)
end)
Window:Toggle(false)
local Toggle4 = UI_1:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)
local Toggle7 = UI_1:CreateToggle("TASTE THE RAINBOW", nil, function(State)
end)
Toggle4:CreateKeybind(Config.Keybind.Name, function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)

local Slider1 = movement:CreateSlider(Label_config.ManaRun.." Multiplier", 0, 100, manarunspeed, false, function(x)
	manarunspeed = (x/100)*30
	if x == 0 then
		manarunspeed = 0
	end
end)

local Slider2 = movement:CreateSlider(Label_config.ManaFly.." Multiplier", 0, 100, manaflyspeed, false, function(x)
	manaflyspeed = (x/100)*30
	if x == 0 then
		manaflyspeed = 0
	end
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
local Slider4 = UI_2:CreateSlider("Tile Scale",0,1,0.5,false, function(Value)
	Window:SetTileScale(Value)
end)
game:GetService("RunService").Stepped:Connect(function()
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
game:GetService("RunService"):BindToRenderStep("Update UI",1,function()
	if Toggle7:GetState() then
		Window:ChangeColor(Color3.fromHSV(tick() * 128 % 255/255, 1, 0.75))
		Window:SetBackgroundColor(Color3.fromHSV(tick() * 128 % 255/255, 1, 0.5))
	else
		Window:ChangeColor(Config.Color)
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
			local leftorright,backorforward = 0,0
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				backorforward = backorforward + manaflyspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.W) then
				backorforward = backorforward - manaflyspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				leftorright = leftorright + manaflyspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				leftorright = leftorright - manaflyspeed
			end

			local targetCF = workspace.CurrentCamera.CFrame
			local rx,ry,_ = targetCF:ToOrientation()
			targetCF = CFrame.new(0,0,0)*CFrame.Angles(0,ry,0) *CFrame.Angles(rx,0,0)
            manaflypos = (CFrame.new(manaflypos.p) * targetCF)*CFrame.new(leftorright,0,backorforward)
            Character:SetPrimaryPartCFrame(manaflypos)
            Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
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
        	    backorforward = backorforward + manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.W) then
        	    backorforward = backorforward - manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.D) then
        	    leftorright = leftorright + manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.A) then
        	    leftorright = leftorright - manarunspeed
        	end
			targetCF = workspace.CurrentCamera.CFrame
			local _, ry, _ = targetCF:ToOrientation()
			targetCF = (CFrame.new(Character:GetPrimaryPartCFrame().p)*CFrame.Angles(0,ry,0)) * CFrame.new(leftorright,0,backorforward)
			Character:SetPrimaryPartCFrame(targetCF)
		end
	end
end)

Colorpicker3:UpdateColor(Config.Color)
Dropdown3:SetOption("Default")
Colorpicker4:UpdateColor(Color3.new(1,1,1))

ArtificialHB:Fire(0)
ArtificialHB.Event:Wait()
Toggle4:SetState(true)
