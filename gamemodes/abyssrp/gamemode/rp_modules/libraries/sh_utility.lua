-- Utility

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

function ent:SetPlayerOwner(ply)
	self:SetNWString("Owner", ply:Nick())
	self:SetNWEntity("OwnerObj", ply)
end

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

concommand.Add("getentpos", function(ply)
	local ent = ply:GetEyeTraceNoCursor().Entity
	local pos=ent:GetPos()
	local ang=ent:GetAngles()
	ply:ChatPrint("Vector("..pos.x ..", " ..pos.y..", ".. pos.z..")")
	ply:ChatPrint("Angle("..ang.p ..", " ..ang.y..", ".. ang.r..")")
end)

concommand.Add("getclass", function(ply)
	local ent = ply:GetEyeTraceNoCursor().Entity
	ply:ChatPrint(ent:GetClass())
end)

concommand.Add("getmodel", function(ply)
	local ent = ply:GetEyeTraceNoCursor().Entity
	ply:ChatPrint(ent:GetModel())
end)

concommand.Add("hitpos",function(ply)
	local pos = ply:GetEyeTraceNoCursor().HitPos
	ply:ChatPrint("Vector("..pos.x ..", " ..pos.y..", ".. pos.z..")")
end)

function generatelist()
	local veh={}
	for k,v in pairs(table.Copy(list.Get("Vehicles"))) do
		table.insert(veh,table.Merge(v,{uid=k}))
	end
	table.sort(veh,function(a,b) return a.Name<b.Name end) 
	for k,v in ipairs(veh) do
		if v.Category=="LW Cars" then
			file.Append("vehicles.txt", "RP:AddVehicle({\n\tname=\""..v.Name.."\",\n\tuid=\""..v.uid.."\",\n\tmodel=\""..v.Model.."\",\n\tcost=150\n})\n\n")
		end
	end
end

function ScreenNotify(msg)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTCENTER, tostring(msg))
	end
end

local defaultweps={
	["weapon_stunstick"]=true,
	["weapon_crowbar"]=true,
	["weapon_pistol"]=true,
	["weapon_smg1"]=true,
	["weapon_ar2"]=true,
	["weapon_crossbow"]=true,
	["weapon_shotgun"]=true,
	["weapon_grenade"]=true,
	["weapon_rpg"]=true
}

function RP:ItemExists(class)
	if defaultweps[class] then
		return true
	end

	local entlist=list.Get("SpawnableEntities")
	if entlist[class] then
		return true
	end
	
	local weplist=list.Get("Weapon")
	for a,b in pairs(weplist) do
		if class==b.ClassName then
			return true
		end
	end
	
	return false
end

function RP:Print(...)
	MsgC(Color(0,255,255), "[AbyssRP] ", Color(255,255,255), ...)
	MsgN()
end

function RP:Warning(...)
	self:Print(Color(255,255,0), "Warning: ", Color(255,255,255), ...)
end