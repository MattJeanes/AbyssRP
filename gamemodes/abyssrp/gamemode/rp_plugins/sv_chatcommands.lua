/*-------------------------------------------------------------------------------------------------------------------------
	Provides chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Chat Commands"
PLUGIN.Description = "Provides chat commands to run plugins."
PLUGIN.Author = "Overv"

// Thank you http://lua-users.org/lists/lua-l/2009-07/msg00461.html
function PLUGIN:Levenshtein( s, t )
	local d, sn, tn = {}, #s, #t
	local byte, min = string.byte, math.min
	for i = 0, sn do d[i * tn] = i end
	for j = 0, tn do d[j] = j end
	for i = 1, sn do
		local si = byte(s, i)
		for j = 1, tn do
d[i*tn+j] = min(d[(i-1)*tn+j]+1, d[i*tn+j-1]+1, d[(i-1)*tn+j-1]+(si == byte(t,j) and 0 or 1))
		end
	end
	return d[#d]
end

function PLUGIN:GetCommand( msg )
	return ( string.match( msg, "%w+" ) or "" ):lower()
end

function PLUGIN:GetArguments( msg )
	local args = {}
	local first = true
	
	for match in string.gmatch( msg, "[^ ]+" ) do
		if ( first ) then first = false else
			table.insert( args, match )
		end
	end
	
	return args
end

function PLUGIN:PlayerSay( ply, msg )
	if RP:GetSetting("localchat",false) and RP:GetLocalMode(msg) ~= 0 then return end
	if ( string.Left( msg, 1 ) == "/" or string.Left( msg, 1 ) == "!" or string.Left( msg, 1 ) == "@" ) then
		local command = self:GetCommand( msg )
		local args = self:GetArguments( msg )
		local closest = { dist = 99, plugin = "" }
		
		if ( #command > 0 ) then
		
			if evolve then
				for a,b in pairs(evolve.plugins) do
					if ( b.ChatCommand == command or ( type( b.ChatCommand ) == "table" and table.HasValue( b.ChatCommand, command ) ) ) then	
						for c,d in pairs(RP.plugins) do
							if ( d.ChatCommand == command or ( type( d.ChatCommand ) == "table" and table.HasValue( d.ChatCommand, command ) ) ) then
								RP.SilentNotify = string.Left( msg, 1 ) == "@"
								res, ret = pcall( d.Call, d, ply, args, string.sub( msg, #command + 3 ), command )
								RP.SilentNotify = false
								if ( !res ) then
									RP:Notify( RP.colors.red, "Plugin '" .. d.Title .. "' failed with error:" )
									RP:Notify( RP.colors.red, ret )
								end
								
								return ""
							end
						end
						
						evolve.SilentNotify = string.Left( msg, 1 ) == "@"
						res, ret = pcall( b.Call, b, ply, args, string.sub( msg, #command + 3 ), command )
						evolve.SilentNotify = string.Left( msg, 1 ) == "@"
	
						if ( !res ) then
							RP:Notify( RP.colors.red, "Plugin '" .. b.Title .. "' failed with error:" )
							RP:Notify( RP.colors.red, ret )
						end
						
						return ""
					end
				end
			end
		
			for _, plugin in ipairs( RP.plugins ) do
				if ( plugin.ChatCommand == command or ( type( plugin.ChatCommand ) == "table" and table.HasValue( plugin.ChatCommand, command ) ) ) then	
					RP.SilentNotify = string.Left( msg, 1 ) == "@"
					res, ret = pcall( plugin.Call, plugin, ply, args, string.sub( msg, #command + 3 ), command )
					RP.SilentNotify = false
					
					if ( !res ) then
						RP:Notify( RP.colors.red, "Plugin '" .. plugin.Title .. "' failed with error:" )
						RP:Notify( RP.colors.red, ret )
					end
					
					return ""
				elseif ( plugin.ChatCommand ) then					
					local dist = self:Levenshtein( command, type( plugin.ChatCommand ) == "table" and plugin.ChatCommand[1] or plugin.ChatCommand )
					if ( dist < closest.dist ) then
						closest.dist = dist
						closest.plugin = plugin
					end
				end
			end
		
			if ( closest.dist <= 0.25 * #closest.plugin.ChatCommand ) then
				RP.SilentNotify = string.Left( msg, 1 ) == "@"
				res, ret = pcall( closest.plugin.Call, closest.plugin, ply, args )
				RP.SilentNotify = false
				
				if ( !res ) then
					RP:Notify( RP.colors.red, "RP Plugin '" .. closest.plugin.Title .. "' failed with error:" )
					RP:Notify( RP.colors.red, ret )
				end
				
				return ""
			end
		end
	end
end

RP:AddPlugin( PLUGIN )