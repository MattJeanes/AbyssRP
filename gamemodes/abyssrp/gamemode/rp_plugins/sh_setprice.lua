/*-------------------------------------------------------------------------------------------------------------------------
	Change the price of your shipments!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Set Price"
PLUGIN.Description = "To set the price of your shipments!"
PLUGIN.Author = "Matt J"
PLUGIN.ChatCommand = "setprice"
PLUGIN.Usage = "<amount>"

function PLUGIN:Call( ply, args )
	
	local trace = ply:GetEyeTraceNoCursor()
	local ent = trace.Entity
	
	if not ent.IsShipment then
		RP:Error(ply, RP.colors.white, "This is not a shipment!")
		return
	end
	
	if not ent.Owner == ply then
		RP:Error(ply, RP.colors.white, "This is not your shipment!")
		return
	end
	
	if not args[1] then
		RP:Error(ply, RP.colors.white, "You need to choose a price!")
		return
	end
	
	if tonumber(args[1]) < ent.DefaultPrice then
		RP:Error(ply, RP.colors.white, "That number is too small!")
		return
	end
	
	ent.Price = args[1]
	ent:SetNWInt("price", args[1])
	RP:Notify(ply, RP.colors.white, "You have set the price of your shipment to: ", RP.colors.blue, RP:CC(args[1]), RP.colors.white, ".")
	
end

RP:AddPlugin( PLUGIN )