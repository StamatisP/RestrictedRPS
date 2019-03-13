include( "shared.lua" )
include("cl_database.lua")
include("items.lua")
include("cl_round_controller.lua")
include("cl_lobby.lua")
include("hud.lua")
include("cl_tablecam.lua")
include("cl_options.lua")
include("sh_soundmanager.lua")
include("cl_jukebox.lua")
include("music.lua")

local delay = 2
local lastOccurrence = -delay
RoundStarted = false
TablePlayerIsUsing = nil

MySelf = MySelf or NULL
hook.Add("InitPostEntity", "GetLocal", function() 
	MySelf = LocalPlayer()
end)

local function keyUse()
	if hook.Run("StartChat") then print("startchat true") return end
	if gui.IsConsoleVisible() then return end
	if input.IsKeyDown(KEY_E) then 
		local eyetrace = LocalPlayer():GetEyeTrace()
		// check if eyetrace hit sky or world
		if eyetrace.HitSky == false then
			if eyetrace.HitWorld == false then
				if !eyetrace.Entity:IsPlayer() then
					TablePlayerIsUsing = eyetrace.Entity
				end	
			end
		end
		//print(TablePlayerIsUsing)
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

local tab = {
	[ "$pp_colour_addr" ] = 0.05,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1.1,
	[ "$pp_colour_colour" ] = 0.8,
	[ "$pp_colour_mulr" ] = 0.06,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

hook.Add("Think", "InputManager", inputManager)
hook.Add("Think","e_pressed", keyUse)
/*hook.Add("RenderScreenspaceEffects", "testingcolor", function()
	DrawColorModify(tab)
end)*/

//i should implement credits one day... thank you bass

net.Receive("AnnounceWinnerOfMatch", function(len, ply)
	local player1 = net.ReadString()
	local player2 = net.ReadString()
	local player1Choice = net.ReadString()
	local player2Choice = net.ReadString()
	local isTie = net.ReadBool()

	if player1 != LocalPlayer():GetName() and player2 != LocalPlayer():GetName() then return end
	if !isTie then 
		chat.AddText(player1 .. " has beaten " .. player2 .. ", with " .. player1Choice .. " vs " .. player2Choice .. ".")
	elseif isTie then
		chat.AddText("This match ended in a tie! The match was " .. player1Choice .. " vs " .. player2Choice .. ".")
	end
end)

CreateClientConVar("rps_money", "1000000", false, true, "Amount of money you desire.")
CreateClientConVar("rps_selection", "Broken", false, true, "Your card selection.")