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
	print(Variables)
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
