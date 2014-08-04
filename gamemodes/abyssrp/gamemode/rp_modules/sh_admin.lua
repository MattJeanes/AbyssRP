-- Admin

hook.Add("PlayerNoClip", "RP-Admin", function( ply )
	if not ply:RP_IsAdmin() or (ply:RP_IsAdmin() and not RP:GetSetting("adminnoclip")) or ply.RP_Jailed then
		return false
	end
end)

if SERVER then
	RP:AddSetting("toolblacklist",{
		"creator",
		"nocollide_world",
		"ol_stacker",
		"advdupe2",
		"duplicator",
		"dynamite",
		"emitter",
		"hoverball",
		"physprop",
		"rtcam",
		"trails",
		"paint",
		"colour",
		"caraispawner",
		"carcheckpointspawner",
		"carfuel",
		"carhealth",
		"carnodespawner",
		"cartuning",
		"cratemaker",
		"wire_expression2",
		"wire_trail",
		"wire_holoemitter",
		"wire_cam",
		"wire_colorer",
		"wire_hoverball",
		"wire_detonator",
		"wire_explosive",
		"wire_simple_explosive",
		"wire_igniter",
		"wire_spawner",
		"wire_teleporter",
		"wire_turret"
	})
end

local function build(ply)
	if (not ply:RP_IsAdmin() and not RP:GetSetting("build")) or (ply:RP_IsAdmin() and not RP:GetSetting("adminbuild") and not RP:GetSetting("build")) then
		return false
	end
end
	
local function adminbuild(ply)
	if not ply:RP_IsAdmin() or (ply:RP_IsAdmin() and not RP:GetSetting("adminbuild") and not RP:GetSetting("build")) then
		return false
	end
end

hook.Add("CanTool", "RP-Admin", function(ply,_,tool)
	if not (build(ply)==false) and adminbuild(ply)==false then
		if table.HasValue(RP:GetSetting("toolblacklist",{}), tool) then
			return false
		end
	end
end)

if SERVER then
	util.AddNetworkString("RP-SetSetting")
	util.AddNetworkString("RP-ResetSettings")

	RP:AddSetting("build", true)
	RP:AddSetting("adminbuild", true)
	RP:AddSetting("adminnoclip", true)
	
	local ragdollwhitelist={
		"models/props_c17/FurnitureMattress001a.mdl"
	}	
	
	hook.Add("PlayerSpawnProp", "RP-Admin", build)
	
	hook.Add("PlayerSpawnRagdoll", "RP-Admin", function(ply,item)
		local allowed=build(ply)
		if not table.HasValue(ragdollwhitelist,item) or allowed==false then
			return false
		end
	end)
	
	hook.Add("PlayerSpawnSENT", "RP-Admin", adminbuild)
	hook.Add("PlayerGiveSWEP", "RP-Admin", adminbuild)
	hook.Add("PlayerSpawnSWEP", "RP-Admin", adminbuild)
	hook.Add("PlayerSpawnNPC", "RP-Admin", adminbuild)
	hook.Add("PlayerSpawnEffect", "RP-Admin", adminbuild)
	hook.Add("PlayerSpawnVehicle", "RP-Admin", adminbuild)
	hook.Add("CanDrive", "RP-Admin", adminbuild)
	
	net.Receive("RP-SetSetting", function(len,ply)
		if not ply:IsSuperAdmin() then return end
		local k=net.ReadString()
		local t=net.ReadUInt(8)
		local v=net.ReadType(t)
		if RP.Settings[k] ~= v then
			local success=RP:SetSetting(k,v)
			if success then
				if type(v)=="table" then
					RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has modified table '", RP.colors.red, k, RP.colors.white, "'.")
				else
					RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has changed '", RP.colors.red, k, RP.colors.white, "' to "..tostring(v)..".")
				end
			end
		end
	end)
	
	net.Receive("RP-ResetSettings", function(len,ply)
		if not ply:IsSuperAdmin() then return end
		local success=RP:ResetSettings()
		if success then
			RP:Notify(RP.colors.blue, ply:Nick(), RP.colors.white, " has ", RP.colors.red, "reset", RP.colors.white, " all gamemode settings.")
		else
			RP:Error(ply, RP.colors.white, "An error occurred.")
		end
	end)
