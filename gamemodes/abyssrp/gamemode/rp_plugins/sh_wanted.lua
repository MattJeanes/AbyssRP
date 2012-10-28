/*-------------------------------------------------------------------------------------------------------------------------
	Make someone feel wanted! Awh!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Wanted"
PLUGIN.Description = "Allows arresting on a player."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "wanted"
PLUGIN.Usage = "<player> [1/0]"

function PLUGIN:Call( ply, args )
	if (ply:Team() == RP:GetTeamN("police chief")) or (ply:Team() == RP:GetTeamN("mayor")) or (ply:Team() == RP:GetTeamN("officer")) then
		local players = RP:FindPlayer( args, ply, true, true )
		local enabled = ( tonumber( args[ #args ] ) or 1 ) > 0
		if ( #players == 1 ) then
			if enabled then
			players[1].Wanted = true
			RP:Notify(RP.colors.blue, players[1]:Nick(), RP.colors.white, " is now wanted by Police!")
			ScreenNotify(players[1]:Nick() .. " is now wanted by Police!")
			else
			players[1].Wanted = false
			RP:Notify(RP.colors.blue, players[1]:Nick(), RP.colors.white, " is no longer wanted by Police!")
			ScreenNotify(players[1]:Nick() .. " is no longer wanted by Police!")
			end
		elseif ( #players > 1 ) then
			RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
		else
			RP:Notify( ply, RP.colors.red, "No matching players." )
		end
	else
		RP:Notify( ply, RP.colors.red, "You are not allowed to do that." )
	end
end

RP:AddPlugin( PLUGIN )