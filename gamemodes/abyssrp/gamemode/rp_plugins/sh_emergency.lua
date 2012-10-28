/*-------------------------------------------------------------------------------------------------------------------------
	Emergency Notification
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Emergency"
PLUGIN.Description = "Allow certain teams to give a serverside emergency announcement."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "emergency"
PLUGIN.Usage = "<emergency>"
PLUGIN.Privileges = { "Emergency" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	if ply:Team()==RP:GetTeamN("police chief") or ply:Team()==RP:GetTeamN("mayor") then
		RP:Notify(Color(255,0,0), "EMERGENCY: ".. table.concat(args, " "))
	else
		RP:Error(ply, RP.colors.white, "You are not the Police Chief or Mayor!")
	end
end

RP:AddPlugin( PLUGIN )