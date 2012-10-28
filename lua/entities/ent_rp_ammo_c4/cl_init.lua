include('shared.lua')

language.Add("ent_rp_ammo_c4", "Box of Ammo")
language.Add("C4_ammo", "C4 Explosive")

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