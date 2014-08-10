/*---------------------------------------------------------
   Abyss RP
---------------------------------------------------------*/
GM.Name 	= "AbyssRP"
GM.Author 	= "Dr. Matt"
GM.Email 	= "mattjeanes23@gmail.com"
GM.Website 	= "https://github.com/MattJeanes/AbyssRP"
GM.IsSandboxDerived = false

RP = RP or {}

if SERVER then
	util.AddNetworkString("RP-Settings")
	
	RP.DefaultSettings={} -- Lets us reset all settings
	RP.Settings = {}

	function RP:AddSetting(name,value)
		if self.Settings[name] ~= nil then return false end
		self.DefaultSettings[name]=value
		self.Settings[name]=value
		return true
	end

	function RP:SetSetting(name,value)
		--if not self.Settings[name] then return false end
		self.Settings[name]=value
		self:SaveSettings()
		self:BroadcastSettings()
		return true
	end

	function RP:SaveSettings()
		file.Write("rp_settings.txt", von.serialize(self.Settings))
	end

	function RP:LoadSettings()
		if file.Exists("rp_settings.txt", "DATA") then
			table.Merge(self.Settings,von.deserialize(file.Read("rp_settings.txt", "DATA")))
		end
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
	
	function RP:ResetSettings()
		self.Settings={}
		for k,v in pairs(self.DefaultSettings) do
			self.Settings[k]=v
		end
		self:SaveSettings()
		self:BroadcastSettings()
		return true
	end
	
	hook.Add("PlayerInitialSpawn", "RP-Settings", function(ply)
		RP:SendSettings(ply)
	end)
elseif CLIENT then
	RP.Settings = RP.Settings or {}
	
	net.Receive("RP-Settings",function(len)
		RP.Settings=von.deserialize(net.ReadString())
	end)
end

function RP:GetSetting(name,default)
	if self.Settings[name] ~= nil then
		return self.Settings[name]
	else
		return default
	end
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

local meta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString("RP-PlayerInfo")

	RP.PlayerInfo={}

	function RP:SavePlayerInfo()
		file.Write("rp_playerinfo.txt", von.serialize(self.PlayerInfo))
	end

	function RP:LoadPlayerInfo()
		if file.Exists("rp_playerinfo.txt", "DATA") then
			table.Merge(self.PlayerInfo,von.deserialize(file.Read("rp_playerinfo.txt", "DATA")))
		end
		self:SavePlayerInfo()
		self:BroadcastPlayerInfo()
	end
	
	function RP:GetPlayerValue(uid, id, default)
		if (RP.PlayerInfo[uid] ~= nil) and (RP.PlayerInfo[uid][id] ~= nil) then
			return RP.PlayerInfo[uid][id]
		else
			return default
		end
	end
	
	function RP:SetPlayerValue(uid, id, value)
		if not self.PlayerInfo[uid] then self.PlayerInfo[uid]={} end
		self.PlayerInfo[uid][id] = value
		self:SavePlayerInfo()
		if IsValid(player.GetByUniqueID(uid)) then
			self:SendPlayerInfo(player.GetByUniqueID(uid))
		end
	end
	
	function meta:GetValue(id,default)
		local uid=self:UniqueID()
		if (RP.PlayerInfo[uid] ~= nil) and (RP.PlayerInfo[uid][id] ~= nil) then
			return RP.PlayerInfo[uid][id]
		else
			return default
		end
	end

	function meta:SetValue(id,value)
		if not RP.PlayerInfo[self:UniqueID()] then RP.PlayerInfo[self:UniqueID()]={} end
		RP.PlayerInfo[self:UniqueID()][id] = value
		RP:SavePlayerInfo()
		RP:SendPlayerInfo(self)
	end
	
	function RP:SendPlayerInfo(ply)
		if not RP.PlayerInfo[ply:UniqueID()] then return end
		net.Start("RP-PlayerInfo")
			net.WriteString(von.serialize(self.PlayerInfo[ply:UniqueID()]))
		net.Send(ply)
	end
	
	function RP:BroadcastPlayerInfo()
		for k,v in pairs(player.GetAll()) do
			self:SendPlayerInfo(v)
		end
	end
	
	hook.Add("PlayerInitialSpawn", "RP-PlayerInfo", function(ply)
		RP:SendPlayerInfo(ply)
	end)
elseif CLIENT then
	RP.PlayerInfo = RP.PlayerInfo or {}
	
	net.Receive("RP-PlayerInfo", function(len)
		RP.PlayerInfo=von.deserialize(net.ReadString())
	end)
	
	function RP:GetPlayerValue(id, default)
		return RP.PlayerInfo[id] ~= nil and RP.PlayerInfo[id] or default
	end
	
	function meta:GetValue(id, default)
		return RP:GetPlayerValue(id, default)
	end
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

if SERVER then
	RP:LoadSettings()
	RP:LoadPlayerInfo()
end