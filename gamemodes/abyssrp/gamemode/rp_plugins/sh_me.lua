/*-------------------------------------------------------------------------------------------------------------------------
	/me command
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Me"
PLUGIN.Description = "Represent an action."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "me"
PLUGIN.Usage = "<action>"
PLUGIN.Privileges = { "Me" }

function PLUGIN:Call( ply, args )
	local action = table.concat( args, " " )
	
	if ( #action > 0 ) then
		RP:Notify( team.GetColor(ply:Team()), ply:Nick(), RP.colors.white, " " .. tostring( action ) )
	else
		RP:Error( ply, RP.colors.white, "Invalid Arguments!" )
	end
end

RP:AddPlugin( PLUGIN )