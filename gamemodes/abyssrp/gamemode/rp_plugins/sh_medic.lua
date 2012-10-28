/*-------------------------------------------------------------------------------------------------------------------------
	Meedic!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Medic!"
PLUGIN.Description = "Allows a player to call for a medic!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "medic"

function PLUGIN:Call( ply, args )
	local m=RP:GetTeamN("medic")
	
	if not m then return end
	
	if ply:Health() >= ply:GetMaxHealth() then
		RP:Error(ply, RP.colors.white, "You already have full health!")
		return
	end
	
	if ply:Team()==RP:GetTeamN("medic") then
		RP:Error(ply, RP.colors.white, "You are a medic! Right click with med-kit.")
		return
	end
	
	if team.NumPlayers(m)==0 then
		RP:Error(ply, RP.colors.white, "There are no medics!")
		return
	end
		
	RP:Notify(ply, RP.colors.white, "You have called for a medic!")

	for _, pl in pairs(team.GetPlayers(m)) do
		RP:Notify(pl, RP.colors.blue, ply:Nick(), RP.colors.white, " has requested a medic!")
		pl:PrintMessage(HUD_PRINTCENTER, ply:Nick() .. " has requested a medic!")
	end
	
end

RP:AddPlugin( PLUGIN )