AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Destructed = false
	self:SetModel("models/Items/item_item_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWInt("count", self.count)
	self:SetNWString("name", self.info.name)
	self:SetNWFloat("cost", self.cost)
	self:SetSharedOwner()
	self.locked = true
	self.IsShipment = true
	timer.Simple(2, function() if IsValid( self ) then self.locked = false end end)
	self.damage = 100
	self.ShareGravgun = true
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end

function ENT:OnTakeDamage(dmg)
	if not self.locked then
		self.damage = self.damage - dmg:GetDamage()
		if self.damage <= 0 then
			self:Destruct()
		end
	end
end

function ENT:Use()
	if not self.locked then
		self.locked = true -- One activation per second
		self.sparking = true
		timer.Create(self:EntIndex() .. "crate", 1, 1, function() self:UseSpawn() end)
	end
end

function ENT:UseSpawn()
	timer.Destroy(self:EntIndex() .. "crate")
	self.sparking = false
	if self.count <= 1 then self:Remove() end
	local item=RP.SpawnItem(self.Owner,self.info,self.cost,self:LocalToWorld(Vector(0,0,40)))
	
	if not IsValid(item) or not item:IsInWorld() then
		self.locked = false
		return
	end
	
	self.count = self.count - 1
	self:SetNWInt("count", self.count)
	self.locked = false
end

function ENT:Think()
	if self.sparking then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
end


function ENT:Destruct()
	if self.Destructed then return end
	self.Destructed = true

	local pos=self:GetPos()
	for i=1,self.count do
		RP.SpawnItem(self.Owner,self.info,self.cost,pos+Vector(0,0,i*5),Angle(0,0,0))
	end
	self:Remove()
end
