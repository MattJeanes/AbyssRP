/*-------------------------------------------------------------------------------------------------------------------------
	Vote demotion
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Vote-demote"
PLUGIN.Description = "Allow players to vote-demote other players."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "demote"
PLUGIN.Usage = "<ply>"
PLUGIN.Privileges = { "Vote-demote" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	local players = RP:FindPlayer( args[1] )
	if #players==1 then
		local TCol = team.GetColor(players[1]:Team())
		if players[1]==ply then RP:Error(ply, RP.colors.white, "You can't vote-demote yourself!") return end
		if players[1]:Team()==0 or players[1]:Team()==1 then RP:Error(ply, RP.colors.white, "You cannot demote this player, they are a citizen or have no team at all.") return end
		if ply:RP_IsAdmin() then
			RP:Notify(TCol, players[1]:Nick(), RP.colors.white, " has been demoted by admin ", team.GetColor(ply:Team()), ply:Nick(), RP.colors.white, ".")
			players[1]:SetTeam( 1 )
			players[1]:Spawn()
			return
		end
		if self.Time then self.TimeR = math.floor(self.Time-CurTime()+GetConVarNumber("rp_demotecooldown")) end
		if self.Time and (self.TimeR > 0) then
			RP:Error(ply, RP.colors.white, "Vote-demotion is cooling down, try again in ", RP.colors.blue, tostring(self.TimeR).." second(s)", RP.colors.white, ".")
			return
		end
		self.Time=CurTime()
		Vote:Create("Demote "..players[1]:Nick().."?", {"Yes", "No"}, function(winner,results,isRandom,msg)
			RP:Notify(RP.colors.blue, "Vote-demote results: ", RP.colors.white, msg)
			if isRandom then
				RP:Notify(RP.colors.white, "Vote-demotion on ", TCol, players[1]:Nick(), RP.colors.white, " tied, auto-failing.")
				return
			elseif winner[1]=="Yes" then
				RP:Notify(RP.colors.white, "Vote-demotion on ", TCol, players[1]:Nick(), RP.colors.white, " succeeded, demoting.")
				players[1]:SetTeam( 1 )
				players[1]:Spawn()
			else
				RP:Notify(RP.colors.white, "Vote-demotion on ", TCol, players[1]:Nick(), RP.colors.white, " failed.")
			end				
		end)
	elseif #players==0 then
		RP:Error(ply, RP.colors.white, "No players found!")
	else
		RP:Notify( ply, RP.colors.white, "Did you mean ", RP.colors.red, RP:CreatePlayerList( players, true ), RP.colors.white, "?" )
	end
end

RP:AddPlugin( PLUGIN )