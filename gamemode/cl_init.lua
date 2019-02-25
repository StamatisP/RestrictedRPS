include( "shared.lua" )
include("database/cl_database.lua")
include("database/items.lua")
include("round_controller/cl_round_controller.lua")
include("lobby_manager/cl_lobby.lua")
include("hud.lua")
include("cl_tablecam.lua")
include("cl_options.lua")
include("sh_soundmanager.lua")

local delay = 2
local lastOccurrence = -delay

MySelf = MySelf or NULL
hook.Add("InitPostEntity", "GetLocal", function() 
	MySelf = LocalPlayer()
end)

local function keyUse()
	if hook.Run("StartChat") then return end
	if input.IsKeyDown(KEY_E) then 
		print(TablePlayerIsUsing)
		local timeElapsed = CurTime() - lastOccurrence
		if timeElapsed < delay then 
			return
		end
		lastOccurrence = CurTime()
		//print("e pressed")
		net.Start("KEY_USE")
		net.SendToServer()

		hook.Run("KEY_USE")
	end
end

local function inputManager()
	if input.IsKeyDown(KEY_Z) then
		local timeElapsed = CurTime() - lastOccurrence
		if timeElapsed < delay then
			return
		else
			lastOccurrence = CurTime()
			net.Start("ZawaPlay")
			-- ZawaPlay is in init.lua
			net.SendToServer()
		end
	end
end

hook.Add("Think", "InputManager", inputManager)
hook.Add("Think","e_pressed", keyUse)

CreateClientConVar("rps_money", "1000000", false, true, "Amount of money you desire.")
CreateClientConVar("rps_selection", "Broken", false, true, "Your card selection.")