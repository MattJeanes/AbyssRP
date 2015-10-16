hook.Add( "PlayerDeath", "Player-Death", function(victim, weapon, killer)
	if victim:IsPlayer() and killer:IsPlayer() and killer != victim then
		victim:ChatPrint("You were killed by player: " .. killer:Nick() .. " Using: " .. weapon:Nick())
	end
end)