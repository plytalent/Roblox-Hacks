local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootpart = Character.HumanoidRootPart

local player_module = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local control_module = player_module:GetControls()
local camera_module = player_module:GetCameras()

local cf_of_hrp = CFrame.new()
LocalPlayer.CharacterAdded:Connect(function(newcharacter)
    Character = newcharacter
    while Character.PrimaryPart == nil do
        RunService.Stepped:Wait()
    end
    cf_of_hrp = Character:GetPrimaryPartCFrame()
    rootpart = Character.HumanoidRootPart
end)

local Fluent
local SaveManager
local InterfaceManager

if RunService:IsStudio() then
    Fluent = require(game:GetService("ReplicatedStorage").Fluent)
else
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end

local getgenv = getgenv or function() if not _G.getgenv then warn("Create getgenv Tables")_G.getgenv = {} end return _G.getgenv end
local env = getgenv()
local Drawing_Exist, _ = pcall(function() Drawing.new("Text"):Remove() return nil end)

function worldpoint_to_viewpoint(pos)
    local pos, in_fov = workspace.CurrentCamera:WorldToViewportPoint(pos)
    return {Vector2.new(pos.X,pos.Y),in_fov}
end
if not Drawing_Exist then
    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() warn("protect_gui No Exist!") end
    Drawing = env._fake_Drawing
    if not Drawing then
        Drawing = {}
        Drawing._objs = {}
        Drawing._update_loop = RunService.RenderStepped:Connect(function()
            for property, _internal_obj in pairs(Drawing._objs) do
                if not property._removed then
                    _internal_obj.Text = property["Text"]
                    _internal_obj.Visible = property["Visible"]
                    _internal_obj.TextSize = property["Size"]
                    _internal_obj.TextTransparency = property["Transparency"]
                    _internal_obj.TextStrokeTransparency = property["Outline"] and 0 or 1
                    _internal_obj.Position = UDim2.new(0,property["Position"].X,0,property["Position"].Y)
                    property.TextBounds = _internal_obj.TextBounds
                end
            end
        end)
        Drawing._gui = Instance.new("ScreenGui", RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"))
        ProtectGui(Drawing._gui)
        Drawing._gui.Name = "Fake Drawing"
        Drawing._fake = true
    end
    function Drawing.new(Type)
        if Type ~= "Text" then
            error(string.format("s% not Supported", Type))
            return
        end
        local _internal_obj = Instance.new("TextLabel",Drawing._gui)
        _internal_obj.BackgroundTransparency = 1
        local obj_property = {
            Font = 0,
            Size = 24,
            Text = "Place",
            Color = Color3.new(255/255, 0/255, 0/255),
            Center = true,
            Outline = true,
            _removed = false,
            Position = Vector2.new(0, 0),
            TextBounds = _internal_obj.TextBounds,
            Transparency = 0,
            OutlineColor = Color3.new(0, 0, 0)
        }
        function obj_property:Remove()
            obj_property._removed = true
            _internal_obj:Destory()
        end
        Drawing._objs[obj_property] = _internal_obj
        return obj_property
    end
    if not env._fake_Drawing then
        env._fake_Drawing = Drawing
    end
end   
function DrawTextLabel()
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
    Visualize = DrawTextLabel()
    env.Visualize = Visualize
else
    RunService:UnbindFromRenderStep("Visualize CF_hrp_point")
end     
RunService:BindToRenderStep("Visualize CF_hrp_point", 0,function()
    local cf_p = cf_of_hrp.p
    local point_fov = worldpoint_to_viewpoint(cf_p)
    Visualize.Text = string.format("Current Point: [X: %.2f][Y: %.2f][Z: %.2f]",cf_p.X,cf_p.Y,cf_p.Z)
    Visualize.Position = point_fov[1]
    Visualize.Visible = point_fov[2] and env.Enable_Visualize
end)

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
    Misc = Window:AddTab({ Title = "Misc", Icon = "circle-ellipsis" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    Debug = Window:AddTab({ Title = "Debug", Icon = "bug" }),
    Funny = Window:AddTab({ Title = "Funny", Icon = "party-popper" })
}

local movement_dir_z, movement_dir_x = 0, 0
local Options = Fluent.Options
local ManaSoulToggle = Tabs.Main:AddToggle("NoClip", {
    Title = "ManaSoul",
    Default = false
})
local ManaSoulKey = Tabs.Keybinds:AddKeybind("ManaSoulKeyBind", {
    Title = "ManaSoul Key",
    Mode = "Toggle",
    Default = "P",
})
local cf_of_hrp_visualize_toggle = Tabs.Debug:AddToggle("cf_of_hrp_visualize", {
    Title = "Point Visual",
    Default = false
})
cf_of_hrp_visualize_toggle:OnChanged(function()
    env.Enable_Visualize = Options.cf_of_hrp_visualize.Value
end)
Options.cf_of_hrp_visualize:SetValue(env.Enable_Visualize)

ManaSoulKey:OnClick(function()
    Options.NoClip:SetValue(not Options.NoClip.Value)
end)

env.Manastuff_NoClip_EV = RunService.Stepped:Connect(function()
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

Fluent:Notify({
    Title = "ManaStuff MainModule Loaded",
    Content = "The Main Script has been loaded.",
    Duration = 8
})

local Movment_Sub_module
if not RunService:IsStudio() then
    Fluent:Notify({
        Title = "MainModule",
        Content = "Try To Load Movement Module",
        Duration = 8
    })
    local s, err =  pcall(function()
        local sub_module_source = game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/_Movement_Module.lua")
        local _s, sub_module_init = pcall(loadstring(sub_module_source))
        if _s then
            local _s, e = pcall(
                sub_module_init,
                {
                    Fluent
                },
                Tabs.Main,
                {
                    Title = "ManaFly",
                    Description = "(In Gaia)",
                    Default = false
                },
                {
                    Title = "ManaRun",
                    Default = false
                },{
                    Title = "Speed",
                    Description = "Speed For Both ManaFly/ManaRun",
                    Default = 250,
                    Min = 0,
                    Max = 500,
                    Rounding = 1
                }
            )
            if _s then
                Fluent:Notify({
                    Title = "MainModule",
                    Content = "Loaded Movement Submodule",
                    Duration = 8
                })
            else
                print(e)
                Fluent:Notify({
                    Title = "Movement Module",
                    Content = "Internal Error",
                    Duration = 8
                })
            end
        else
            print(sub_module_init)
            Fluent:Notify({
                Title = "Movement Module",
                Content = "Module Error",
                Duration = 8
            })
        end
    end)
    if not s then
        print(err)
        Fluent:Notify({
            Title = "MainModule",
            Content = "Failed To Load Movement SubModule",
            SubContent = err,
            Duration = 8
        })
    end
else
    Movment_Sub_module = require(game:GetService("ReplicatedStorage").Sub_module.Movment)
    Fluent:Notify({
        Title = "MainModule",
        Content = "Loaded Local Movement Submodule",
        Duration = 8
    })
end

if not RunService:IsStudio() then
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
                    local _s, e = pcall(sub_module_init, HttpService, RunService, UIS, Players, Fluent, Options, SaveManager, InterfaceManager, Window, Tabs, getgenv())
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
else
    Fluent:Notify({
        Title = "SubModule",
        Content = "Not Available",
        Duration = 8
    })
end
if SaveManager then
    SaveManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    SaveManager:SetFolder("Manastuff Hub/"..tostring(game.PlaceId))
    SaveManager:BuildConfigSection(Tabs.Settings)
    SaveManager:LoadAutoloadConfig()
else
    Tabs.Settings:AddParagraph({
        Title = "Save Manager Library Missing",
        Content = "Save Manager Not Available"
    })
end    
if InterfaceManager then
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("Manastuff Hub")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
else
    Tabs.Settings:AddParagraph({
        Title = "Interface Manager Library Missing",
        Content = "Interface Manager Not Available"
    })
end
Window:SelectTab(1)
if not Character:FindFirstChild("Torso") then
    Tabs.Funny:AddParagraph({
        Title = "CustomAnimation",
        Content = "Incompatible BodyType"
    })
else
    Tabs.Funny:AddParagraph({
        Title = "CustomAnimation",
        Content = "!!!WARNING!!!! Use At Your Own Risk!!!"
    })
    local CustomAnimation_toggle = Tabs.Funny:AddToggle("CustomAnimation", {
        Title = "Custom Animation Fly/Run",
        Default = false
    })
    env.CustomAnimation = false
    CustomAnimation_toggle:OnChanged(function()
        env.CustomAnimation = Options.CustomAnimation.Value
    end)
    function QuaternionSlerp(a, b, t)
        local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
        local startInterp, finishInterp;
        if cosTheta >= 0.0001 then
            if (1 - cosTheta) > 0.0001 then
                local theta = math.acos(cosTheta)
                local invSinTheta = 1 / math.sin(theta)
                startInterp = math.sin((1 - t) * theta) * invSinTheta
                finishInterp = math.sin(t * theta) * invSinTheta
            else
                startInterp = 1 - t
                finishInterp = t
            end
        else
            if (1 + cosTheta) > 0.0001 then
                local theta = math.acos(-cosTheta)
                local invSinTheta = 1 / math.sin(theta)
                startInterp = math.sin((t - 1) * theta) * invSinTheta
                finishInterp = math.sin(t * theta) * invSinTheta
            else
                startInterp = t - 1
                finishInterp = t
            end
        end
        return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
    end

    function QuaternionFromCFrame(cf) 
        local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components() 
        local trace = m00 + m11 + m22 
        if trace > 0 then 
            local s = math.sqrt(1 + trace) 
            local recip = 0.5/s 
            return (m21-m12)*recip, (m02-m20)*recip, (m10-m01)*recip, s*0.5 
        else 
            local i = 0 
            if m11 > m00 then
                i = 1
            end
            if m22 > (i == 0 and m00 or m11) then 
                i = 2 
            end 
            if i == 0 then 
                local s = math.sqrt(m00-m11-m22+1) 
                local recip = 0.5/s 
                return 0.5*s, (m10+m01)*recip, (m20+m02)*recip, (m21-m12)*recip 
            elseif i == 1 then 
                local s = math.sqrt(m11-m22-m00+1) 
                local recip = 0.5/s 
                return (m01+m10)*recip, 0.5*s, (m21+m12)*recip, (m02-m20)*recip 
            elseif i == 2 then 
                local s = math.sqrt(m22-m00-m11+1) 
                local recip = 0.5/s return (m02+m20)*recip, (m12+m21)*recip, 0.5*s, (m10-m01)*recip 
            end 
        end 
    end
    function QuaternionToCFrame(px, py, pz, x, y, z, w) 
        local xs, ys, zs = x + x, y + y, z + z 
        local wx, wy, wz = w*xs, w*ys, w*zs 
        local xx = x*xs 
        local xy = x*ys 
        local xz = x*zs 
        local yy = y*ys 
        local yz = y*zs 
        local zz = z*zs 
        return CFrame.new(px, py, pz,1-(yy+zz), xy - wz, xz + wy,xy + wz, 1-(xx+zz), yz - wx, xz - wy, yz + wx, 1-(xx+yy)) 
    end

    function Clerp(a,b,t) 
        local qa = {QuaternionFromCFrame(a)}
        local qb = {QuaternionFromCFrame(b)} 
        local ax, ay, az = a.x, a.y, a.z 
        local bx, by, bz = b.x, b.y, b.z
        local _t = 1-t
        return QuaternionToCFrame(_t*ax + t*bx, _t*ay + t*by, _t*az + t*bz,QuaternionSlerp(qa, qb, t)) 
    end
    function rayCast(Pos, Dir, Max, Ignore)  -- Origin Position , Direction, MaxDistance , IgnoreDescendants
        return workspace:FindPartOnRay(Ray.new(Pos, Dir.unit * (Max or math.huge)), Ignore) 
    end 
    local Links = {}
    local Torso = Character.Torso
    local RHI = Torso["Right Hip"]
    local LHI = Torso["Left Hip"]
    local RSH = Torso["Right Shoulder"]
    local LSH = Torso["Left Shoulder"]
    local RootJoint = rootpart.RootJoint
    local RootCF=CFrame.fromEulerAnglesXYZ(-1.57,0,3.14)
    local necko=CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
    if env.animation_ev then
        env.animation_ev:Disconnect()
        RHI.C0 = env.animation_joint_state.RHI.C0
        RHI.C1 = env.animation_joint_state.RHI.C1
        LHI.C0 = env.animation_joint_state.LHI.C0
        LHI.C1 = env.animation_joint_state.LHI.C1
        RSH.C0 = env.animation_joint_state.RSH.C0
        RSH.C1 = env.animation_joint_state.RSH.C1
        LSH.C0 = env.animation_joint_state.LSH.C0
        LSH.C1 = env.animation_joint_state.LSH.C1
        RootJoint.C0 = env.animation_joint_state.RootJoint.C0
        RootJoint.C1 = env.animation_joint_state.RootJoint.C1
    else
        env.animation_joint_state = {
            RHI = {C0 = RHI.C0, C1 = RHI.C1},
            LHI = {C0 = LHI.C0, C1 = LHI.C1},
            RSH = {C0 = RSH.C0, C1 = RSH.C1},
            LSH = {C0 = LSH.C0, C1 = LSH.C1},
            Neck = {C0 = Torso.Neck.C0, C1 = Torso.Neck.C1},
            RootJoint = {C0 = RootJoint.C0, C1 = RootJoint.C1}
        }
        env.animation_sine = 0
    end

    local cf = CFrame.new
    local angles = CFrame.Angles
    local ROOTC0 =  RootJoint.C0
    local NECKC0 = Torso.Neck.C0
    local COS = math.cos
    local ACOS = math.acos
    local SIN = math.sin
    local ASIN = math.asin
    local ABS = math.abs
    local MRANDOM = math.random
    local FLOOR = math.floor
    local cf=CFrame.new
    local cn=CFrame.new
    local euler=CFrame.fromEulerAnglesXYZ
    local angles=CFrame.Angles
    local reset_c0 = false
    env.animation_ev = RunService.RenderStepped:Connect(function()
        if not env.CustomAnimation then
            if not reset_c0 then
                reset_c0 = true
                RHI.C0 = env.animation_joint_state.RHI.C0
                LHI.C0 = env.animation_joint_state.LHI.C0
                RSH.C0 = env.animation_joint_state.RSH.C0
                LSH.C0 = env.animation_joint_state.LSH.C0
                Torso.Neck.C0 = env.animation_joint_state.Neck.C0
                RootJoint.C0 = env.animation_joint_state.RootJoint.C0
            end
            return
        end
        Torso = Character.Torso
        RHI = Torso["Right Hip"]
        LHI = Torso["Left Hip"]
        RSH = Torso["Right Shoulder"]
        LSH = Torso["Left Shoulder"]
        RootJoint = rootpart.RootJoint
        local sine = env.animation_sine
        local hum = Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local animator = hum:FindFirstChild("Animator")
            if animator then
                for i, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop(0)
                end
            end
        end

        local torvel=(rootpart.Velocity*Vector3.new(1,0,1)).magnitude
        if torvel<10 then
            --idle
            RHI.C0=Clerp(RHI.C0,cf(1,-0.25,-0.5)*angles(math.rad(0),math.rad(90),math.rad(0))*angles(math.rad(-2.5),math.rad(0),math.rad(-10)),.1)
            LHI.C0=Clerp(LHI.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-90),math.rad(0))*angles(math.rad(-2.5),math.rad(0),math.rad(10)),.1)
            RootJoint.C0=Clerp(RootJoint.C0,RootCF*cf(0,0,1.5 + 0.1 * math.cos(sine / 28))*angles(math.rad(0 - 1 * math.cos(sine / 34)),math.rad(0),math.rad(0)),.1)
            Torso.Neck.C0=Clerp(Torso.Neck.C0,necko*angles(math.rad(15),math.rad(0),math.rad(0)),.1)
            RSH.C0=Clerp(RSH.C0,cf(1.5,0.5,0)*angles(math.rad(10),math.rad(0),math.rad(20 + 2.5 * math.cos(sine / 28))),.1)
            LSH.C0=Clerp(LSH.C0,cf(-1.5,0.5,0)*angles(math.rad(10),math.rad(0),math.rad(-20 - 2.5 * math.cos(sine / 28))),.1)
        elseif torvel>10 then
            --Walk/Running
            RHI.C0=Clerp(RHI.C0,cf(1,-0.25,-0.5)*angles(math.rad(0),math.rad(90),math.rad(0))*angles(math.rad(-2.5),math.rad(0),math.rad(-20)),.2)
            LHI.C0=Clerp(LHI.C0,cf(-1,-1,0)*angles(math.rad(0),math.rad(-90),math.rad(0))*angles(math.rad(-2.5),math.rad(0),math.rad(20)),.2)
            RootJoint.C0=Clerp(RootJoint.C0,RootCF*cf(0,-0.5,0.5 + 0.1 * math.cos(sine / 28))*angles(math.rad(75),math.rad(0),math.rad(0)),.2)
            Torso.Neck.C0=Clerp(Torso.Neck.C0,necko*angles(math.rad(-45),math.rad(0),math.rad(0)),.2)
            RSH.C0=Clerp(RSH.C0,cf(1.5,0.5,0)*angles(math.rad(-30),math.rad(0),math.rad(30 + 2.5 * math.cos(sine / 28))),.2)
            LSH.C0=Clerp(LSH.C0,cf(-1.5,0.5,0)*angles(math.rad(-30),math.rad(0),math.rad(-30 - 2.5 * math.cos(sine / 28))),.2)
        end
        reset_c0 = false
        env.animation_sine = sine + 1
    end)
end
