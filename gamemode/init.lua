AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile("cl_database.lua")
AddCSLuaFile("items.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_round_controller.lua")
AddCSLuaFile("cl_lobby.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("cl_tablecam.lua")
AddCSLuaFile("sounds.lua")
AddCSLuaFile("sh_soundmanager.lua")
AddCSLuaFile("cl_options.lua")
AddCSLuaFile("cl_jukebox.lua")
AddCSLuaFile("medialib.lua")
AddCSLuaFile("music.lua")
AddCSLuaFile("cl_credits.lua")
AddCSLuaFile("cl_buyout.lua")
AddCSLuaFile("circles.lua")

include("sv_database.lua")
include("items.lua")
include( "shared.lua" )
include("sv_round_controller.lua")
include("sv_lobby.lua")
include("sv_tablecam.lua")
include("sounds.lua")
include("sh_soundmanager.lua")
include("sv_soundmanager.lua")
include("sv_sql.lua")
//include("mysqlite.lua")

function GM:AddNetworkStrings()
	util.AddNetworkString("OpenLobby")
	util.AddNetworkString("StartGame")
	util.AddNetworkString("closeLobby")
	util.AddNetworkString("KEY_USE")
	util.AddNetworkString("ZawaPlay")
	util.AddNetworkString("UpdateRoundStatus")
	util.AddNetworkString("database")
	util.AddNetworkString("UpdateTableView")
	util.AddNetworkString("InventoryDrop")
	util.AddNetworkString("RemovePlayer")
	util.AddNetworkString("FadeInMusic")
	util.AddNetworkString("PlayerTableCheckGUIEnable")
	util.AddNetworkString("ArePlayersReady")
	util.AddNetworkString("AnnounceWinnerOfMatch")
	util.AddNetworkString("UpdatePlayerVar")
	util.AddNetworkString("RRPS_InitializeVars")
	util.AddNetworkString("RRPS_VarDisconnect")
	util.AddNetworkString("SendLeaderboardInfo")
	util.AddNetworkString("PlayerReady")
	util.AddNetworkString("BuyoutPlayer")
	util.AddNetworkString("AnnounceVictory")
	util.AddNetworkString("PrivateMessage")
	util.AddNetworkString("UpdateRoundCompoundTimes")
	util.AddNetworkString("PlayerTableUpdate") // naming sucks... this is for when a player wins a match at table
	util.AddNetworkString("PlayerTableStatusUpdate")
end

local playermodels = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl"
}

GM:AddNetworkStrings()

/*resource.AddFile("materials/models/gamecard/GameCard_Rock.vmt")
resource.AddFile("materials/models/gamecard/GameCard_Paper.vmt")
resource.AddFile("materials/models/gamecard/GameCard_Scissors.vmt")
resource.AddFile("sound/music/littlezawa_loop_by_bass.wav")
//resource.AddFile("sound/ambient/zawa1.wav")
//resource.AddFile("sound/ambient/zawa2.wav")
resource.AddFile("models/table/table.mdl")
resource.AddFile("materials/models/table/table_texture.vmt")
resource.AddFile("models/gamecard/gamecard.mdl")
resource.AddFile("materials/logo.png")*/
resource.AddFile("DSMarkerFelt.ttf")
resource.AddWorkshop("1694325066")

