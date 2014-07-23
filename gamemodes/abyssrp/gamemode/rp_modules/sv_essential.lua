function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass(ply, "player_abyssrp")
	ply:LoadPlayerData()
	ply:SavePlayerData()
	if ply:GetNWInt("cash") == nil then
		ply:SetCash(1000)
	end
	if ply:GetNWInt("bank") == nil then
		ply:SetBank(100)
	end
	ply:ConCommand( "team_menu" )
end

function GM:PlayerSpawn( ply )
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )
	
	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply )

	-- Call item loadout function
	ply:RemoveAllAmmo()
	ply:StripWeapons()
	hook.Call( "PlayerLoadout", GAMEMODE, ply )
end

function GM:ShowSpare1( ply )
    ply:ShowMenu()
end
 
function GM:ShowSpare2( ply )
    ply:ConCommand( "team_menu" )
end

function GM:SetupMove( ply )

	GAMEMODE:SetPlayerSpeed(ply, 125, 250)	
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
   Desc: Give the player the default spawning weapons/ammo
---------------------------------------------------------*/
function GM:PlayerLoadout( ply )
	if ply.RP_Jailed then return end
	local t=ply:GetTeam()
	
	if not t.nohands then ply:Give( "hands" ) end
	
	ply:Give( "weapon_physcannon" )
	ply:Give( "gmod_camera" )
	ply:Give( "weapon_keys" )
	
	if ply:RP_IsAdmin() and GetConVarNumber("rp_admingivetools")==1 then
		ply:Give( "gmod_tool" )
		ply:Give( "weapon_physgun" )
	end
	
	if t.weps then
		for k,v in pairs(t.weps) do
			ply:Give(v)
		end
	end
	
	if t.armor then
		ply:SetArmor(t.armor)
	end
end

function GM:PlayerSetModel( ply )
	local m = RP:GetTeamModel( ply:Team() )
	util.PrecacheModel( m )
	ply:SetModel( m )
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
     return true
end