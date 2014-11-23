/*-------------------------------------------------------------------------------------------------------------------------
	RP Names
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Roleplay Name"
PLUGIN.Description = "Give yourself a roleplay nickname."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "rpname"
PLUGIN.Usage = "[name]"
PLUGIN.Privileges = { "RP Name" }

function PLUGIN:Call( ply, args )
	if not args[1] and ply:GetValue("rpname",nil) then
		RP:Notify(ply, RP.colors.white, "You have disabled your roleplay name.")
		ply:SetValue("rpname", nil)
		RP:UpdateCustomNames()
		return
	elseif not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid arguments.")
		return
	end
	
	local nick="~"..table.concat(args, " ")
	RP:Notify(ply, RP.colors.white, "You have set your roleplay name to: "..nick)
	ply:SetValue("rpname", nick)
	RP:UpdateCustomNames()
end

RP:AddPlugin( PLUGIN )