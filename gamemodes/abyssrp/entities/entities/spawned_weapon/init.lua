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
	local class = self.Class
	local ammohax = self.ammohacked
	local weapon = ents.Create(tostring(class))
	local cost = self.Cost
	
	if not weapon:IsValid() then return false end
	
	local CanPickup = hook.Call("PlayerCanPickupWeapon", GAMEMODE, activator, weapon)
	if not CanPickup then weapon:Remove() return end
	
	if self.SingleSpawn or (self.Owner:SteamID() == activator:SteamID()) then
		weapon:SetAngles(self:GetAngles())
		weapon:SetPos(self:GetPos())
		weapon.ShareGravgun = true
		weapon.nodupe = true
		weapon.ammohacked = ammohax
		weapon:Spawn()
		self:Remove()
		return
	end
	
	if activator:GetCash() >= cost then
		weapon:SetAngles(self:GetAngles())
		weapon:SetPos(self:GetPos())
		weapon.ShareGravgun = true
		weapon.nodupe = true
		weapon.ammohacked = ammohax
		weapon:Spawn()
		self:Remove()
		activator:TakeCash(cost)
		self.Owner:AddCash(cost)
	else
		RP:Error(activator, RP.colors.white, "Not enough cash! You need: ", RP.colors.blue, RP:CC(cost), RP.colors.white, ".")
		return false
	end
end
