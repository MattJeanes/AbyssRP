surface.CreateFont( "LargeFont", {size=48} )
surface.CreateFont( "MediumFont", {size=24} )
surface.CreateFont( "SmallFont", {size=16} )

function round(x)
  if x%2 ~= 0.5 then
	return math.floor(x+0.5)
  end
	return x-0.5
end

local function changeteam_menu( close )
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetSize( ScrW()-(ScrW()*0.02),ScrH()-(ScrH()*0.02) )
	DermaPanel:Center()
	DermaPanel:SetTitle( "Main Menu" )
	DermaPanel:SetDraggable( false )
	if not close then
		DermaPanel:ShowCloseButton( false )
	end
	DermaPanel:MakePopup()

	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( DermaPanel )
	PropertySheet:SetPos( ScrW()*0.01,ScrH()*0.03 )
	PropertySheet:SetSize( ScrW()-(ScrW()*0.04),ScrH()-(ScrH()*0.06) )

	local ChangeTeamSheet = vgui.Create( "DPanel", DermaPanel ) -- We create a panel so we can draw shit on; if we use the frame, it comes up transparent for some reason
	ChangeTeamSheet:SetPos( ScrW()*0.01,ScrH()*0.03 )
	ChangeTeamSheet:SetSize( ScrW()-(ScrW()*0.04),ScrH()-(ScrH()*0.06) )
	ChangeTeamSheet.Paint = function()
		draw.RoundedBox( 8, ScrW() * 0.74, ScrH() * 0.01, ScrW() * 0.2, ScrH() * 0.68, Color( 0, 0, 0, 150 ) )
		draw.RoundedBox( 8, ScrW() * 0.005, ScrH() * 0.005, ScrW() * 0.09, ScrH() * 0.89, Color( 0, 0, 0, 150 ) )
	end
	
	local TestingPanel = {}

	for i=1,4 do
		TestingPanel[i] = vgui.Create( "DPanel", ChangeTeamSheet )
		TestingPanel[i]:SetPos( ScrW()*0.11, ScrH()*0.01 + (ScrH()*0.22*i) - ScrH()*0.22 )
		if i == 4 then
			TestingPanel[i]:SetSize( ScrW()*0.62, ScrH()*0.2 )
		else
			TestingPanel[i]:SetSize( ScrW()*0.62, ScrH()*0.21 )
		end
		TestingPanel[i].Paint = function() -- Paint function
			--Set our rect color below us; we do this so you can see items added to this panel
			draw.RoundedBox( 8, 0, 0, TestingPanel[i]:GetWide(), TestingPanel[i]:GetTall(), Color(50, 50, 50, 255) ) -- Draw the rect
		end
	end
	
	local t=LocalPlayer():GetTeam()
	
	IText = {}
	for i=1,4 do
		IText[i] = vgui.Create("DTextEntry", TestingPanel[i])
		IText[i]:SetPos(ScrW()*0.005,ScrH()*0.005)
		IText[i]:SetSize(TestingPanel[i]:GetWide() - 10, TestingPanel[i]:GetTall() - 10)
		IText[i]:SetMultiline(true)
		IText[i]:SetWrap(true)
		
		IText[i]:SetTextColor(color_white)
		IText[i]:SetFont("MediumFont")
		IText[i]:SetDrawBackground(false)
		IText[i]:SetDrawBorder(false)
		IText[i]:SetEditable(false)
	end
	
	IText[1].Update = function(self)
		local count=""
		local votejoin="\nVote to join: No"
		if t.maxplayers then count="\nPlayers: "..team.NumPlayers(SelectedTeam).."/"..t.maxplayers end
		if t.votejoin then votejoin="\nVote to join: Yes" end
		self:SetText("Job Title: ".. t.name .. "\nSalary: ".. RP:CC(t.salary)..count..votejoin )
	end
	IText[2].Update = function(self)
		self:SetText("Description:\n".. t.desc)
	end
	IText[3].Update = function(self)
		self:SetText("Rules:\n".. t.rules)
	end
	IText[4].Update = function(self)
		self:SetText("Extra Information:\n" .. t.extra)
	end
	
	for i=1,4 do
		IText[i]:Update()
	end
	
	local DermaList = vgui.Create( "DPanelList", ChangeTeamSheet )
	DermaList:SetPos( ScrW() * 0.01, ScrH() * 0.01 )
	DermaList:SetSize( ScrW() * 0.08, ScrH() * 0.88 )
	DermaList:SetSpacing( ScrH()*0.015 ) -- Spacing between items
	DermaList:EnableHorizontal( false ) -- Only vertical items
	DermaList:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis

	local teamicon = vgui.Create( "DModelPanel", ChangeTeamSheet )

	SelectedTeam = LocalPlayer():Team()

	if teamicon:IsValid() then teamicon:Remove() end
	teamicon = vgui.Create( "DModelPanel", ChangeTeamSheet )
	teamicon:SetModel( LocalPlayer():GetModel() )
	teamicon:SetPos(ScrW() * 0.74, ScrH() * 0.01)
	teamicon:SetSize(ScrW() * 0.2, ScrH() * 0.68)
	teamicon:SetCamPos(Vector(80,0,40))
	teamicon:SetLookAt(Vector(0,0,35))
	teamicon:SetFOV(30)
	teamicon:GetEntity():SetEyeTarget(Vector(100,0,65))
	teamicon.LayoutEntity = function() end -- TODO: On/Off?

	local join = vgui.Create("DButton", ChangeTeamSheet)
	join.jointext = "Join this class!"
	join.spawntext = "Respawn!"
	join:SetPos( ScrW() * 0.74, ScrH() * 0.72 )
	join:SetSize( ScrW() * 0.2, ScrH() * 0.15 )
	join:SetText( join.spawntext )
	join.DoClick = function()
		net.Start("RP-ChangeTeam")
			net.WriteFloat(SelectedTeam)
		net.SendToServer()
		DermaPanel:Close()
	end
	
	for i=1,#team.GetAllTeams() do
		local teams = vgui.Create( "DButton" ) 
		teams:SetSize( ScrW() * 0.07, ScrH() * 0.065 ) 
		teams:SetText( RP.Team[i].name )
		teams.DoClick = function() //Make the player join the team
			SelectedTeam = i
			t=RP.Team[i]
			for i=1,4 do
				IText[i]:Update()
			end
			teamicon:SetModel( RP:GetTeamModel(i) )
			teamicon:GetEntity():SetEyeTarget(Vector(100,0,65))
			if LocalPlayer():Team()==i then
				join:SetText(join.spawntext)
			else
				join:SetText(join.jointext)
			end
		end
		
		DermaList:AddItem(teams)
	end

	PropertySheet:AddSheet( "Change Team", ChangeTeamSheet, "icon16/group.png", false, false )	
end

concommand.Add("team_menu", function()
	changeteam_menu(true)
end)

hook.Add("InitPostEntity", "RP-ChangeTeam", function()
	changeteam_menu(false)
end)

net.Receive("RP-TeamMenu", function(len)
	changeteam_menu(tobool(net.ReadBit()))
end)