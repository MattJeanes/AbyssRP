/*-------------------------------------------------------------------------------------------------------------------------
	Achievements!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Achievements"
PLUGIN.Description = "To see what achievements you have!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "achievements"
PLUGIN.Usage = "[name]"

function PLUGIN:Call( ply, args )
	local arg = string.Implode(" ", args)
	
	if not args[1] then
		RP:Notify(ply, RP.colors.white, "Achievements:")
		for k,v in ipairs(RP.Achievements) do
			timer.Simple((k/4), function()
				if ply:Achieved(v) then
					RP:Notify(ply, RP.colors.white, v.name .. ": ", RP.colors.blue, "Achieved", RP.colors.white, ".")
				else
					RP:Notify(ply, RP.colors.white, v.name .. ": ", RP.colors.red, "Not Achieved", RP.colors.white, ".")
				end
			end)
		end
		return
	end
	
	for k,v in pairs(RP.Achievements) do
		if string.lower(arg) == string.lower(v.name) then
			RP:Notify(ply, RP.colors.white, "Name: ", RP.colors.blue, v.name)
			RP:Notify(ply, RP.colors.white, "Description: ", RP.colors.blue, v.desc)
			RP:Notify(ply, RP.colors.white, "Reward: ", RP.colors.blue,  RP:CC(v.reward))
			if v.total then
				RP:Notify(ply, RP.colors.white, "Progress: ", RP.colors.blue, tostring(ply:GetAchievementValue(v,"c",0)), RP.colors.white, "/", RP.colors.blue, tostring(v.total))
			end
			if ply:Achieved(v) then
				RP:Notify(ply, RP.colors.white, "Achieved: ", RP.colors.blue, "Yes")
			else
				RP:Notify(ply, RP.colors.white, "Achieved: ", RP.colors.red, "No")
			end
			return
		end
	end
end

RP:AddPlugin( PLUGIN )