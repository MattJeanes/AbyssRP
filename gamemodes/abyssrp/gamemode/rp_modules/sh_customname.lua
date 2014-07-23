-- RP custom name

if SERVER then
	function UpdateRPNames()
		for k,v in pairs(player.GetAll()) do
			if v:GetPData("rpname") then
				v:SetNWString("rpname", v:GetPData("rpname"))
			elseif not v:GetPData("rpname") and v:GetNWString("rpname") then
				v:SetNWString("rpname","")
			end
		end
	end
	hook.Add("PlayerInitialSpawn", "RP_CustomNameGet", UpdateRPNames)
elseif CLIENT then
	local pmeta = FindMetaTable("Player")
	if not pmeta.SteamName then
		pmeta.SteamName=pmeta.Name
	end
	function pmeta:Name()
		local rpname=self:GetNWString("rpname","")
		if rpname=="" then
			return self:SteamName()
		else
			return rpname
		end
	end
	pmeta.GetName = pmeta.Name
	pmeta.Nick = pmeta.Name
end