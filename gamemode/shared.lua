GM.Name = "Restricted Rock Paper Scissors"
GM.Author = "Mineturtle"
GM.Email = "no"
GM.Website = "nah"

GM.roundstart = 6
GM.endroundtime = 66
local maxId = 0
local RRPSvars = {}
local RRPSvarById = {}
local _roundstart = false

DeriveGamemode("base")

function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
end

function GM:CreateTeams()
	team.SetUp(1, "Players", Color(150, 100, 100, 255), false)
	team.SetUp(2, "Blacksuits", Color(20, 20, 20, 255), false)
	team.SetUp(TEAM_SPECTATOR, "Spectators", Color(200, 200, 0, 255), true)

	team.SetSpawnPoint(1, "info_player_deathmatch")
	team.SetSpawnPoint(2, "info_player_deathmatch")
	team.SetSpawnPoint(3, "info_player_deathmatch")
end	

function GM:GetRoundTime()
	return GetConVarNumber("rps_roundtime")
end

CreateConVar("rps_maxtime", 20, FCVAR_REPLICATED,"Max time for the round.")
CreateConVar("rps_interestrate", 0.015, FCVAR_REPLICATED,"Interest rate.")
CreateConVar("rps_interestrepeat", 75, FCVAR_REPLICATED,"Number of seconds until interest is done.") //75 in a 20 min game

hook.Add("StartCommand", "NullControl", function(ply, cmd)
	//print(GetGlobalBool("IsRoundStarted"))
	if ply:GetNWBool("TableView") then
		//print(ply:GetNWBool("TableView"))
		cmd:ClearMovement();
        cmd:RemoveKey( IN_ATTACK ); --See: https://wiki.garrysmod.com/page/Enums/IN
        cmd:RemoveKey( IN_JUMP );
        cmd:RemoveKey( IN_DUCK );
	end
	// why not work??
	// oh hey it works
	if not _roundstart then 
		cmd:ClearMovement();
        cmd:RemoveKey( IN_ATTACK ); --See: https://wiki.garrysmod.com/page/Enums/IN
        cmd:RemoveKey( IN_JUMP );
        cmd:RemoveKey( IN_DUCK );
	end
end)

hook.Add("RoundStarted", "commandround", function()
	_roundstart = true
end)

timer.Create("CheckRoundStarted", 5, 0, function()
	if _roundstart then timer.Destroy("CheckRoundStarted") return end
	_roundstart = GetGlobalBool("IsRoundStarted", false)
end)

function WriteRRPSVar(name, value)
	local RRPSvar = RRPSvars[name]
	if not RRPSvar then
		print("weird, RRPSvar is nil")
	end

	net.WriteUInt(RRPSvar.id, 8)
	return RRPSvar.writeFn(value)
end

function RegisterRRPSVar(name, writeFn, readFn)
	maxId = maxId + 1

	RRPSvars[name] = {id = maxId, name = name, writeFn = writeFn, readFn = readFn}
	RRPSvarById[maxId] = RRPSvars[name]
end

function ReadRRPSVar()
	local RRPSvarId = net.ReadUInt(8)
	local RRPSvar = RRPSvarById[RRPSvarId]

	local val = RRPSvar.readFn(value)
	return RRPSvar.name, val
end

function FindPlayer(text)
	if not text or text == "" then return nil end
	local players = player.GetAll()

	for k, v in pairs(players) do
		if string.find(string.lower(v:Nick()), string.lower(tostring(text)), 1, true) ~= nil then
			return v
		else
			print("could not find player " .. text)
		end
	end
	return nil
end

function fp(tbl)
    local func = tbl[1]

    return function(...)
        local fnArgs = {}
        local arg = {...}
        local tblN = table.maxn(tbl)

        for i = 2, tblN do fnArgs[i - 1] = tbl[i] end
        for i = 1, table.maxn(arg) do fnArgs[tblN + i - 1] = arg[i] end

        return func(unpack(fnArgs, 1, table.maxn(fnArgs)))
    end
end

Flip = function(f)
    if not f then error("not a function") end
    return function(b, a, ...)
        return f(a, b, ...)
    end
end

RegisterRRPSVar("money", net.WriteDouble, net.ReadDouble)
RegisterRRPSVar("debt", net.WriteDouble, net.ReadDouble)
RegisterRRPSVar("rockcards", fp{Flip(net.WriteInt), 8}, fp{net.ReadInt, 8})
RegisterRRPSVar("papercards", fp{Flip(net.WriteInt), 8}, fp{net.ReadInt, 8})
RegisterRRPSVar("scissorscards", fp{Flip(net.WriteInt), 8}, fp{net.ReadInt, 8})
RegisterRRPSVar("stars", fp{Flip(net.WriteInt), 8}, fp{net.ReadInt, 8})