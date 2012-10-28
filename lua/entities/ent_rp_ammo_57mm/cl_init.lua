include('shared.lua')

language.Add("ent_rp_ammo_57mm", "Box of Ammo")
language.Add("5.7MM_ammo", "5.7MM Ammo")

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
	
	self.Entity:DrawModel()
end