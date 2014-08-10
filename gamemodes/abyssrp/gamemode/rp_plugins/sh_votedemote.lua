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

if SERVER then
	RP:AddSetting("demotecooldown", 60)
	RP:AddSetting("admindemote", false)
	RP:AddSetting("adminvotedemote", false)
end

local cooldown=0
function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	local players = RP:FindPlayer( args[1] )
	if #players==1 then
		local TCol = team.GetColor(players[1]:Team())
		if players[1]==ply then RP:Error(ply, RP.colors.white, "You can't demote yourself!") return end
		if players[1]:Team()==0 or players[1]:Team()==1 then RP:Error(ply, TCol, players[1]:Nick(), RP.colors.white, " is already on the '", team.GetColor(1), team.GetName(1), RP.colors.white, "' job.") return end
		if ply:RP_IsAdmin() and not RP:GetSetting("adminvotedemote",false) then
			RP:Notify(TCol, players[1]:Nick(), RP.colors.white, " has been demoted by admin ", team.GetColor(ply:Team()), ply:Nick(), RP.colors.white, ".")
			players[1]:SetTeam(1)
			players[1]:Spawn()
			return
		end
		if players[1]:RP_IsAdmin() and not RP:GetSetting("admindemote",false) then
			RP:Notify(TCol, players[1]:Nick(), RP.colors.white, " can't be demoted because they're ", RP.colors.red, "an admin.")
			return
		end
		if cooldown and cooldown > CurTime() then
			RP:Error(ply, RP.colors.white, "Vote-demotion is cooling down, try again in ", RP.colors.blue, RP:FormatTime(math.ceil(cooldown-CurTime())), RP.colors.white, ".")
			return
		end
		cooldown=CurTime()+RP:GetSetting("demotecooldown")
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