-- Cash

RP:AddSetting("cashlosspercent", 0.25)
RP:AddSetting("maxdroppedcash", 5000)
RP:AddSetting("admindropcash",false)

hook.Add("PlayerInitialSpawn", "RP-Money", function(ply)
	if ply:GetValue("cash",nil) == nil then
		ply:SetCash(1000)
	end
	if ply:GetValue("bank",nil) == nil then
		ply:SetBank(100)
	end
end)

function RP:GiveSalary()
	for k,v in pairs(player.GetAll()) do
		if v:Team()==0 then continue end
		local salary=v:GetTeamValue("salary")
		hook.Call( "RP-Payday", GAMEMODE, v, salary)
		v:AddCash(salary)
		RP:Notify(v, RP.colors.white, "Payday! You have recieved your pay: ", RP.colors.blue, RP:CC(salary))
	end
end

timer.Create("RP-GiveSalary", RP.SalaryTime, 0, function()
	RP:GiveSalary()
end)

-- Payday hook test!
/*
hook.Add("Payday", "RPPAYDAYTEST", function(ply, salary)
	print("yay recieved")
	print("Name: "..ply:Nick())
	print("Salary: "..salary)
end)
*/

hook.Add( "PlayerDeath", "RP-Cash", function(victim, weapon, killer)
	if (victim:GetCash() * RP:GetSetting("cashlosspercent") > 5) and not (not RP:GetSetting("admindropcash") and victim:RP_IsAdmin()) then
		if math.random(1,4) == 1 then
			local ent = ents.Create("rp_cash")
			local pos = victim:GetPos()
			local cash = math.Round(math.Clamp(victim:GetCash() * RP:GetSetting("cashlosspercent"), 0, RP:GetSetting("maxdroppedcash")))
			ent.Cash = cash
			ent:SetPos(pos)
			ent:Spawn()
			ent:DropToFloor()
			ent.Owner = victim
			timer.Simple(0.5,function()
				if IsValid(ent) and ent:IsInWorld() then
					victim:TakeCash(cash)
					RP:Notify(victim, RP.colors.white, "You dropped ", RP.colors.red, RP:CC(cash), RP.colors.white, " on death!")
				end
			end)
		end
	end
end)