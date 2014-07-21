/*-------------------------------------------------------------------------------------------------------------------------
	Spawn Shipments!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Shipments"
PLUGIN.Description = "Allows a player to spawn gun shipments!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "buyshipment"
PLUGIN.Usage = "<item> [amount]"

function PLUGIN:Call( ply, args )
	local arg = args[1]
	if ply.RP_Jailed then return end
	
	if not args[1] then
		RP:Error(ply, RP.colors.white, "You must make an input!")
		return
	end
	
	if not ply:Team()==9 then
		RP:Error(ply, RP.colors.white, "You must be a ", team.GetColor(9), "gun dealer", RP.colors.white, "!")
		return
	end
	
	for k,v in pairs(RP.Shipments) do
		if string.lower(arg) == string.lower(v.name) then
			local trace = ply:GetEyeTraceNoCursor()
			local count = tonumber(args[2]) or 10
			local cash = tonumber(ply:GetPData("cash"))
			local cost = tonumber((v.cost * count))
			if cash >= cost then
				local shipment = ents.Create("spawned_shipment")
				shipment.ShareGravgun = true
				shipment.Class = v.class
				shipment.Count = count
				shipment.Name = v.name
				shipment.TheOwner = ply
				shipment.Model = v.model
				shipment:SetPos(trace.HitPos + Vector(0,0,35))
				shipment.nodupe = true
				shipment.DefaultPrice = v.cost
				shipment:Spawn()
				ply:TakeCash(cost)
				timer.Simple(0.1,function()
					if not (shipment:IsInWorld()) then
						RP:Error(ply, RP.colors.white, "Shipment spawn failure! Refunded: ", RP.colors.blue, RP:CC(cost), RP.colors.white, ".")
						ply:AddCash(cost)
					else
						RP:Notify(ply, RP.colors.white, "Shipment bought (", RP.colors.blue, v.name, RP.colors.white, "): ", RP.colors.red, RP:CC(cost) )
					end
				end)
			else
				RP:Error(ply, RP.colors.white, "Not enough cash: ", RP.colors.blue, RP:CC(cost), RP.colors.white, " required!" )
			end
			return
		end
	end
	
	RP:Error( ply, RP.colors.white, "Invalid choice!" )
end

RP:AddPlugin( PLUGIN )