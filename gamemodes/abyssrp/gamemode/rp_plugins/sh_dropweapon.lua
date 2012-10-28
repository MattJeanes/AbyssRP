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

	for i=1,#NoDropWeapons do
			if ply:GetActiveWeapon():GetClass() == NoDropWeapons[i] then // Lua Error: Hook 'ChatCommands' Failed: Tried to use a NULL entity! - Attempted fix!
			RP:Notify(ply, RP.colors.white, "You cannot drop this weapon!")
			return
		end
	end
	
	ply:GetActiveWeapon().TheOwner = ply
	
	RP:Notify(ply, RP.colors.white, "You have dropped your current weapon!")

	ply:DropWeapon(ply:GetActiveWeapon())
	
end

RP:AddPlugin( PLUGIN )