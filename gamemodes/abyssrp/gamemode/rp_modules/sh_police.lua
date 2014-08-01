-- Police

if SERVER then
	RP:AddSetting("jailtime", 120)
	util.AddNetworkString("RP-SetWanted")
	
	local meta = FindMetaTable("Player")
	
	function meta:SetWanted(wanted,reason,noauto)
		if self.RP_Wanted and wanted then return false end
		if not self.RP_Wanted and not wanted then return false end
		if not reason then reason="" end
		
		if wanted then
			if not noauto then
				timer.Create("RP-Wanted-"..self:UniqueID(), 300, 1, function()
					local success=self:SetWanted(false)
					if success then
						RP:Notify(self, RP.colors.white, "You have evaded Police. You are no longer wanted.")
					end
				end)
			end
		else
			if timer.Exists("RP-Wanted-"..self:UniqueID()) then
				timer.Remove("RP-Wanted-"..self:UniqueID())
			end
		end
		
		self.RP_Wanted = wanted
		self.RP_WantedReason = reason
		
		net.Start("RP-SetWanted")
			net.WriteEntity(self)
			net.WriteBit(wanted)
			net.WriteString(reason)
		net.Broadcast()
		
		return true
	end

	function meta:Arrest()
		if self.RP_Jailed then return false end
		
		self.RP_Jailed = true
		
		self:StripWeapons()
		self.RP_RestorePos = self:GetPos()
		
		if #RP.JailPoses > 0 then
			self.JailPos = table.Random(RP.JailPoses)
		elseif RP.JailPos then
			self.JailPos = RP.JailPos
		end
		if not self.JailPos then return false end
		
		self:SetPos( self.JailPos )
		
		self:SetMoveType( MOVETYPE_WALK )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		return true
	end
		
	function meta:Unarrest()
		if not self.RP_Jailed then return false end
		
		if timer.Exists("JailTimer-"..self:SteamID()) then
			timer.Destroy("JailTimer-"..self:SteamID())
		end
		
		if timer.Exists("RP-Wanted-"..self:UniqueID()) then
			timer.Remove("RP-Wanted-"..self:UniqueID())
		end
		
		self.RP_Wanted = nil
		self.RP_Jailed = nil
		self:Spawn()
		
		timer.Simple(0.1, function()
			self:SetPos( self.RP_RestorePos )
			self.RP_RestorePos = nil
		end)
		
		return true
	end

	hook.Add("PlayerSpawn", "RP-Jail", function(ply)
		if ( ply.RP_Jailed ) then
			ply:SetPos( ply.JailPos )
		end
	end)

	hook.Add("CanPlayerSuicide", "RP-Jail", function(ply)
		if ( ply.RP_Jailed ) then return false end
	end)

	hook.Add("PlayerNoClip", "RP-Jail", function(ply)
		if ( ply.RP_Jailed ) then return false end
	end)
elseif CLIENT then
	net.Receive("RP-SetWanted", function(len)
		local ent=net.ReadEntity()
		ent.RP_Wanted=tobool(net.ReadBit())
		ent.RP_WantedReason=net.ReadString()
	end)

	hook.Add("RP-Menu", "RP-Police", function(sheet, x, y)
		if not LocalPlayer():GetTeamValue("police") then return end
		local panel = vgui.Create("Panel")
		panel:SetSize(x,y)
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Player")
		listview:AddColumn("Wanted")
		listview:SetMultiSelect(false)
		for k,v in pairs(player.GetAll()) do
			listview:AddLine(v:Nick(), v.RP_Wanted and v.RP_WantedReason or "Not wanted")
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(player.GetAll()) do
				if v.name==name then
					selected=v
					selectedn=k
					update()
				end
			end
		end
		
		sheet:AddSheet("Police", panel)
	end)
end