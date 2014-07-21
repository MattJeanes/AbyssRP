surface.CreateFont("Arial16", {size=16})
surface.CreateFont("Arial24", {size=24, weight=800})

local d=0
hook.Add("KeyPress", "PlayerUsePlayer", function(ply, key)
	if key==IN_USE then
		local e=LocalPlayer():GetEyeTraceNoCursor().Entity
		if not IsValid(e) then return end
		if e:GetClass()=="player" and e:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
			if d > CurTime() then return end
			d=CurTime()+1
			
			

			local DFrame1 = vgui.Create('DFrame')
			DFrame1:SetSize(ScrW() * 0.16, ScrH() * 0.25)
			DFrame1:Center()
			DFrame1:SetTitle('Player Menu')
			DFrame1:SetSizable(false)
			DFrame1:SetDeleteOnClose(false)
			DFrame1:MakePopup()
			
			local DLabel2 = vgui.Create("DTextEntry", DFrame1)
			DLabel2:SetPos(ScrW()*0.01, ScrH()*0.03)
			DLabel2:SetSize(ScrW() * 0.15, ScrH() * 0.25)
			DLabel2:SetMultiline(true)
			DLabel2:SetWrap(true)
			DLabel2:SetText(e:Nick()..": "..team.GetName(e:Team())..".")
			DLabel2:SetTextColor(color_white)
			DLabel2:SetFont("Arial24")
			DLabel2:SetDrawBackground(false)
			DLabel2:SetDrawBorder(false)
			DLabel2:SetEditable(false)

			local DLabel1 = vgui.Create("DTextEntry", DFrame1)
			DLabel1:SetPos(ScrW()*0.01, ScrH()*0.08)
			DLabel1:SetSize(ScrW() * 0.15, ScrH() * 0.25)
			DLabel1:SetMultiline(true)
			DLabel1:SetWrap(true)
			DLabel1:SetText("Please enter an amount or a message into the box below and press the corresponding button.")
			DLabel1:SetTextColor(color_white)
			DLabel1:SetFont("Arial16")
			DLabel1:SetDrawBackground(false)
			DLabel1:SetDrawBorder(false)
			DLabel1:SetEditable(false)
			
			local DTextEntry1 = vgui.Create("DTextEntry", DFrame1)
			DTextEntry1:SetPos(ScrW()*0.01, ScrH()*0.13)
			DTextEntry1:SetSize(ScrW() * 0.14, ScrH() * 0.02)
			
			local DButton1 = vgui.Create('DButton', DFrame1)
			DButton1:SetSize( ScrW() * 0.06, ScrH() * 0.06 )
			DButton1:SetPos( ScrW() * 0.01, ScrH() * 0.17 )
			DButton1:SetText('Give Cash')
			DButton1.DoClick = function()
				RunConsoleCommand("rp", "givecash", e:SteamID(), DTextEntry1:GetValue())
				DFrame1:Close()
			end
			
			local DButton2 = vgui.Create('DButton', DFrame1)
			DButton2:SetSize( ScrW() * 0.06, ScrH() * 0.06 )
			DButton2:SetPos( ScrW() * 0.09, ScrH() * 0.17 )
			DButton2:SetText('Send PM')
			DButton2.DoClick = function()
				RunConsoleCommand("rp", "pm", e:SteamID(), DTextEntry1:GetValue())
				DFrame1:Close()
			end
		end
	end
end)