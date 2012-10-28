/*-------------------------------------------------------------------------------------------------------------------------
	Whisper
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Whisper"
PLUGIN.Description = "Whisper to other players"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "w"
PLUGIN.Usage = "<message>"
PLUGIN.Privileges = { "Whisper" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	
	local msg=table.concat(args, " ")
	RP:TalkToRange(ply, msg, 90, "Whisper")
	print(ply:Nick()..": "..msg)
end

RP:AddPlugin( PLUGIN )

/*-------------------------------------------------------------------------------------------------------------------------
	Yell
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Yell"
PLUGIN.Description = "Yell to other players"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "y"
PLUGIN.Usage = "<message>"
PLUGIN.Privileges = { "Yell" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	
	local msg=table.concat(args, " ")
	RP:TalkToRange(ply, msg, 550, "Yell")
	print(ply:Nick()..": "..msg)
end

RP:AddPlugin( PLUGIN )

/*-------------------------------------------------------------------------------------------------------------------------
	OOC
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "OOC"
PLUGIN.Description = "Talk out-of-character"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "ooc"
PLUGIN.Usage = "<message>"
PLUGIN.Privileges = { "OOC" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	
	local msg=table.concat(args, " ")
	RP:Notify( RP.colors.white, "(OOC) ", team.GetColor(ply:Team()), ply:SteamName(), RP.colors.white, ": "..msg )
	print(ply:Nick()..": "..msg)
end

RP:AddPlugin( PLUGIN )

/*-------------------------------------------------------------------------------------------------------------------------
	LOOC
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "LOOC"
PLUGIN.Description = "Talk locally out-of-character"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "looc"
PLUGIN.Usage = "<message>"
PLUGIN.Privileges = { "LOOC" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end
	
	local msg=table.concat(args, " ")
	RP:TalkToRange(ply, msg, 250, "LOOC")
	print(ply:Nick()..": "..msg)
end

RP:AddPlugin( PLUGIN )