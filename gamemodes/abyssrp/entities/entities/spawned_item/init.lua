AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	self:SetSharedOwner()
	if phys and phys:IsValid() then phys:Wake() end
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
end


function ENT:Use(activator,caller)	
	local item = ents.Create(self.info.class)
	if not IsValid(item) then return false end
	
	if not (self.Owner==activator) and activator:GetCash() < self.info.cost then
		RP:Error(activator, RP.colors.white, "Not enough cash! You need: ", RP.colors.blue, RP:CC(cost), RP.colors.white, ".")
		return false
	end
	
	item:SetAngles(self:GetAngles())
	item:SetPos(self:GetPos())
	item.ShareGravgun = true
	item.nodupe = true
	if self.info.class=="rp_ammobox" then
		item.info=self.info
	end
	item:Spawn()
	self:Remove()
	
	if self.Owner ~= activator then
		activator:TakeCash(self.info.cost)
		self.Owner:AddCash(self.info.cost)
	end
end
