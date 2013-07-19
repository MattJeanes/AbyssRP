include('shared.lua')

language.Add("ent_rp_ammo_9mm", "Box of Ammo")
language.Add("9MM_ammo", "9MM Ammo")

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