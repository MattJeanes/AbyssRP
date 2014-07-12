function RP:GiveSalary()
	for k,v in pairs(player.GetAll()) do
		if v:Team()==0 then continue end
		hook.Call( "Payday", GAMEMODE, v, RP.Team[v:Team()].salary )
		v:SetNWInt("cash", v:GetNWInt("cash") + tonumber(RP.Team[v:Team()].salary))
		RP:Notify(v, RP.colors.white, "Payday! You have recieved your pay. ", RP.colors.blue, "$"..tonumber(RP.Team[v:Team()].salary))
		v:SavePlayerData()
	end
	timer.Simple(300,function() self:GiveSalary() end)
end

RP:GiveSalary()

-- Payday hook test!
/*
hook.Add("Payday", "RPPAYDAYTEST", function(ply, salary)
	print("yay recieved")
	print("Name: "..ply:Nick())
	print("Salary: "..salary)
end)
*/

local meta = FindMetaTable("Player")

function meta:SavePlayerData()
	self:SetPData("cash", self:GetNWInt("cash",0))
	self:SetPData("bank", self:GetNWInt("bank",0))
end

function meta:LoadPlayerData()
	self:SetNWInt("cash", self:GetPData("cash",0))
	self:SetNWInt("bank", self:GetPData("bank",100))
end

function meta:GetCash()
	local amount=self:GetPData("cash",0)
	if not tonumber(amount) then amount=0 end
	return tonumber(amount)
end

function meta:AddCash(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 1 then return end
	self:SetNWInt("cash", self:GetPData("cash",0) + amount)
	self:SavePlayerData()
end

function meta:SetCash(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 1 then return end
	self:SetNWInt("cash", amount)
	self:SavePlayerData()
end

function meta:TakeCash(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 1 then return end
	if (self:GetPData("cash") - amount) < -1 then return end 
	self:SetNWInt("cash", self:GetPData("cash",0) - amount)
	self:SavePlayerData()
end

function meta:AddBank(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 1 then return end
	self:SetNWInt("bank", self:GetNWInt("bank",0) + amount)
	self:SavePlayerData()
end

function meta:TakeBank(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 1 then return end
	if (self:GetPData("bank") - amount) < -1 then return end 
	self:SetNWInt("bank", self:GetNWInt("bank",0) - amount)
	self:SavePlayerData()
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