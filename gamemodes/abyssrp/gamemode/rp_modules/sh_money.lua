local meta = FindMetaTable("Player")

function meta:GetCash()
	local amount=self:GetNWInt("cash",0)
	return tonumber(amount)
end

function meta:GetBank()
	local amount=self:GetNWInt("bank",0)
	return tonumber(amount)
end

if CLIENT then return end

function RP:GiveSalary()
	for k,v in pairs(player.GetAll()) do
		if v:Team()==0 then continue end
		hook.Call( "Payday", GAMEMODE, v, RP.Team[v:Team()].salary )
		v:AddCash(tonumber(RP.Team[v:Team()].salary))
		RP:Notify(v, RP.colors.white, "Payday! You have recieved your pay: ", RP.colors.blue, "$"..tonumber(RP.Team[v:Team()].salary))
	end
end

timer.Create("RP-GiveSalary", 300, 0, function()
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

function meta:SavePlayerData()
	self:SetPData("cash", self:GetCash())
	self:SetPData("bank", self:GetBank())
end

function meta:LoadPlayerData()
	self:SetNWInt("cash", self:GetPData("cash",0))
	self:SetNWInt("bank", self:GetPData("bank",100))
end

function meta:SetCash(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 0 then return end
	self:SetNWInt("cash", amount)
	self:SavePlayerData()
end

function meta:AddCash(amount)
	self:SetCash(self:GetCash()+amount)
end

function meta:TakeCash(amount)
	self:SetCash(self:GetCash()-amount)
end

function meta:SetBank(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 0 then return end
	self:SetNWInt("bank", amount)
	self:SavePlayerData()
end

function meta:AddBank(amount)
	self:SetBank(self:GetBank()+amount)
end

function meta:TakeBank(amount)
	self:SetBank(self:GetBank()-amount)
end

hook.Add( "PlayerDeath", "RP-Money", function(victim, weapon, killer)
	if (victim:GetCash() * GetConVarNumber("rp_cashlosspercent") > 5) and not (GetConVarNumber("rp_admindropmoney")==0 and victim:RP_IsAdmin()) then
		if math.random(1,4) == 1 then
			local ent = ents.Create("rp_cash")
			local pos = victim:GetPos()
			local cash = math.Round(math.Clamp(victim:GetCash() * GetConVarNumber("rp_cashlosspercent"), 0, GetConVarNumber("rp_maxdroppedcash")))
			ent.Cash = cash
			ent:SetPos(pos)
			ent:Spawn()
			ent:DropToFloor()
			ent.Owner = victim
			timer.Simple(0.5,function()
				if IsValid(ent) and ent:IsInWorld() then
					victim:TakeCash(cash1)
					RP:Notify(victim, RP.colors.white, "You dropped ", RP.colors.red, "$".. cash, RP.colors.white, " on death!")
				end
			end)
		end
	end
end)

CreateConVar( "rp_cashlosspercent", "0.25", FCVAR_NOTIFY )
CreateConVar( "rp_maxdroppedcash", "5000", FCVAR_NOTIFY )