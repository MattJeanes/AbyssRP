-- Settings

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
else
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