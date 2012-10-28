include('shared.lua')

language.Add("ent_rp_ammo_50", "Box of Ammo")
language.Add(".50MM_ammo", ".50MM Ammo")

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