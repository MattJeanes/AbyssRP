AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Destructed = false
	self:SetModel("models/Items/item_item_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWString("name", self.Name)
	self:SetNWInt("count", self.Count)
	self:SetNWInt("cost", self.DefaultCost)
	self:SetSharedOwner()
	self.locked = true
	self.IsShipment = true
	timer.Simple( GetConVarNumber( "rp_shipmentspawntime" ), function() if IsValid( self ) then self.locked = false end end )
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
		timer.Create(self:EntIndex() .. "crate", 1, 1, function() self.SpawnItem(self) end)
	end
end

function ENT:SpawnItem()
	if not IsValid(self) then return end
	timer.Destroy(self:EntIndex() .. "crate")
	self.sparking = false
	local count = self.Count
	local pos = self:GetPos()
	local cost = tonumber(self.Cost) or tonumber(self.DefaultCost)
	local owner = self.Owner
	local class = self.Class
	local model = self.Model
	if count <= 1 then self:Remove() end
		/*
		if string.find(class, "weapon") then
			local weapon = ents.Create("spawned_weapon")
			weapon:SetModel(model)
			weapon.ShareGravgun = true
			weapon.Class = class
			weapon:SetPos(pos + Vector(0,0,35))
			weapon.nodupe = true
			weapon:Spawn()
		else
			local item = ents.Create(class)
			item:SetModel(model)
			item.ShareGravgun = true
			item:SetNWString("Owner", "Shared")
			item:SetPos(pos + Vector(0,0,35))
			item:Spawn()
		end
		*/
		
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel(model)
		weapon.ShareGravgun = true
		weapon.Class = class
		weapon.Owner = owner
		weapon.Cost = cost
		weapon:SetPos(pos + self:GetAngles():Up()*40)
		weapon:SetAngles(self:GetAngles() + Angle(0,0,0))
		weapon.nodupe = true
		weapon:Spawn()
		
		timer.Simple(0.1,function()
			if not (weapon:IsInWorld()) then
				self.locked = false
				return
			end
		end)
			
	count = count - 1
	self.Count = count
	self:SetNWInt("count", count)
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
	
	local count = tonumber(self.Count)
	local class = self.Class
	local vPoint = self:GetPos()
	local cost = tonumber(self.Cost) or tonumber(self.DefaultCost)
	local model = self.Model
	local owner = self.Owner
	
	for i=1, count, 1 do
		/*
		if string.find(class, "weapon") then
			local weapon = ents.Create("spawned_weapon")
			weapon:SetModel(model)
			weapon.ShareGravgun = true
			weapon.Class = class
			weapon:SetPos(Vector(vPoint.x, vPoint.y, vPoint.z + (i*5)))
			weapon.nodupe = true
			weapon:Spawn()
		else
			local item = ents.Create(class)
			item:SetModel(model)
			item.ShareGravgun = true
			item:SetNWString("Owner", "Shared")
			item:SetPos(Vector(vPoint.x, vPoint.y, vPoint.z + (i*5)))
			item:Spawn()
		end
		*/
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel(model)
		weapon.Class = class
		weapon.Cost = cost
		weapon.Owner = owner
		weapon.ShareGravgun = true
		weapon:SetPos(Vector(vPoint.x, vPoint.y, vPoint.z + (i*5)))
		weapon.nodupe = true
		weapon:Spawn()
	end
	self:Remove()
end
