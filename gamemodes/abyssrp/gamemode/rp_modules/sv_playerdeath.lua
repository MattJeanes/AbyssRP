local function playerDies( victim, weapon, killer )
	if victim != killer and IsValid(killer) and killer:IsPlayer() and victim:Nick() != killer:Nick() and (victim:Team() == 2 or victim:Team() == 8) then
	A = team.GetName(victim:Team()) .. " "
		if killer:Team() == 2 or killer:Team() == 8 then
			B = "fellow officer "
		else
			B = team.GetName(killer:Team()) .. " "
		end
	RP:Notify(RP.colors.white, A, RP.colors.blue, victim:GetName(), RP.colors.white, " has been killed by " .. B, RP.colors.red, killer:GetName())
	end
	
	if (tonumber(victim:GetNWInt("cash")) * GetConVarNumber("rp_cashlosspercent") > 5) and not (GetConVarNumber("rp_admindropmoney")==0 and victim:RP_IsAdmin()) then
		if math.random(1,4) == 1 then
			local ent = ents.Create("rp_cash")
			local pos = victim:GetPos()
			local cashlosspercent = GetConVarNumber("rp_cashlosspercent")
			local cash = tonumber(victim:GetNWInt("cash")) * cashlosspercent
			local cash1 = math.Round(cash)
			ent.Cash = cash1
			ent:SetPos(pos)
			ent:Spawn()
			ent:DropToFloor()
			ent.Owner = victim
			timer.Simple(0.5,function()
				if not (ent:IsInWorld()) then
					RP:Error(victim, RP.colors.white, "Cash spawn failure! Nothing dropped on death.")
				else
					victim:TakeCash(cash1)
					RP:Notify(victim, RP.colors.white, "You dropped ", RP.colors.red, "$".. cash1, RP.colors.white, " on death!")
				end
			end)
		end
	else
		RP:Notify(victim, RP.colors.white, "You dropped ", RP.colors.red, "nothing", RP.colors.white, " on death!")
	end
end

hook.Add( "PlayerDeath", "RPDeath", playerDies )

CreateConVar( "rp_cashlosspercent", "0.25", FCVAR_NOTIFY )