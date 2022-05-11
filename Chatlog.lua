local lines = {}
local Text_Drawing = Drawing.new("Text")
local Square_Drawing = Drawing.new("Square")
local Square2_Drawing = Drawing.new("Square")
local UpdateSignal = Instance.new("BindableEvent")

local function IsStringEmpty(String)
	if type(String) == 'string' then
		return String:match'^%s+$' ~= nil or #String == 0 or String == '' or false;
	end
	
	return false;
end

function chatbind(player)
    local firstname = player:GetAttribute('FirstName') or ""
    local lastname = player:GetAttribute('LastName') or ""
    player.Chatted:Connect(function(msg)
        lines[#lines+1] = string.format("%s %s (%s):%s", firstname, lastname, player.Name, msg)
        UpdateSignal:Fire()
        if #lines >= 17 then
            shift(lines)
        end
    end)
end
function shift(tb)
    for i=1, #tb do
        tb[i-1] = tb[i]
    end
    tb[#tb] = nil
end
for _, player in pairs(game:GetService("Players"):GetPlayers())do
    chatbind(player)
end
game:GetService("Players").PlayerAdded:Connect(chatbind)
_G.Chat_log = not _G.Chat_log
local last_updatefire = tick()
game:GetService("RunService").Stepped:Connect(function()
    if (tick() - last_updatefire) > 1/10 then
        last_updatefire = tick()
        UpdateSignal:Fire()
    end
end)
while _G.Chat_log do
    local Buffer = lines[1] or ""
    local VPSize = Workspace.CurrentCamera.ViewportSize
    for i=2,#lines do
        Buffer = Buffer .. "\n"..lines[i]
    end
    Square_Drawing.Size = Vector2.new(500,300)
    Square2_Drawing.Size = Square_Drawing.Size + Vector2.new(10,10)
    
    Square_Drawing.Position = Vector2.new(VPSize.X - Square_Drawing.Size.X-25, VPSize.Y - Square_Drawing.Size.Y-25)
    Square2_Drawing.Position = Square_Drawing.Position-Vector2.new(5,5)
    
    Square2_Drawing.Transparency = 0.5
    Square2_Drawing.Visible = true
    Square2_Drawing.Filled = true
    Square2_Drawing.Color = Color3.fromHSV(tick() * 128 % 255/255, 1, 0.75)
    Square2_Drawing.ZIndex = Square_Drawing.ZIndex - 1
    
    Square_Drawing.Transparency = 0.25
    Square_Drawing.Visible = true
    Square_Drawing.Filled = true
    Square_Drawing.Color = Color3.fromHSV(tick() * 128 % 255/255, 1, 0.75)
    Square_Drawing.ZIndex = Text_Drawing.ZIndex - 1
    
    Text_Drawing.Position = Square_Drawing.Position
    Text_Drawing.Size = 18
    Text_Drawing.Text = Buffer
    Text_Drawing.Outline = false
    Text_Drawing.Color = Color3.new(1,1,1)
    Text_Drawing.OutlineColor = Color3.new(0,0,0)
    Text_Drawing.Transparency = 1
    Text_Drawing.Visible = true

    UpdateSignal.Event:wait()
end
Text_Drawing.Transparency = 0
Text_Drawing.Visible = false
Square_Drawing.Transparency = 0
Square_Drawing.Visible = false
Square_Drawing2.Transparency = 0
Square_Drawing2.Visible = false

Text_Drawing:Remove()
Square_Drawing:Remove()
Square_Drawing2:Remove()
