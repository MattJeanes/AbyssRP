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
	cost=1700
})

RP:AddWeapon({
	name="AK-74",
	class="fas2_ak74",
	ammotype="5.45x39MM",
	cost=1500
})

RP:AddWeapon({
	name="DV2",
	class="fas2_dv2",
	cost=100
})

RP:AddWeapon({
	name="FAMAS F1",
	class="fas2_famas",
	ammotype="5.56x45MM",
	cost=1600
})

RP:AddWeapon({
	name="G36C",
	class="fas2_g36c",
	ammotype="5.56x45MM",
	cost=1500
})

RP:AddWeapon({
	name="G3A3",
	class="fas2_g3",
	ammotype="7.62x51MM",
	cost=1300
})

RP:AddWeapon({
	name="Glock-20",
	class="fas2_glock20",
	ammotype="10x25MM",
	cost=600
})

RP:AddWeapon({
	name="IMI Desert Eagle",
	class="fas2_deagle",
	ammotype=".50 AE",
	cost=1000
})

RP:AddWeapon({
	name="IMI Uzi",
	class="fas2_uzi",
	ammotype="9x19MM",
	cost=900
})

RP:AddWeapon({
	name="KS-23",
	class="fas2_ks23",
	ammotype="23x75MMR",
	cost=1400
})

RP:AddWeapon({
	name="M11A1",
	class="fas2_mac11",
	ammotype=".380 ACP",
	cost=700
})

RP:AddWeapon({
	name="M14",
	class="fas2_m14",
	ammotype="7.62x51MM",
	cost=2000
})

RP:AddWeapon({
	name="M1911",
	class="fas2_m1911",
	ammotype=".45 ACP",
	cost=600
})

RP:AddWeapon({
	name="M21",
	class="fas2_m21",
	ammotype="7.62x51MM",
	cost=2500
})

RP:AddWeapon({
	name="M24",
	class="fas2_m24",
	ammotype="7.62x51MM",
	cost=2300
})

RP:AddWeapon({
	name="M3 Super 90",
	class="fas2_m3s90",
	ammotype="12 Gauge",
	cost=1150
})

RP:AddWeapon({
	name="M4A1",
	class="fas2_m4a1",
	ammotype="5.56x45MM",
	cost=1900
})

RP:AddWeapon({
	name="Machete",
	class="fas2_machete",
	cost=250
})

RP:AddWeapon({
	name="MP5A5",
	class="fas2_mp5a5",
	ammotype="9x19MM",
	cost=1000
})

RP:AddWeapon({
	name="MP5K",
	class="fas2_mp5k",
	ammotype="9x19MM",
	cost=1000
})

RP:AddWeapon({
	name="MP5SD6",
	class="fas2_mp5sd6",
	ammotype="9x19MM",
	cost=1000
})

RP:AddWeapon({
	name="OTs-33 Pernach"
	class="fas2_ots33",
	ammotype="9x18MM",
	cost=650
})

RP:AddWeapon({
	name="P226",
	class="fas2_p226",
	ammotype=".357 SIG",
	cost=550
})

RP:AddWeapon({
	name="PP-19 Bizon",
	class="fas2_pp19",
	ammotype="9x18MM",
	cost=900
})

RP:AddWeapon({
	name="Raging Bull",
	class="fas2_ragingbull",
	ammotype=".454 Casull",
	cost=1700
})

RP:AddWeapon({
	name="Remington 870",
	class="fas2_rem870",
	ammotype="12 Gauge",
	cost=1500
})

RP:AddWeapon({
	name="RPK-47",
	class="fas2_rpk",
	ammotype="7.62x39MM",
	cost=1600
})

RP:AddWeapon({
	name="Sako RK-95",
	class="fas2_rk95",
	ammotype="7.62x39MM",
	cost=1800
})

RP:AddWeapon({
	name="SG 550",
	class="fas2_sg550",
	ammotype="5.56x45MM",
	cost=1400
})

RP:AddWeapon({
	name="SG 552",
	class="fas2_sg552",
	ammotype="5.56x45MM",
	cost=1400
})

RP:AddWeapon({
	name="SKS",
	class="fas2_sks",
	ammotype="7.62x39MM",
	cost=1800
})

RP:AddWeapon({
	name="SR-25",
	class="fas2_sr25",
	ammotype="7.62x51MM",
	cost=2600
})

-- Attachments

RP:AddAttachment({
	name="ACOG 4x",
	class="fas2_att_acog",
	cost=100
})

RP:AddAttachment({
	name="CompM4",
	class="fas2_att_compm4",
	cost=100
})

RP:AddAttachment({
	name="ELCAN C79",
	class="fas2_att_c79",
	cost=100
})

RP:AddAttachment({
	name="EoTech 553",
	class="fas2_att_eotech",
	cost=100
})

RP:AddAttachment({
	name="Foregrip",
	class="fas2_att_foregrip",
	cost=100
})

RP:AddAttachment({
	name="Harris Bipod",
	class="fas2_att_harrisbipod",
	cost=100
})

RP:AddAttachment({
	name="Leupold MK4",
	class="fas2_att_leupold",
	cost=100
})

RP:AddAttachment({
	name="M21 20RND Mag",
	class="fas2_att_m2120mag",
	cost=100
})

RP:AddAttachment({
	name="MP5K 30RND Mag",
	class="fas2_att_mp5k30mag",
	cost=100
})

RP:AddAttachment({
	name="PSO-1",
	class="fas2_att_pso1",
	cost=100
})

RP:AddAttachment({
	name="SG55X 30RND Mag",
	class="fas2_att_sg55x30mag",
	cost=100
})

RP:AddAttachment({
	name="SKS 20RND Mag",
	class="fas2_att_sks20mag",
	cost=100
})

RP:AddAttachment({
	name="SKS 30RND Mag",
	class="fas2_att_sks30mag",
	cost=100
})

RP:AddAttachment({
	name="Suppressor",
	class="fas2_att_suppressor",
	cost=100
})

RP:AddAttachment({
	name="Tritium Sights",
	class="fas2_att_tritiumsights",
	cost=100
})

RP:AddAttachment({
	name="UZI Wooden Stock",
	class="fas2_att_uziwoodenstock",
	cost=100
})