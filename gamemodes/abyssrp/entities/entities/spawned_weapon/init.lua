AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	self.Entity:SetNWString("Owner", "Shared")
	if phys and phys:IsValid() then phys:Wake() end
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
end


function ENT:Use(activator,caller)
	local class = self.Entity.Class
	local ammohax = self.Entity.ammohacked
	local weapon = ents.Create(tostring(class))
	local cost = self.Entity.Price
	
	if not weapon:IsValid() then return false end
	
	local CanPickup = hook.Call("PlayerCanPickupWeapon", GAMEMODE, activator, weapon)
	if not CanPickup then weapon:Remove() return end
	
	if self.Entity.SingleSpawn or (self.Entity.TheOwner:SteamID() == activator:SteamID()) then
		weapon:SetAngles(self.Entity:GetAngles())
		weapon:SetPos(self.Entity:GetPos())
		weapon.ShareGravgun = true
		weapon.nodupe = true
		weapon.ammohacked = ammohax
		weapon:Spawn()
		self.Entity:Remove()
		return
	end
	
	if activator:GetCash() >= cost then
		weapon:SetAngles(self.Entity:GetAngles())
		weapon:SetPos(self.Entity:GetPos())
		weapon.ShareGravgun = true
		weapon.nodupe = true
		weapon.ammohacked = ammohax
		weapon:Spawn()
		self.Entity:Remove()
		activator:TakeCash(cost)
		self.Entity.TheOwner:AddCash(cost)
	else
		RP:Error(ply, RP.colors.white, "Not enough cash! You need: ", RP.colors.blue, RP:CC(cost), RP.colors.white, ".")
		return false
	end
end
