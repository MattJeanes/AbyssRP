/*-------------------------------------------------------------------------------------------------------------------------
	Change Job with a plugin
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Change Job"
PLUGIN.Description = "To change peoples job with a console command"
PLUGIN.Author = "Matt J"
PLUGIN.ChatCommand = "job"
PLUGIN.Usage = "<name>"

function PLUGIN:Call( ply, args )
	local job
	local arg = string.Implode(" ", args)
	for i=1,#team.GetAllTeams() do
		if string.lower(arg) == string.lower(team.GetName(i)) then
			job = i
			break
		end
	end

	if not job then
		RP:Notify( ply, RP.colors.white, "ERROR: ", RP.colors.red, "Invalid choice!")
		return
	end

	RP:ChangeTeam(ply,job)
end

RP:AddPlugin( PLUGIN )