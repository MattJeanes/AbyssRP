/*-------------------------------------------------------------------------------------------------------------------------
	Escape from jail!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "bail"
PLUGIN.Description = "Allows a player to bail out of jail!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "bail"

function PLUGIN:Call( ply, args )
	if ply.RP_Jailed and (args[1] != "letmeout") then
		ply:ConCommand("rp_jailbail")
	else
		RP:Error(ply, RP.colors.white, "You are not in jail!")
	end
end

if SERVER then
	RP:AddSetting("bailcost",1000)
	
	util.AddNetworkString("RP-Bail")
	net.Receive("RP-Bail", function(len,ply)
		if ply:GetCash() >= RP:GetSetting("bailcost") then
			ply:TakeCash(RP:GetSetting("bailcost"))
			local success=ply:Unarrest()
			if success then
				RP:Notify(ply, RP.colors.white, "You have bailed out of jail!")
				RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " bailed themselves out of jail!")
			else
				RP:Notify(ply, RP.colors.white, "Failure to bail out of jail!")
			end
		else
			RP:Error(ply, RP.colors.white, "You do not have enough cash!")
		end
	end)
end

RP:AddPlugin( PLUGIN )