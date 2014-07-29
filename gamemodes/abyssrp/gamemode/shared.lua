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
	if table.HasValue(RP.Constants[type], name) then
		return RP:GetConstantN(type,name)
	end
	local n=#RP.Constants[type]+1
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

function RP:GetConstantN(type,n)
	if not RP.Constants[type] then
		return false
	end
	for k,v in pairs(RP.Constants[type]) do
		if v==n then
			return k
		end
	end
	return false
end

local includes={}

function RP:AddInclude(folder)
	table.insert(includes,folder)
end

function RP:Include(folder)
	local modules = file.Find( "abyssrp/gamemode/"..folder.."/*.lua", "LUA" )
	for _, plugin in ipairs( modules ) do
		local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
		if ( CLIENT and ( prefix == "sh" or prefix == "cl" ) ) then
			include( folder.."/" .. plugin )
		elseif ( SERVER ) then
			if prefix=="sv" or prefix=="sh" then
				include( folder.."/" .. plugin )
			end
			if ( prefix == "sh" or prefix == "cl" ) then
				AddCSLuaFile( "abyssrp/gamemode/"..folder.."/" .. plugin )
			end
		end
	end
end

RP:AddInclude("rp_modules")

for k,v in ipairs(includes) do
	RP:Include(v)
end

RP:LoadPlugins()

CreateConVar( "rp_adminspawnmenu", "1", { FCVAR_NOTIFY, FCVAR_REPLICATED } )
CreateConVar( "rp_costtobail", "1000", { FCVAR_NOTIFY, FCVAR_REPLICATED } )