-- Police

if SERVER then
	RP:AddSetting("jailtime", 120)
	util.AddNetworkString("RP-SetWanted")
	util.AddNetworkString("RP-WantedUpdate")
	
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
	
	net.Receive("RP-SetWanted", function(len,ply)
		local pl=net.ReadEntity()
		local wanted=tobool(net.ReadBit())
		local reason=""
		if wanted then
			reason=net.ReadString()
		end
		local success=pl:SetWanted(wanted,reason)
		if success then
			RP:Notify(RP.colors.blue, pl:Nick(), RP.colors.white, " is "..(wanted and "now wanted by police with the reason \""..reason.."\"." or "no longer wanted by police."))
			ScreenNotify(pl:Nick() .. " is "..(wanted and "now wanted by police." or "no longer wanted by police."))
		else
			RP:Error(ply, RP.colors.white, "Failed to set ", RP.colors.red, pl:Nick(), RP.colors.white, " as "..(wanted and "wanted" or "unwanted")..".")
		end
		net.Start("RP-WantedUpdate") net.Send(ply)
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
		
		local selected,update
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(100,panel:GetTall())
		listview:AddColumn("Player")
		listview:SetMultiSelect(false)
		for k,v in pairs(player.GetAll()) do
			listview:AddLine(v:Nick()).v=v
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			for k,v in pairs(player.GetAll()) do
				if line.v==v then
					selected=v
					update()
				end
			end
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Wanted:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetWide()+5,0)
		
		local wanted = vgui.Create("DLabel",panel)
		wanted:SetPos(listview:GetPos()+listview:GetWide()+5,label:GetTall())
		wanted:SetText("")
		
		local button = vgui.Create("DButton", panel)
		button:SetSize(100,50)
		button:SetPos(panel:GetWide()-button:GetWide()-1,panel:GetTall()-button:GetTall()-1)
		button:SetText("Set wanted")
		button.DoClick = function(self)
			if not IsValid(selected) then return end
			if selected.RP_Wanted then
				net.Start("RP-SetWanted")
					net.WriteEntity(selected)
					net.WriteBit(false)
				net.SendToServer()
			else
				Derma_StringRequest("Set wanted", "Reason?", "", function(text)
					if text:len()==0 then
						RP:Error(LocalPlayer(), RP.colors.white, "You need a reason!")
						return
					end
					net.Start("RP-SetWanted")
						net.WriteEntity(selected)
						net.WriteBit(true)
						net.WriteString(text)
					net.SendToServer()
				end)
			end
		end
		
		function update()
			if not IsValid(selected) then return end
			wanted:SetText(selected.RP_Wanted and selected.RP_WantedReason or "Not wanted")
			button:SetText(selected.RP_Wanted and "Set unwanted" or "Set wanted")
		end
		
		net.Receive("RP-WantedUpdate", function(len)
			update() -- Bit hacky but only good solution afaik
		end)
		
		sheet:AddSheet("Police", panel)
	end)
end