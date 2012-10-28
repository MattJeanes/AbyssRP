function GM:PlayerInitialSpawn( ply ) //"When the player first joins the server and spawns" function 
	// to make sure the first time someone joined it gives them their values.
	ply:LoadPlayerData()
	ply:SavePlayerData()
	if ply:GetNWInt("cash") == nil then
		ply:SetNWInt("cash", 1000)
		ply:SavePlayerData()
	end
	if ply:GetNWInt("bank") == nil then
		ply:SetNWInt("bank", 100)
		ply:SavePlayerData()
	end
	ply:ConCommand( "team_menu" ) //Run the console command when the player first spawns
end

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_abyssrp" )
    // Call item loadout function
	ply:RemoveAllAmmo()
	ply:StripWeapons() -- This command strips all weapons from the player.
	timer.Simple(1,function()
		hook.Call( "PlayerLoadout", GAMEMODE, ply )
    end)
    // Set player model
    hook.Call( "PlayerSetModel", GAMEMODE, ply )
    
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
	
	if not ( ply.RP_Jailed ) then
		if ply:Team()==RP:GetTeamN("freerunner") then ply:Give( "weapon_climb" ) else ply:Give( "hands" ) end
		
		ply:Give( "weapon_physcannon" )
		ply:Give( "gmod_camera" )
		ply:Give( "weapon_keys" )
		
		if ply:RP_IsAdmin() and GetConVarNumber("rp_admingivetools")==1 then
			ply:Give( "gmod_tool" )
			ply:Give( "weapon_physgun" )
		end
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