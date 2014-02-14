local function PhysGravGunPickup(ply, ent)
    if(!ent or !ent:IsValid()) then
		return
    end
	if ply:RP_IsAdmin() and GetConVarNumber("rp_admincandoall")==1 then return true end
	if ent.IsPlayer then return false end
    if ent:GetNWEntity("OwnerObj") == game.GetWorld() then
		return false
    end
    return
end
hook.Add("GravGunPunt", "RP_GravGunPuntRP", PhysGravGunPickup)
hook.Add("GravGunPickupAllowed", "RP_GravGunPickupAllowedRP", PhysGravGunPickup)
hook.Add("PhysgunPickup", "RP_PhysgunPickupRP", PhysGravGunPickup)

function AdminNoclip( ply )
	if ( ply:RP_IsAdmin() and GetConVarNumber("rp_adminnoclip")==1 ) then return true else return end
end

hook.Add("PlayerNoClip", "Admin Noclip", AdminNoclip)

CreateConVar( "rp_adminnoclip", "1", FCVAR_NOTIFY )

function JailedSpawn( ply )
	if ( ply.RP_Jailed ) then
		if JailSupport then
			ply:SetPos( ply.JailPos )
		else
			ply:SetPos( RP.jailPos )
		end
	end
end

hook.Add("PlayerSpawn", "Jail Systems", JailedSpawn ) 

function JailedSuicide( ply )
	if ( ply.RP_Jailed ) then return false end
end

hook.Add("CanPlayerSuicide", "Jailed Suicide", JailedSuicide)

function JailedNoClip( ply )
	if ( ply.RP_Jailed ) then return false end
end

hook.Add("PlayerNoClip", "Jail Noclip", JailedNoClip)

function RP.CanProperty(ply, strProp, ent)
	return (GetConVarNumber("rp_admincandoall")==1 and ply:RP_IsAdmin()) or false
end
hook.Add("CanProperty", "RP.CanProperty", RP.CanProperty)

function GM:PlayerSpawnProp( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerSpawnSENT( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerGiveSWEP( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerSpawnSWEP( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerSpawnNPC( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerSpawnEffect( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerSpawnRagdoll( ply )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		return false
	end
end

function GM:PlayerSpawnedVehicle( ply, veh )
	local adminallow = tobool(GetConVarNumber("rp_adminspawnmenu"))
	if ply.RP_Jailed then veh:Remove() return false end
	if (adminallow and ply:RP_IsAdmin()) then
		return true
	else
		veh:Remove()
	end
end