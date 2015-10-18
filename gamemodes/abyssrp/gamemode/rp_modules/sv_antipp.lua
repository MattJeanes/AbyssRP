-- This script is meant to stop the ability to prop push or prop kill

hook.Add("PhysgunPickup", "RP-AntiPP", function(ply,ent)
	local timerid = "timer_" .. ent:EntIndex()
	if IsValid(ent) and (not ent:IsPlayer()) then
		ent:SetMoveType(MOVETYPE_NONE)
		timer.Create(timerid,3,1,function()
			if IsValid(ent) and (not ent:IsPlayerHolding()) then
				ent:SetCollisionGroup(COLLISION_GROUP_NONE)
				ent:SetColor(Color(255,255,255,255))
			end
		end)
	end
end)

hook.Add("PhysgunPickup", "RP-AntiPP", function(ply,ent)
	if IsValid(ent) and (not ent:IsPlayer()) then
		ent:SetMoveType(MOVETYPE_VPHYSICS)
		ent:PhysicsInit(SOLID_VPHYSICS)
		ent:SetColor(Color(255,255,255,150))
		ent:SetRenderMode(RENDERMODE_TRANSALPHA)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end
end)
