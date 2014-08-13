-- Change team

RP:AddSetting("adminjobvote", false)
RP:AddSetting("jobvotecooldown", 60)

function RP:ChangeTeam( ply, n )
	local t = RP.Team[n]
	if not t then return end
	
	if n==0 then
		return
	end
	
	if ply:Team()==n then
		--RP:Error(ply, RP.colors.white, "You are already on the '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' job.")
		ply:Spawn()
		return
	end
	
	if RP.Team[n].maxplayers and (team.NumPlayers(n) >= RP.Team[n].maxplayers) then
		RP:Error(ply, RP.colors.white, "Sorry, the server is at maximum players on the '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' job.")
		return
	end
	
	if RP.Team[n].votejoin then
		if ply.JobVoteCooldown then
			local timeleft=math.ceil(ply.JobVoteCooldown-CurTime())
			if timeleft > 0 then
				RP:Error( ply, RP.colors.white, "JobVote cooling down - try again in "..RP:FormatTime(timeleft).."." )
				return
			end
		end
		if not (ply:RP_IsAdmin() and not RP:GetSetting("adminjobvote")) and #player.GetAll() >= 2 then
			Vote:Create("Allow "..ply:Nick()..": '"..team.GetName(n).."'?", {"Yes", "No"}, function(winner,results,isRandom,msg)
				RP:Notify(RP.colors.blue, "JobVote Results: ", RP.colors.white, msg)
				if isRandom then
					RP:Notify(RP.colors.white, "Vote to make "..ply:Nick().." join the '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' job tied, auto-failing..")
					return
				elseif winner[1]=="Yes" then
					RP:Notify(RP.colors.white, "JobVote succeeded, ", RP.colors.blue, ply:Nick(), RP.colors.white, " is now on the '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' job.")
					ply:SetTeam( n )
					ply:Spawn()
				else
					RP:Notify(RP.colors.white, "JobVote failed, sorry ", RP.colors.blue, ply:Nick(), RP.colors.white, "!")
				end
				ply.JobVoteCooldown=CurTime()+RP:GetSetting("jobvotecooldown")
			end)
			return
		end
	end
	
	RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has joined the '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' job.")
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