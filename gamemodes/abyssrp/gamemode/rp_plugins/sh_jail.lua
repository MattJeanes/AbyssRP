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
	if (ply:IsAdmin() or ply:IsSuperAdmin()) or ply:Team()==RP:GetTeamN("police chief") and not JailSupport then
		RP.jailPos = ply:GetEyeTraceNoCursor().HitPos
		RP:Notify( RP.colors.blue, ply:Nick(), RP.colors.white, " has set the jail position." )
		RP.jailPosCount = 1
	else
		RP:Error( ply, RP.colors.white, "This map has built in jail positions!")
	end
end

RP:AddPlugin( PLUGIN )