ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pikmin TextScreen - Originally By SammyServers (thanks)"
ENT.Author = "SammyServers"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsPersisted")
end