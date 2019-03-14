AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()

	if (IsValid(phys)) then
		phys:Wake()
	end
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if (!tr.Hit) then return end

	tr.start = ply:EyePos()
	tr.endpos = ply:EyePos() + 95 * ply:GetAimVector()
	tr.filter = ply

	local trace = util.TraceLine(tr)

	local ent = ents.Create(ClassName)

	ent:SetValue(10)

	ent:SetPos(trace.HitPos)
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale(2, 0)

	return ent
end

function ENT:Use(activator, caller)
	print(activator:ReturnPlayerMoney("money") .. " before addition")
	//print(value)
	activator:UpdatePlayerMoney(activator:ReturnPlayerMoney() + self:GetValue())
	print(activator:ReturnPlayerMoney("money") .. " after addition")

	self:Remove()
end