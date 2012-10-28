function GM:SpawnMenuOpen()
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if (adminallow and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) and LocalPlayer():Team() != RP:GetTeamN("car dealer") then
		GAMEMODE:SuppressHint( "OpeningMenu" )
		GAMEMODE:AddHint( "OpeningContext", 20 )
		return true	
	elseif LocalPlayer():Team() == RP:GetTeamN("car dealer") then
		SpawnVehicle_Menu( LocalPlayer() )
		return false
	else
		return false
	end
end

function GM:DrawDeathNotice(x,y)
	if not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		return
	end
	self.BaseClass:DrawDeathNotice(x,y)
end