return function (Variables, Tab, ManaFlyToggleOption, ManaRunToggleOption, MovementSpeedOption)
    local getgenv = getgenv or function() return _G end
    getgenv().ManaStuff_Movement_module_Env = getgenv().ManaStuff_Movement_module_Env or {}
    local env = env.ManaStuff_Movement_module_Env
    local Fluent = Variables.Fluent
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootpart = Character.HumanoidRootPart
    local RunService = game:GetService("RunService")
    local player_module = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
    local control_module = player_module:GetControls()

    local cf_of_hrp = CFrame.new()
    LocalPlayer.CharacterAdded:Connect(function(newcharacter)
        Character = newcharacter
        while Character.PrimaryPart == nil do
            RunService.Stepped:Wait()
        end
        cf_of_hrp = Character:GetPrimaryPartCFrame()
        rootpart = Character.HumanoidRootPart
    end)
    -- local camera_module = player_module:GetCameras() unused
    local _ManaFlyToggleOption = ManaFlyToggleOption or {
        Title = "ManaFly",
        Description = "(In Gaia)",
        Default = false
    }
    local _ManaRunToggleOption = ManaRunToggleOption or {
        Title = "ManaRun",
        Default = false
    }
    local fly_name  = _ManaFlyToggleOption.Title
    local run_name = _ManaRunToggleOption.Title
    local _MovementSpeedOption = MovementSpeedOption or {
        Title = "Speed",
        Description = "Speed For Both "..fly_name.."/"..run_name,
        Default = 250,
        Min = 0,
        Max = 1000,
        Rounding = 1,
    }
    
    local movement_dir_z, movement_dir_x = 0, 0
    local Options = Fluent.Options
    local ManaFlyToggle = Tab:AddToggle("_Fly", _ManaFlyToggleOption)
    local ManaRunToggle = Tab:AddToggle("_Speed", _ManaRunToggleOption)

    _MovementSpeedOption.Callback = function(Value)
        local change = Value/100
        local change = (Options._MovementSpeed.Value / 100)
        if UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.A) then
            local new_vector = control_module:GetMoveVector() * change
            movement_dir_x = new_vector.x
            movement_dir_z = new_vector.z
        end
    end
    local ManaSpeed = Tab:AddSlider("MovementSpeed", _MovementSpeedOption)
    
    local MovementModeDropdown = Tab:AddDropdown("_MovementMode",{
        Title = fly_name.."/"..run_name.." Type",
        Values = {"Positioning", "Velocity", "BodyMover(Velocity)", "BodyMover(Position)", "AlignPosition"},
        Default = "Positioning",
    })
    local ManaFlyKey = Tabs.Keybinds:AddKeybind("_FlyKeyBind", {
        Title = fly_name.." Key",
        Mode = "Toggle",
        Default = "K",
    })
    local ManaRunKey = Tabs.Keybinds:AddKeybind("_RunKeyBind", {
        Title = run_name.." Key",
        Mode = "Toggle",
        Default = "M",
    })
    MovementModeDropdown:OnChanged(function(Value)
        env.MovementMode = Value
    end)

    ManaFlyToggle:OnChanged(function()
        if Character.PrimaryPart then
            cf_of_hrp = Character:GetPrimaryPartCFrame()
        end
    end)

    ManaFlyKey:OnClick(function()
        Options._Fly:SetValue(not Options._Fly.Value)
        Options._Speed:SetValue(false)
        if Character.PrimaryPart then
            cf_of_hrp = Character:GetPrimaryPartCFrame()
        end
        local change = (Options._MovementSpeed.Value / 100)
        if UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.A) then
            local new_vector = control_module:GetMoveVector() * change
            movement_dir_x = new_vector.x
            movement_dir_z = new_vector.z
        end
    end)

    ManaRunKey:OnClick(function()
        if Options._Fly.Value then
            Options._Speed:SetValue(false)
            return
        end
        Options._Speed:SetValue(not Options._Speed.Value)
        movement_dir_z, movement_dir_x = 0, 0
        local change = (Options._MovementSpeed.Value / 100)
        if UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.A) then
            local new_vector = control_module:GetMoveVector() * change
            movement_dir_x = new_vector.x
            movement_dir_z = new_vector.z
        end
    end)

    --// Variables
    local delta = tick()
    local leftorright,backorforward = 0,0
    local targetCF
    local anti_grav = 2.9
    if env.Stepped_Event then
        env.Stepped_Event:Disconnect()
    end
    env.Stepped_Event = RunService.Stepped:Connect(function()
        local _delta = tick()-delta
        delta = tick()
        if math.abs((cf_of_hrp.Position.Y+1.45) - rootpart.Position.Y) > 0.0001 then
            anti_grav = (cf_of_hrp.Position.Y+1.45) - rootpart.Position.Y
        end
        if not env.BodyVelocity then
            env.BodyVelocity = Instance.new("BodyVelocity")
        end
        if not env.BodyPosition then
            env.BodyPosition = Instance.new("BodyPosition")
        end
        if not env.AlignPosition then
            env.AlignPosition = Instance.new("AlignPosition")
            env.AlignPosition_At = Instance.new("Attachment")
        end
        if (Options._Fly.Value or Options._Speed.Value) and env.MovementMode == "BodyMover(Velocity)" then
            env.BodyVelocity.Parent = rootpart
        else
            env.BodyVelocity.Parent = nil
        end
        if (Options._Fly.Value or Options._Speed.Value) and env.MovementMode == "BodyMover(Position)" then
            env.BodyPosition.Parent = rootpart
        else
            env.BodyPosition.Parent = nil
        end
        if (Options._Fly.Value or Options._Speed.Value) and env.MovementMode == "AlignPosition" then
            env.AlignPosition.Parent = rootpart
            env.AlignPosition_At.Parent = rootpart
        else
            env.AlignPosition.Parent = nil
            env.AlignPosition_At.Parent = nil
        end
        if _delta >= (1/60)*0.99 or env.MovementMode == "Velocity" then
            if Options._Fly.Value or Options._Speed.Value then
                local rx,ry,rz = workspace.CurrentCamera.CFrame:ToOrientation()
                targetCF = CFrame.new(0,0,0)*CFrame.Angles(0,ry,0)
                if Options._Fly.Value then
                    targetCF = targetCF * CFrame.Angles(rx,0,0)
                end
                if Options._Speed.Value and env.MovementMode == "Positioning" and Character.PrimaryPart then
                    cf_of_hrp = Character:GetPrimaryPartCFrame()
                end
                cf_of_hrp = (CFrame.new(cf_of_hrp.p) * targetCF)*CFrame.new(movement_dir_x, 0, movement_dir_z)
                if Character ~= nil then
                    if env.MovementMode == "Positioning" and Character.PrimaryPart then
                        Character:SetPrimaryPartCFrame(cf_of_hrp)
                        if Options._Fly.Value then
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
                        if Options._Speed.Value then
                            yv = rootpart.Velocity.y
                        end
                        rootpart.Velocity = Vector3.new(target_velocity.X, yv , target_velocity.Z)
                    elseif env.MovementMode == "BodyMover(Velocity)" then
                        cf_of_hrp = Character:GetPrimaryPartCFrame()
                        local change = (Options._MovementSpeed.Value/1.5)
                        if Options._Fly.Value then
                            env.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        else
                            env.BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
                        end
                        env.BodyVelocity.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(control_module:GetMoveVector() * change)
                    elseif env.MovementMode == "BodyMover(Position)" then
                        if Options._Fly.Value then
                            env.BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        else
                            env.BodyPosition.MaxForce = Vector3.new(math.huge, 0, math.huge)
                        end
                        env.BodyPosition.D = 300
                        env.BodyPosition.P = 10000
                        env.BodyPosition.Position = cf_of_hrp.p
                    elseif env.MovementMode == "AlignPosition" then
                        if Options._Fly.Value then
                            env.AlignPosition.ForceLimitMode = Enum.ForceLimitMode.Magnitude
                            env.AlignPosition.MaxForce = math.huge
                        else
                            env.AlignPosition.ForceLimitMode = Enum.ForceLimitMode.PerAxis
                            env.AlignPosition.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
                        end
                        env.AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
                        env.AlignPosition.ApplyAtCenterOfMass = true
                        env.AlignPosition.Responsiveness = 75
                        env.AlignPosition.Position = cf_of_hrp.p					
                        env.AlignPosition.Attachment0 = env.AlignPosition_At
                    end
                end
            end
        end
    end)
    if env.InputBegan_Event then
        env.InputBegan_Event:Disconnect()
    end
    env.InputBegan_Event = UIS.InputBegan:Connect(function(input,gameProcessed)
        local k = input.KeyCode.Name:lower()
        if k == "w" or k == "s" or k == "a" or k == "d" then
            local change = (Options._MovementSpeed.Value / 100)
            local new_vector = control_module:GetMoveVector() * change
            movement_dir_x = new_vector.x
            movement_dir_z = new_vector.z
        end
    end)
    if env.InputEnded_Event then
        env.InputEnded_Event:Disconnect()
    end
    env.InputEnded_Event = UIS.InputEnded:Connect(function(input,gameProcessed)
        local k = input.KeyCode.Name:lower()
        if k == "w" or k == "s" or k == "a" or k == "d" then
            local change = (Options._MovementSpeed.Value / 100)
            local new_vector = control_module:GetMoveVector() * change
            movement_dir_x = new_vector.x
            movement_dir_z = new_vector.z
        end
    end)
end
