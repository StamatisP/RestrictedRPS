AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile("database/cl_database.lua")
AddCSLuaFile("database/items.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("round_controller/cl_round_controller.lua")
AddCSLuaFile("lobby_manager/cl_lobby.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("cl_tablecam.lua")
AddCSLuaFile("sounds.lua")
AddCSLuaFile("sh_soundmanager.lua")
AddCSLuaFile("cl_options.lua")

include("database/sv_database.lua")
include("database/items.lua")
include( "shared.lua" )
include("round_controller/sv_round_controller.lua")
include("lobby_manager/sv_lobby.lua")
include("sv_tablecam.lua")
include("sounds.lua")
include("sh_soundmanager.lua")
include("sv_soundmanager.lua")

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
end

GM:AddNetworkStrings()

------ Deletes a directory, this function is called recursively!--- do NOT use a trailing slash with this function.---
function file.PurgeDirectory(name)
	local files, directories = file.Find(name .. "/*", "DATA");

	-- Delete files 
	for a, f in pairs(files) do
		file.Delete(name .. "/" .. f);
	end-- Recurse directories
	for b, d in pairs(directories) do
		file.PurgeDirectory(name .. "/" .. d);
	end
	-- Delete directory folder, please note that if a single file in this directory failed to delete then-- this call will fail.  file.Delete can fail if it's open with something else, file.Open'd in another-- addon for example
    file.Delete(name)
end

if file.Exists("server/rrps/players","DATA") then
	file.PurgeDirectory("server/rrps/players")
	print("purging rps directory")
end


local startWeapons = {
	"weapon_fists"
}

//local pmeta = FindMetaTable("Player")

/*function pmeta:GiveLoadout()
	for k, v in pairs(startWeapons) do
		self:Give(v)
	end
end*/

function GM:PlayerSpawn(ply)
	ply:SetModel("models/player/group01/male_07.mdl")
end

function GM:PlayerConnect(name, ip) 
	print("Player "..name.." has connected with IP ("..ip..")")
end

function GM:PlayerInitialSpawn(ply) 
	print("Player "..ply:Name().." has spawned.")
end

function GM:PlayerAuthed(ply, steamID, uniqueID)
	print("Player: ".. ply:Nick() .. ", has gotten authed.")
	ply:databaseCheck()
end

function GM:PlayerDisconnected(ply)
	ply:databaseDisconnect()
end

hook.Add("PlayerSay", "CommandIdent", function(ply, text, team)
	local playerMsg = string.lower(text)
	playerMsg = string.Explode(" ", playerMsg)

	if (playerMsg[1] == "/dropmoney") then
		if (tonumber(playerMsg[2])) then
			local amount = tonumber(playerMsg[2])
			local plyBalance = ply:databaseGetValue("money")

			if (amount > 0 and amount <= plyBalance) then
				ply:databaseSetValue("money", plyBalance - amount)

				scripted_ents.Get("money_entity"):SpawnFunction(ply, ply:GetEyeTrace(), "money_entity"):SetValue(amount)
			end

			return ""
		end
	end

	if (playerMsg[1] == "/givemoney") then
		if (tonumber(playerMsg[2])) then
			local amount = tonumber(playerMsg[2])
			local plyBalance = ply:databaseGetValue("money")
			if (amount > 0) then
				ply:databaseSetValue("money", plyBalance + amount)
				print("giving " .. ply:Nick() .. " money")
			end

			return ""
		end
	end
end)

function GM:CanPlayerSuicide( ply )
	return ply:IsSuperAdmin()
end

net.Receive("ZawaPlay", function(len, ply)
	ReadSound("ambient/zawa1.wav", false)
	print("zawa")
end)

net.Receive("KEY_USE", function(len, ply)
	hook.Call("KEY_USE", GAMEMODE, ply)
end)

/*hook.Add("Think", "PlayerStopMove", function()
	for _, v in pairs(player.GetAll()) do
		//print(v:GetNWBool("TableView"))
		if v:GetNWBool("TableView") then
			v:SetAbsVelocity(Vector(0,0,0))
		end
	end
end)*/

-- Music controller here.
-- idea: have music randomly chosen, or maybe chosen based on how successful you are

/*timer.Simple(945, function() 
	--plays 945 seconds in, 16 minutes 45 seconds. to fit in zawa song
	ReadSound("music/ultrazawa.wav", true)
end)*/ -- NO NO NO IF IT'S SERVERSIDE THEN IT'S A BITCH
