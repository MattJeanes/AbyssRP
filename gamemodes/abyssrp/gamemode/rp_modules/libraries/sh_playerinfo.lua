-- Player info

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
else
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