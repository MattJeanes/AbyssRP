RP.AmmoTypes = {}
RP.Weapons = {}
RP.Attachments = {}

function RP:AddAmmoType(t)
	local n = #RP.AmmoTypes+1
	RP.AmmoTypes[n]=table.Copy(t)
end

function RP:AddWeapon(t)
	local n = #RP.Weapons+1
	RP.Weapons[n]=table.Copy(t)
end

function RP:AddAttachment(t)
	local n = #RP.Attachments+1
	RP.Attachments[n]=table.Copy(t)
end

-- Ammo types

RP:AddAmmoType({
	name=".357 SIG",
	cost=0.6
})

RP:AddAmmoType({
	name=".380 ACP",
	cost=0.5
})

-- Unused apparently
RP:AddAmmoType({
	name=".44 Magnum",
	cost=0.45
})

RP:AddAmmoType({
	name=".45 ACP",
	cost=0.5
})

RP:AddAmmoType({
	name=".454 Casull",
	cost=1
})

RP:AddAmmoType({
	name=".50 AE",
	cost=5
})

-- Unused apparently
RP:AddAmmoType({
	name=".50 BMG",
	cost=1
})

RP:AddAmmoType({
	name="10x25MM",
	cost=0.4
})

RP:AddAmmoType({
	name="12 Gauge",
	cost=0.8
})

RP:AddAmmoType({
	name="23x75MMR",
	cost=3
})

RP:AddAmmoType({
	name="5.45x39MM",
	cost=0.2
})

RP:AddAmmoType({
	name="5.56x45MM",
	cost=0.3
})

RP:AddAmmoType({
	name="7.62x39MM",
	cost=0.4
})

-- Unused apparently
RP:AddAmmoType({
	name="7.62x51MM",
	cost=0.35
})

RP:AddAmmoType({
	name="9x18MM",
	cost=0.4
})

RP:AddAmmoType({
	name="9x19MM",
	cost=0.4
})

-- Weapons

RP:AddWeapon({
	name="AK-47",
	class="fas2_ak47",
	ammotype="7.62x39MM",
	model="models/weapons/w_rif_ak47.mdl",
	displaymodel="models/weapons/w_ak47.mdl",
	cost=1700
})

RP:AddWeapon({
	name="AK-74",
	class="fas2_ak74",
	ammotype="5.45x39MM",
	model="models/weapons/w_rif_ak47.mdl",
	displaymodel="models/weapons/w_ak47.mdl",
	cost=1500
})

RP:AddWeapon({
	name="DV2",
	class="fas2_dv2",
	model="models/weapons/w_knife_ct.mdl",
	displaymodel="models/weapons/w_dv2.mdl",
	cost=100
})

RP:AddWeapon({
	name="FAMAS F1",
	class="fas2_famas",
	ammotype="5.56x45MM",
	model="models/weapons/w_rif_famas.mdl",
	displaymodel="models/weapons/w_famas.mdl",
	cost=1600
})

RP:AddWeapon({
	name="G36C",
	class="fas2_g36c",
	ammotype="5.56x45MM",
	model="models/weapons/w_rif_m4a1.mdl",
	displaymodel="models/weapons/w_g36e.mdl",
	cost=1500
})

RP:AddWeapon({
	name="G3A3",
	class="fas2_g3",
	ammotype="7.62x51MM",
	model="models/weapons/w_rif_ak47.mdl",
	displaymodel="models/weapons/w_g3a3.mdl",
	cost=1300
})

RP:AddWeapon({
	name="Glock-20",
	class="fas2_glock20",
	ammotype="10x25MM",
	model="models/weapons/w_pist_glock18.mdl",
	displaymodel="models/weapons/w_pist_glock18.mdl",
	cost=600
})

RP:AddWeapon({
	name="IMI Desert Eagle",
	class="fas2_deagle",
	ammotype=".50 AE",
	model="models/weapons/w_pist_deagle.mdl",
	displaymodel="models/weapons/w_deserteagle.mdl",
	cost=1000
})

