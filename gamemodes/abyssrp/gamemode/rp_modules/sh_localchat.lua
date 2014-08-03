-- Local chat

if SERVER then
	RP:AddSetting("localchat",false)
	
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
	
	hook.Add("PlayerCanSeePlayersChat", "RP-Localchat", function(text,teamonly,listener,speaker)
		if not RP:GetSetting("localchat") then return end
		if listener != speaker and listener:GetPos():Distance(speaker:GetPos()) > 250 then
			return false
		end
	end)
elseif CLIENT then
	function GM:OnPlayerChat( ply, txt, teamchat, dead )
		local tab = {}

		if ( dead ) then
			table.insert( tab, Color( 255, 30, 40 ) )
			table.insert( tab, "*DEAD* " )
		end

		if ( teamchat ) then
			table.insert( tab, Color( 30, 160, 40 ) )
			table.insert( tab, "(TEAM) " )
		end

		if ( IsValid( ply ) ) then
			table.insert( tab, team.GetColor( ply:Team() ) )
			table.insert( tab, ply:Nick() )
		else
			table.insert( tab, "Console" )
		end

		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, ": " .. txt )

		chat.AddText( unpack( tab ) )

		return true
	end
	
	surface.CreateFont("RP-Localchat",
		{
			font="Marlett",
			size=ScreenScale(7),
			weight=500
		}
	)

	hook.Add("HUDPaint", "RPWhoCanHear", function()
		if RP:GetSetting("localchat") and ChatOpen then
			local n=ScrH()*0.023
			local w, l = ScrW()/80, ScrH()/1.75
			local h = l - (#CalcHear() * n) - n
			draw.WordBox(2, w, h, "The following people can hear you:", "RP-Localchat", Color(0,0,0,150), Color(39, 174, 96, 250))
			for k,v in pairs(CalcHear()) do
				draw.WordBox(2, w, h + k*n, v, "RP-Localchat", Color(0,0,0,150), Color(255,255,255,150))
			end
		end
	end)

	function RP:WhoCanHear(size)
		local t={}
		for k,v in pairs(player.GetAll()) do
			if v ~= LocalPlayer() then
				local distance = LocalPlayer():GetPos():Distance(v:GetPos())
				if distance<=size then
					table.insert(t,v:Nick())
				end
			end
		end
		if #t == 0 then return {"No-one"} elseif #t==#player.GetAll() then return {"Everyone"} else return t end
	end

	function CalcHear()
		if ChatText then
			if string.sub(ChatText,1,2) == "/w" then
				return RP:WhoCanHear(90)
			elseif string.sub(ChatText,1,2) == "/y" then
				return RP:WhoCanHear(550)
			elseif string.sub(ChatText,1,4) == "/ooc" then
				return {"Everyone"}
			elseif string.sub(ChatText,1,2) == "//" then
				return {"Everyone"}
			else
				return RP:WhoCanHear(250)
			end
		else
			return {}
		end
	end

	hook.Add("StartChat", "RPWhoCanHear", function()
		ChatOpen=true
	end)

	hook.Add("FinishChat", "RPWhoCanHear", function()
		ChatOpen=nil
	end)

	hook.Add("ChatTextChanged", "RPWhoCanHear", function(text)
		ChatText=text
	end)
end