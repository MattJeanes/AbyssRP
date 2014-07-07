// Admin hooks

hook.Add("PlayerNoClip", "Admin Noclip", function( ply )
	if not ply:RP_IsAdmin() or (ply:RP_IsAdmin() and GetConVarNumber("rp_adminnoclip")==0) then
		return false
	end
end)

CreateConVar( "rp_adminnoclip", "1", FCVAR_NOTIFY )

hook.Add("PlayerSpawn", "Jail Systems", function(ply)
	if ( ply.RP_Jailed ) then
		ply:SetPos( ply.JailPos )
	end
end)

hook.Add("CanPlayerSuicide", "Jailed Suicide", function(ply)
	if ( ply.RP_Jailed ) then return false end
end)

hook.Add("PlayerNoClip", "Jail Noclip", function(ply)
	if ( ply.RP_Jailed ) then return false end
end)

local function PlayerSpawnItem(ply,item)
	if not ply:RP_IsAdmin() or (ply:RP_IsAdmin() and GetConVarNumber("rp_adminspawnmenu")==0) then
		if IsValid(item) then
			item:Remove()
		end
		return false
	end
end
hook.Add("PlayerSpawnProp", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerSpawnSENT", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerGiveSWEP", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerSpawnSWEP", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerSpawnNPC", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerSpawnEffect", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerSpawnRagdoll", "RP-AdminSpawnmenu", PlayerSpawnItem)
hook.Add("PlayerSpawnedVehicle", "RP-AdminSpawnmenu", PlayerSpawnItem)