AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 55
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	
	self.cur = 0
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
end

function ENT:Use( activator, caller )
	if self.cur > CurTime() then return end
	if not activator:IsPlayer() then return end
	self.cur=CurTime()+1
	
	sound.Play("buttons/button5.wav", self:GetPos(), 50, 100, 1)
	sound.Play("ambient/levels/labs/coinslot1.wav", self:GetPos(), 50, 100, 1)

	local ent = ents.Create( "durgz_water" )
	ent:SetPos(self:LocalToWorld(Vector(15,-5,-20)))
	ent:SetAngles(self:LocalToWorldAngles(Angle(0,0,90)))
	ent:Spawn()
	ent:Activate()
end