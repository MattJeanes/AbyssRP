// this script is meant to stop the ability to prop push or prop kill
if CLIENT then
	hook.Add("PhysgunDrop","stopfall",function(ply,ent)
		net.Start("propfreeze")
			net.WriteEntity(ent)
		net.SendToServer()
	end)

	hook.Add("PhysgunPickup","ghost",function(ply,ent)
		net.Start("propghost")
			net.WriteEntity(ent)
		net.SendToServer()
	end)

else
	util.AddNetworkString("propfreeze")
	local function recieveandfreeze()
		local tempent = net.ReadEntity()
		local timerid = "timer_" .. tempent:EntIndex()
		if tempent:IsValid() and !tempent:IsPlayer() then
			tempent:SetMoveType(MOVETYPE_NONE)
			timer.Create(timerid,3,1,function()
				if tempent:IsValid() and !tempent:IsPlayerHolding() then
					tempent:SetCollisionGroup(COLLISION_GROUP_NONE)
					tempent:SetColor(Color(255,255,255,255))
				end
			end)
		end
	end
	net.Receive("propfreeze",recieveandfreeze)

	local function recieveandghost()
		local tempghostent = net.ReadEntity()
		if tempghostent:IsValid() and !tempghostent:IsPlayer() then
			tempghostent:SetMoveType(MOVETYPE_VPHYSICS)
			tempghostent:PhysicsInit(SOLID_VPHYSICS)
			tempghostent:SetColor(Color(255,255,255,150))
			tempghostent:SetRenderMode(RENDERMODE_TRANSALPHA)
			tempghostent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end
	end
	net.Receive("propghost",recieveandghost)
	util.AddNetworkString("propghost")

end
