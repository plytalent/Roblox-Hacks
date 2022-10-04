getgenv().Rainbow = false

if not getgenv().mob_esp_init_lock then
    getgenv().mob_esp_init_lock = true
    local s,err = pcall(function()
        function synTextLabel()
            local TextLabel = Drawing.new("Text")
            if not getgenv().Syn_Drawing then
                getgenv().Syn_Drawing = {}
            end
            getgenv().Syn_Drawing[#getgenv().Syn_Drawing+1] = TextLabel
            TextLabel.Text = "Place"
            TextLabel.Size = 24
            TextLabel.Center = true
            TextLabel.Outline = true
            TextLabel.Color = Color3.new(255/255, 0/255, 0/255)
            TextLabel.OutlineColor = Color3.new(0, 0, 0)
            return TextLabel
        end
        function worldpoint_to_viewpoint(pos)
            local pos, in_fov = workspace.CurrentCamera:WorldToViewportPoint(pos.p)
            return {Vector2.new(pos.X,pos.Y),in_fov}
        end
        getgenv().textlabels_Line1 = getgenv().textlabels_Line1 or {}
        getgenv().textlabels_Line2 = getgenv().textlabels_Line2 or {}
        getgenv().Events = getgenv().Events or {}
        getgenv().Lock_Create = false
        game:GetService("RunService"):UnbindFromRenderStep("ESP Mob V2")
        for i,ev in pairs(getgenv().Events) do
            if getgenv().Events[i] then
                ev:Disconnect()
                getgenv().Events[i] = nil
            end
        end
        function addinstance_to_renderlist(character_object)
            local s,err = pcall(function()
                if character_object.Name:split("")[1] == "." and getgenv().textlabels_Line1[character_object] == nil and getgenv().textlabels_Line2[character_object] == nil then
                    while getgenv().Lock_Create do
                        wait()
                    end
                    getgenv().Lock_Create = true
                    getgenv().lock_render = true
                    getgenv().textlabels_Line1[character_object] = synTextLabel()
                    getgenv().textlabels_Line2[character_object] = synTextLabel()
                    getgenv().textlabels_Line1[character_object].Visible = false
                    getgenv().textlabels_Line2[character_object].Visible = false
                    getgenv().textlabels_Line1[character_object].ZIndex = -1000
                    getgenv().textlabels_Line2[character_object].ZIndex = getgenv().textlabels_Line1[character_object].ZIndex-1
                    getgenv().Lock_Create = false
                end
            end)
            getgenv().lock_render = false
            if not s then
                rconsoleinfo(string.format("ChildAdded_EV: %s",err))
            end
        end
        getgenv().Events["ChildAdded_EV"] = workspace.Live.ChildAdded:Connect(addinstance_to_renderlist)
        getgenv().Events["ChildRemoved_EV"] = workspace.Live.ChildRemoved:Connect(function(character_object)
            local s,err = pcall(function()
                if getgenv().textlabels_Line1[character_object] ~= nil and character_object.Parent == nil then
                    getgenv().lock_render = true
                    getgenv().textlabels_Line1[character_object].Visible = false
                    getgenv().textlabels_Line1[character_object] = nil
                    getgenv().textlabels_Line2[character_object].Visible = false
                    getgenv().textlabels_Line2[character_object] = nil
                end
            end)
            getgenv().lock_render = false
            if not s then
                rconsoleinfo(string.format("ChildRemoved_EV: %s",err))
            end
        end)
        for _,character_object in pairs(workspace.Live:GetChildren())do
            addinstance_to_renderlist(character_object)
        end
        game:GetService("RunService"):BindToRenderStep("ESP Mob V2",201, function()
            local s,err = pcall(function()
                for npc_model,renderobject in pairs(getgenv().textlabels_Line1) do
                    local s,err = pcall(function()
                        local renderobject1 = renderobject
                        local renderobject2 = getgenv().textlabels_Line2[npc_model]
                        if renderobject1 ~= nil and renderobject2 ~= nil then
                            local character = npc_model
                            local part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                            if not part then
                                part = character:FindFirstChildOfClass("Part") or character:FindFirstChildOfClass("MeshPart")
                            end
                            if part then
                                local playerpos = workspace.CurrentCamera.CFrame.Position
                                if game:GetService("Players").LocalPlayer.Character ~= nil then
                                    local player_hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if player_hrp then
                                        playerpos = player_hrp.CFrame.Position
                                    end
                                end
                                
                                local character_pos = part.CFrame
                                local pos_and_infov = worldpoint_to_viewpoint(character_pos)
                                renderobject1.Position = pos_and_infov[1]
                                renderobject2.Position = renderobject1.Position + Vector2.new(0,renderobject1.TextBounds.Y)
                                local humanoid = character:FindFirstChild("Humanoid")
                                if humanoid then
                                    renderobject1.Text = string.format("%s",character.Name)
                                    renderobject2.Text = string.format("[%.2f] [%.2f/%.2f] [%.2f%%]", (character_pos.Position - playerpos).Magnitude, humanoid.Health, humanoid.MaxHealth, (humanoid.Health/humanoid.MaxHealth)*100)
                                else
                                    renderobject1.Text = string.format("%s",character.Name)
                                    renderobject2.Text = string.format("[%.2f] [null/null] [null%%]", (character_pos.Position - playerpos).Magnitude)
                                end
                                renderobject1.Color = getgenv().Rainbow and Color3.fromHSV(tick() * 128 % 255/255, 1, 1) or Color3.new(1,0,0)
                                renderobject2.Color = getgenv().Rainbow and Color3.fromHSV(tick() * 128 % 255/255, 1, 1) or Color3.new(1,1,1)
                                renderobject1.Size = 20
                                renderobject2.Size = renderobject1.Size-1
                                if (character_pos.Position - playerpos).Magnitude > 6000 then
                                    pos_and_infov[2] = false
                                end
                                renderobject1.Visible = pos_and_infov[2]
                                renderobject2.Visible = renderobject1.Visible
                            end
                        end
                    end)
                    if not s then
                        rconsoleinfo(err)
                    end
                end
            end)
            if not s then
                rconsoleinfo(err)
            end
        end)
        local last_cleaning_tick = tick()
        local last_fully_cleaning_tick = tick()
        getgenv().Events["Cleaner_EV"] = game:GetService("RunService").Stepped:Connect(function()
            local s,err = pcall(function()
                if tick()-last_cleaning_tick >= 5 then
                    last_cleaning_tick = tick()
                    for npc_model,renderobject in pairs(getgenv().textlabels_Line1) do
                        local renderobject2 = getgenv().textlabels_Line2[npc_model]
                        if npc_model.Parent == nil and npc_model then
                            local s, _ = pcall(function()
                                renderobject.Visible = false
                                renderobject2.Visible = false
                                renderobject:Remove()
                                renderobject2:Remove()
                            end)
                            if s then
                                getgenv().textlabels_Line1[npc_model] = nil
                                getgenv().textlabels_Line2[npc_model] = nil
                            end
                        end

                    end
                end
            end)
            if not s then
                rconsoleinfo(err)
            end
        end)
        getgenv().Events["Remover_EV"] = game:GetService("RunService").Stepped:Connect(function()
            local s,err = pcall(function()
                if tick()-last_fully_cleaning_tick >= 6 then
                    last_fully_cleaning_tick = tick()
                    local flag = false
                    for _,renderobject in pairs(getgenv().Syn_Drawing) do
                        for _, r in pairs(getgenv().textlabels_Line1) do
                            if r == renderobject then
                                flag = true
                            end
                        end
                        for _, r in pairs(getgenv().textlabels_Line2) do
                            if r == renderobject then
                                flag = true
                            end
                        end
                        if not flag then
                            pcall(function()
                                renderobject.Visible = false
                                renderobject:Remove()
                            end)
                        end
                    end
                end
            end)
            if not s then
                rconsoleinfo(err)
            end
        end)
    end)
    if not s then
        rconsoleinfo(string.format("Init: %s",err))
    end
    wait(1)
    getgenv().mob_esp_init_lock = false
end
