-- RP custom name

if SERVER then
	function RP:UpdateCustomNames()
		for k,v in pairs(player.GetAll()) do
			if v:GetPData("rpname") then
				v:SetNWString("rpname", v:GetPData("rpname"))
			elseif not v:GetPData("rpname") and v:GetNWString("rpname") then
				v:SetNWString("rpname","")
			end
		end
	end
	hook.Add("PlayerInitialSpawn", "RP-CustomName", RP.UpdateCustomNames)
end

local pmeta = FindMetaTable("Player")
if not pmeta.SteamName then
	pmeta.SteamName=pmeta.Name
end
function pmeta:Name()
	local rpname=self:GetNWString("rpname","")
	if rpname=="" or not rpname then
		return self:SteamName()
	else
		return rpname
	end
end
pmeta.GetName = pmeta.Name
pmeta.Nick = pmeta.Name