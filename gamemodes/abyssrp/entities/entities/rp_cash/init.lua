AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/Money.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	timer.Simple(300,function()
		if IsValid(self) then
			self:Remove()
		end
	end)
	
	self:SetSharedOwner()
	
	local phys = self:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	if not self.Cash then
		self:Remove()
	end
	
	self:SetNWFloat("cash", self.Cash)
end

function ENT:Use(activator, caller)
	if IsValid(activator) then
		if activator:IsPlayer() and activator:Alive() then
			activator:AddCash(tonumber(self.Cash))
			hook.Call("RP-PickupCash", GAMEMODE, activator, tonumber(self.Cash), self.Owner)
			if activator == self.Owner then
				RP:Notify(self.Owner, RP.colors.white, "You picked up your own dropped cash: ", RP.colors.blue, RP:CC(self.Cash), RP.colors.white, "!")
			else
				if IsValid(self.Owner) then
					RP:Notify(activator, RP.colors.white, "You have picked up ", team.GetColor(self.Owner:Team()), self.Owner:Nick(), RP.colors.white, "'s Cash: ", RP.colors.blue, RP:CC(self.Cash), RP.colors.white, "!")
					RP:Notify(self.Owner, RP.colors.blue, activator:Nick(), RP.colors.white, " picked up your dropped cash!")
				else
					RP:Notify(activator, RP.colors.white, "You have picked up ", RP.colors.red, "Someone", RP.colors.white, "'s Cash: ", RP.colors.blue, RP:CC(self.Cash), RP.colors.white, "!")
				end
			end
			self:Remove()
		end
	end
end