if SERVER then AddCSLuaFile() end

/*-------------------------------------------------------------------------------------------------------------------------
	Chat commands - Evolve replacement
-------------------------------------------------------------------------------------------------------------------------*/

local pluginFile

function RP:LoadPlugins()
	RP.plugins = {}
	plugins = file.Find( "abyssrp/gamemode/rp_plugins/*.lua", "LUA" ) -- not good practise, fix when its fixed
	for _, plugin in ipairs( plugins ) do
		local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
		pluginFile = plugin

		if ( CLIENT and ( prefix == "sh" or prefix == "cl" ) ) then
			include( "rp_plugins/" .. plugin )
		elseif ( SERVER ) then
			include( "rp_plugins/" .. plugin )
			if ( prefix == "sh" or prefix == "cl" ) then AddCSLuaFile( "abyssrp/gamemode/rp_plugins/" .. plugin ) end
		end
	end
end

function RP:AddPlugin( plugin )
	if ( string.Left( pluginFile, string.find( pluginFile, "_" ) - 1 ) != "cl" or CLIENT ) then
		table.insert( RP.plugins, plugin )
		plugin.File = pluginFile
		if ( plugin.Privileges and SERVER ) then table.Add( RP.privileges, plugin.Privileges ) table.sort( RP.privileges ) end
	else
		table.insert( RP.plugins, { Title = plugin.Title, File = pluginFile } )
	end
end

function RP:AddPlugin( PLUGIN )
	table.insert( RP.plugins, PLUGIN )
end

function RP:FindPlugin( name )
	for k,v in pairs(RP.plugins) do
		if v.ChatCommand == name then
			return v
		end
	end
end

function RP:Error( ply, ... )
	RP:Notify(ply, RP.colors.red, "ERROR: ", ...)
end

function RP:PluginSafeCall(cmd, ply, args, silent)
	
	local v = RP:FindPlugin(cmd)
	
	RP.SilentNotify = silent
	res, ret = pcall( v.Call, v, ply, args )
	RP.SilentNotify = false
	
	if ( !res ) then
		RP:Notify( RP.colors.red, "Plugin '" .. v.Title .. "' failed with error:" )
		RP:Notify( RP.colors.red, ret )
	end
end

function RP:FormatTime( t )
	if ( t < 0 ) then
		return "Forever"
	elseif ( t < 60 ) then
		if ( t == 1 ) then return "one second" else return t .. " seconds" end
	elseif ( t < 3600 ) then
		if ( math.ceil( t / 60 ) == 1 ) then return "one minute" else return math.ceil( t / 60 ) .. " minutes" end
	elseif ( t < 24 * 3600 ) then
		if ( math.ceil( t / 3600 ) == 1 ) then return "one hour" else return math.ceil( t / 3600 ) .. " hours" end
	elseif ( t < 24 * 3600 * 7 ) then
		if ( math.ceil( t / ( 24 * 3600 ) ) == 1 ) then return "one day" else return math.ceil( t / ( 24 * 3600 ) ) .. " days" end
	elseif ( t < 24 * 3600 * 30 ) then
		if ( math.ceil( t / ( 24 * 3600 * 7 ) ) == 1 ) then return "one week" else return math.ceil( t / ( 24 * 3600 * 7 ) ) .. " weeks" end
	else
		if ( math.ceil( t / ( 24 * 3600 * 30 ) ) == 1 ) then return "one month" else return math.ceil( t / ( 24 * 3600 * 30 ) )  .. " months" end
	end
end