CreateConVar("rps_roundtime", player.GetCount() * 30, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Amount of time it takes for RRPS round to end.")

local developerMode = false
local pmeta = FindMetaTable("Player")
local voiceDistance = 400 * 400
local specSpawns = {}

local startWeapons = {
	"weapon_fists"
}

local function calcPlyCanHearPlayerVoice(listener)
	if not IsValid(listener) then return end
	//debugoverlay.Sphere(listener:GetPos(), 350, 1, Color(255, 255, 255, 255), false)
	listener.CanHear = listener.CanHear or {}
	local shootPos = listener:GetShootPos()
	for _, talker in ipairs(player.GetAll()) do
		local talkerShootPos = talker:GetShootPos()
		listener.CanHear[talker] = (shootPos:DistToSqr(talkerShootPos) < voiceDistance)
	end
end
hook.Add("PlayerInitialSpawn","CanHearVoice", function(ply)
	timer.Create(ply:UserID() .. "CanHearVoice", 0.5, 0, Curry(calcPlyCanHearPlayerVoice, 2)(ply)) // no idea what im doin but if darkrp did it it should be fine hopefully
end)
hook.Add("PlayerDisconnected", "CanHearVoice", function(ply)
	if not ply.CanHear then return end
	for _, v in ipairs(player.GetAll()) do
		if not v.CanHear then continue end
		v.CanHear[ply] = nil
	end
	timer.Remove(ply:UserID() .. "CanHearVoice")
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if not talker:Alive() then return false end

	local canHear = listener.CanHear and listener.CanHear[talker]
	return canHear, true
end

//local pmeta = FindMetaTable("Player")

/*function pmeta:GiveLoadout()
	for k, v in pairs(startWeapons) do
		self:Give(v)
	end
end*/

// TODO IN FUTURE: WithinABox seems to be useful to keep people out of places

hook.Add("InitPostEntity", "SpecSpawnFill", function()
	specSpawns = ents.FindByClass("spectator_spawn")
	//print(#ents.FindByClass("*"))
	//print("printing spec spawns")
	//PrintTable(specSpawns)
end)

function GM:PlayerSpawn(ply)
	if self.round_status == 1 then
		if ply:Team() == 2 then
			print("making " .. ply:Nick() .. " a blacksuit during the round")
			ply:UnSpectate()
			ply:SetupHands()
			ply:SetWalkSpeed(160)
			ply:SetRunSpeed(320)
			ply:SetCrouchedWalkSpeed(0.4)
			ply:SetAvoidPlayers(true)
			ply:Give("weapon_fists")
			ply:Give("weapon_empty_hands")
			ply:Give("weapon_kidnap")
			return 
		end
		if ply:GetNWBool("Defeated", false) or ply:GetNWBool("Dragged", false) then
			/*local newpos = table.Random(defeatedSpawns)
			ply:SetupHands()
			ply:SetWalkSpeed(150)
			ply:SetRunSpeed(320)
			ply:SetCrouchedWalkSpeed(0.4)
			ply:SetAvoidPlayers(true)
			ply:SetTeam(1)
			ply:SetPos(newpos:GetPos())*/
			print("making " .. ply:Nick() .. " unspectate after being defeated or dragged")
			ply:UnSpectate()
			return
		end
		print("Spectator " .. ply:Nick() .. " has spawned.")
		ply:UnSpectate()
		local newpos = specSpawns[math.random(#specSpawns)]
		//print(newpos)
		//print(math.random(#specSpawns))
		//print(#specSpawns)
		ply:SetModel(playermodels[math.random(#playermodels)])
		ply:SetPlayerColor(Vector(math.Rand(0.1, 1), math.Rand(0.1, 1), math.Rand(0.1, 1)))
		ply:SetupHands()
		ply:SetWalkSpeed(150)
		ply:SetRunSpeed(280)
		ply:SetCrouchedWalkSpeed(0.4)
		ply:SetAvoidPlayers(true)
		ply:SetTeam(3)
		ply:SetPos(newpos:GetPos())
		net.Start("CloseLobby")
		net.Send(ply)
		return
	else
		ply:UnSpectate()
		math.randomseed(os.time())
		ply:SetModel(playermodels[math.random(#playermodels)])
		ply:SetPlayerColor(Vector(math.Rand(0.1, 1), math.Rand(0.1, 1), math.Rand(0.1, 1)))
		ply:SetupHands()
		ply:SetWalkSpeed(150)
		ply:SetRunSpeed(280)
		ply:SetCrouchedWalkSpeed(0.4)
		ply:SetAvoidPlayers(true)
		ply:SetTeam(1)
		net.Start("OpenLobby")
		net.Send(ply)
	end
end

function GM:PlayerInitialSpawn(ply) 
	print("Player "..ply:Name().." has spawned.")
	ply.RRPSvars = ply.RRPSvars or {}
	if GetGlobalBool("IsRoundStarted", false) then
		ply:SetTeam(3)
	end
end

function GM:GetFallDamage(ply, speed)
	return 0
end

function GM:PlayerConnect(name, ip) 
	print("Player "..name.." has connected with IP ("..ip..")")
end

function GM:ShowHelp(ply)
	if not GetGlobalBool("IsRoundStarted") then return end
	ply:ConCommand("inventory")
end

function GM:ShowTeam(ply)
	ply:ConCommand("jukebox")
end

function GM:ShowSpare1(ply)
	if not GetGlobalBool("IsRoundStarted", false) then return end
	ply:ConCommand("rps_buyout")
end

function GM:ShowSpare2(ply)
	ply:ConCommand("rps_credits")
end

function GM:PlayerAuthed(ply, steamID, uniqueID)
	print("Player: ".. ply:Nick() .. ", has gotten authed.")
	//ply:databaseCheck()
end

function GM:CanPlayerSuicide( ply )
	return ply:IsSuperAdmin()
end

function GM:PlayerDisconnected(ply)
	ply:databaseDisconnect()
end

hook.Add("PlayerSay", "CommandIdent", function(ply, text, team)
	local playerMsg = string.lower(text)
	playerMsg = string.Explode(" ", playerMsg)
	// drop money command
	if (playerMsg[1] == "/dropmoney") then
		if (tonumber(playerMsg[2])) then
			local amount = tonumber(playerMsg[2])
			local plyBalance = ply:ReturnPlayerVar("money")

			local roundedamount = math.Round(amount, 2)
			if (roundedamount > 0 and roundedamount <= plyBalance) then
				ply:UpdatePlayerVar("money", plyBalance - roundedamount)

				scripted_ents.Get("money_entity"):SpawnFunction(ply, ply:GetEyeTrace(), "money_entity"):SetValue(roundedamount)
			end

			return ""
		end
		ply:ChatPrint("Usage: /dropmoney 1000")
		return ""
	end
	// give money command
	if (playerMsg[1] == "/givemoney") then
		if (tonumber(playerMsg[2])) then
			local amount = tonumber(playerMsg[2])
			local plyBalance = ply:ReturnPlayerVar("money")
			local roundedamount = math.Round(amount, 2)

			if (roundedamount > 0) then
				local tr = ply:GetEyeTrace()
				if (tr.Entity ~= ply) then
					if (tr.Entity:IsPlayer()) then
						print(tr.Entity)
						ply:UpdatePlayerVar("money", plyBalance - roundedamount)
						tr.Entity:UpdatePlayerVar("money", tr.Entity:ReturnPlayerVar("money") + roundedamount)
						ply:ChatPrint("You have given " .. tr.Entity:Nick() .. " $" .. roundedamount .. ".")
						return ""
					end
					ply:ChatPrint("You need to look at the target player!")
					return ""
				else
					ply:ChatPrint("You need to look at the target player!")
					return ""
				end
			else
				ply:ChatPrint("Amount must be greater than 0!")
				return ""
			end
		end
		ply:ChatPrint("Usage: /givemoney 1000")
		return ""
	end
	// check cards command
	if (playerMsg[1] == "/cards") then
		local rockcardAmount = 0
		local papercardAmount = 0
		local scissorscardAmount = 0
		for k, v in pairs(player.GetAll()) do
			//if (v:databaseGetValue("rockcards") == nil) then ErrorNoHalt("what is goin on") return end
			//print(v:inventoryGetItemAmount("rockcards"))
			if v:Team() == 1 then 
				rockcardAmount = rockcardAmount + v:ReturnPlayerVar("rockcards")
				papercardAmount = papercardAmount + v:ReturnPlayerVar("papercards")
				scissorscardAmount = scissorscardAmount + v:ReturnPlayerVar("scissorscards")
			end
		end
		ply:ChatPrint(string.format("There are %i rock cards, %i paper cards, and %i scissors cards remaining.", rockcardAmount, papercardAmount, scissorscardAmount))
		return ""
	end
	//pm command
	if (playerMsg[1] == "/pm") then
		if not isstring(playerMsg[2]) then ply:ChatPrint("Usage: /pm \"player name\" \"message\"") return "" end
		
		if FindPlayer(tostring(playerMsg[2])) then
			net.Start("PrivateMessage")
				net.WriteString(tostring(playerMsg[3]))
				net.WriteBool(false)
				net.WriteString(ply:Nick())
			net.Send(FindPlayer(tostring(playerMsg[2])))
		else
			print("player " .. playerMsg[2] .. " was not found!")
			ply:ChatPrint("Player not found. Try typing it differently.")
			return ""
		end
	end

	if (playerMsg[1] == "/dev") then
		if not ply:IsSuperAdmin() then return "" end
		if (tonumber(playerMsg[2])) then
			if (playerMsg[2] == "0") then developerMode = false end
			if (playerMsg[2] == "1") then developerMode = true end

			ply:ChatPrint("Setting developer mode to " .. tostring(developerMode))
			return ""
		end
	end

	if (playerMsg[1] == "/setnwint") then
		//print(playerMsg[2], playerMsg[3])
		if not ply:IsSuperAdmin() or not developerMode then return "" end
		if not playerMsg[2] or not playerMsg[3] then print("hu???", playerMsg[2], playerMsg[3]) return "" end
		if (playerMsg[2] == "luck") then ply:SetNWInt("Luck", tonumber(playerMsg[3])) end
		print("fug")
		//ply:SetNWInt(playerMsg[2], tonumber(playerMsg[3]))
		return ""
	end

	if (playerMsg[1] == "/getnwint") then
		if not ply:IsSuperAdmin() or not developerMode then return "" end
		if not playerMsg[2] then return "" end
		if (playerMsg[2] == "luck") then ply:ChatPrint(ply:GetNWInt("Luck", 69)) end
		return ""
	end
	if (playerMsg[1] == "/endround") then
		if not ply:IsSuperAdmin() or not developerMode then return "" end
		gmod.GetGamemode():EndRound()
		ply:ChatPrint("round ended!")
		return ""
	end
	if (playerMsg[1] == "/spawnmoney") then
		if not ply:IsSuperAdmin() or not developerMode then return "" end
		if not tonumber(playerMsg[2]) then return "" end
		scripted_ents.Get("money_entity"):SpawnFunction(ply, ply:GetEyeTrace(), "money_entity"):SetValue(tonumber(playerMsg[2]))
		return ""
	end
	if (playerMsg[1] == "/takestars") then
		if not developerMode then return "" end
		ply:TakeAwayFromPlayerVar("stars", 3)
		return ""
	end
	if (playerMsg[1] == "/getstars") then
		if not developerMode then return "" end
		if not tonumber(playerMsg[2]) then return "" end
		ply:TakeAwayFromPlayerVar("stars", -tonumber(playerMsg[2]))
		return ""
	end
	if (playerMsg[1] == "/blacksuit") then
		if not developerMode then return "" end
		local newpos = ply:GetPos()
		ply:SetTeam(2)
		ply:SetPlayerColor(Vector(0, 0, 0))
		ply:Spawn()
		ply:SetPos(newpos)
		return ""
	end
	if (playerMsg[1] == "/victorious") then
		if not developerMode then return "" end
		ply:SetNWBool("Victorious", true)
		print(ply:Nick() .. " is victorious")
		net.Start("AnnounceVictory")
   		net.Send(ply)
		return ""
	end
	if (playerMsg[1] == "/help") then
		ply:ChatPrint([[
  Press F1 to open your Inventory.
  Press F2 to open the Jukebox.
  Press F3 to open the Buy Out menu.
  Press F4 to open the Credits.]])
		ply:ChatPrint([[
  Type /cards to check how many cards remain.
  Type /dropmoney (number) to drop money.
  Type /givemoney (number) to give money to who you are looking at.
  Type /pm to privately message someone.]])
		return ""
	end
end)

hook.Add("PlayerUse", "PreventUseTable", function(ply, ent)
	if not (IsValid(ent)) then return end
	//if ply:Team() == 3 then return false end

	if (ent:GetClass() == "rps_table") then
		ply:SetNWEntity("TableUsing", ent)
		if not (ply:ReturnPlayerVar("stars") >= 1) then 
			print(ply:GetName() .. " has no stars") 
			return false
		end
		return true
	end

	//print(ent:GetName())

	if (ent:GetName() == "upper_button") then
		if not (ply:Team() == 2) and not (ply:GetNWBool("Victorious", false)) then
			//ply:ChatPrint("You cannot access the upper level until you are Victorious.")
			//print("ply is not a blacksuit and not victorious")
			return false
		end
		return true
	end

	if (ent:GetClass() == "func_button") then
		//print(ply:Team())
		if not (ply:Team() == 2) then 
			//print("non-blacksuits cannot use") 
			return false 
		end
		return true
	end
end)

/*hook.Add("PlayerDisconnected", "DisconnectRRPSVars", function(len, ply)
	net.Start("RRPS_VarDisconnect")
		net.WriteUInt(ply:UserID(), 16)
	net.Broadcast()
end)*/

function GM:PlayerDisconnected(ply)
	net.Start("RRPS_VarDisconnect")
		net.WriteUInt(ply:UserID(), 16)
	net.Broadcast()
end

function ChatPrintToAllPlayers(message)
	for k, ply in pairs(player.GetAll()) do
		ply:ChatPrint(message)
	end
end

net.Receive("ZawaPlay", function(len, ply)
	sound.Play("zawa_sound", ply:GetPos())
end)

net.Receive("KEY_USE", function(len, ply)
	hook.Call("KEY_USE", GAMEMODE, ply)
end)

net.Receive("PlayerReady", function(len, ply)
	local bool = net.ReadBool()
	ply:SetNWBool("rps_ready", bool)
end)

net.Receive("BuyoutPlayer", function(len, ply)
	local person = net.ReadEntity()
	if not person then ErrorNoHalt("WTF PERSON IS NIL") return end

	if ply:ReturnPlayerVar("stars") < 3 then return end

	ply:TakeAwayFromPlayerVar("stars", 3)
	person:TakeAwayFromPlayerVar("stars", -3)
	person:SetNWBool("Defeated", false)
end)

function pmeta:UpdatePlayerVar(var, value, target)
	target = target or player.GetAll()

	local vars = self.RRPSvars

	vars = vars or {}
	vars[var] = value
	if not value then ErrorNoHalt("warning! no value!") return end

	net.Start("UpdatePlayerVar")
		net.WriteUInt(self:UserID(), 16)
		WriteRRPSVar(var, value)
	net.Send(target)
end

function pmeta:TakeAwayFromPlayerVar(var, value, target)
	target = target or player.GetAll()

	local val = self:ReturnPlayerVar(var) - value
	self:UpdatePlayerVar(var, val, target)
end

function pmeta:SetSelfRRPSVar(var, value)
    local vars = self.privateRRPSVars

    vars = vars or {}
    vars[var] = true

    self:UpdatePlayerVar(var, value, self)
end

function pmeta:ReturnPlayerVar(var)
	local vars = self.RRPSvars

	vars = vars or {}
	//if not vars[var] then return 0 end
	return vars[var]
end

function pmeta:SendRRPSVars()
	if self:EntIndex() == 0 then return end
	
	local plys = player.GetAll()

	net.Start("RRPS_InitializeVars")
		net.WriteUInt(#plys, 8)
		for _, target in ipairs(plys) do
			net.WriteUInt(target:UserID(), 16)

			local RRPSvars = {}
			for var, value in pairs(target.RRPSvars) do
				if self ~= target and (target.privateRRPSVars or {})[var] then continue end
				table.insert(RRPSvars, var)
			end

			local vars_cnt = #RRPSvars
			net.WriteUInt(vars_cnt, 10)
			for i = 1, vars_cnt, 1 do
				WriteRRPSVar(RRPSvars[i], target.RRPSvars[RRPSvars[i]])
			end
		end
	net.Send(self)
end
concommand.Add("_sendRRPSvars", function(ply)
	if ply.RRPSvarsSent and ply.RRPSvarsSent > (CurTime() - 3) then return end
	ply.RRPSvarsSent = CurTime()
	ply:SendRRPSVars()
end)

ReverseArgs = function(...)

   --reverse args by building a function to do it, similar to the unpack() example
   local function reverse_h(acc, v, ...)
      if select('#', ...) == 0 then
         return v, acc()
      else
         return reverse_h(function () return v, acc() end, ...)
      end
   end

   -- initial acc is the end of the list
   return reverse_h(function () return end, ...)
end

Curry = function(func, num_args)
    if not num_args then error("Missing argument #2: num_args") end
    if not func then error("Function does not exist!", 2) end
    -- helper
    local function curry_h(argtrace, n)
        if n == 0 then
            -- reverse argument list and call function
            return func(ReverseArgs(argtrace()))
        else
            -- "push" argument (by building a wrapper function) and decrement n
            return function(x)
                return curry_h(function() return x, argtrace() end, n - 1)
            end
        end
   end

   -- no sense currying for 1 arg or less
   if num_args > 1 then
      return curry_h(function() return end, num_args)
   else
      return func
   end
end

//MySQLite.initialize()