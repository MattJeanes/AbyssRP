/*-------------------------------------------------------------------------------------------------------------------------
	Show the shop!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Shop"
PLUGIN.Description = "The Shop!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "shop"

function PLUGIN:Call( ply, args )
	local success=hook.Call("RP-Shop", GAMEMODE, ply)
	if success==false then
		RP:Error(ply, RP.colors.white, "There is no shop assigned to your class!")
	end
end

RP:AddPlugin( PLUGIN )