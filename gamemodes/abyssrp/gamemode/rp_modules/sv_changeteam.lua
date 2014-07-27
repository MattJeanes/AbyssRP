local function changeteam( ply, n )
	local t = RP.Team[n]
	if ply:InVehicle() then
		RP:Error(ply, RP.colors.white, "You cannot change class in a vehicle!")
		return
	elseif n==0 then
		RP:Error(ply, RP.colors.white, "You cannot have no class!")
		ply:PrintMessage(HUD_PRINTCENTER, "ERROR: You cannot have no class!")
		timer.Simple(1,function()
			ply:ConCommand("team_menu")
		end)
		return
	elseif ply:Team()==n then
		--RP:Error(ply, RP.colors.white, "You are already on class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
		ply:Spawn()
	elseif RP.Team[n].maxplayers and (team.NumPlayers(n) >= RP.Team[n].maxplayers) then
		RP:Error(ply, RP.colors.white, "Sorry, the server is at maximum players on class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
		if ply:Team() == 0 then
			timer.Simple(1,function()
				ply:ConCommand("team_menu")
			end)
		end
		return
	elseif RP.Team[n].votejoin then
		if ply:RP_IsAdmin() and GetConVarNumber("rp_adminteamvote")==0 then
			RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has joined the class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
			ply:SetTeam( n )
			ply:Spawn()
			return
		end
		if ( #player.GetAll() < 2 ) then
			RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has joined the class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
			ply:SetTeam( n )
			ply:Spawn()
			return
		end
		if ply.TeamVoteCooldown then
			local timeleft=math.floor(ply.TeamVoteCooldown-CurTime())
			if timeleft > 0 then
				RP:Error( ply, RP.colors.white, "Team-Vote cooling down - try again in "..timeleft.." seconds." )
				if ply:Team()==0 then ply:ConCommand("team_menu") end
				return
			end
		end
		Vote:Create("Allow "..ply:Nick()..": '"..team.GetName(n).."'?", {"Yes", "No"}, function(winner,results,isRandom,msg)
			RP:Notify(RP.colors.blue, "TeamVote Results: ", RP.colors.white, msg)
			if isRandom then
				RP:Notify(RP.colors.white, "Vote to make "..ply:Nick().." join the class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "' tied, auto-failing..")
				if ply:Team()==0 then ply:ConCommand("team_menu") end
				return
			elseif winner[1]=="Yes" then
				RP:Notify(RP.colors.white, "TeamVote succeeded, ", RP.colors.blue, ply:Nick(), RP.colors.white, " is now on class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
				ply:SetTeam( n )
				ply:Spawn()
			else
				RP:Notify(RP.colors.white, "TeamVote failed, sorry ", RP.colors.blue, ply:Nick(), RP.colors.white, "!")
				if ply:Team()==0 then ply:ConCommand("team_menu") end
			end
			ply.TeamVoteCooldown=CurTime()+GetConVarNumber("rp_teamvotecooldown")
		end)
	else
		RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has joined the class '", team.GetColor(n), string.lower(team.GetName(n)), RP.colors.white, "'.")
		ply:SetTeam( n ) //Make the player join the team
		ply:Spawn()
	end
end
concommand.Add( "rp_changeteam", changeteam )

util.AddNetworkString("RP-TeamMenu")
util.AddNetworkString("RP-ChangeTeam")

function GM:ShowSpare2( ply )
    net.Start("RP-TeamMenu")
		net.WriteBit(true)
	net.Send(ply)
end

net.Receive("RP-ChangeTeam", function(len,ply)
	changeteam(ply,net.ReadFloat())
end)

CreateConVar( "rp_admindemote", "0", FCVAR_NOTIFY )
CreateConVar( "rp_adminteamvote", "0", FCVAR_NOTIFY )
CreateConVar( "rp_demotecooldown", "60", FCVAR_NOTIFY )
CreateConVar( "rp_teamvotecooldown", "60", FCVAR_NOTIFY )