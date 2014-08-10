-- Local chat

function RP:PlayerHearPlayer(a,b,mode)
	if not IsValid(a) or not IsValid(b) then return true end
	local dist=a:GetPos():Distance(b:GetPos())
	if mode == 1 then -- Whisper
		return dist < RP:GetSetting("whisperdist",0)
	elseif mode == 2 then -- Yell
		return dist < RP:GetSetting("yelldist",0)
	elseif mode == 3 or mode == 4 then -- OOC
		return true
	else -- Normal
		return dist < RP:GetSetting("talkdist",0)
	end
end

function RP:GetLocalMode(text)
	if not text then return 0 end
	local cmd=string.sub(text,1,1)
	if cmd=="!" or cmd=="/" then
		local mode=string.lower(string.sub(text,2,2))
		if mode == "w" then -- Whisper
			return 1
		elseif mode == "y" then -- Yell
			return 2
		elseif string.sub(text,2,4) == "ooc" then -- OOC
			return 3
		elseif cmd=="/" and mode == "/" then -- OOC Alt
			return 4
		end
	end
	return 0 -- Normal
end

if SERVER then
	RP:AddSetting("localchat",false)
	RP:AddSetting("talkdist",250)
	RP:AddSetting("whisperdist",90)
	RP:AddSetting("yelldist",550)
	
	util.AddNetworkString("RP-Localchat")
	
	function GM:PlayerSay(ply,text,teamchat)
		if not RP:GetSetting("localchat",false) then return text end
		local mode=RP:GetLocalMode(text)
		if mode==1 or mode==2 or mode==4 then
			text=string.Trim(string.sub(text,3))
		elseif mode==3 then
			text=string.Trim(string.sub(text,5))
		end
		if string.len(text)==0 then return "" end
		net.Start("RP-Localchat")
			net.WriteEntity(ply)
			net.WriteString(text)
			net.WriteBit(teamchat)
			if IsValid(ply) then
				net.WriteBit(not ply:Alive())
			else
				net.WriteBit(false)
			end
			net.WriteFloat(mode)
		net.Broadcast()
		return text
	end
elseif CLIENT then	
	local ChatOpen,ChatText
	
	net.Receive("RP-Localchat", function(len)
		local ply = net.ReadEntity()
		local text = net.ReadString()
		local teamchat = tobool(net.ReadBit())
		local dead = tobool(net.ReadBit())
		local mode = net.ReadFloat()
		
		if not RP:PlayerHearPlayer(LocalPlayer(),ply,mode) then return end
	
		local tab = {}
		
		if ( dead ) then
			table.insert( tab, Color( 255, 30, 40 ) )
			table.insert( tab, "*DEAD* " )
		end

		if ( teamchat ) then
			table.insert( tab, Color( 30, 160, 40 ) )
			table.insert( tab, "(TEAM) " )
		end
		
		if mode ~= 0 then
			table.insert( tab, Color( 255, 255, 255 ) )
			if mode==1 then
				table.insert( tab, "(Whisper) " )
			elseif mode==2 then
				table.insert( tab, "(Yell) " )
			elseif mode==3 or mode==4 then
				table.insert( tab, "(OOC) " )
			else
				table.insert( tab, "" ) -- Failsafe
			end
		end
		
		if ( IsValid( ply ) ) then
			table.insert( tab, team.GetColor( ply:Team() ) )
			table.insert( tab, ply:Nick() )
		else
			table.insert( tab, "Console" )
		end

		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, ": " .. text )

		chat.AddText( unpack( tab ) )
	end)

	hook.Add("OnPlayerChat", "RP-Localchat", function( ply, text, teamchat, dead )
		if RP:GetSetting("localchat", false) then return true end
	
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
		table.insert( tab, ": " .. text )

		chat.AddText( unpack( tab ) )

		return true
	end)
	
	surface.CreateFont("RP-Localchat",
		{
			font="Marlett",
			size=ScreenScale(7),
			weight=500
		}
	)
	
	local function WhoCanHear(mode)
		local t={}
		for k,v in pairs(player.GetAll()) do
			if v ~= LocalPlayer() then
				if RP:PlayerHearPlayer(LocalPlayer(),v,mode) then
					table.insert(t,v:Nick())
				end
			end
		end
		if #t == 0 then
			return {"No-one"}
		elseif (#t==#player.GetAll()-1) then
			return {"Everyone"}
		else
			return t
		end
	end

	hook.Add("HUDPaint", "RP-Localchat", function()
		if RP:GetSetting("localchat") and ChatOpen then
			local t=WhoCanHear(RP:GetLocalMode(ChatText))
			local n=ScrH()*0.023
			local w, l = ScrW()/80, ScrH()/1.75
			local h = l - (#t * n) - n
			draw.WordBox(2, w, h, "The following people can hear you:", "RP-Localchat", Color(0,0,0,150), Color(39, 174, 96, 250))
			for k,v in pairs(t) do
				draw.WordBox(2, w, h + k*n, v, "RP-Localchat", Color(0,0,0,150), Color(255,255,255,150))
			end
		end
	end)

	hook.Add("StartChat", "RP-Localchat", function()
		ChatOpen=true
	end)

	hook.Add("FinishChat", "RP-Localchat", function()
		ChatOpen=nil
	end)

	hook.Add("ChatTextChanged", "RP-Localchat", function(text)
		ChatText=text
	end)
end