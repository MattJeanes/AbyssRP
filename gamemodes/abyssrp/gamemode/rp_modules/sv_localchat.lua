hook.Add("PlayerSay", "RP_CustomName", function(ply, text)
	if not ( string.Left( text, 1 ) == "/" or string.Left( text, 1 ) == "!" or string.Left( text, 1 ) == "@" ) then
		if GetConVarNumber("rp_localchat")==0 then
			RP:Notify( team.GetColor(ply:Team()), ply:Nick(), RP.colors.white, ": "..text )
			print(ply:Nick()..": "..text)
		else
			RP:TalkToRange(ply, text, 250)
			print(ply:Nick()..": "..text)
		end
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