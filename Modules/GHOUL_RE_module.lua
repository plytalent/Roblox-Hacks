return function (HttpService, RunService, UIS, Players, Fluent, Options, SaveManager, InterfaceManager, Window, Tabs, env)
    if not (HttpService and RunService and UIS and Players and Fluent and Options and SaveManager and InterfaceManager and Window and Tabs and env) then
        Fluent:Notify({
            Title = "Specific Game Module Init",
            Content = "Missing Arguments",
            Duration = 5 -- Set to nil to make the notification not disappear
        })
    end
    Fluent:Notify({
        Title = "Specific Game Module Loading",
        Content = "GHOUL://RE Module Loading",
        SubContent = "Goon://Re Module Loading", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })
    Fluent:Notify({
        Title = "Specific Game Module Loading",
        Content = "Replacing Old ManaSoul(NoClip)",
        Duration = 3 -- Set to nil to make the notification not disappear
    })
    if env.Manastuff_NoClip_EV then
        Fluent:Notify({
            Title = "Specific Game Module Loading",
            Content = "Disconnect Default ManaSoul(NoClip)",
            Duration = 3 -- Set to nil to make the notification not disappear
        })
        local old_value = Options.NoClip.Value
        Options.NoClip:SetValue(false)
        for _=1, 3 do
            RunService.Stepped:Wait()
        end
        env.Manastuff_NoClip_EV:Disconnect()
        env.Manastuff_NoClip_EV = nil
        Options.NoClip:SetValue(old_value)
    end
    local default_clip = {}
    local noclip_state = {
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        CollisionGroup = ""
    }
    env.Manastuff_NoClip_EV = RunService.Stepped:Connect(function()
        if Character then
            for _,v in pairs(Character:GetDescendants())do
                if v:IsA("BasePart") then
                    if default_clip[v] == nil then
                        default_clip[v] = {}
                        for index, _ in pairs(noclip_state) do
                            default_clip[v][index] = v[index]
                        end
                    end
                    if Options.NoClip.Value then
                        for index, val in pairs(default_clip[v]) do
                            v[index] = noclip_state[index]
                        end
                    else
                        for index, val in pairs(default_clip[v]) do
                            v[index]= val
                        end
                    end
                elseif v:IsA("ObjectValue") then
                    if v.Value:IsA("BasePart") then
                        local _t_v = v.Value
                        if default_clip[_t_v] == nil then
                            default_clip[_t_v] = {
                                CanCollide = _t_v.CanCollide,
                                CanQuery = _t_v.CanQuery,
                                CanTouch = _t_v.CanQuery,
                                CollisionGroup = _t_v.CollisionGroup
                            }
                        end
                        if Options.NoClip.Value then
                            for index, val in pairs(default_clip[_t_v]) do
                                _t_v[index] = noclip_state[index]
                            end
                        else
                            for index, val in pairs(default_clip[_t_v]) do
                                _t_v[index]= val
                            end
                        end
                    end
                end
            end
        end
    end)
    Fluent:Notify({
        Title = "Specific Game Module Loading",
        Content = "Replaced Old ManaSoul(NoClip)",
        Duration = 3 -- Set to nil to make the notification not disappear
    })
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GuiService = game:GetService('GuiService')
    local plr = Players.LocalPlayer
    local gui = plr.PlayerGui
    local char = plr.Character or plr.CharacterAdded:Wait()

    plr.CharacterAdded:Connect(function(newchar)
        char = newchar
    end)

    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
    local GhoulPoints = 0

    task.spawn(function()
        local targets = {"DeveloperProducts", "Container", "CosmeticInterfacePoints", "GhoulPoints"}
        local obj = gui 
        for __index = 1, #targets do
            while not obj:FindFirstChild(targets[_index]) do
                RunService.RenderStepped:Wait()
            end
            obj = obj:FindFirstChild(targets[_index])
        end
        RunService.RenderStepped:Connect(function()
            GhoulPoints = tonumber(obj.Text:sub(17))
        end)
    end)

    Tabs.GHOUL_RE = Window:AddTab({ Title = "GHOUL://RE", Icon = "joystick" })
    RedeemCodes = Tabs.GHOUL_RE:AddButton({
        Title = "Redeem Codes",
        Callback = function()
            local code = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/GHOUL_RE_Codes.json")) 
            for i,v in ipairs(code) do
                Remotes.CodeStuff:InvokeServer(v)
                RunService.Stepped:Wait()
            end
        end
    })
    env.Auto_reroll = false
    env.SelectedKagunes = {}
    local SelectedKaguneDropdown = Tabs.GHOUL_RE:AddDropdown("SelectedKaguneDropdown", {
        Title = "Select Kagunes To NOT ReRoll",
        Description = "You can select What Kagune's To Stop When ReRoll",
        Values = {"Select Kagune's", "-Legendary-", "Eto", "Mayu", "Ken", "Takizawa", "Yomo", "Noro", "-Rare-", "Tsukiyama", "Yamori", "-Common-", "Wing", "Beaked", "Nishio"},
        Multi = true,
        Default = {"Select Kagune's"},
    })
    local SelectableValues = {"Eto", "Mayu", "Ken", "Takizawa", "Yomo", "Noro", "Tsukiyama", "Yamori", "Wing", "Beaked", "Nishio"}
    local Update_DropDown = {}
    SelectedKaguneDropdown:OnChanged(function(Value)
        local Values = {}
        Update_DropDown = {}
        for Value, State in next, Value do
            if table.find(SelectableValues,Value) then
                Update_DropDown[Value] = true
                table.insert(Values, Value)
            else
                Update_DropDown[Value] = false
            end
        end
        env.SelectedKagune = Values
    end)
    AutoKaguneReRollButton = Tabs.GHOUL_RE:AddButton({
        Title = "Auto Kagune ReRoll With GhoulPoints",
        Description = "Press Again To Stop Mid Way",
        Callback = function()
            SelectedKaguneDropdown:SetValue(Update_DropDown)
            env.Auto_reroll = not env.Auto_reroll
            if env.Auto_reroll then
                Fluent:Notify({
                    Title = "Auto ReRoll",
                    Content = "Started",
                    Duration = 5 -- Set to nil to make the notification not disappear
                })
                function WaitForType()
                    while not char:FindFirstChild("Type") and GhoulPoints >= 20 and env.Auto_reroll do
                        RunService.Stepped:Wait()
                    end
                    return char.Type
                end
                local _type = WaitForType().Value
                local s, err = pcall(function()
                    while not table.find(env.SelectedKagune,_type) and GhoulPoints >= 20 and env.Auto_reroll do
                        local oldv = WaitForType().Value
                        Remotes.GhoulPoint:FireServer(2151876503)
                        GuiService.SelectedCoreObject = gui.ActionConfirm.MainFrame.AcceptButton
                        for _=1, 3 do
                            RunService.RenderStepped:Wait()
                        end
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        while oldv == WaitForType().Value do
                            RunService.Stepped:Wait()
                        end
                        print("Before",_type)
                        _type = WaitForType().Value
                        print("After",_type)
                        for _=1, 30 do
                            RunService.RenderStepped:Wait()
                        end
                    end
                    _type = WaitForType().Value
                end)
                local reason = "Got Selected Kagune"
                local sub = ""
                if s then
                    if not env.Auto_reroll then
                        reason = "ReRoll Canceled"
                    else
                        if table.find(env.SelectedKagune, _type) then
                            reason = "Not Enough GhoulPoints"
                            sub = "Got ".. tostring(GhoulPoints) .. " Points Left"
                        end
                        env.Auto_reroll = false
                    end
                else
                    reason = "Error In ReRoll Function"
                    print(err)
                end
                Fluent:Notify({
                    Title = "Auto ReRoll",
                    Content = reason,
                    SubContent = sub,
                    Duration = 5 -- Set to nil to make the notification not disappear
                })
            end
        end
    })
    Fluent:Notify({
        Title = "Specific Game Module Loaded",
        Content = "GHOUL://RE Module Loaded",
        SubContent = "Goon://Re Module Loaded", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })
end
