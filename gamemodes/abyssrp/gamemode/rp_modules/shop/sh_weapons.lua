-- Weapons

RP.AmmoTypes = {}
RP.Weapons = {}
RP.Attachments = {}

function RP:AddAmmoType(t)
	t.model="models/items/boxmrounds.mdl"
	t.class="rp_ammobox"
	table.insert(self.AmmoTypes,table.Copy(t))
end

function RP:AddWeapon(t)
	table.insert(self.Weapons,table.Copy(t))
end

function RP:AddAttachment(t)
	t.model="models/items/boxmrounds.mdl"
	table.insert(self.Attachments,table.Copy(t))
end

-- Shops

RP:AddShop({
	uid="weapon",
	name="Weapons",
	column="Weapon",
	tbl=RP.Weapons,
	nospin=true,
	view=function(p)
		local mins,maxs = p.Entity:GetRenderBounds()
		p:SetCamPos(mins:Distance(maxs)*Vector(0,1,0))
		p:SetLookAt((maxs + mins)/2)
	end
})

RP:AddShop({
	uid="ammo",
	name="Ammo",
	column="Ammo type",
	tbl=RP.AmmoTypes,
	view=function(p)
		local mins,maxs = p.Entity:GetRenderBounds()
		p:SetCamPos(mins:Distance(maxs)*Vector(1.5,0,1))
		p:SetLookAt((maxs + mins)/2)
	end
})

RP:AddShop({
	uid="attachment",
	name="Attachments",
	column="Attachment",
	tbl=RP.Attachments,
	view=function(p)
		local mins,maxs = p.Entity:GetRenderBounds()
		p:SetCamPos(mins:Distance(maxs)*Vector(1.5,0,1))
		p:SetLookAt((maxs + mins)/2)
	end
})

-- Ammo types

RP:AddAmmoType({
	name=".357 SIG",
	clip=30,
	cost=18
})

RP:AddAmmoType({
	name=".380 ACP",
	clip=60,
	cost=30
})

-- Unused apparently
RP:AddAmmoType({
	name=".44 Magnum",
	clip=12,
	cost=5.5
})

RP:AddAmmoType({
	name=".45 ACP",
	clip=30,
	cost=15
})

RP:AddAmmoType({
	name=".454 Casull",
	clip=10,
	cost=10
})

RP:AddAmmoType({
	name=".50 AE",
	clip=14,
	cost=70
})

-- Unused apparently
RP:AddAmmoType({
	name=".50 BMG",
	clip=20,
	cost=20
})

RP:AddAmmoType({
	name="10x25MM",
	clip=60,
	cost=24
})

RP:AddAmmoType({
	name="12 Gauge",
	clip=16,
	cost=13
})

RP:AddAmmoType({
	name="23x75MMR",
	clip=20,
	cost=60
})

RP:AddAmmoType({
	name="5.45x39MM",
	clip=60,
	cost=12
})

RP:AddAmmoType({
	name="5.56x45MM",
	clip=60,
	cost=18
})

RP:AddAmmoType({
	name="7.62x39MM",
	clip=60,
	cost=24
})

-- Unused apparently
RP:AddAmmoType({
	name="7.62x51MM",
	clip=40,
	cost=14
})

RP:AddAmmoType({
	name="9x18MM",
	clip=60,
	cost=24
})

RP:AddAmmoType({
	name="9x19MM",
	clip=40,
	cost=16
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