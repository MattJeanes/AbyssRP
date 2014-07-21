hook.Add("SpawnMenuOpen", "RP-Essential", function()
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if not adminallow and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		return false
	elseif not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		return false
	end
end)

hook.Add("ContextMenuOpen", "RP-Essential", function()
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if not adminallow and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		return false
	elseif not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		return false
	end
end)

hook.Add("DrawDeathNotice", "RP-Essential", function(x,y)
	if not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		return false
	end
end)