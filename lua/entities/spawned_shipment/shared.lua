ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Shipment"
ENT.Author = "philxyz"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "owning_ent")
end