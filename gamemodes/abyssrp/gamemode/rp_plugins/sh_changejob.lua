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
	
	local arg = string.Implode(" ", args)
	for i=1,#team.GetAllTeams() do
		if string.lower(arg) == string.lower(team.GetName(i)) then
			JobFound = true
			JobNum = i
		end
	end

	if not JobFound then
		RP:Notify( ply, RP.colors.white, "ERROR: ", RP.colors.red, "Invalid choice!")
		return
	end

	ply:ConCommand("rp_changeteam " .. tostring(JobNum))
	JobFound = false
	JobNum = nil
end

RP:AddPlugin( PLUGIN )