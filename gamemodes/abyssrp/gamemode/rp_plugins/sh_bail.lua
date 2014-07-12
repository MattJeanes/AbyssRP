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
	util.AddNetworkString("RP-Bail")
	net.Receive("RP-Bail", function(len,ply)
		if ply:GetCash() >= tonumber(GetConVarNumber("rp_costtobail")) then
			ply:TakeCash(tonumber(GetConVarNumber("rp_costtobail")))
			RP:UnarrestPlayer( ply, true )
			if timer.Exists("JailTimer-"..ply:SteamID()) then
				timer.Stop("JailTimer-"..ply:SteamID())
			end
		else
			RP:Error(ply, RP.colors.white, "You do not have enough cash!")
		end
	end)
end

RP:AddPlugin( PLUGIN )