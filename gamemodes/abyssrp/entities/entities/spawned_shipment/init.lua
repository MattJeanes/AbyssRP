AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity.Destructed = false
	self.Entity:SetModel("models/Items/item_item_crate.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetNWString("name", self.Entity.Name)
	self.Entity:SetNWInt("count", self.Entity.Count)
	self.Entity:SetNWInt("cost", self.Entity.DefaultCost)
	self.Entity:SetNWString("Owner", "Shared")
	self.locked = true
	self.IsShipment = true
	timer.Simple( GetConVarNumber( "rp_shipmentspawntime" ), function() if IsValid( self ) then self.locked = false end end )
	self.damage = 100
	self.Entity.ShareGravgun = true
	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end

function ENT:OnTakeDamage(dmg)
	if not self.locked then
		self.damage = self.damage - dmg:GetDamage()
		if self.damage <= 0 then
			self.Entity:Destruct()
		end
	end
end

function ENT:Use()
	if not self.locked then
		self.locked = true -- One activation per second
		self.sparking = true
		timer.Create(self.Entity:EntIndex() .. "crate", 1, 1, function() self.SpawnItem(self) end)
	end
end

function ENT:SpawnItem()
	if not IsValid(self.Entity) then return end
	timer.Destroy(self.Entity:EntIndex() .. "crate")
	self.sparking = false
	local count = self.Entity.Count
	local pos = self:GetPos()
	local cost = tonumber(self.Entity.Cost) or tonumber(self.Entity.DefaultCost)
	local owner = self.Entity.TheOwner
	local class = self.Entity.Class
	local model = self.Entity.Model
	if count <= 1 then self.Entity:Remove() end
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
		weapon.TheOwner = owner
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
	self.Entity.Count = count
	self.Entity:SetNWInt("count", count)
	self.locked = false
end

function ENT:Think()
	if self.sparking then
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
end


function ENT:Destruct()
	if self.Entity.Destructed then return end
	self.Entity.Destructed = true
	
	local count = tonumber(self.Entity.Count)
	local class = self.Entity.Class
	local vPoint = self.Entity:GetPos()
	local cost = tonumber(self.Entity.Cost) or tonumber(self.Entity.DefaultCost)
	local model = self.Entity.Model
	local owner = self.Entity.TheOwner
	
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
		weapon.TheOwner = owner
		weapon.ShareGravgun = true
		weapon:SetPos(Vector(vPoint.x, vPoint.y, vPoint.z + (i*5)))
		weapon.nodupe = true
		weapon:Spawn()
	end
	self.Entity:Remove()
end
