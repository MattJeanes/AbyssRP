-- Cash

local meta = FindMetaTable("Player")

function meta:GetCash()
	local amount=self:GetNWFloat("cash",0)
	return tonumber(amount)
end

function meta:GetBank()
	local amount=self:GetNWFloat("bank",0)
	return tonumber(amount)
end

function RP:CC(value) -- Cash convert
	value=tonumber(value)
	if not value then
		value=0
	end
	local str,k=string.format("%.2f", tostring(value))
	while true do
	str,k = string.gsub(str, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	if value > 0 and value < 1 then -- Pennies/cent etc
		if value >= 0.1 then
			return string.sub(str,-2).."p"
		else
			return string.sub(str,-1).."p"
		end
	elseif string.find(str,"%.00") then
		return "£"..string.sub(str,1,-4)
	else
		return "£"..str
	end
end

RP.SalaryTime = 300

if CLIENT then return end

RP:AddSetting("cashlosspercent", 0.25)
RP:AddSetting("maxdroppedcash", 5000)
RP:AddSetting("admindropcash",false)

hook.Add("PlayerInitialSpawn", "RP-Money", function(ply)
	ply:LoadPlayerData()
	if ply:GetNWFloat("cash") == nil then
		ply:SetCash(1000)
	end
	if ply:GetNWFloat("bank") == nil then
		ply:SetBank(100)
	end
end)

function RP:GiveSalary()
	for k,v in pairs(player.GetAll()) do
		if v:Team()==0 then continue end
		local salary=v:GetTeamValue("salary")
		hook.Call( "Payday", GAMEMODE, v, salary)
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

function meta:LoadPlayerData()
	local uid=self:UniqueID()
	self:SetNWFloat("cash", self:GetValue("cash",0))
	self:SetNWFloat("bank", self:GetValue("bank",0))
end

function meta:SetCash(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 0 then return end
	self:SetNWFloat("cash", amount)
	self:SetValue("cash", amount)
	RP:SavePlayerInfo()
end

function meta:AddCash(amount)
	if amount<=0 then return end
	self:SetCash(self:GetCash()+amount)
end

function meta:TakeCash(amount)
	if amount<=0 then return end
	self:SetCash(self:GetCash()-amount)
end

function meta:SetBank(amount)
	if not tonumber(amount) then return end;
	if tonumber(amount) < 0 then return end
	self:SetNWFloat("bank", amount)
	self:SetValue("bank", amount)
	RP:SavePlayerInfo()
end

function meta:AddBank(amount)
	self:SetBank(self:GetBank()+amount)
end

function meta:TakeBank(amount)
	self:SetBank(self:GetBank()-amount)
end

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