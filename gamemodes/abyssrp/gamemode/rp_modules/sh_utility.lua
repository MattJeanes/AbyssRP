RP.colors = {}
RP.colors.blue = Color( 98, 176, 255, 255 )
RP.colors.red = Color( 255, 62, 62, 255 )
RP.colors.white = color_white

local pl = FindMetaTable( "Player" )

function pl:RP_IsAdmin()
	if self:IsAdmin() or self:IsSuperAdmin() then
		return true
	else
		return false
	end
end

local ent = FindMetaTable( "Entity" )

function ent:SetWorldOwner()
	self:SetNWString("Owner", "World")
	self:SetNWEntity("OwnerObj", game.GetWorld())
end

function ent:SetSharedOwner()
	self:SetNWString("Owner", "Shared")
	self:SetNWEntity("OwnerObj", nil)
end

concommand.Add("getpolicedoor", function(ply)
	local pos = ply:GetEyeTraceNoCursor().Entity:GetPos()
	ply:ChatPrint("RP:AddPoliceDoor(Vector("..pos.x ..", " ..pos.y..", ".. pos.z.."))")
end)

concommand.Add("getclass", function(ply)
	local ent = ply:GetEyeTraceNoCursor().Entity
	ply:ChatPrint(ent:GetClass())
end)

concommand.Add("hitpos",function(ply)
	local pos = ply:GetEyeTraceNoCursor().HitPos
	ply:ChatPrint("Vector("..pos.x ..", " ..pos.y..", ".. pos.z..")")
end)

function ScreenNotify(msg)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTCENTER, tostring(msg))
	end
end