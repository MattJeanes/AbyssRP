/*-------------------------------------------------------------------------------------------------------------------------
	Drop money!
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Drop Money"
PLUGIN.Description = "Drop your money!"
PLUGIN.Author = "Overv/Matt J"
PLUGIN.ChatCommand = "dropmoney"
PLUGIN.Usage = "<money>"
PLUGIN.Privileges = { "Drop Money" }

function PLUGIN:Call( ply, args )
	if not args[1] or #args>1 or args[1]=="0" then
		RP:Error(ply, RP.colors.white, "Invalid Arguments!")
		return
	end

	if not string.find(args[1], "[^%d]") then
		local A = ply:GetCash()
		local B = tonumber(args[1])
		local C = A - B
		if C > -1 then
			RP:Notify( ply, RP.colors.white, "You have dropped ", RP.colors.blue, RP:CC(B), RP.colors.white, "!")
			local ent = ents.Create("rp_cash")
			ent.Cash = B
			local tr = ply:GetEyeTraceNoCursor()
			ent:SetPos(tr.HitPos)
			ent:Spawn()
			ent.Owner = ply
			timer.Simple(.5,function()
				if ent:IsInWorld() then
					ply:TakeCash(B)
				else
					RP:Error(ply, RP.colors.white, "Failure to spawn cash!")
				end
			end)
		else
			RP:Error( ply, RP.colors.white, "You do not have enough money!" )
		end
	else
		RP:Error( ply, RP.colors.white, "You cannot drop words as money!")
	end
end

RP:AddPlugin( PLUGIN )