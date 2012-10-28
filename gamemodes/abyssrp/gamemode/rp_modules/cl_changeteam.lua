function changeteam_menu( ply )

	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetSize( ScrW()-(ScrW()*0.02),ScrH()-(ScrH()*0.02) )
	DermaPanel:Center()
	DermaPanel:SetTitle( "Main Menu" )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( false )
	DermaPanel:SetDeleteOnClose( true )
	if LocalPlayer():Team() == 0 then
		DermaPanel:ShowCloseButton( false )
	else
		DermaPanel:ShowCloseButton( true )
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
	
	surface.CreateFont( "LargeFont", {font="Ariel", size=48} )
	surface.CreateFont( "MediumFont", {font="Ariel", size=24} )
	surface.CreateFont( "SmallFont", {font="Ariel", size=16} )
	
	UText = {}
	
	function UpdateText(teamn)
		local t = RP.Team[teamn]
		local count=""
		local votejoin="\nVote to join: No"
		if t.maxplayers then count="\nPlayers: "..team.NumPlayers(teamn).."/"..t.maxplayers end
		if t.votejoin then votejoin="\nVote to join: Yes" end
		for i=1,4 do
			UText[i] = vgui.Create("DTextEntry", TestingPanel[i])
			UText[i]:SetPos(ScrW()*0.005,ScrH()*0.005)
			UText[i]:SetSize(TestingPanel[i]:GetWide() - 10, TestingPanel[i]:GetTall() - 10)
			UText[i]:SetMultiline(true)
			UText[i]:SetWrap(true)
			if i == 1 then
				if t == 0 then
					UText[i]:SetText("Job Title: ".. t.name .. "\nSalary: ".. t.salary )
				else
					UText[i]:SetText("Job Title: ".. t.name .. "\nSalary: $".. t.salary..count..votejoin )
				end
			elseif i == 2 then
				UText[i]:SetText("Description:\n".. t.desc)
			elseif i == 3 then
				UText[i]:SetText("Rules:\n".. t.rules)
			elseif i == 4 then
				UText[i]:SetText("Extra Information:\n" .. t.extra)
			end
			UText[i]:SetTextColor(color_white)
			UText[i]:SetFont("MediumFont")
			UText[i]:SetDrawBackground(false)
			UText[i]:SetDrawBorder(false)
			UText[i]:SetEditable(false)
		end
	end
	hook.Add("TextUpdate", "Update the text!", UpdateText)
	
	hook.Call("TextUpdate", GAMEMODE, LocalPlayer():Team())


	function round(x)
	  if x%2 ~= 0.5 then
		return math.floor(x+0.5)
	  end
		return x-0.5
	end

	function Aspect()
		if (ScrW()/ScrH() < 1.74) and (ScrW()/ScrH() > 1.5) then
			return 3
		elseif round(ScrW()/ScrH()) == 2 then
			return 1
		elseif round(ScrW()/ScrH()) == 1 then
			return 2
		end
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
	if Aspect() == 1 then
		teamicon:SetPos( ScrW()*0.45, ScrH()*0.02 )
	elseif Aspect() == 2 then
		teamicon:SetPos( ScrW()*0.34, ScrH()*0.02 )
	elseif Aspect() == 3 then
		teamicon:SetPos( ScrW()*0.42, ScrH()*0.02 )
	end
	teamicon:SetModel( LocalPlayer():GetModel() )
	teamicon:SetSize( ScrH() * 1.4, ScrH() * 1.4 )
	teamicon:SetCamPos( Vector( 120, 0, 50 ) )
	teamicon:SetLookAt( Vector( 50, 0, 30 ) )

	button = vgui.Create("DButton", ChangeTeamSheet)
	button:Remove()

	local function UpdateJoinButton()
		if RPJoinTeamButton then RPJoinTeamButton:Remove() end
		RPJoinTeamButton = vgui.Create("DButton", ChangeTeamSheet)
		RPJoinTeamButton:SetPos( ScrW() * 0.74, ScrH() * 0.72 )
		RPJoinTeamButton:SetSize( ScrW() * 0.2, ScrH() * 0.15 )
		RPJoinTeamButton:SetText( "Join this team!" )
		RPJoinTeamButton.DoClick = function()
			RunConsoleCommand("rp_changeteam", tostring(SelectedTeam) )
			DermaPanel:Close()
		end
	end
	
	UpdateJoinButton()
	
	for i=1,#team.GetAllTeams() do
		local teams = vgui.Create( "DButton" ) 
		//teams:SetPos( ScrW() * 0.012, ScrH() * 0.02 + ((ScrH() * 0.08 * i) - ScrH() * 0.08 ))
		teams:SetSize( ScrW() * 0.07, ScrH() * 0.065 ) 
		teams:SetText( RP.Team[i].name )
		//DermaList:AddItem(teams[i])
		teams.DoClick = function() //Make the player join the team 
			teamicon:Remove()
			for i=1,4 do
				UText[i]:Remove()
			end
			teamicon = vgui.Create( "DModelPanel", ChangeTeamSheet )
			if Aspect() == 1 then
				teamicon:SetPos( ScrW()*0.45, ScrH()*0.02 )
			elseif Aspect() == 2 then
				teamicon:SetPos( ScrW()*0.34, ScrH()*0.02 )
			elseif Aspect() == 3 then
				teamicon:SetPos( ScrW()*0.42, ScrH()*0.02 )
			end
			teamicon:SetModel( RP:GetTeamModel(i) )
			teamicon:SetSize( ScrH() * 1.4, ScrH() * 1.4 )
			teamicon:SetCamPos( Vector( 120, 0, 50 ) )
			teamicon:SetLookAt( Vector( 50, 0, 30 ) )
			SelectedTeam = i
			hook.Call( "TextUpdate", GAMEMODE, i )
			UpdateJoinButton()
		end
		
		DermaList:AddItem(teams)
	end

/*
	local InventorySheet = vgui.Create( "DPanel", DermaPanel ) -- We create a panel so we can draw shit on; if we use the frame, it comes up transparent for some reason
	InventorySheet:SetPos( 125, 50 )
	InventorySheet:SetSize( ScrW()-(ScrW()*0.04),ScrH()-(ScrH()*0.06) )
	*/


	PropertySheet:AddSheet( "Change Team", ChangeTeamSheet, "icon16/group.png", false, false )
	//PropertySheet:AddSheet( "Inventory", InventorySheet, "icon16/inventory.png", false, false )

	
end

concommand.Add( "team_menu", changeteam_menu )