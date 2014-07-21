local function VehicleSpawn(ply, command, args)
	local cardealer=RP:GetTeamN("car dealer")
	if ply:Team()!=cardealer then
		RP:Error(ply, RP.colors.white, "You are not a ", team.GetColor(cardealer), "Car Dealer", RP.colors.white, "!")
		return
	end
	local cash = tonumber(ply:GetPData("cash"))
	for k,v in pairs(RP.Vehicles) do
		if string.lower(args[1]) == string.lower(v.name) then
			if (cash - v.cost) < -1 then
				RP:Error(ply, RP.colors.white, "You don't have enough cash!")
			else
				RP:Notify(ply, RP.colors.white, "You have bought vehicle: ", RP.colors.blue, v.name, RP.colors.white, " for ", RP.colors.red, RP:CC(v.cost), RP.colors.white, ".")
				
				local ent = ents.Create(v.class)
				ent:SetKeyValue("vehiclescript", v.script) 
				ent:SetModel(v.model)     
				ent:SetPos(ply:GetEyeTraceNoCursor().HitPos)
				//ent:SetAngles(Vector(0, 0, 0))
				ent:Activate()
				ent:Spawn()
				ent:SetNWString("Owner", "Shared")
				ent.Cost = v.cost
				ent.TheOwner = ply
				ent.Ownable = false
				if SPropProtection then
					SPropProtection.PlayerMakePropOwner(ply, ent)
				end
				ply:TakeCash(v.cost)
			end
		end
	end
end

concommand.Add("rp_vehiclespawn",VehicleSpawn)