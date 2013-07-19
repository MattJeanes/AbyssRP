include('shared.lua')

language.Add("ent_rp_ammo_45", "Box of Ammo")
language.Add(".45MM_ammo", ".45MM Ammo")

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