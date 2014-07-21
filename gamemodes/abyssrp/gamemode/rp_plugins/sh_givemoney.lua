/*-------------------------------------------------------------------------------------------------------------------------
	Give money away!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Give Money"
PLUGIN.Description = "Give your money away!"
PLUGIN.Author = "Overv/Matt J"
PLUGIN.ChatCommand = "givemoney"
PLUGIN.Usage = "<player> <money>"
PLUGIN.Privileges = { "Give Money", "Money Check" }

function PLUGIN:Call( ply, args )
	local players = RP:FindPlayer( args, ply, true, true )
	if ( #players == 1 ) then
		if players[1] == ply then
		RP:Error(ply, RP.colors.white, "You cannot send money to yourself!")
		return end
		if not string.find(args[2], "[^%d]") then
			local A = ply:GetCash()
			local B = tonumber(args[2]) or 0
			if A > B then
				ply:TakeCash(B)
				players[1]:AddCash(B)
				RP:Notify( ply, RP.colors.white, "You have given ", RP.colors.red, RP:CC(B), RP.colors.white, " to: ", RP.colors.blue, players[1]:Nick() )
				RP:Notify( players[1], RP.colors.white, "You have received ", RP.colors.red, RP:CC(B), RP.colors.white, " from: ", RP.colors.blue, ply:Nick() )
			else
				RP:Error( ply, RP.colors.white, "You do not have enough money to complete this transaction!" )
			end
		else
			RP:Error( ply, RP.colors.white, "You cannot give people words as money!")
		end
	elseif ( #players > 1 ) then
		RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
	else
		RP:Notify( ply, RP.colors.red, "No matching players with an equal or lower immunity found." )
	end
end

RP:AddPlugin( PLUGIN )