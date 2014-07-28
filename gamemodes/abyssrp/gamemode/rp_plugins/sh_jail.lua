/*-------------------------------------------------------------------------------------------------------------------------
	Set the jail position!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Set Jail"
PLUGIN.Description = "Allows a player to set the jail position!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "setjail"
PLUGIN.Usage = nil

function PLUGIN:Call( ply, args )
	if ply:RP_IsAdmin() or ply:Team()==RP:GetTeamN("police chief") and #RP.JailPoses > 0 then
		RP.JailPos = ply:GetEyeTraceNoCursor().HitPos
		RP:Notify( RP.colors.blue, ply:Nick(), RP.colors.white, " has set the jail position." )
	else
		RP:Error( ply, RP.colors.white, "This map has built in jail positions!")
	end
end

RP:AddPlugin( PLUGIN )