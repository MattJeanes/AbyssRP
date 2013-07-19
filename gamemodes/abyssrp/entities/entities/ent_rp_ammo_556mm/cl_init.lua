include('shared.lua')

language.Add("ent_rp_ammo_556mm", "Box of Ammo")
language.Add("5.56MM_ammo", "5.56MM Ammo")

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