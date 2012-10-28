/*-------------------------------------------------------------------------------------------------------------------------
	Buy stuff!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Buy"
PLUGIN.Description = "Allows a player to spawn guns!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "buy"
PLUGIN.Usage = "<item>"

function PLUGIN:Call( ply, args )
	if ply.RP_Jailed then return end
	if not RP:GetTeamN("gun dealer") then return end
	
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid arguments.")
		return
	end
		
	for k,v in pairs(RP.Shipments) do
		if string.lower(args[1]) == string.lower(v.name) then
			local trace = ply:GetEyeTraceNoCursor()
			local cash = tonumber(ply:GetPData("cash"))
			if cash >= v.cost then
				if ply:Team() == RP:GetTeamN("gun dealer") then
					local item = ents.Create("spawned_weapon")
					item:SetModel(v.model)
					item.ShareGravgun = true
					item.Class = v.class
					item:SetPos(trace.HitPos + Vector(0,0,35))
					item.nodupe = true
					item:Spawn()
					item.SingleSpawn = true
					ply:TakeCash(v.cost)
					timer.Simple(0.1,function()
						if not (item:IsInWorld()) then
							RP:Error(ply, RP.colors.white, "Item spawn failure! Refunded: ", RP.colors.blue, "$".. tostring(v.cost), RP.colors.white, ".")
							ply:AddCash(cost)
						else
							RP:Notify(ply, RP.colors.white, "Item bought (", RP.colors.blue, v.name, RP.colors.white, "): ", RP.colors.red, "$" .. v.cost )
						end
					end)
				else
					RP:Error( ply, RP.colors.white, "You must be a ", team.GetColor(9), "gun dealer", RP.colors.white, "!" )
				end			
			else
				RP:Error(ply, RP.colors.white, "Not enough cash: ", RP.colors.blue, "$" .. cost, RP.colors.white, " required!" )
			end
			return
		end
	end
	
	RP:Error( ply, RP.colors.white, "Invalid choice!" )
end

RP:AddPlugin( PLUGIN )