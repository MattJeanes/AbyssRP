if not Vote then Vote = {} end

usermessage.Hook("StartVote", function(data)
	local o={}
	for i=1, data:ReadFloat() do
		table.insert(o,data:ReadString())
	end
	local q=data:ReadString()
	Vote:ShowMenu(q,o)
end)

function Vote:Create(q, o, c)
	if ( self.Question ) then
		return
	elseif ( #player.GetAll() < 2 ) then
		return
	end

	self.Question = q
	self.Options = o
	self.Votes = {}
	self.VotingPlayers = 0
	self.Callback = c
	
	umsg.Start("StartVote")
		umsg.Float(#o)
		for k,v in ipairs(o) do
			umsg.String(tostring(v))
		end
		umsg.String(q)
	umsg.End()
	
	timer.Create( "RP_VoteEnd", 10, 1, function() Vote:End() end )
	
	RP:Notify( RP.colors.white, "Vote started: (", RP.colors.blue, self.Question, RP.colors.white, ")." )
		
end

function Vote:End()
	SendUserMessage( "RP_VoteEnd", nil )
	
	local msg = ""
	local results={}
	for i = 1, #self.Options do
		local percent
		if ( table.Count( self.Votes ) == 0 ) then percent = 0 else percent = math.Round( ( self.Votes[i] or 0 ) / self.VotingPlayers * 100 ) end
		
		msg = msg .. self.Options[i] .. " (" .. percent .. "%)"
		results[i]={self.Options[i], percent}
		if ( i == #self.Options - 1 ) then
			msg = msg .. " and "
		elseif ( i != #self.Options ) then
			msg = msg .. ", "
		end
	end
	local winner={}
	local max=0
	local duplicates={}
	for k,v in pairs(results) do
		if v[2] > max then
			winner=v
			max=v[2]
		end
	end
	
	for k,v in pairs(results) do
		if v[2]==max then
			table.insert(duplicates,v)
		end
	end
	
	if #duplicates > 1 then
		winner=duplicates[math.random(#duplicates)]
		self.winnerIsRandom=true
	end
	
	//RP:Notify(RP.colors.white, "The winner of that vote was: ", RP.colors.blue, winner[1], RP.colors.white, "(Randomized="..tostring(self.winnerIsRandom)..") with a total vote percentage of: ", RP.colors.red, winner[2].."%", RP.colors.white, ".")
	
	if self.Callback then self.Callback(winner, results, self.winnerIsRandom, msg) end
	self.Callback=nil
	self.Question=nil
	self.winnerIsRandom=nil
	for _, pl in ipairs( player.GetAll() ) do
		pl.RP_Voted = nil
	end
end

function Vote:ShowMenu( question, options )
	self.Window = vgui.Create( "DFrame" )
	self.Window:SetSize( 200, 35 + #options * 30 )
	self.Window:SetPos( ScrW() / 2 - self.Window:GetWide() / 2, ScrH() / 2 - self.Window:GetTall() / 2 )
	self.Window:SetTitle( question )
	self.Window:SetDraggable( false )
	self.Window:ShowCloseButton( false )
	self.Window:SetBackgroundBlur( true )
	self.Window:MakePopup()
	
	local optionlist = vgui.Create( "DPanelList", self.Window )
	optionlist:SetPos( 5, 25 )
	optionlist:SetSize( 190, #options * 30 + 5 )
	optionlist:SetPadding( 5 )
	optionlist:SetSpacing( 5 )
	
	for i,v in ipairs( options ) do
		local votebut = vgui.Create( "DButton" )
		votebut:SetText( v )
		votebut:SetTall( 25 )
		votebut.DoClick = function()
			RunConsoleCommand( "RP_DoVote", i )
			self.Window:Close()
		end
		
		optionlist:AddItem( votebut )
	end
end

if ( SERVER ) then
	concommand.Add( "RP_DoVote", function( ply, _, args )
		if ( Vote.Question and !ply.RP_Voted and tonumber( args[1] ) and tonumber( args[1] ) <= #Vote.Options ) then
			local optionid = tonumber( args[1] )
			
			if ( !Vote.Votes[optionid] ) then
				Vote.Votes[optionid] = 1
			else
				Vote.Votes[optionid] = Vote.Votes[optionid] + 1
			end
			
			ply.RP_Voted = true
			
			Vote.VotingPlayers = Vote.VotingPlayers + 1
			if ( Vote.VotingPlayers == #player.GetAll() ) then
				timer.Destroy( "RP_VoteEnd" )
				Vote:End()
			end
		end
	end )
end

usermessage.Hook( "RP_VoteEnd", function()
	if ( Vote.Window and Vote.Window.Close ) then
		Vote.Window:Close()
	end
end )