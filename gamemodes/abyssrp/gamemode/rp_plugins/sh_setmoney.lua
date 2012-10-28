/*-------------------------------------------------------------------------------------------------------------------------
	Set your money!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Set Money"
PLUGIN.Description = "Set your money!"
PLUGIN.Author = "Overv/Matt J"
PLUGIN.ChatCommand = "setmoney"
PLUGIN.Usage = "<player> <money>"
PLUGIN.Privileges = { "Set Money" }

function PLUGIN:Call( ply, args )
	if not ply:RP_IsAdmin() then RP:Error(ply, RP.colors.white, "You are not an admin!") return end
	if ( #args == 2 ) then
		local players = RP:FindPlayer( args, ply, true, true )
		if not string.find(args[2], "[^%d]") then
			if ( #players == 1 ) then
				players[1]:SetNWInt("cash", tonumber(args[2]))
				if ply == players[1] then
					RP:Notify( ply, RP.colors.white, "You have set your own money to: ", RP.colors.blue, "$" .. args[2], RP.colors.white, "!")
				else
					RP:Notify( ply, RP.colors.white, "You have set ", RP.colors.blue, players[1]:Nick() .. "s", RP.colors.white, " balance to: ", RP.colors.blue, "$".. args[2], RP.colors.white, "!" )
					RP:Notify( players[1], RP.colors.blue, ply:Nick(), RP.colors.white, " has set your money to: ", RP.colors.blue, "$" .. args[2], RP.colors.white, "!" )
				end
				players[1]:SavePlayerData()
			elseif ( #players > 1 ) then
				RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
			else
				RP:Notify( ply, RP.colors.red, "No matching players with an equal or lower immunity found." )
			end
		else
			RP:Notify( ply, RP.colors.red, "ERROR: ", RP.colors.white, "You cannot set someones balance to a word!")
		end
	else
		RP:Notify( ply, RP.colors.red, "ERROR: ", RP.colors.white, "Invalid Arguments!" )
	end
end

RP:AddPlugin( PLUGIN )