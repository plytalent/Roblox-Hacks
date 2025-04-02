return function(Fluent,module_name_or_place_id)
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local IsStudio = RunService:IsStudio()
    local IsServer = RunService:IsServer()
    local Module
    local Submodule_init
    local function _print(...)
        local out = ""
        for _, v in pairs({...}) do
            out = out .. tostring(v)
        end
        if IsStudio then
            Fluent:Notify({
                Title = "Ruby Module Loader[Studio Mode]",
                Content = out,
                Duration = 8
            })
        elseif IsServer then
            print("[Ruby Module Loader][Server Mode]",out)
        else
            Fluent:Notify({
                Title = "Ruby Module Loader",
                Content = out,
                Duration = 8
            })
        end
    end
    _print("Finding Module")
    if IsStudio or IsServer then
        Module = game:GetService("ReplicatedStorage").Sub_module:FindFirstChild(module_name_or_place_id)
    else
        local mapper = {}
        local game_module = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/map.json"))
        local universal = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/universal_module.json"))
        for name, filename in pairs(universal) do
            mapper[name] = filename
        end
        for name, placeids in pairs(game_module) do
            for _, placeid in ipairs(placeids) do
                mapper[placeid] = name
            end
        end
        local Module_Source = game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/"..filename.."_module.lua")
        Module = loadstring(Module_Source)
    end
    return Module
end
