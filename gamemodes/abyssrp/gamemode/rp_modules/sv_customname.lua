function UpdateRPNames()
	for k,v in pairs(player.GetAll()) do
		if v:GetPData("rpname") then
			v:SetNWString("rpname", v:GetPData("rpname"))
		elseif not v:GetPData("rpname") and v:GetNWString("rpname") then
			v:SetNWString("rpname")
		end
	end
end
hook.Add("PlayerInitialSpawn", "RP_CustomNameGet", UpdateRPNames)