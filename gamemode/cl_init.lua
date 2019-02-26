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
	if hook.Run("StartChat") then print("startchat true") return end
	if input.IsKeyDown(KEY_E) then 
		print(TablePlayerIsUsing)
		local timeElapsed = CurTime() - lastOccurrence
		if timeElapsed < delay then 
			//print(timeElapsed .. " < " .. delay)
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
		//print(LocalPlayer():GetNWBool("TableView"))
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

net.Receive("AnnounceWinnerOfMatch", function(len, ply)
	local player1 = net.ReadString()
	local player2 = net.ReadString()
	local player1Choice = net.ReadString()
	local player2Choice = net.ReadString()
	local isTie = net.ReadBool()

	if !isTie then 
		chat.AddText(player1 .. " has beaten " .. player2 .. ", with " .. player1Choice .. " vs " .. player2Choice)
	elseif isTie then
		chat.AddText("This match has ended in a tie! The match was " .. player1Choice .. " vs " .. player2Choice)
	end
end)

CreateClientConVar("rps_money", "1000000", false, true, "Amount of money you desire.")
CreateClientConVar("rps_selection", "Broken", false, true, "Your card selection.")