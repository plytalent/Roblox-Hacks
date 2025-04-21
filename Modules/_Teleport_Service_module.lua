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

local module = {}
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LocalPlayer
local IsStudio = RunService:IsStudio()
module.require_variables = {
	"Fluent",
	"Window",
	"Tabs"
}
module.Main_Function_Name = "Main"
function module.Main(Variables)
	local storedargs = RubyEnv:get_args()
	if #storedargs>0 then
		Variables = storedargs[0]
	end	
	module.Fluent = Variables.Fluent
	module.Window = Variables.Window
	module.Tabs = Variables.Tabs
	module.Tabs.Teleport_Service = module.Window:AddTab({ Title = "Teleport Service", Icon = "server"})
	module.Tab_Teleport_Service = Variables.Tabs.Teleport_Service
	LocalPlayer = game:GetService("Players").LocalPlayer
	if IsStudio then
		module.Tab_Teleport_Service:AddParagraph({
			Title = "Teleport Service In Studio Mode",
			Content = "Teleport Service Not Available"
		})
	end
	module.Tab_Teleport_Service:AddButton({
		Title = "Click To Rejoin",
		Callback = function()
			if IsStudio then
				print("TeleportService:TeleportToPlaceInstance("..tostring(game.PlaceId)..", '"..game.JobId.."', "..tostring(LocalPlayer)..")")
				return
			end
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end
	})
	if setclipboard then
		module.Tab_Teleport_Service:AddButton({
			Title = "Click To Copy JobId",
			Description = "JobID:" .. game.JobId,
			Callback = function()
				if setclipboard then
					setclipboard(game.JobId)
				else
					print(game.JobId)
				end
			end
		})
	end
	if not getclipboard then
		local Input = module.Tab_Teleport_Service:AddInput("JobId_Input", {
			Title = "Enter JobID to Join",
			Default = game.JobId,
			Placeholder = "00000000-0000-0000-0000-000000000000",
			Numeric = false, -- Only allows numbers
			Finished = false, -- Only calls callback when you press enter
			Callback = function(Value)
				if not Value then
					return
				end
				local jid = Value:match("[0-9A-Z]+\-[0-9A-Z]+\-[0-9A-Z]+\-[0-9A-Z]+\-[0-9A-Z]+")
				if IsStudio then
					print("TeleportService:TeleportToPlaceInstance("..tostring(game.PlaceId)..",'"..jid.."',"..tostring(LocalPlayer)..")")
					return
				end
				TeleportService:TeleportToPlaceInstance(game.PlaceId, jid,LocalPlayer)
			end
		})
	else
		local join_to_jobid_button = module.Tab_Teleport_Service:AddButton({
			Title = "Click To Join JobId",
			Description = "JobID:" .. game.JobId,
			Callback = function()
				if IsStudio then
					print("TeleportService:TeleportToPlaceInstance(",game.PlaceId, ",\'", getclipboard(), "',",LocalPlayer,")")
					return
				end
				TeleportService:TeleportToPlaceInstance(game.PlaceId, getclipboard(),LocalPlayer)
			end
		})
	end
end
return module
