hook.Add("PlayerSay", "RP-Localchat", function(ply, text)
	if GetConVarNumber("rp_localchat")==1 then
		RP:TalkToRange(ply, text, 250)
		print(ply:Nick()..": "..text)
		return ""
	end
end)

function RP:TalkToRange(ply, text, size, mode)
	local ents = ents.FindInSphere(ply:EyePos(), size)
	for k, v in pairs(ents) do
		if v:IsPlayer() then
			if mode then
				RP:Notify( v, RP.colors.white, "("..mode..") ", team.GetColor(ply:Team()), ply:Nick(), RP.colors.white, ": "..text )
			else
				RP:Notify( v, team.GetColor(ply:Team()), ply:Nick(), RP.colors.white, ": "..text )
			end
		end
	end
end