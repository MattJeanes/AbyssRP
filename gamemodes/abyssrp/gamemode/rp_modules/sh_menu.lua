local meta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString("RP-ShowMenu")
	function meta:ShowMenu()
		net.Start("RP-ShowMenu") net.Send(self)
	end
	function GM:ShowSpare1( ply )
		ply:ShowMenu()
	end
elseif CLIENT then
	local acts={
		robot="Dance: Robot",
		dance="Dance",
		zombie="Zombie",
		cheer="Cheer",
		laugh="Laugh",
		muscle="Dance: Sexy",
		pers="I'm a dick",
		halt="Halt",
		salute="Salute",
		disagree="Disagree",
		bow="Bow",
		becon="Come here",
		agree="Thumbs up",
		wave="Wave"
	}
	function meta:ShowMenu()
		local frame = vgui.Create("DFrame")
		frame:SetSize(480,300)
		frame:Center()
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
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(100,panel:GetTall())
		listview:SetPos(panel:GetWide()-listview:GetWide()-1,0)
		listview:AddColumn("Gestures")
		listview:SetMultiSelect(false)
		for k,v in pairs(acts) do
			listview:AddLine(v)
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(acts) do
				if v==name then
					RunConsoleCommand("act",k)
					frame:Close()
				end
			end
		end
		
		sheet:AddSheet("Home",panel)
		
		hook.Call("RP-Menu", GAMEMODE, sheet, x, y)
	end
	net.Receive("RP-ShowMenu", function(len)
		LocalPlayer():ShowMenu()
	end)
end