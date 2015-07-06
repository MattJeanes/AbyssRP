-- Cash

local meta = FindMetaTable("Player")

function meta:GetCash()
	local amount=self:GetValue("cash",0)
	return tonumber(amount)
end

function meta:GetBank()
	local amount=self:GetValue("bank",0)
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

if SERVER then
	function meta:SetCash(amount)
		if not tonumber(amount) then return end
		if tonumber(amount) < 0 then return end
		self:SetValue("cash", amount)
		hook.Call("RP-CashChanged", GAMEMODE, self, amount)
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
		self:SetValue("bank", amount)
		hook.Call("RP-BankChanged", GAMEMODE, self, amount)
	end

	function meta:AddBank(amount)
		self:SetBank(self:GetBank()+amount)
	end

	function meta:TakeBank(amount)
		self:SetBank(self:GetBank()-amount)
	end
end