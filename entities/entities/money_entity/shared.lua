function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Value")
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money"
ENT.Author = "Mineturtle"
ENT.Contact = ""
ENT.Purpose = "Physical money"
ENT.Instructions = "Pick it up."

ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.Model = "models/props/cs_assault/Money.mdl"