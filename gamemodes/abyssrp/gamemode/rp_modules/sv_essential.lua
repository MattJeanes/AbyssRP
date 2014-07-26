-- Essential code

function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass(ply, "player_abyssrp")
	ply:SetTeam(1)
end

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass(ply, "player_abyssrp")
	self.BaseClass.BaseClass.PlayerSpawn(self,ply)
end