RP:AddWeapon({
	name="IMI Uzi",
	class="fas2_uzi",
	ammotype="9x19MM",
	model="models/weapons/w_smg_mp5.mdl",
	displaymodel="models/weapons/w_mp5.mdl",
	cost=900
})

RP:AddWeapon({
	name="KS-23",
	class="fas2_ks23",
	ammotype="23x75MMR",
	model="models/weapons/w_shot_m3super90.mdl",
	displaymodel="models/weapons/world/shotguns/ks23.mdl",
	cost=1400
})

RP:AddWeapon({
	name="M11A1",
	class="fas2_mac11",
	ammotype=".380 ACP",
	model="models/weapons/w_smg_mp5.mdl",
	displaymodel="models/weapons/w_mp5.mdl",
	cost=700
})

RP:AddWeapon({
	name="M14",
	class="fas2_m14",
	ammotype="7.62x51MM",
	model="models/weapons/w_snip_awp.mdl",
	displaymodel="models/weapons/w_m14.mdl",
	cost=2000
})

RP:AddWeapon({
	name="M1911",
	class="fas2_m1911",
	ammotype=".45 ACP",
	model="models/weapons/w_pist_p228.mdl",
	displaymodel="models/weapons/w_1911.mdl",
	cost=600
})

RP:AddWeapon({
	name="M21",
	class="fas2_m21",
	ammotype="7.62x51MM",
	model="models/weapons/w_snip_awp.mdl",
	displaymodel="models/weapons/w_m14.mdl",
	cost=2500
})

RP:AddWeapon({
	name="M24",
	class="fas2_m24",
	ammotype="7.62x51MM",
	model="models/weapons/w_snip_awp.mdl",
	displaymodel="models/weapons/w_m24.mdl",
	cost=2300
})

RP:AddWeapon({
	name="M3 Super 90",
	class="fas2_m3s90",
	ammotype="12 Gauge",
	model="models/weapons/w_shot_m3super90.mdl",
	displaymodel="models/weapons/w_m3.mdl",
	cost=1150
})

RP:AddWeapon({
	name="M4A1",
	class="fas2_m4a1",
	ammotype="5.56x45MM",
	model="models/weapons/w_rif_m4a1.mdl",
	displaymodel="models/weapons/w_m4.mdl",
	cost=1900
})

RP:AddWeapon({
	name="Machete",
	class="fas2_machete",
	model="models/weapons/w_knife_ct.mdl",
	displaymodel="models/weapons/w_machete.mdl",
	cost=250
})

RP:AddWeapon({
	name="MP5A5",
	class="fas2_mp5a5",
	ammotype="9x19MM",
	model="models/weapons/w_smg_mp5.mdl",
	displaymodel="models/weapons/w_mp5.mdl",
	cost=1000
})

RP:AddWeapon({
	name="MP5K",
	class="fas2_mp5k",
	ammotype="9x19MM",
	model="models/weapons/w_smg_mp5.mdl",
	displaymodel="models/weapons/w_mp5.mdl",
	cost=1000
})

RP:AddWeapon({
	name="MP5SD6",
	class="fas2_mp5sd6",
	ammotype="9x19MM",
	model="models/weapons/w_smg_mp5.mdl",
	displaymodel="models/weapons/w_mp5.mdl",
	cost=1000
})

RP:AddWeapon({
	name="OTs-33 Pernach",
	class="fas2_ots33",
	ammotype="9x18MM",
	model="models/weapons/world/pistols/ots33.mdl",
	displaymodel="models/weapons/world/pistols/ots33.mdl",
	cost=650
})

RP:AddWeapon({
	name="P226",
	class="fas2_p226",
	ammotype=".357 SIG",
	model="models/weapons/w_pist_p228.mdl",
	displaymodel="models/weapons/w_pist_p228.mdl",
	cost=550
})

RP:AddWeapon({
	name="PP-19 Bizon",
	class="fas2_pp19",
	ammotype="9x18MM",
	model="models/weapons/w_smg_biz.mdl",
	displaymodel="models/weapons/w_smg_biz.mdl",
	cost=900
})

