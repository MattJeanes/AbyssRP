/*-------------------------------------------------------------------------------------------------------------------------
	Show the shop!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Shop"
PLUGIN.Description = "The Shop!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "shop"

function PLUGIN:Call( ply, args )
	RP:Notify(ply, RP.colors.white, "You can buy the following things!")
	timer.Simple(0.5,function()
		for k,v in pairs(RP.Shipments) do
			timer.Simple(k*0.2, function()
				RP:Notify(ply, RP.colors.white, v.name .. " for ", RP.colors.blue, "$".. v.cost)
			end)
		end
	end)
end

RP:AddPlugin( PLUGIN )