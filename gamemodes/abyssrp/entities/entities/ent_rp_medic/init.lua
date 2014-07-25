AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Owner = self.Owner

	if !IsValid(self.Owner) then
		self:Remove()
		return
	end

	self:SetModel("models/items/healthkit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	undo.Create("Medic Kit")
		undo.AddEntity(self)
		undo.SetPlayer(self.Owner)
	undo.Finish()

	self:SetUseType(SIMPLE_USE)
end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)

	self:EmitSound(Sound("HealthVial.Touch"))
	self:Remove()

	activator:SetHealth(100)
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	for _, v in pairs(ents.FindInSphere(self:GetPos(), 5)) do
		if (v:IsNPC()) then
			self:EmitSound(Sound("HealthVial.Touch"))
			self:Remove()

			v:SetHealth(100)
		end
	end
end