AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	
	self:SetText("Default bad text")
	self:SetTColor(Vector(2.55,2,0))
	
	self:SetModel("models/hunter/plates/plate5x6.mdl") // change this to something bigger
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial("phoenix_storms/mat/mat_phx_carbonfiber")
	self:SetColor(Color(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	phys:EnableMotion(false)
	//self:SetPos(Vector(1225.0625, -4773.96875, 489.34375))
end