function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Player1")
	self:NetworkVar("Entity", 1, "Player2")
	self:NetworkVar("Bool", 0, "TableStarted")
	self:NetworkVar("Int", 0, "TableStatus")
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Table Entity"

ENT.Spawnable = false