if SERVER then
	RP.SilentNotify = false
	
	function RP:Notify( ... )
		local ply
		local arg = { ... }
		
		if ( type( arg[1] ) == "Player" or arg[1] == NULL ) then ply = arg[1] end
		if ( arg[1] == 1 ) then
				for _, pl in ipairs( player.GetAll() ) do
				if ( pl:IsAdmin() ) then
					table.remove( arg, 1 )
					RP:Notify( pl, unpack( arg ) )
				end
			end
			return
		end
		
		if ( ply != NULL and !self.SilentNotify ) then
			umsg.Start( "RP_Notification", ply )
				umsg.Short( #arg )
				for _, v in ipairs( arg ) do
					if ( type( v ) == "string" ) then
						umsg.String( v )
					elseif ( type ( v ) == "table" ) then
						umsg.Short( v.r )
						umsg.Short( v.g )
						umsg.Short( v.b )
						umsg.Short( v.a )
					end
				end
			umsg.End()
		end
	end
else
	function RP:Notify( ... )
		local arg = { ... }
		
		args = {}
		for _, v in ipairs( arg ) do
			if ( type( v ) == "string" or type( v ) == "table" ) then table.insert( args, v ) end
		end
		
		chat.AddText( unpack( args ) )
	end
	
	usermessage.Hook( "RP_Notification", function( um )
		local argc = um:ReadShort()
		local args = {}
		for i = 1, argc / 2, 1 do
			table.insert( args, Color( um:ReadShort(), um:ReadShort(), um:ReadShort(), um:ReadShort() ) )
			table.insert( args, um:ReadString() )
		end
		
		chat.AddText( unpack( args ) )
	end )
end

-- Returns all arguments and returns "foo bar" as one.
function GetArgs(msg)
	local args = {}
	local first = true
	
	for match in string.gmatch( msg, "[^ ]+" ) do
		if ( first ) then first = false else
			table.insert( args, match )
		end
	end
	
	return args
end

if ( !RP.HookCall ) then RP.HookCall = hook.Call end
hook.Call = function( name, gm, ... )
	local arg = { ... }
	
	for _, plugin in ipairs( RP.plugins ) do
		if ( plugin[ name ] ) then		
			local retValues = { pcall( plugin[name], plugin, ... ) }
			
			if ( retValues[1] and retValues[2] != nil ) then
				table.remove( retValues, 1 )
				return unpack( retValues )
			elseif ( !retValues[1] ) then
				RP:Notify( RP.colors.red, "Hook '" .. name .. "' in plugin '" .. plugin.Title .. "' failed with error:" )
				RP:Notify( RP.colors.red, retValues[2] )
			end
		end
	end
	
	return RP.HookCall( name, gm, ... )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Player collections
-------------------------------------------------------------------------------------------------------------------------*/

function RP:IsNameMatch( ply, str )
	if ( str == "*" ) then
		return true
	elseif ( str == "@" and ply:IsAdmin() ) then
		return true
	elseif ( str == "!@" and !ply:IsAdmin() ) then
		return true
	elseif ( string.match( str, "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
		return ply:SteamID() == str
	elseif ( string.Left( str, 1 ) == "\"" and string.Right( str, 1 ) == "\"" ) then
		return ( ply:Nick() == string.sub( str, 2, #str - 1 ) )
	else
		return ( string.lower( ply:Nick() ) == string.lower( str ) or string.find( string.lower( ply:Nick() ), string.lower( str ), nil, true ) )
	end
end

function RP:FindPlayer( name, def, nonum, noimmunity )
	local matches = {}
	
	if ( !name or #name == 0 ) then
		matches[1] = def
	else
		if ( type( name ) != "table" ) then name = { name } end
		local name2 = table.Copy( name )
		if ( nonum ) then
			if ( #name2 > 1 and tonumber( name2[ #name2 ] ) ) then table.remove( name2, #name2 ) end
		end
		
		for _, ply in ipairs( player.GetAll() ) do
			for _, pm in ipairs( name2 ) do
				if ( RP:IsNameMatch( ply, pm ) and !table.HasValue( matches, ply ) and ( noimmunity or !def ) ) then table.insert( matches, ply ) end
			end
		end
	end
	
	return matches
end

function RP:CreatePlayerList( tbl, notall )
	local lst = ""
	local lword = "and"
	if ( notall ) then lword = "or" end
	
	if ( #tbl == 1 ) then
		lst = tbl[1]:Nick()
	elseif ( #tbl == #player.GetAll() ) then
		lst = "everyone"
	else
		for i = 1, #tbl do
			if ( i == #tbl ) then lst = lst .. " " .. lword .. " " .. tbl[i]:Nick() elseif ( i == 1 ) then lst = tbl[i]:Nick() else lst = lst .. ", " .. tbl[i]:Nick() end
		end
	end
	
	return lst
end