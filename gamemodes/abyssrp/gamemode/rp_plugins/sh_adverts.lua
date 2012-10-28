/*-------------------------------------------------------------------------------------------------------------------------
	Adverts
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Adverts"
PLUGIN.Description = "Show an advert to the server"
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "advert"
PLUGIN.Usage = "<advert>"
PLUGIN.Privileges = { "Advert" }

function PLUGIN:Call( ply, args )
	if not args[1] then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end

	RP:Notify(RP.colors.white, "ADVERT: ", Color(230,220,80), table.concat(args, " "))
end

RP:AddPlugin( PLUGIN )