include('shared.lua')

language.Add("ent_rp_fuel", "Gaz Can")

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