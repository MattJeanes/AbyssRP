/*-------------------------------------------------------------------------------------------------------------------------
	Sell all the things!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Sell all"
PLUGIN.Description = "Allows a player to sell all their stuff!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "sell"
PLUGIN.Usage = "[vehicles/doors/shipments]"

function PLUGIN:Call( ply, args )

	arg = string.lower(string.Implode(" ", args))

	if !args[1] then
		ply:SellVehicles(false)
		ply:SellDoors(false)
		ply:SellShipments(false)
	elseif arg == "vehicles" then
		ply:SellVehicles(false)
	elseif arg == "doors" then
		ply:SellDoors(false)
	elseif arg == "shipments" then
		ply:SellShipments(false)
	else
		RP:Error(ply, RP.colors.white, "Invalid choice!")
	end
	
end

RP:AddPlugin( PLUGIN )