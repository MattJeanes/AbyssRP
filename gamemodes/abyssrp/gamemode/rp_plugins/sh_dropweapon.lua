/*-------------------------------------------------------------------------------------------------------------------------
	Drop a weapon!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Drop weapon"
PLUGIN.Description = "Allows a player to drop their weapon!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "drop"

function PLUGIN:Call( ply, args )
	local success=RP:PlayerDropWeapon(ply)
	if success then
		RP:Notify(ply, RP.colors.white, "You have dropped your current weapon!")
	else
		RP:Error(ply, RP.colors.white, "You cannot drop this weapon!")
	end
end

RP:AddPlugin( PLUGIN )