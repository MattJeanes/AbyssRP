/*-------------------------------------------------------------------------------------------------------------------------
	Give ownership of a door or vehicle
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Give Ownership"
PLUGIN.Description = "Door/Car ownership giving!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "giveownership"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	local entity = ply:GetEyeTraceNoCursor().Entity
	if not entity:IsVehicle() and not entity:IsDoor() then
		RP:Error(ply, RP.colors.white, "You need to be looking at a door/vehicle!")
		return
	elseif entity.TheOwner != ply then
		RP:Error(ply, RP.colors.white, "You are not the owner of this!")
		return
	else
		local players = RP:FindPlayer( args, ply, true, true )
		if ( #players == 1 ) then
			if entity:IsDoor() then
				entity.TheOwner = players[1]
				RP:Notify(ply, RP.colors.white, "You have given ownership of your door to: ", RP.colors.blue, players[1]:Nick(), RP.colors.white, "!")
				RP:Notify(players[1], RP.colors.white, "You have recieved a door from: ", RP.colors.blue, ply:Nick(), RP.colors.white, ". Oh Joy!")
			elseif entity:IsVehicle() then
				entity.TheOwner = players[1]
				if SPropProtection then
					SPropProtection.PlayerMakePropOwner(players[1], entity)
				end
				RP:Notify(ply, RP.colors.white, "You have given ownership of your vehicle to: ", RP.colors.blue, players[1]:Nick(), RP.colors.white, "!")
				RP:Notify(players[1], RP.colors.white, "You have recieved a vehicle from: ", RP.colors.blue, ply:Nick(), RP.colors.white, ". Oh Joy!")
			end
			
		elseif ( #players > 1 ) then
			RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
		else
			RP:Notify( ply, RP.colors.red, "No matching players." )
		end
	end
end

RP:AddPlugin( PLUGIN )