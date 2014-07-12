hook.Add("PlayerDeath", "RP-PoliceKill", function( victim, weapon, killer )
	if IsValid(victim) and IsValid(killer) and victim != killer and RP.Team[victim:Team()].police and RP.Team[killer:Team()].police then
		RP:Notify(RP.colors.white, team.GetName(victim:Team()) .. " ", RP.colors.blue, victim:Nick(), RP.colors.white, " has been killed by " .. team.GetName(killer:Team()) .. " ", RP.colors.red, killer:Nick())
	end
end)