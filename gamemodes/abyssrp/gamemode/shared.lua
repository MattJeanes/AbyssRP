/*---------------------------------------------------------
	Abyss RP
---------------------------------------------------------*/
GM.Name 	= "AbyssRP"
GM.Author 	= "Dr. Matt"
GM.Email 	= "mattjeanes23@gmail.com"
GM.Website 	= "https://github.com/MattJeanes/AbyssRP"
GM.IsSandboxDerived = false

RP = RP or {}

function RP:LoadFolder(path,addonly)
	-- Loads modules
	local folder = "abyssrp/gamemode/"..path.."/"
	local modules = file.Find( folder.."*.lua", "LUA" )
	for _, plugin in ipairs( modules ) do
		local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
		if ( CLIENT and ( prefix == "sh" or prefix == "cl" ) ) then
			if not addonly then
				include( folder..plugin )
			end
		elseif ( SERVER ) then
			if ( prefix=="sv" or prefix=="sh" ) and ( not addonly ) then
				include( folder..plugin )
			end
			if ( prefix == "sh" or prefix == "cl" ) then
				AddCSLuaFile( folder..plugin )
			end
		end
	end
end
RP:LoadFolder("rp_modules/libraries")
RP:LoadFolder("rp_modules")

RP:LoadPlugins()

if SERVER then
	RP:LoadSettings()
	RP:LoadPlayerInfo()
end