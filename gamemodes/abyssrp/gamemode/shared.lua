/*---------------------------------------------------------
   Abyss RP
---------------------------------------------------------*/
GM.Name 	= "AbyssRP"
GM.Author 	= "Dr. Matt"
GM.Email 	= "mattjeanes23@gmail.com"
GM.Website 	= "https://github.com/MattJeanes/AbyssRP"

RP = RP or {}

RP.Settings = RP.Settings or {}

function RP:GetSetting(name,default)
	return self.Settings[name] or default
end

if SERVER then
	util.AddNetworkString("RP-Settings")
	
	function RP:AddSetting(name,value)
		self.Settings[name]=value
	end

	function RP:SetSetting(name,value)
		self.Settings[name]=value
		self:SaveSettings()
		self:BroadcastSettings()
	end

	function RP:SaveSettings()
		file.Write("rp_settings.txt", von.serialize(self.Settings))
	end

	function RP:LoadSettings()
		if not file.Exists("rp_settings.txt", "DATA") then return end
		table.Merge(self.Settings,von.deserialize(file.Read("rp_settings.txt", "DATA")))
		self:SaveSettings()
		self:BroadcastSettings()
	end
	
	function RP:SendSettings(ply)
		net.Start("RP-Settings")
			net.WriteString(von.serialize(self.Settings))
		net.Send(ply)
	end
	
	function RP:BroadcastSettings()
		net.Start("RP-Settings")
			net.WriteString(von.serialize(self.Settings))
		net.Broadcast()
	end
	
	hook.Add("PlayerInitialSpawn", "RP-Settings", function(ply)
		RP:SendSettings(ply)
	end)
elseif CLIENT then
	net.Receive("RP-Settings",function(len)
		RP.Settings=von.deserialize(net.ReadString())
	end)
end

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

RP.PlayerInfo={}

function RP:SavePlayerInfo()
	file.Write("rp_playerinfo.txt", von.serialize(self.PlayerInfo))
end

function RP:LoadPlayerInfo()
	if not file.Exists("rp_playerinfo.txt", "DATA") then return end
	self.PlayerInfo=von.deserialize(file.Read("rp_playerinfo.txt", "DATA"))
end

function RP:GetPlayerValue(uid, id, default)
	if RP.PlayerInfo[uid] then
		return RP.PlayerInfo[uid][id] or default
	else
		return default
	end
end

function RP:SetPlayerValue(uid, id, value)
	if not RP.PlayerInfo[uid] then RP.PlayerInfo[uid]={} end
	RP.PlayerInfo[uid][id] = value
end

local meta = FindMetaTable("Player")

function meta:GetValue(id,default)
	if RP.PlayerInfo[self:UniqueID()] then
		return RP.PlayerInfo[self:UniqueID()][id] or default
	else
		return default
	end
end

function meta:SetValue(id,value)
	if not RP.PlayerInfo[self:UniqueID()] then RP.PlayerInfo[self:UniqueID()]={} end
	RP.PlayerInfo[self:UniqueID()][id] = value
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
RP:LoadPlayerInfo()

if SERVER then
	RP:LoadSettings()
end