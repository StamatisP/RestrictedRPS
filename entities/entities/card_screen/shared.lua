ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Sign"
ENT.Author = "Mac"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Text")
	self:NetworkVar("Vector", 0, "TColor")
end