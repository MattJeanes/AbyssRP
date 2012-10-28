AddCSLuaFile()

hook.Add("HUDPaint", "RPWhoCanHear", function()
	if GetConVarNumber("rp_localchat") == 1 and ChatOpen then
		local n=ScrH()*0.02
		local w, l = ScrW()/80, ScrH()/1.75
		local h = l - (#CalcHear() * n) - n
		draw.WordBox(2, w, h, "The following people can hear you:", "AbyssRPHUD2", Color(0,0,0,160), Color(0,255,0,255))
		for k,v in pairs(CalcHear()) do
			draw.WordBox(2, w, h + k*n, v, "AbyssRPHUD2", Color(0,0,0,160), Color(255,255,255,255))
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