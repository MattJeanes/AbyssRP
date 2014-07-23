/*-------------------------------------------------------------------------------------------------------------------------
	RP Names
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Roleplay Name"
PLUGIN.Description = "Give yourself a roleplay nickname."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "rpname"
PLUGIN.Usage = "<name>"
PLUGIN.Privileges = { "RP Name" }

function PLUGIN:Call( ply, args )
	if not args[1] and ply:GetPData("rpname") then
		RP:Notify(ply, RP.colors.white, "You have disabled your roleplay name.")
		ply:RemovePData("rpname")
		UpdateRPNames()
		return
	elseif not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid arguments.")
		return
	end
	
	local nick="~"..table.concat(args, " ")
	RP:Notify(ply, RP.colors.white, "You have set your roleplay name to: "..nick)
	ply:SetPData("rpname", nick)
	UpdateRPNames()
end

RP:AddPlugin( PLUGIN )