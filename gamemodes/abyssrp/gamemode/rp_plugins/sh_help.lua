/*-------------------------------------------------------------------------------------------------------------------------
	Show users a help list
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Help commands"
PLUGIN.Description = "Allows a player to recieve help about AbyssRP!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "help"

function PLUGIN:Call( ply, args )

	umsg.Start( "RP_CommandStart", ply ) umsg.End()
	
	for _, v in ipairs( RP.plugins ) do
		if ( v.ChatCommand ) then
			umsg.Start( "RP_Command", ply )
				umsg.String( v.ChatCommand )
				umsg.String( tostring( v.Usage ) )
				umsg.String( v.Description )
			umsg.End()
		end
	end
	
	umsg.Start( "RP_CommandEnd", ply ) umsg.End()
	
	RP:Notify( ply, RP.colors.white, "All chat commands have been printed to your console." )
	
end

RP:AddPlugin( PLUGIN )

/*-------------------------------------------------------------------------------------------------------------------------
	Show users a command list
-------------------------------------------------------------------------------------------------------------------------*/
local PLUGIN = {}
PLUGIN.Title = "List commands"
PLUGIN.Description = "Allows a player to recieve help about AbyssRP!"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "commands"

function PLUGIN:Call( ply, args )

	RP:FindPlugin("help"):Call( ply, args )
	
end

RP:AddPlugin( PLUGIN )

if CLIENT then
	usermessage.Hook( "RP_CommandStart", function( um )
		print( "\n============ Available chat commands for AbyssRP ============\n" )
	end )

	usermessage.Hook( "RP_CommandEnd", function( um )
		print( "" )
	end )

	usermessage.Hook( "RP_Command", function( um )
		local com = um:ReadString()
		local usage = um:ReadString()
		local desc = um:ReadString()
		
		if ( usage != "nil" ) then
			print( "!" .. com .. " " .. usage .. " - " .. desc )
		else
			print( "!" .. com .. " - " .. desc )
		end
	end )
end