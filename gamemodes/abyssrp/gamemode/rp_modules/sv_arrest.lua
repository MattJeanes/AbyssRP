function RP:ArrestPlayer( ply, jailer )

	ply.RP_Jailed = true
	
	ply:StripWeapons()
	ply.RP_RestorePos = ply:GetPos()
	if #RP.JailPoses > 0 then
		ply.JailPos = table.Random(RP.JailPoses)
	elseif RP.JailPos then
		ply.JailPos = RP.JailPos
	end
	if not ply.JailPos then return false end
	
	ply:SetPos( ply.JailPos )
	
	ply:SetMoveType( MOVETYPE_WALK )
	ply:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local jailtime = GetConVarNumber("rp_jailtime")
	RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has been arrested!")
	RP:Notify(ply, RP.colors.white, "You've been arrested by ", RP.colors.blue, jailer:Nick())
	RP:Notify(jailer, RP.colors.white, "You've arrested: ", RP.colors.blue, ply:Nick(), RP.colors.white, "!")
	ply.Jailer = jailer
	RP:Notify(ply, RP.colors.white, "You will be released in: ", RP.colors.blue, tostring(jailtime), RP.colors.white, " seconds.")
	return true
end

function RP:UnarrestPlayer( ply, bailed )
	local jailer = ply.Jailer
	if !ply:IsValid() then return false end
	
	if timer.Exists("RP-Wanted-"..ply:UniqueID()) then
		timer.Remove("RP-Wanted-"..ply:UniqueID())
	end
	ply.Wanted = false
	
	ply.RP_Jailed = nil
	ply:Spawn()
	timer.Simple( 0.1, function() ply:SetPos( ply.RP_RestorePos ) end )
	
	if bailed then
		RP:Notify(ply, RP.colors.white, "You have bailed out of jail!")
		RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has bailed themselves out of jail!")
	else
		RP:Notify(ply, RP.colors.white, "You have been released!")
		RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has been released!")
	end
	ply.Wanted = nil
	ply.Jailer = nil
	return true
end

hook.Add("PlayerSpawn", "RP-Jail", function(ply)
	if ( ply.RP_Jailed ) then
		ply:SetPos( ply.JailPos )
	end
end)

hook.Add("CanPlayerSuicide", "RP-Jail", function(ply)
	if ( ply.RP_Jailed ) then return false end
end)

hook.Add("PlayerNoClip", "RP-Jail", function(ply)
	if ( ply.RP_Jailed ) then return false end
end)

CreateConVar( "rp_jailtime", "120", FCVAR_NOTIFY )