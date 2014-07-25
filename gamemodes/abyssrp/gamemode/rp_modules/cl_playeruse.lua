surface.CreateFont("Arial16", {size=16})
surface.CreateFont("Arial24", {size=24, weight=800})

function RP:PlayerUse(e)
	local DFrame = vgui.Create('DFrame')
	DFrame:SetSize(350,190)
	DFrame:Center()
	DFrame:SetTitle('Player Menu')
	DFrame:MakePopup()
	
	local DLabel = vgui.Create("DLabel", DFrame)
	DLabel:SetPos(10, 30)
	DLabel:SetSize(DFrame:GetWide(),DFrame:GetTall())
	DLabel:SetText(e:Nick()..": "..team.GetName(e:Team()))
	DLabel:SetTextColor(color_white)
	DLabel:SetFont("Arial24")
	DLabel:SizeToContents()

	local DLabel = vgui.Create("DLabel", DFrame)
	DLabel:SetPos(10, 60)
	DLabel:SetSize(DFrame:GetWide(),DFrame:GetTall())
	DLabel:SetText("Please enter an amount or a message into the box below\nand press the corresponding button.")
	DLabel:SetTextColor(color_white)
	DLabel:SetFont("Arial16")
	DLabel:SizeToContents()
	
	local DTextEntry = vgui.Create("DTextEntry", DFrame)
	DTextEntry:SetPos(10, 100)
	DTextEntry:SetWide(330)
	
	local DButton = vgui.Create('DButton', DFrame)
	DButton:SetPos( 10, 130 )
	DButton:SetSize( 160, 50 )
	DButton:SetText('Give Cash')
	DButton.DoClick = function()
		LocalPlayer():ConCommand("rp givecash \""..e:SteamID().."\" "..DTextEntry:GetValue()) -- RunConsoleCommand causes weird behaviour
		DFrame:Close()
	end
	
	local DButton = vgui.Create('DButton', DFrame)
	DButton:SetPos( 180, 130 )
	DButton:SetSize( 160, 50 )
	DButton:SetText('Send PM')
	DButton.DoClick = function()
		LocalPlayer():ConCommand("rp pm \""..e:SteamID().."\" "..DTextEntry:GetValue()) -- RunConsoleCommand causes weird behaviour
		DFrame:Close()
	end
end

local d=0
hook.Add("KeyPress", "PlayerUsePlayer", function(ply, key)
	if key==IN_USE then
		local e=LocalPlayer():GetEyeTraceNoCursor().Entity
		if not IsValid(e) then return end
		if e:GetClass()=="player" and e:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
			if d > CurTime() then return end
			d=CurTime()+1
			RP:PlayerUse(e)
		end
	end
end)