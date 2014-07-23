/*---------------------------------------------------------
   Abyss RP
---------------------------------------------------------*/
GM.Name 	= "AbyssRP"
GM.Author 	= "Dr. Matt"
GM.Email 	= "mattjeanes23@gmail.com"
GM.Website 	= "http://mattjeanes.com"

//Load modules

RP = RP or {}

RP.Constants={}

function RP:AddConstant(type,name)
	if not RP.Constants[type] then
		RP.Constants[type]={}
	end
	local n=table.Count(RP.Constants[type])+1
	RP.Constants[type][n]=name
	return n
end

function RP:GetConstant(type,n)
	if not RP.Constants[type] then
		return false
	end
	for k,v in pairs(RP.Constants[type]) do
		if k==n then
			return v
		end
	end
	return false
end	

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

CreateConVar( "rp_adminspawnmenu", "1", { FCVAR_NOTIFY, FCVAR_REPLICATED } )
CreateConVar( "rp_costtobail", "1000", { FCVAR_NOTIFY, FCVAR_REPLICATED } )