include('shared.lua')

language.Add("ent_rp_ammo_46mm", "Box of Ammo")
language.Add("4.6MM_ammo", "4.6MM Ammo")

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