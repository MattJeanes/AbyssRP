/*-------------------------------------------------------------------------------------------------------------------------
	Make someone feel wanted! Awh!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Wanted"
PLUGIN.Description = "Allows arresting on a player."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "wanted"
PLUGIN.Usage = "<player> <reason>"

function PLUGIN:Call( ply, args )
	if (ply:Team() == RP:GetTeamN("police chief")) or (ply:Team() == RP:GetTeamN("mayor")) or (ply:Team() == RP:GetTeamN("officer")) then
		local players = RP:FindPlayer( args, ply, true, true )
		local reason = table.concat( args, " ", 2 ) or ""
		if ( #players == 1 ) then
			if ( #reason > 0 ) then
				players[1].Wanted = true
				RP:Notify(RP.colors.blue, players[1]:Nick(), RP.colors.white, " is now wanted by Police with the reason \""..reason.."\".")
				ScreenNotify(players[1]:Nick() .. " is now wanted by Police!")
			else
				RP:Error( ply, "You need a reason!" )
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

local PLUGIN = {}
PLUGIN.Title = "Unwanted"
PLUGIN.Description = "Unwants a player."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "unwanted"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	if (ply:Team() == RP:GetTeamN("police chief")) or (ply:Team() == RP:GetTeamN("mayor")) or (ply:Team() == RP:GetTeamN("officer")) then
		local players = RP:FindPlayer( args, ply, true, true )
		if ( #players == 1 ) then
			players[1].Wanted = false
			RP:Notify(RP.colors.blue, players[1]:Nick(), RP.colors.white, " is no longer wanted by Police!")
			ScreenNotify(players[1]:Nick() .. " is no longer wanted by Police!")
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