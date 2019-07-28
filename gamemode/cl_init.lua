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
include("cl_credits.lua")
include("cl_buyout.lua")
include("sounds.lua")

local delay = 2
local lastOccurrence = -delay
RoundStarted = false
CompoundTimer = nil
RoundTimer = nil
//TablePlayerIsUsing = LocalPlayer():GetNWEntity("TableUsing", NULL) or nil
local RRPSvars = {}
local pmeta = FindMetaTable("Player")
local _OLDSCRW

MySelf = MySelf or NULL
hook.Add("InitPostEntity", "GetLocal", function() 
	MySelf = LocalPlayer()
end)

function CreateGameFonts()
	surface.CreateFont( "SongTitle", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = ScrW() / 76.8,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
	})

	surface.CreateFont("RoundLobbyFont",{
		font = "Arial",
		size = ScrW() / 76.8,
		weight = 500,
		antialias = true
	})

	surface.CreateFont("NormalText", {
		font = "Arial",
		size = ScrW() / 48,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
	})

	surface.CreateFont("CardText", {
		font = "DS Marker Felt",
		size = ScrW() / 38.4,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})
end

local function keyUse()
	if hook.Run("StartChat") then print("startchat true") return end
	if gui.IsConsoleVisible() then return end
	if input.IsKeyDown(KEY_E) then
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
		//hook.Run("PlayerTableWin")
	end
	/*if input.IsKeyDown(KEY_P) then
		local timeElapsed = CurTime() - lastOccurrence
		if timeElapsed < delay then 
			//print(timeElapsed .. " < " .. delay)
			return
		end
		lastOccurrence = CurTime()
		hook.Run("PlayerTableLoss")
	end*/
end

local function ZawaZawa()
	local zawaDelay = math.random(15, 30) // in seconds
	// if luck is 100, player will hear the zawas every 3 minutes
	print("next zawa in " .. zawaDelay .. " seconds.")
	timer.Create("ZawaPlayer", zawaDelay, 0, function()
		local plyLuck = LocalPlayer():GetNWInt("Luck", 50)
		zawaDelay = Lerp(plyLuck / 100, math.random(15, 30), math.random(180, 220))
		timer.Adjust("ZawaPlayer", zawaDelay, 0)
		//sound.Play("zawa_sound", LocalPlayer:GetPos()) // should this be serverside?
		net.Start("ZawaPlay")
		net.SendToServer()
		print("next zawa in " .. zawaDelay .. " seconds.")
		print(timer.TimeLeft("ZawaPlayer"))
	end)
end

hook.Add("Think","e_pressed", keyUse)
hook.Add("RoundStarted", "ZawaSounds", ZawaZawa)

//i should implement credits one day... thank you bass

net.Receive("AnnounceWinnerOfMatch", function(len, ply)
	local player1 = net.ReadString()
	local player2 = net.ReadString()
	local player1Choice = net.ReadString()
	local player2Choice = net.ReadString()
	local isTie = net.ReadBool()

	if player1 != LocalPlayer():GetName() and player2 != LocalPlayer():GetName() then return end
	if !isTie then 
		chat.AddText(Color(0, 255, 0, 255), player1, Color(255, 255, 255, 255), " has beaten ", Color(255, 0, 0, 255), player2, Color(255, 255, 255, 255), ", with ", Color(0, 255, 0, 255), player1Choice, Color(255, 255, 255, 255), " vs ", Color(255, 0, 0, 255),  player2Choice .. ".")
	elseif isTie then
		chat.AddText("This match ended in a tie! The match was " .. player1Choice .. " vs " .. player2Choice .. ".")
	end
end)

net.Receive("AnnounceVictory", function(len)
	chat.AddText(Color(0, 255, 0, 255), "Congratulations, you are victorious! Please go upstairs and enjoy your reward.")
end)

net.Receive("PrivateMessage", function(len)
	local message = net.ReadString()
	local anon = net.ReadBool() // ill implement this one day
	local sender = net.ReadString()
	
	if anon then
		chat.AddText(Color(100, 100, 255), "An anonymous player has sent you a message: ", Color(255, 100, 100), message)
	else
		chat.AddText(Color(100, 100, 255), sender, " has sent you a message: ", Color(255, 100, 100), message)
	end
end)

net.Receive("UpdateRoundCompoundTimes", function()
	local compound = net.ReadFloat()
	local round = net.ReadInt(16)

	CompoundTimer = compound
	RoundTimer = round
end)

net.Receive("PlayerTableUpdate", function()
	local haveWon = net.ReadBool()
	print("player table update")
	if haveWon then
		hook.Run("PlayerTableWin")
	else
		hook.Run("PlayerTableLoss")
	end
end)

net.Receive("PlayerTableStatusUpdate", function()
	hook.Run("PlayerTableEnter")
end)

CreateClientConVar("rps_money", "1000000", false, true, "Amount of money you desire.")
CreateClientConVar("rps_selection", "Broken", false, true, "Your card selection.")

function pmeta:ReturnPlayerVar(var)
	if not var then ErrorNoHalt("you forgot to put a var to return") return end
	local vars = RRPSvars[self:UserID()]
	//this runs on the player themselves btw
	//print(vars[var])
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
	for _, v in pairs(player.GetAll()) do
		if v:ReturnPlayerVar("money") then continue end

		RunConsoleCommand("_sendRRPSvars")
		return
	end
	timer.Remove("checkifitcame")
end)

CreateGameFonts()
hook.Add("PostRender", "RedrawFonts", function()
	if _OLDSCRW then
		if ScrW() ~= _OLDSCRW then
			CreateGameFonts()
			print("Recreating fonts due to screen resolution change.")
			_OLDSCRW = ScrW()
		end
	else
		_OLDSCRW = ScrW()
	end
end)