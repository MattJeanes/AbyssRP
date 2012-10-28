/*-------------------------------------------------------------------------------------------------------------------------
	It command
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "It"
PLUGIN.Description = "Represent an action on an object."
PLUGIN.Author = "Dr.Matt/Overv"
PLUGIN.ChatCommand = "it"
PLUGIN.Usage = "<action>"
PLUGIN.Privileges = { "It" }

function PLUGIN:Call( ply, args )
	local action = table.concat( args, " " )
	
	if ( #action > 0 ) then
		RP:Notify( RP.colors.white, "**", RP.colors.blue, tostring( action ) )
	else
		RP:Error( ply, RP.colors.white, "Invalid Arguments!" )
	end
end

RP:AddPlugin( PLUGIN )