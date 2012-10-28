/*-------------------------------------------------------------------------------------------------------------------------
	Events
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Events"
PLUGIN.Description = "Show an event to the server"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "event"
PLUGIN.Usage = "<event>"
PLUGIN.Privileges = { "Event" }

function PLUGIN:Call( ply, args )
	if not ply:RP_IsAdmin() then
		RP:Error(ply, RP.colors.white, "You are not an admin.")
		return
	end
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end

	RP:Notify(Color(255,140,0), "EVENT: ".. table.concat(args, " "))
end

RP:AddPlugin( PLUGIN )