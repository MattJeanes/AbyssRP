/*-------------------------------------------------------------------------------------------------------------------------
	Allow a search warrant on someone!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Search Warrant"
PLUGIN.Description = "Allows an officer to open a suspect's doors!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "warrant"

function PLUGIN:Call( ply, args )
	
	if not (ply:Team()==RP:GetTeamN("mayor") or ply:Team()==RP:GetTeamN("police chief")) then
		RP:Error(ply, RP.colors.white, "You are not the mayor/police chief!")
		return
	end
	
	local players = RP:FindPlayer( args, ply, true, true )
	local enabled = ( tonumber( args[ #args ] ) or 1 ) > 0
	
	if ( #players > 1 ) then
		RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
		return
	elseif ( #players == 0 ) then
		RP:Notify( ply, RP.colors.red, "No matching players." )
		return
	else

		
		if enabled then
		
			players[1].Warranted = true
			
			RP:Notify(RP.colors.blue, players[1]:Nick(), RP.colors.white, " now has a search warrant!")
			ScreenNotify(players[1]:Nick() .. " now has a search warrant!")
			
		else
		
			players[1].Warranted = false
			
			RP:Notify(RP.colors.blue, players[1]:Nick(), RP.colors.white, " no longer has a search warrant!")
			ScreenNotify(players[1]:Nick() .. " no longer has a search warrant!")
			
		end
	end
end

RP:AddPlugin( PLUGIN )