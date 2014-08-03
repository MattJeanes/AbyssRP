-- Climb core

resource.AddFile("sound/climbswep/rolls/roll_1.mp3") -- Using a wav that is 170 kb? No thanks, it has the same quality even if it's in MP3 format.

local function CSWEP_UpdateSettings(ply)
	if not ply:RP_IsAdmin() then
		ply:ChatPrint("Admin-only.")
		return
	end
	
	game.ConsoleCommand("cswep_snapsallowed " .. math.Clamp(tonumber(ply:GetInfo("cswep_snapsallowed_cl")), 0, 1) .. "\n")
	game.ConsoleCommand("cswep_gradualaccel " .. math.Clamp(tonumber(ply:GetInfo("cswep_gradualaccel_cl")), 0, 1) .. "\n")
	game.ConsoleCommand("cswep_gradualaccel_global " .. math.Clamp(tonumber(ply:GetInfo("cswep_gradualaccel_global_cl")), 0, 1) .. "\n") 
end

concommand.Add("cswep_updatesettings", CSWEP_UpdateSettings)

local function CSWEP_ResetSettings(ply)
	if not ply:RP_IsAdmin() then
		ply:ChatPrint("Admin-only.")
		return
	end
	
	game.ConsoleCommand("cswep_snapsallowed 1\n")
	game.ConsoleCommand("cswep_gradualaccel 1\n")
	game.ConsoleCommand("cswep_gradualaccel_global 0\n")
	
	for k, v in pairs(player.GetAll()) do
		if v:RP_IsAdmin() then
			v:ConCommand("cswep_snapsallowed_cl 1")
			v:ConCommand("cswep_gradualaccel_cl 1")
			v:ConCommand("cswep_gradualaccel_global_cl 0")
		end
	end
end

concommand.Add("cswep_resetsettings", CSWEP_ResetSettings)