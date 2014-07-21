/*-------------------------------------------------------------------------------------------------------------------------
	See info about things!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Info"
PLUGIN.Description = "See info about things!"
PLUGIN.Author = "Overv/Matt J"
PLUGIN.ChatCommand = "info"
PLUGIN.Usage = "<item>"

function PLUGIN:Call( ply, args )
	if not args[1] then RP:Error(ply, RP.colors.white, "Invalid Arguments!") return end
	for i=1,#Shipments.Name do
		if string.lower(args[1]) == string.lower(Shipments.Name[i]) then
			ShipmentFound = true
			ShipmentNum = i
		end
	end
	if not ShipmentFound then
		RP:Notify( ply, RP.colors.red, "ERROR: Invalid choice!")
		return
	end
	local A = tonumber(ply:GetPData( "cash" ))
	local i = ShipmentNum
	local B = tonumber(Shipments.Cost[i])
	local C = A - B
	
	RP:Notify( ply, RP.colors.white, "Name: ", RP.colors.blue, Shipments.Name[i] )
	RP:Notify( ply, RP.colors.white, "Price: ", RP.colors.blue, RP:CC( B ) )
	RP:Notify( ply, RP.colors.white, "Current Balance: ", RP.colors.blue, RP:CC( A ) )
	RP:Notify( ply, RP.colors.white, "Balance after purchase: ", RP.colors.blue, RP:CC( C ) )
	ShipmentFound = false
	ShipmentNum = nil
end

RP:AddPlugin( PLUGIN )