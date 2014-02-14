AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/Money.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_NPC)
	timer.Simple(300,function()
		if self.Entity then
			self.Entity:Remove()
		end
	end)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	self.Entity:SetNWInt("cash", self.Entity.Cash)
end

function ENT:Use(activator, caller)
	if IsValid(activator) then
		if activator:IsPlayer() and activator:Alive() then
			activator:AddCash(tonumber(self.Cash))
			if activator == self.Owner then
				RP:Notify(self.Owner, RP.colors.white, "You picked up your own dropped money: ", RP.colors.blue, "$".. tostring(self.Cash), RP.colors.white, "!")
			else
				RP:Notify(activator, RP.colors.white, "You have picked up ", team.GetColor(self.Owner:Team()), self.Owner:Nick(), RP.colors.white, "'s Cash: ", RP.colors.blue, "$".. tostring(self.Cash), RP.colors.white, "!")
				RP:Notify(self.Owner, RP.colors.blue, activator:Nick(), RP.colors.white, " picked up your dropped money!")
			end
			self:Remove()
		end
	end
end