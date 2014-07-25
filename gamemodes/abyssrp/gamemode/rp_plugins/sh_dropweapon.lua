/*-------------------------------------------------------------------------------------------------------------------------
	Drop a weapon!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Drop weapon"
PLUGIN.Description = "Allows a player to drop their weapon!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "drop"

function PLUGIN:Call( ply, args )
	if (!ply:Alive()) then
		RP:Error(ply, RP.colors.white, "You can't drop weapons, You're dead!")
		return
	end

	for k,v in pairs(RP:NoDropWeapons()) do
			if ply:GetActiveWeapon():GetClass() == v then // Lua Error: Hook 'ChatCommands' Failed: Tried to use a NULL entity! - Attempted fix!
			RP:Notify(ply, RP.colors.white, "You cannot drop this weapon!")
			return
		end
	end
	
	ply:GetActiveWeapon().Owner = ply
	ply:DropWeapon(ply:GetActiveWeapon())
	RP:Notify(ply, RP.colors.white, "You have dropped your current weapon!")	
end

RP:AddPlugin( PLUGIN )