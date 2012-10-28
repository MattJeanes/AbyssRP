/*-------------------------------------------------------------------------------------------------------------------------
	Send a private message to someone
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "PM"
PLUGIN.Description = "Send someone a private message."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "pm"
PLUGIN.Usage = "<playersayer> <message>"
PLUGIN.Privileges = { "Private messages" }

function PLUGIN:Call( ply, args )
	local players = RP:FindPlayer( args[1] )
	
	if ( #players < 2 or !players[1] ) then			
		if ( #players > 0 ) then
			local msg = table.concat( args, " ", 2 )
			
			if ( #msg > 0 ) then
				RP:Notify( ply, RP.colors.white, "To ", team.GetColor( players[1]:Team() ), players[1]:Nick(), RP.colors.white, ": " .. msg )
				RP:Notify( players[1], RP.colors.white, "From ", team.GetColor( ply:Team() ), ply:Nick(), RP.colors.white, ": " .. msg )
			else
				RP:Notify( ply, RP.colors.red, "No message specified." )
			end
		else
			RP:Error(ply, RP.colors.white, "No Players Found!")
		end
	else
		RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
	end
end

RP:AddPlugin( PLUGIN )