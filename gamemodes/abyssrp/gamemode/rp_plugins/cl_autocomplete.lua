/*-------------------------------------------------------------------------------------------------------------------------
	Provides autocomplete for chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Chat Autocomplete"
PLUGIN.Description = "Provides autocomplete for chat commands"
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

local Suggestions = {}

function PLUGIN:HUDPaint()
	if ( self.Chat ) then
		local x, y = chat.GetChatBoxPos()
		x = x + ScrW() * 0.03875
		y = y + ScrH() / 4 + 5
		
		surface.SetFont( "ChatFont" )
		
		for _, v in ipairs( Suggestions ) do
			local sx, sy = surface.GetTextSize( v.ChatCommand )
			
			draw.SimpleText( v.ChatCommand, "ChatFont", x, y, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( " " .. v.Usage or "", "ChatFont", x + sx, y, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( v.ChatCommand, "ChatFont", x, y, Color( 255, 255, 100, 255 ) )
			draw.SimpleText( " " .. v.Usage or "", "ChatFont", x + sx, y, Color( 255, 255, 255, 255 ) )
			
			y = y + sy
		end
	end
end

function PLUGIN:ChatTextChanged( str )
	if ( string.Left( str, 1 ) == "/" or string.Left( str, 1 ) == "!" or string.Left( str, 1 ) == "@" ) then
		local com = string.sub( str, 2, ( string.find( str, " " ) or ( #str + 1 ) ) - 1 )
		Suggestions = {}
		
		for _, v in pairs( RP.plugins ) do
			if ( v.ChatCommand and string.sub( v.ChatCommand, 0, #com ) == string.lower( com ) and #Suggestions < 3 ) then table.insert( Suggestions, { ChatCommand = string.sub( str, 1, 1 ) .. v.ChatCommand, Usage = v.Usage or "" } ) end
		end
		
		if evolve then
			for _, v in pairs( evolve.plugins ) do
				if ( v.ChatCommand and string.sub( v.ChatCommand, 0, #com ) == string.lower( com ) and #Suggestions < 3 ) then table.insert( Suggestions, { ChatCommand = string.sub( str, 1, 1 ) .. v.ChatCommand, Usage = v.Usage or "" } ) end
			end
		end
		
		table.SortByMember( Suggestions, "ChatCommand", function( a, b ) return a < b end )
	else
		Suggestions = {}
	end
end

function PLUGIN:OnChatTab( str )
	if ( string.match( str, "^[/!][^ ]*$" ) and #Suggestions > 0 ) then
		return Suggestions[1].ChatCommand .. " "
	end
end

function PLUGIN:StartChat() self.Chat = true end
function PLUGIN:FinishChat() self.Chat = false end

RP:AddPlugin( PLUGIN )