elseif CLIENT then
	hook.Add("SpawnMenuOpen", "RP-Essential", function()
		return build(LocalPlayer())
	end)
	hook.Add("ContextMenuOpen", "RP-Essential", function()
		return build(LocalPlayer())
	end)

	hook.Add("DrawDeathNotice", "RP-Admin", function(x,y)
		if not LocalPlayer():RP_IsAdmin() then
			return false
		end
	end)
	
	hook.Add("RP-Menu", "RP-Admin", function(sheet,x,y)
		if not LocalPlayer():IsSuperAdmin() then return end
		
		local selected,selectedv,selectedt,selectedtv
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local wang = vgui.Create( "DNumberWang", panel )
		wang:SetPos( 155, 0 )
		wang:SetVisible(false)
		wang:SetMinMax(-10000,10000)
		wang.OnValueChanged = function(self,value)
			selectedv=tonumber(value)
		end
		
		local check = vgui.Create( "DCheckBoxLabel", panel )
		check:SetPos( 155, 0 )
		check:SetVisible(false)
		check.OnChange = function(self, value)
			selectedv=tobool(value)
		end
		
		local text = vgui.Create( "DTextEntry", panel )
		text:SetPos( 155, 0 )
		text:SetWide(150)
		text:SetVisible(false)
		text.OnTextChanged = function(self)
			selectedv=tostring(self:GetValue())
		end
		
		local tableview = vgui.Create("DListView",panel)
		tableview:SetSize(150,panel:GetTall())
		tableview:SetPos(155,0)
		tableview:AddColumn("Table")
		tableview:SetMultiSelect(false)
		tableview:SetVisible(false)
		tableview.build = function(self)
			if type(selectedv)=="table" then
				self:Clear()
				for k,v in pairs(selectedv) do
					self:AddLine(v)
				end
				self:SortByColumn(1)
			end
		end
		tableview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(selectedv) do
				if v==name then
					selectedt=k
					selectedtv=v
				end
			end
		end
		
		local addline = vgui.Create( "DButton", panel )
		addline:SetText("Add line")
		addline:SetSize(100,50)
		addline:SetPos(panel:GetWide()-addline:GetWide()-1,0)
		addline:SetVisible(false)
		addline.DoClick = function(self)
			Derma_StringRequest("Add line", "Enter line value", "", function(text)
				table.insert(selectedv,text)
				tableview:build()
			end)
		end
		
		local editline = vgui.Create( "DButton", panel )
		editline:SetText("Edit line")
		editline:SetSize(100,50)
		editline:SetPos(panel:GetWide()-editline:GetWide()-1,55)
		editline:SetVisible(false)
		editline.DoClick = function(self)
			if selectedt and selectedtv then
				Derma_StringRequest("Edit line", "Enter line value", selectedtv, function(text)
					selectedv[selectedt]=text
					tableview:build()
				end)
			end
		end
		
		local removeline = vgui.Create( "DButton", panel )
		removeline:SetText("Remove line")
		removeline:SetSize(100,50)
		removeline:SetPos(panel:GetWide()-removeline:GetWide()-1,110)
		removeline:SetVisible(false)
		removeline.DoClick = function(self)
			if selectedt and selectedtv then
				table.remove(selectedv,selectedt)
				tableview:build()
			end
		end
		
		local button = vgui.Create( "DButton", panel )
		button:SetText("Apply")
		button:SetSize(100,50)
		button:SetPos(panel:GetWide()-button:GetWide()-1,panel:GetTall()-button:GetTall()-1)
		button.DoClick = function(self)
			net.Start("RP-SetSetting")
				net.WriteString(selected)
				net.WriteType(selectedv)
			net.SendToServer()
		end
		
		local reset = vgui.Create( "DButton", panel )
		reset:SetText("Reset All")
		reset:SetSize(100,50)
		reset:SetPos(panel:GetWide()-reset:GetWide()-1,0)
		reset.DoClick = function(self)
			Derma_Query("Are you sure? This cannot be undone.", "Reset All Settings",
				"Yes", function() net.Start("RP-ResetSettings") net.SendToServer() LocalPlayer():CloseMenu() end,
				"No"
			)
		end
		
		local function update()
			if (not selected) then return end
			selectedv=RP.Settings[selected]
			selectedt=nil
			selectedtv=nil
			reset:SetVisible(false)
			wang:SetVisible(false)
			check:SetVisible(false)
			text:SetVisible(false)
			tableview:SetVisible(false)
			addline:SetVisible(false)
			editline:SetVisible(false)
			removeline:SetVisible(false)
			local t=type(selectedv)
			if t=="table" then
				selectedv=table.Copy(selectedv)
				tableview:build()
				tableview:SetVisible(true)
				addline:SetVisible(true)
				editline:SetVisible(true)
				removeline:SetVisible(true)
			elseif t=="number" then
				wang:SetValue(selectedv)
				wang:SetVisible(true)
			elseif t=="boolean" then
				check:SetText(selected)
				check:SetValue(selectedv)
				check:SetVisible(true)
				check:SizeToContents()
			elseif t=="string" then
				text:SetValue(selectedv)
				text:SetVisible(true)
			end
		end
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(150,panel:GetTall())
		listview:SetPos(0,0)
		listview:AddColumn("Settings")
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Settings) do
			listview:AddLine(k).v=k
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			for k,v in pairs(RP.Settings) do
				if line.v==k then
					selected=k
				end
			end
			update()
		end
		
		sheet:AddSheet("Admin",panel)
	end)
end