RP:AddWeapon({
	name="Raging Bull",
	class="fas2_ragingbull",
	ammotype=".454 Casull",
	model="models/weapons/w_357.mdl",
	displaymodel="models/weapons/w_357.mdl",
	cost=1700
})

RP:AddWeapon({
	name="Remington 870",
	class="fas2_rem870",
	ammotype="12 Gauge",
	model="models/weapons/w_shot_m3super90.mdl",
	displaymodel="models/weapons/w_m3.mdl",
	cost=1500
})

RP:AddWeapon({
	name="RPK-47",
	class="fas2_rpk",
	ammotype="7.62x39MM",
	model="models/weapons/w_rif_ak47.mdl",
	displaymodel="models/weapons/w_ak47.mdl",
	cost=1600
})

RP:AddWeapon({
	name="Sako RK-95",
	class="fas2_rk95",
	ammotype="7.62x39MM",
	model="models/weapons/w_rif_ak47.mdl",
	displaymodel="models/weapons/world/rifles/rk95.mdl",
	cost=1800
})

RP:AddWeapon({
	name="SG 550",
	class="fas2_sg550",
	ammotype="5.56x45MM",
	model="models/weapons/w_snip_sg550.mdl",
	displaymodel="models/weapons/w_sg550.mdl",
	cost=1400
})

RP:AddWeapon({
	name="SG 552",
	class="fas2_sg552",
	ammotype="5.56x45MM",
	model="models/weapons/w_snip_sg550.mdl",
	displaymodel="models/weapons/w_sg550.mdl",
	cost=1400
})

RP:AddWeapon({
	name="SKS",
	class="fas2_sks",
	ammotype="7.62x39MM",
	model="models/weapons/w_snip_awp.mdl",
	displaymodel="models/weapons/world/rifles/sks.mdl",
	cost=1800
})

RP:AddWeapon({
	name="SR-25",
	class="fas2_sr25",
	ammotype="7.62x51MM",
	model="models/weapons/w_snip_sg550.mdl",
	displaymodel="models/weapons/w_sr25.mdl",
	cost=2600
})

-- Attachments

RP:AddAttachment({
	name="ACOG 4x",
	class="fas2_att_acog",
	cost=250
})

RP:AddAttachment({
	name="CompM4",
	class="fas2_att_compm4",
	cost=200
})

RP:AddAttachment({
	name="ELCAN C79",
	class="fas2_att_c79",
	cost=300
})

RP:AddAttachment({
	name="EoTech 553",
	class="fas2_att_eotech",
	cost=200
})

RP:AddAttachment({
	name="Foregrip",
	class="fas2_att_foregrip",
	cost=50
})

RP:AddAttachment({
	name="Harris Bipod",
	class="fas2_att_harrisbipod",
	cost=50
})

RP:AddAttachment({
	name="Leupold MK4",
	class="fas2_att_leupold",
	cost=400
})

RP:AddAttachment({
	name="M21 20RND Mag",
	class="fas2_att_m2120mag",
	cost=150
})

RP:AddAttachment({
	name="MP5K 30RND Mag",
	class="fas2_att_mp5k30mag",
	cost=175
})

RP:AddAttachment({
	name="PSO-1",
	class="fas2_att_pso1",
	cost=350
})

RP:AddAttachment({
	name="SG55X 30RND Mag",
	class="fas2_att_sg55x30mag",
	cost=175
})

RP:AddAttachment({
	name="SKS 20RND Mag",
	class="fas2_att_sks20mag",
	cost=150
})

RP:AddAttachment({
	name="SKS 30RND Mag",
	class="fas2_att_sks30mag",
	cost=175
})

RP:AddAttachment({
	name="Suppressor",
	class="fas2_att_suppressor",
	cost=200
})

RP:AddAttachment({
	name="Tritium Sights",
	class="fas2_att_tritiumsights",
	cost=50
})

RP:AddAttachment({
	name="UZI Wooden Stock",
	class="fas2_att_uziwoodenstock",
	cost=100
})

