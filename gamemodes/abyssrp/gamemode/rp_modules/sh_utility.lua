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

function GetVectors( ply )
	local pos = ply:GetEyeTraceNoCursor().Entity:GetPos()
	local ang = ply:GetEyeTraceNoCursor().Entity:GetAngles()
	ply:ChatPrint(pos.x ..", " ..pos.y..", ".. pos.z)
	ply:ChatPrint(tostring(ang))
end
concommand.Add("fvector", GetVectors)

function getpos(ply)
    local trace = ply:GetEyeTraceNoCursor()
    local ent = trace.Entity
    
    ply:ChatPrint(tostring(trace.HitPos))
end

concommand.Add("hitpos",getpos)

function ScreenNotify(msg)
	local msg1 = tostring(msg)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTCENTER, msg1)
	end
end