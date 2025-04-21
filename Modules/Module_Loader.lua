if not _G.RubyEnv then
    -- Check if the singleton already exists

    local RubyEnv = {}
    RubyEnv.__index = RubyEnv

    -- Internal state
    local internal_args = {}
    local internal_vars = {}

    -- Argument management
    function RubyEnv:get_args()
        return internal_args
    end

    function RubyEnv:set_args(...)
        internal_args = {...}
    end

    -- Variable storage
    function RubyEnv:get_var(name)
        return internal_vars[name]
    end

    function RubyEnv:set_var(name, value)
        internal_vars[name] = value
    end

    -- Function wrapping
    function RubyEnv:wrap_function(fn)
        return function(...)
            local args = {...}
            local storeargs = self:get_args()
            if #storeargs > 0 then
                args = storeargs
            end
            return fn(table.unpack(args))
        end
    end

    function RubyEnv:call_function(fn, ...)
        local args = {...}
        self:set_args(table.unpack(args))
        return fn(table.unpack(args))
    end

    -- Assign to global namespace
    _G.RubyEnv = setmetatable({}, RubyEnv)
end
local RubyEnv = _G.RubyEnv

return function(Fluent,module_name_or_place_id)
	local storedargs = RubyEnv:get_args()
	if #storeargs>0 then
		Fluent                  = storeargs[0]
		module_name_or_place_id = storeargs[1]
	end
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local IsStudio = RunService:IsStudio()
	local IsServer = RunService:IsServer()
	local IsExecutor, _ = pcall(function() game:HttpGet("https://github.com/plytalent/Roblox-Hacks/blob/main/Unnamed%20ESP%20Patcher.lua") return true end)
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
		local module_instance = game:GetService("ReplicatedStorage").Sub_module:FindFirstChild(module_name_or_place_id)
		if module_instance then
			Module = require(module_instance)
		else
			_print("Not Found "..module_name_or_place_id)
			return function() return function() end end
		end
	elseif IsExecutor or identifyexecutor then
		local Module_Source
		if isfolder and isfile then
			if isfolder("Ruby_SubModules") then
				local target_source_file = "Ruby_SubModules/"..tostring(module_name_or_place_id).."_module.lua"
				if isfile(target_source_file) then
					Module_Source = readfile(target_source_file)
				end
			end
		end
		if not Module_Source then
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
			for id_name, ModuleName in pairs(mapper) do
				local Module_Source
				local h_s, h_e = pcall(function()
					Module_Source = game:HttpGet("https://raw.githubusercontent.com/plytalent/Roblox-Hacks/refs/heads/main/Modules/"..filename.."_module.lua")
					return true
				end)
				if not h_s then
					_print(h_e)
				end
			end
		end
		Module = loadstring(Module_Source)
	end
	return Module
end