local weapon=RP:AddConstant("shop","weapon")
local ammotype=RP:AddConstant("shop","ammotype")
local attachment=RP:AddConstant("shop","attachment")

if CLIENT then
	hook.Add("RP-Menu", "RP-Weapons", function(sheet,x,y)
		if not (LocalPlayer():Team()==RP:GetTeamN("gun dealer")) then return end
		local function send(t,n,q,s)
			if t and n and q then
				net.Start("RP-Shipments")
					net.WriteFloat(t)
					net.WriteFloat(n)
					net.WriteFloat(q)
					net.WriteBit(tobool(s))
				net.SendToServer()
				return true
			else
				return false
			end
		end

		local function GenerateView(Panel)
			local PrevMins, PrevMaxs = Panel.Entity:GetRenderBounds()
			Panel:SetCamPos(PrevMins:Distance(PrevMaxs)*Vector(0,1,0))
			Panel:SetLookAt((PrevMaxs + PrevMins)/2)
		end
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Weapon")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Weapons) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Weapons) do
				if v.name==name then
					selected=v
					selectedn=k
					update()
				end
			end
		end
			
		local label = vgui.Create("DLabel",panel)
		label:SetPos(listview:GetPos()+listview:GetWide()+5,2.5)
		label:SetText("Quantity:")
		label:SizeToContents()
		local numberwang = vgui.Create("DNumberWang",panel)
		numberwang:SetPos(label:GetPos()+label:GetWide()+5,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,100)
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(weapon,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(weapon,selectedn,quantity,true)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)
		
		local cost = vgui.Create("DLabel",panel)
		cost:SetText(RP:CC(0))
		cost:SetFont("DermaLarge")
		cost:SizeToContents()
		cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-cost:GetTall()-5)
		
		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-cost:GetTall()-10)
		icon.LayoutEntity = function() end -- TODO: On/Off?
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
			icon:SetModel(selected.displaymodel)
			GenerateView(icon)
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Weapons",panel)
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Ammo type")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.AmmoTypes) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.AmmoTypes) do
				if v.name==name then
					selected=v
					selectedn=k
					update()
				end
			end
		end
			
		local label = vgui.Create("DLabel",panel)
		label:SetPos(listview:GetPos()+listview:GetWide()+5,2.5)
		label:SetText("Quantity:")
		label:SizeToContents()
		local numberwang = vgui.Create("DNumberWang",panel)
		numberwang:SetPos(label:GetPos()+label:GetWide()+5,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,100)
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(ammotype,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(ammotype,selectedn,quantity,true)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)
		
		local cost = vgui.Create("DLabel",panel)
		cost:SetText(RP:CC(0))
		cost:SetFont("DermaLarge")
		cost:SizeToContents()
		cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-cost:GetTall()-5)
		
		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-cost:GetTall()-10)
		icon:SetModel("models/items/boxmrounds.mdl")
		icon:SetCamPos(Vector(40,0,20))
		icon:SetLookAt(Vector(0,0,5))
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Ammo",panel)
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Attachment")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Attachments) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Attachments) do
				if v.name==name then
					selected=v
					selectedn=k
					update()
				end
			end
		end
			
		local label = vgui.Create("DLabel",panel)
		label:SetPos(listview:GetPos()+listview:GetWide()+5,2.5)
		label:SetText("Quantity:")
		label:SizeToContents()
		local numberwang = vgui.Create("DNumberWang",panel)
		numberwang:SetPos(label:GetPos()+label:GetWide()+5,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,100)
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(attachment,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(attachment,selectedn,quantity,true)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)
		
		local cost = vgui.Create("DLabel",panel)
		cost:SetText(RP:CC(0))
		cost:SetFont("DermaLarge")
		cost:SizeToContents()
		cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-cost:GetTall()-5)
		
		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-cost:GetTall()-10)
		icon:SetModel("models/items/boxmrounds.mdl")
		icon:SetCamPos(Vector(40,0,20))
		icon:SetLookAt(Vector(0,0,5))
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Attachments",panel)
	end)
end