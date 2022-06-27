local DrawUI = loadstring(game:HttpGet("https://pastebin.com/raw/yUiWjGmT"))()
local httpservice = game:GetService("HttpService")
local speedlabel = DrawUI:synTextLabel()
DrawUI:MakeDraggable(speedlabel)
if not _G.ArtificialHB then
    _G.ArtificialHB = Instance.new("BindableEvent")
end
_G.ArtificialHB.Name = "ArtificialHeartbeat"

local frame = 1 / 60
local tf = 0
local allowframeloss = false
local tossremainder = false
local lastframe = tick()

_G.ArtificialHB:Fire()

if _G.Render then
   _G.Render:Disconnect() 
end
local laststeptick = tick()
_G.Render = game:GetService("RunService").Stepped:connect(function(s)
    local steppeddelta = tick() - laststeptick
    laststeptick = tick()
	tf = tf + steppeddelta
	if tf >= frame then
	    local delta = tick() - lastframe
		if allowframeloss then
			_G.ArtificialHB:Fire(delta)
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do
			    local delta = tick() - lastframe
				_G.ArtificialHB:Fire(delta)
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
local UnderCover = false
local readf = function(fname)
	if readfile then
		if isfile then
			if isfile(fname) then
				return readfile(fname)
			end
		end
	end
	return ""
end
local writef = writefile or function() end
local protective_call_wrapper = function(real, err)
    local err = err or rconsoleinfo
    if typeof(err) == "function" then
        err = rconsoleinfo
    end
    if type(real) == "function" then
        local fake = function(...)
            local args = {...}
            local s,e_res = pcall(function()
                return {real(unpack(args))}
            end)
            if not s then
                if err then
                    err("ERROR: "..tostring(e_res)) -- EXTERNAL CONSOLE
                end
            else
                return unpack(e_res)
            end
        end
        return fake
    end
    return real
end
local config = {
	["NoClip"]={
		Options = {
			Enabled = false
		}
	},
	["ManaRun"]={
		Options = {
			Enabled = false,
			speed = 2.75,
		}
	},
	["ManaFly"] = {
		Options = {
			Enabled = false,
			speed = 0,
		}
	},
	["NoFall"] = {
		Options = {
			Enabled = false,
			speed = 0,
			CFrameOffset = 3.5,
		}
	}
}
local json_data = readf("ManaStuff.Json")
if json_data ~= "" then
	config = httpservice:JSONDecode(json_data)
else
	local JSONData = httpservice:JSONEncode(config)
	writef("ManaStuff.Json", JSONData)
end

local Noclip = (function()
	--// Variables
	local module = {}
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local MANAFLY = nil
	module = config.NoClip
	function module:Enable()
		module.Options.Enabled = true
	end
	function module:Disable()
		module.Options.Enabled = false
        Player.Character.HumanoidRootPart.CanCollide=true
	end
	RunService.Stepped:Connect(function()
		if module.Options.Enabled then
			local Character = Player.Character
            if Character then
			    for _,v in pairs(Character:GetDescendants())do
			    	if v:IsA("BasePart") then
			    		v.CanCollide =  false
			    	end
			    end
            end
		end
	end)
	return module
end)()

local ManaRun= (function()
	--// Variables
	local module = {}
	local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
    local framelimit = 60
    local localposition = CFrame.new()
    local delta = tick()
    local delta2 = tick()
	local leftorright,backorforward = 0,0
    local targetCF 
	module = config.ManaRun
	function module:Enable()
		module.Options.Enabled = true
		leftorright,backorforward = 0,0
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            backorforward = backorforward + module.Options.speed
        end
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            backorforward = backorforward - module.Options.speed
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            leftorright = leftorright + module.Options.speed
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            leftorright = leftorright - module.Options.speed
        end
	end
	function module:Disable()
		module.Options.Enabled = false
		leftorright, backorforward = 0,0
	end
    function module:SpeedChange()
        if leftorright ~= 0 then
            if leftorright > 0 then
                leftorright = module.Options.speed
            else
                leftorright = -module.Options.speed
            end
        end
        if backorforward ~= 0 then
            if backorforward > 0 then
                backorforward = module.Options.speed
            else
                backorforward = -module.Options.speed
            end
        end
    end
	_G.ArtificialHB.Event:Connect(function()
		local Character = Player.Character
		if game.PlaceId == 4691401390 then
			if workspace:FindFirstChild'Players' then
				Character = workspace.Players:FindFirstChild(Player.Name);
			end
		end
		if module.Options.Enabled and Character then
            if (tick()-delta) >= 1/60 then
                delta = tick()
			    targetCF = workspace.CurrentCamera.CFrame
			    local rx,ry,rz = targetCF:ToOrientation()
			    targetCF = (CFrame.new(Character:GetPrimaryPartCFrame().p)*CFrame.Angles(0,ry,0)) * CFrame.new(leftorright,0,backorforward)
			    Character:SetPrimaryPartCFrame(targetCF)
            end
		end
	end)
	Player:GetMouse().KeyDown:Connect(function(k)
		if k == "w" then
			backorforward = backorforward - module.Options.speed
		elseif k == "s" then
			backorforward = backorforward + module.Options.speed
		elseif k == "a" then
			leftorright = leftorright - module.Options.speed
		elseif k == "d" then
			leftorright = leftorright + module.Options.speed
		end
	end)
	Player:GetMouse().KeyUp:Connect(function(k)
		if k == "w" then
			backorforward = backorforward + module.Options.speed
		elseif k == "s" then
			backorforward = backorforward - module.Options.speed
		elseif k == "a" then
			leftorright = leftorright + module.Options.speed
		elseif k == "d" then
			leftorright = leftorright - module.Options.speed
		end
	end)
	return module
end)()
local NOFALL
if game.PlaceId == 6032399813 or game.PlaceId == 5735553160 or game.PlaceId == 8668476218 then
	--[[
	NOFALL = (function()
		module = config.NoFall
		module.original = nil
		module.original = nil
		module.newnamecall = newcclosure(function(remote, ...)
			if typeof(remote) == "Instance" then
				local args = { ... }
				local methodName = getnamecallmethod()
				local validInstance, remoteName = pcall(function()
					return remote.Name
				end)
		        local vaildparent, parent = pcall(function()
		            return remote.Parent
		        end)
				if module.Options.Enabled and (validInstance and (methodName == "FireServer" or methodName == "fireServer") and (vaildparent and remoteName:find("ArchMageOwO") and #args == 2 and typeof(args[1]) == "number" and typeof(args[2]) == "boolean" )) then
					return nil
				else
					return original(remote, ...)
				end
			end
			return original(remote, ...)
		end, module.original)
		module.oldNamecall = hookmetamethod(game, "__namecall", module.newnamecall)
		

		module.original = module.original or function(...)
			return oldNamecall(...)
		end
		module.newnamecall = newcclosure(function(remote, ...)
		    if typeof(remote) == "Instance" and not checkcaller() then
		        local args = { ... }
		        local methodName = getnamecallmethod()
		        local validInstance, remoteName = pcall(function()
		            return remote.Name
		        end)
		        if module.Options.Enabled and validInstance and (methodName == "FireServer" or methodName == "fireServer" or methodName == "InvokeServer" or methodName == "invokeServer") and remoteName:find("ArchMageOwO") and #args == 2 and typeof(args[1]) == "number" and typeof(args[2]) == "boolean" then
		            return nil
		        else
		            return module.original(remote, ...)
		        end
		    end
		    return module.original(remote, ...)
		end, module.original)
		if hookmetamethod then
		     module.oldNamecall = hookmetamethod(game, "__namecall", module.newnamecall)
	         module.original = module.original or function(...)
	             return module.oldNamecall(...)
	         end
	     else
			module:Disable()
	     end

		function module:Enable()
			module.Options.Enabled = true
		end
		function module:Disable()
	        module.Options.Enabled = false
		end
	    module:Enable()
		return module
	end)()
--]]
elseif game.PlaceId == 6032399813 or game.PlaceId == 5735553160 or game.PlaceId == 8668476218 then
	--[[
	NOFALL = (function()
		module = config.NoFall
		module.original = nil
		module.original = nil
		module.newnamecall = newcclosure(function(remote, ...)
			if typeof(remote) == "Instance" then
				local args = { ... }
				local methodName = getnamecallmethod()
				local validInstance, remoteName = pcall(function()
					return remote.Name
				end)
		        local vaildparent, parent = pcall(function()
		            return remote.Parent
		        end)
				if module.Options.Enabled and (validInstance and (methodName == "FireServer" or methodName == "fireServer") and (vaildparent and parent.Name == "FallDamage" and remoteName == "RemoteEvent")) then
					return nil
				else
					return original(remote, ...)
				end
			end
			return original(remote, ...)
		end, module.original)
		module.oldNamecall = hookmetamethod(game, "__namecall", module.newnamecall)
		function module:Enable()
			module.Options.Enabled = true
		end
		function module:Disable()
	        module.Options.Enabled = false
		end
	    module:Enable()
		return module
	end)()
	--]]
end
local ManaFly = (function()
    local tweenservice = game:GetService("TweenService")
    local module = {}
	local MANAFLY
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
    local x,y,z = 0,0,0
	module = config.ManaFly
	function module:Enable()
		local Character = Player.Character
		if game.PlaceId == 4691401390 then
			if workspace:FindFirstChild'Players' then
				Character = workspace.Players:FindFirstChild(Player.Name);
			end
		end
		MANAFLY = Character:GetPrimaryPartCFrame()
		module.Options.Enabled = true
		x,y,z = 0,0,0
	end
	function module:Disable()
		module.Options.Enabled = false
		x,y,z = 0,0,0
	end
	function module:SpeedChange(Speed)
		if z > 0 then
			z = Speed
		elseif z < 0 then
			z = -Speed
		end
		if y > 0 then
			y = Speed
		elseif y < 0 then
			y = -Speed
		end
		if x > 0 then
			x = Speed
		elseif x < 0 then
			x = -Speed
		end
	end
    local bodyvelocity,bodygyro
    Player:GetMouse().KeyDown:Connect(function(k)
		if not module.Options.Enabled then return end
		if k == "w" then
			x = x - module.Options.speed
		elseif k == "s" then
			x = x + module.Options.speed
		elseif k == "a" then
			z = z - module.Options.speed
		elseif k == "d" then
			z = z + module.Options.speed
		elseif k == module.Options.Down then
			y = y - module.Options.speed
		elseif k == module.Options.Up then
			y = y + module.Options.speed
		end
		--rconsoleinfo("ManaFly: X: "..tostring(x).." Y: "..tostring(y).." Z: "..tostring(z))
	end)
	Player:GetMouse().KeyUp:Connect(function(k)
		if not module.Options.Enabled then 
			return 
		end
		if x == 0 and z == 0 and y == 0 then
			return 
		end
		if k == "w" then
			x = x + module.Options.speed
		elseif k == "s" then
			x = x - module.Options.speed
		elseif k == "a" then
			z = z + module.Options.speed
		elseif k == "d" then
			z = z - module.Options.speed
		elseif k == module.Options.Down then
			y = y + module.Options.speed
		elseif k == module.Options.Up then
			y = y - module.Options.speed
		end
	end)
    local function fly()
        if module.Options.Enabled then
            local targetCF = workspace.CurrentCamera.CFrame
			local rx,ry,rz = targetCF:ToOrientation()
			targetCF = CFrame.new(0,0,0)*CFrame.Angles(0,ry,0) *CFrame.Angles(rx,0,0)
			local Character = Player.Character
			if game.PlaceId == 4691401390 then
				if workspace:FindFirstChild'Players' then
					Character = workspace.Players:FindFirstChild(Player.Name);
				end
			end
            if Character ~= nil then
                MANAFLY = (CFrame.new(MANAFLY.p) * targetCF)*CFrame.new(z,y,x)
                Character:SetPrimaryPartCFrame(MANAFLY)
                Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
    --RunService:BindToRenderStep("MANAFLY",1,fly)
	_G.ArtificialHB.Event:Connect(fly)
	return module
end)()

function updateui()
    protective_call_wrapper(function()
		if (game.PlaceId == 6032399813 or game.PlaceId == 5735553160 or game.PlaceId == 8668476218) and typeof(NOFALL) == "table" then
			local stringformat = "=== Universal ===\nManaRun(M):\t%s\n\tSpeed:\t%.2f\nManaFly(K):\t%s\n\tSpeed:\t%.2f\nManaSoul(P):\t%s\nUnderCover(RCtrl):\t%s\n=== Deepwoken ===\nNo Fall(Y):\t%s"
			if not NOFALL.Options then
				speedlabel.Text = stringformat:format(tostring(ManaRun.Options.Enabled),ManaRun.Options.speed,tostring(ManaFly.Options.Enabled),ManaFly.Options.speed,tostring(Noclip.Options.Enabled),tostring(UnderCover),"N/A")
			else
				speedlabel.Text = stringformat:format(tostring(ManaRun.Options.Enabled),ManaRun.Options.speed,tostring(ManaFly.Options.Enabled),ManaFly.Options.speed,tostring(Noclip.Options.Enabled),tostring(UnderCover),tostring(NOFALL.Options.Enabled))
			end
		else
			local stringformat = "=== Universal ===\nManaRun(M):\t%s\n\tSpeed:\t%.2f\nManaFly(K):\t%s\n\tSpeed:\t%.2f\nManaSoul(P):\t%s\nUnderCover(RCtrl):\t%s"
        	speedlabel.Text = stringformat:format(tostring(ManaRun.Options.Enabled),ManaRun.Options.speed,tostring(ManaFly.Options.Enabled),ManaFly.Options.speed,tostring(Noclip.Options.Enabled),tostring(UnderCover))
		end
    end)()
end

function countnewline(str)
    local lines = 1
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then
            lines = lines + 1
        end
    end
    return lines
end

local holdminus = false
local holdplus = false
updateui()
speedlabel.Position = Vector2.new(0,(workspace.CurrentCamera.ViewportSize.Y/1.5) - (countnewline(speedlabel.Text)*speedlabel.Size))
speedlabel.Visible = false



local Player = game:GetService("Players").LocalPlayer
local CurrentKeyPress = {}
Player:GetMouse().KeyDown:Connect(function(k)
	if k:byte() == 49 then
		k = "rightcontrol"
	end
	CurrentKeyPress[k] = true
end)
Player:GetMouse().KeyUp:Connect(function(k)
	if k:byte() == 49 then
		k = "rightcontrol"
	end
	CurrentKeyPress[k] = false
end)

function checkkey(keyname)
	if CurrentKeyPress[keyname] then
		return true
	end
	return false
end

game:GetService("UserInputService").InputBegan:Connect(function(input,gameProcessed)
	if gameProcessed then
		return
	end
	if not checkkey(input.KeyCode.Name:lower()) then
		return
	end
    if input.KeyCode == Enum.KeyCode.M then
        if not ManaRun.Options.Enabled and not UnderCover then
            if ManaFly.Options.Enabled then
                ManaFly:Disable()
            end
            ManaRun:Enable()
        else
            ManaRun:Disable()
        end
    elseif input.KeyCode == Enum.KeyCode.P and not UnderCover then
        if not Noclip.Options.Enabled then
            Noclip:Enable()
        else
            Noclip:Disable()
        end
    elseif input.KeyCode == Enum.KeyCode.K and not UnderCover then
        if not ManaFly.Options.Enabled then
            if ManaRun.Options.Enabled then
                ManaRun:Disable()
            end
            ManaFly:Enable()
        else
            ManaFly:Disable()
        end
	elseif input.KeyCode == Enum.KeyCode.Y then
        if NOFALL then
            if not NOFALL.Options.Enabled then
                NOFALL:Enable()
            else
                NOFALL:Disable()
            end
        end
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        UnderCover= not UnderCover
        speedlabel.Visible = not UnderCover
        if ManaRun.Options.Enabled then
            ManaRun:Disable()
        end
        if ManaFly.Options.Enabled then
            ManaFly:Disable()
        end
		if Noclip.Options.Enabled then
           Noclip:Disable()
        end
    end
    if speedlabel.Visible then
        if input.KeyCode == Enum.KeyCode.KeypadMinus then
            holdminus = true
            ManaRun.Options.speed = ManaRun.Options.speed - 1/100
        end
        if input.KeyCode == Enum.KeyCode.KeypadPlus then
            holdplus = true
            ManaRun.Options.speed = ManaRun.Options.speed + 1/100
        end
    end
end)
coroutine.resume(coroutine.create(function()
    while true do
		speedlabel.Visible = not UnderCover
        updateui()
        if holdminus then
            ManaRun.Options.speed = ManaRun.Options.speed - 1/100
        end
        if holdplus then
            ManaRun.Options.speed = ManaRun.Options.speed + 1/100
        end
        if ManaRun.Options.speed < 0 then
            ManaRun.Options.speed = 0
        end
        ManaRun:SpeedChange()
        ManaFly.Options.speed = ManaRun.Options.speed
        ManaFly:SpeedChange(ManaRun.Options.speed)
        for _=1,10 do
            game:GetService("RunService").RenderStepped:Wait()
        end
    end
end))
game:GetService("UserInputService").InputEnded:Connect(function(input,gameProcessed)
    if input.KeyCode == Enum.KeyCode.KeypadMinus then
        holdminus = false
    end
    if input.KeyCode == Enum.KeyCode.KeypadPlus then
        holdplus = false
    end
end)
game.Close:Connect(function()
    writef("ManaStuff.Json", JSONData)
end)