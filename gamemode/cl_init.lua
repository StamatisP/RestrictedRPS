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
local RRPSvars = {}
local pmeta = FindMetaTable("Player")

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

function GetPlayerVarFromServer()
	//net.Start("RequestPlayerVar")
		//net.WriteString(P) // think of how i want to return the player money in the hud and such
end

hook.Add("Think", "InputManager", inputManager)
hook.Add("Think","e_pressed", keyUse)

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

function pmeta:ReturnPlayerVar(var)
	if not var then ErrorNoHalt("you forgot to put a var to return") return end
	local vars = RRPSvars[self:UserID()]
	//this runs on the player themselves btw
	return vars and vars[var] or nil
end

local function RetrievePlayerVar(userID, var, value)
	local ply = Player(userID)
	RRPSvars[userID] = RRPSvars[userID] or {}

	RRPSvars[userID][var] = value

	if IsValid(ply) then
		ply.RRPSvars = RRPSvars[userID]
	end
end

local function DoRetrieve()
	local userID = net.ReadUInt(16)
	local var, value = ReadRRPSVar()

	RetrievePlayerVar(userID, var, value)
end
net.Receive("UpdatePlayerVar", DoRetrieve)

local function InitializeRRPSvars(len)
	local plyCount = net.ReadUInt(8)

	for i = 1, plyCount, 1 do
		local userID = net.ReadUInt(16)
		local varCount = net.ReadUInt(10)

		for j = 1, varCount, 1 do
			local var, value = ReadRRPSVar()
			RetrievePlayerVar(userID, var, value)
		end
	end
end
net.Receive("RRPS_InitializeVars", InitializeRRPSvars)
timer.Simple(0, function()
	RunConsoleCommand("_sendRRPSvars")
end)

net.Receive("RRPS_VarDisconnect", function(len)
	local userID = net.ReadUInt(16)
	RRPSvars[userID] = nil
end)

timer.Create("checkifitcame", 15, 0, function()
	for _, v in ipairs(player.GetAll()) do
		if v:ReturnPlayerVar("money") then continue end

		RunConsoleCommand("_sendRRPSvars")
		return
	end
	timer.Remove("checkifitcame")
end)