-- Essential code

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(1)
	player_manager.SetPlayerClass(ply, "player_abyssrp")
end

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass(ply, "player_abyssrp")
	self.BaseClass.BaseClass.PlayerSpawn(self,ply)
end