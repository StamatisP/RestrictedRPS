GM.Name = "Restricted Rock Paper Scissors"
GM.Author = "Mineturtle"
GM.Email = "no"
GM.Website = "nah"

GM.roundstart = 6
GM.endroundtime = 66
local maxId = 0
local RRPSvars = {}
local RRPSvarById = {}

DeriveGamemode("base")

function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
end

function GM:GetRoundTime()
	return GetConVarNumber("rps_roundtime")
end

CreateConVar("rps_maxtime", 20, FCVAR_REPLICATED,"Max time for the round.")
CreateConVar("rps_interestrate", 0.015, FCVAR_REPLICATED,"Interest rate.")
CreateConVar("rps_interestrepeat", 75, FCVAR_REPLICATED,"Number of seconds until interest is done.") //75 in a 20 min game

hook.Add("StartCommand", "NullControl", function(ply, cmd)
	if ply:GetNWBool("TableView") then
		//print(ply:GetNWBool("TableView"))
		cmd:ClearMovement();
        cmd:RemoveKey( IN_ATTACK ); --See: https://wiki.garrysmod.com/page/Enums/IN
        cmd:RemoveKey( IN_JUMP );
        cmd:RemoveKey( IN_DUCK );
	end
end)

function WriteRRPSVar(name, value)
	local RRPSvar = RRPSvars[name]
	if not RRPSvar then
		print("weird")
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

RegisterRRPSVar("money", net.WriteDouble, net.ReadDouble)
RegisterRRPSVar("debt", net.WriteDouble, net.ReadDouble)