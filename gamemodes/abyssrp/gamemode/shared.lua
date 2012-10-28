/*---------------------------------------------------------
   Abyss RP
---------------------------------------------------------*/
GM.Name 	= "AbyssRP"
GM.Author 	= "Dr. Matt"
GM.Email 	= "mattjeanes23@gmail.com"
GM.Website 	= "http://mattjeanes.com"

//Load modules

RP = {}

local modules = file.Find( "abyssrp/gamemode/rp_modules/*.lua", "LUA" )
for _, plugin in ipairs( modules ) do
	local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
	if ( CLIENT and ( prefix == "sh" or prefix == "cl" ) ) then
		include( "rp_modules/" .. plugin )
	elseif ( SERVER ) then
		if prefix=="sv" or prefix=="sh" then
			include( "rp_modules/" .. plugin )
		end
		if ( prefix == "sh" or prefix == "cl" ) then
			AddCSLuaFile( "abyssrp/gamemode/rp_modules/" .. plugin )
		end
	end
end
modules=nil

RP:LoadPlugins()

CreateConVar( "rp_adminspawnmenu", "1", { FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE } )
CreateConVar( "rp_costtobail", "1000", { FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE } )
CreateConVar( "rp_localchat", "1", { FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE } )