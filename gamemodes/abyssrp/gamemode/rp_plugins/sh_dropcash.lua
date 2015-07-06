/*-------------------------------------------------------------------------------------------------------------------------
	Drop cash!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Drop Cash"
PLUGIN.Description = "Drop your cash!"
PLUGIN.Author = "Overv/Matt J"
PLUGIN.ChatCommand = "dropcash"
PLUGIN.Usage = "<cash>"
PLUGIN.Privileges = { "Drop Cash" }

function PLUGIN:Call( ply, args )
	if tonumber(args[1]) then
		local A = ply:GetCash()
		local B = tonumber(args[1])
		if B > 0 then
			local C = A - B
			if C > -1 then
				RP:Notify( ply, RP.colors.white, "You have dropped ", RP.colors.blue, RP:CC(B), RP.colors.white, ".")
				local ent = ents.Create("rp_cash")
				ent.Cash = B
				local tr = ply:GetEyeTraceNoCursor()
				ent:SetPos(tr.HitPos)
				ent:Spawn()
				ent.Owner = ply
				if ent:IsInWorld() then
					ply:TakeCash(B)
				else
					RP:Error(ply, RP.colors.white, "Failure to spawn cash!")
				end
			else
				RP:Error( ply, RP.colors.white, "You do not have enough cash!" )
			end
		else
			RP:Error( ply, RP.colors.white, "You cannot drop negative cash!" )
		end
	else
		RP:Error( ply, RP.colors.white, "Invalid arguments!")
	end
end

RP:AddPlugin( PLUGIN )