-- Change team

RP:AddSetting("adminteamvote", false)
RP:AddSetting("teamvotecooldown", 60)

function RP:ChangeTeam( ply, n )
	local t = RP.Team[n]
	if not t then return end
	
	if n==0 then
		return
	end
	
	if ply:Team()==n then
		--RP:Error(ply, RP.colors.white, "You are already on class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
		ply:Spawn()
		return
	end
	
	if RP.Team[n].maxplayers and (team.NumPlayers(n) >= RP.Team[n].maxplayers) then
		RP:Error(ply, RP.colors.white, "Sorry, the server is at maximum players on class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
		return
	end
	
	if RP.Team[n].votejoin then
		if ply.TeamVoteCooldown then
			local timeleft=math.floor(ply.TeamVoteCooldown-CurTime())
			if timeleft > 0 then
				RP:Error( ply, RP.colors.white, "Team-Vote cooling down - try again in "..RP:FormatTime(timeleft).."." )
				return
			end
		end
		if not (ply:RP_IsAdmin() and not RP:GetSetting("adminteamvote")) and #player.GetHumans() >= 2 then
			Vote:Create("Allow "..ply:Nick()..": '"..team.GetName(n).."'?", {"Yes", "No"}, function(winner,results,isRandom,msg)
				RP:Notify(RP.colors.blue, "TeamVote Results: ", RP.colors.white, msg)
				if isRandom then
					RP:Notify(RP.colors.white, "Vote to make "..ply:Nick().." join the class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' tied, auto-failing..")
					return
				elseif winner[1]=="Yes" then
					RP:Notify(RP.colors.white, "TeamVote succeeded, ", RP.colors.blue, ply:Nick(), RP.colors.white, " is now on class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
					ply:SetTeam( n )
					ply:Spawn()
				else
					RP:Notify(RP.colors.white, "TeamVote failed, sorry ", RP.colors.blue, ply:Nick(), RP.colors.white, "!")
				end
				ply.TeamVoteCooldown=CurTime()+RP:GetSetting("teamvotecooldown")
			end)
			return
		end
	end
	
	RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has joined the class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
	ply:CloseMenu()
	ply:SetTeam(n)
	ply:Spawn()
end

util.AddNetworkString("RP-TeamMenu")
util.AddNetworkString("RP-ChangeTeam")

function GM:ShowSpare2( ply )
    net.Start("RP-TeamMenu")
		net.WriteBit(true)
	net.Send(ply)
end

net.Receive("RP-ChangeTeam", function(len,ply)
	RP:ChangeTeam(ply,net.ReadFloat())
end)