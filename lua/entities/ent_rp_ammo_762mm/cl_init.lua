include('shared.lua')

language.Add("ent_rp_ammo_762mm", "Box of Ammo")
language.Add("7.62MM_ammo", "7.62MM Ammo")

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