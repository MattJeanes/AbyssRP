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
		if not LocalPlayer():RP_IsAdmin() then return end
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local DScrollPanel = vgui.Create( "DScrollPanel",panel )
		DScrollPanel:SetSize( panel:GetWide()-161, panel:GetTall() )
		DScrollPanel:SetPos( 160, 0 )
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("WIP")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(panel:GetWide()-label:GetWide(),0)
		
		local label = vgui.Create("DLabel",DScrollPanel)
		label:SetText("")
		label:SizeToContents()
		label:SetPos(0,0)
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(150,panel:GetTall())
		listview:SetPos(0,0)
		listview:AddColumn("Settings")
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Settings) do
			listview:AddLine(k)
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Settings) do
				if k==name then
					if type(v)=="table" then
						local s=""
						for a,b in pairs(v) do
							s=s..tostring(b).."\n"
						end
						label:SetText(s)
					else
						label:SetText(tostring(v))
					end
					label:SizeToContents()
				end
			end
		end
		
		sheet:AddSheet("Admin",panel)
	end)
end