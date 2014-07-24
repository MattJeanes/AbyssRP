local meta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString("RP-ShowMenu")
	function meta:ShowMenu()
		net.Start("RP-ShowMenu") net.Send(self)
	end
elseif CLIENT then
	function meta:ShowMenu()
		local frame = vgui.Create("DFrame")
		frame:SetSize(480,300)
		frame:SetPos((ScrW()/2)-(frame:GetWide()/2), (ScrH()/2)-(frame:GetTall()/2))
		frame:SetTitle("Menu")
		frame:ShowCloseButton(true)
		frame:MakePopup()
		
		local sheet = vgui.Create("DPropertySheet",frame)
		sheet:SetSize(frame:GetWide()-10,frame:GetTall()-35)
		sheet:SetPos(5,30)
		
		local x,y=sheet:GetWide()-15,sheet:GetTall()-35
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Menu.\nHello "..LocalPlayer():Nick()..".")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(0,0)
		
		sheet:AddSheet("Home",panel)
		
		hook.Call("RP-Menu", GAMEMODE, sheet, x, y)
	end
	net.Receive("RP-ShowMenu", function(len)
		LocalPlayer():ShowMenu()
	end)
end