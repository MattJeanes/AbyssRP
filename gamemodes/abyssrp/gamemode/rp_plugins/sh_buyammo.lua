/*-------------------------------------------------------------------------------------------------------------------------
	Buy ALL THE AMMO!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Buy Ammo"
PLUGIN.Description = "Allows a player to buy some sexy ammo!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "buyammo"
PLUGIN.Usage = "<weapon> <ammo>"

function PLUGIN:Call( ply, args )
	local fullarg = string.Implode(" ", args)
	if ply.RP_Jailed then return end
	
	if not args[1] then
		RP:Error(ply, RP.colors.white, "You must choose a weapon!")
		return
	end
	
	if not args[2] then
		RP:Error(ply, RP.colors.white, "You must choose the amount of ammunition!")
		return
	end
	
	for k,v in pairs(RP.Shipments) do
		if string.lower(args[1]) == string.lower(v.name) then
			local count = tonumber(args[2])
			local cash = tonumber(ply:GetPData("cash"))
			local cost = tonumber((v.ammocost * count))
			
			if v.ammotype == "None" then
				RP:Error(ply, RP.colors.white, "This weapon does not take ammo!")
				return
			end
			
			if cash >= cost then			
				ply:GiveAmmo(tonumber(args[2]), v.ammotype)
				RP:Notify(ply, RP.colors.white, "Ammo Bought (", RP.colors.blue, args[2], RP.colors.white, ") for your "..v.name.. ": ", RP.colors.red, "$" .. cost, RP.colors.white, ".")
				ply:TakeCash(cost)
			else
				RP:Error(ply, RP.colors.white, "Not enough cash: ", RP.colors.blue, "$" .. cost, RP.colors.white, " required!" )
			end
			return
		end
	end
	
	RP:Error( ply, RP.colors.white, "Invalid weapon!" )
end

RP:AddPlugin( PLUGIN )