/*-------------------------------------------------------------------------------------------------------------------------
	Show the menu!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Menu"
PLUGIN.Description = "Open the menu"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "menu"

function PLUGIN:Call( ply, args )
	ply:ShowMenu()
end

RP:AddPlugin( PLUGIN )