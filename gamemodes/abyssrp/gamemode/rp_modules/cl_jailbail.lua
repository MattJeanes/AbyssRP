function jailbail_menu( ply, command, cost )
	local DButton2
	local DButton1
	local DTextEntry1
	local DLabel1
	local DFrame1

	DFrame1 = vgui.Create('DFrame')
	DFrame1:SetSize(ScrW() * 0.16, ScrH() * 0.25)
	DFrame1:Center()
	DFrame1:SetTitle('Jail Bail!')
	DFrame1:SetSizable(false)
	DFrame1:SetDeleteOnClose(false)
	DFrame1:MakePopup()

	DLabel1 = vgui.Create('DLabel')
	DLabel1:SetParent(DFrame1)
	DLabel1:SetPos(ScrW() * 0.01, ScrH() * 0.04)
	DLabel1:SetText("You are in jail, oh no!\nYou can bail out using the button below!\n\nBailing out costs: $"..GetConVarNumber("rp_costtobail").."!")
	DLabel1:SizeToContents()

	DButton1 = vgui.Create('DButton')
	DButton1:SetParent(DFrame1)
	DButton1:SetSize(ScrW() * 0.14, ScrH() * 0.12)
	DButton1:SetPos( ScrW() * 0.01, ScrH() * 0.12 )
	DButton1:SetText('Bail my ass outta this jail!')
	DButton1.DoClick = function()
		net.Start("RP-Bail")
		net.SendToServer()
	DFrame1:Close()
	end
end

concommand.Add( "rp_jailbail", jailbail_menu )