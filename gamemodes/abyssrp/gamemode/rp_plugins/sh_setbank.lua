/*-------------------------------------------------------------------------------------------------------------------------
	Set your bank amount!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Set Bank"
PLUGIN.Description = "Set your bank amount!"
PLUGIN.Author = "Overv/Matt J"
PLUGIN.ChatCommand = "setbank"
PLUGIN.Usage = "<player> <cash>"
PLUGIN.Privileges = { "Set Bank" }

function PLUGIN:Call( ply, args )
	if not ply:RP_IsAdmin() then RP:Error(ply, RP.colors.white, "You are not an admin!") return end
	if ( #args == 2 ) then
		local players = RP:FindPlayer( args, ply, true, true )
		if tonumber(args[2]) then
			if ( #players == 1 ) then
				players[1]:SetBank(tonumber(args[2]))
				if ply == players[1] then
					RP:Notify( ply, RP.colors.white, "You have set your own bank amount to: ", RP.colors.blue, RP:CC(args[2]), RP.colors.white, ".")
				else
					RP:Notify( ply, RP.colors.white, "You have set ", RP.colors.blue, players[1]:Nick() .. "s", RP.colors.white, " bank balance to: ", RP.colors.blue, RP:CC(args[2]), RP.colors.white, "!" )
					RP:Notify( players[1], RP.colors.blue, ply:Nick(), RP.colors.white, " has set your bank amount to: ", RP.colors.blue, RP:CC(args[2]), RP.colors.white, "!" )
				end
			elseif ( #players > 1 ) then
				RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
			else
				RP:Notify( ply, RP.colors.red, "No matching players with an equal or lower immunity found." )
			end
		else
			RP:Notify( ply, RP.colors.red, "ERROR: ", RP.colors.white, "Invalid arguments!")
		end
	else
		RP:Notify( ply, RP.colors.red, "ERROR: ", RP.colors.white, "Invalid arguments!" )
	end
end

RP:AddPlugin( PLUGIN )