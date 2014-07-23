/*-------------------------------------------------------------------------------------------------------------------------
	Show the menu!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Menu"
PLUGIN.Description = "Class specific menu"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "menu"

function PLUGIN:Call( ply, args )
	local success=ply:ShowMenu()
	if not success then
		RP:Error(ply, RP.colors.white, "There is no menu assigned to your class!")
	end
end

RP:AddPlugin( PLUGIN )