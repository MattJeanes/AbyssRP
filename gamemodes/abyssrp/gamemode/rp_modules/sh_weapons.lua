RP.AmmoTypes = {}
RP.Weapons = {}

function RP:AddAmmoType(t)
	local n = #RP.AmmoTypes+1
	RP.AmmoTypes[n]=table.Copy(t)
end

function RP:AddWeapon(t)
	local n = #RP.Weapons+1
	RP.Weapons[n]=table.Copy(t)
end

-- Ammo types

RP:AddAmmoType({
	name=".357 SIG",
	cost=5
})

RP:AddAmmoType({
	name=".380 ACP",
	cost=5
})

RP:AddAmmoType({
	name=".44 Magnum",
	cost=5
})

RP:AddAmmoType({
	name=".45 ACP",
	cost=5
})

RP:AddAmmoType({
	name=".454 Casull",
	cost=5
})

RP:AddAmmoType({
	name=".50 AE",
	cost=5
})

RP:AddAmmoType({
	name=".50 BMG",
	cost=5
})

RP:AddAmmoType({
	name="10x25MM",
	cost=5
})

RP:AddAmmoType({
	name="12 Gauge",
	cost=5
})

RP:AddAmmoType({
	name="23x75MMR",
	cost=5
})

RP:AddAmmoType({
	name="5.45x39MM",
	cost=5
})

RP:AddAmmoType({
	name="5.56x45MM",
	cost=5
})

RP:AddAmmoType({
	name="7.62x39MM",
	cost=5
})

RP:AddAmmoType({
	name="7.62x51MM",
	cost=5
})

RP:AddAmmoType({
	name="9x18MM",
	cost=5
})

RP:AddAmmoType({
	name="9x19MM",
	cost=5
})

-- Weapons

RP:AddWeapon({
	name="AK-47",
	class="fas2_ak47",
	cost=5
})

RP:AddWeapon({
	name="AK-74",
	class="fas2_ak74",
	cost=5
})

RP:AddWeapon({
	name="DV2",
	class="fas2_dv2",
	cost=5
})

RP:AddWeapon({
	name="FAMAS F1",
	class="fas2_famas",
	cost=5
})

RP:AddWeapon({
	name="G36C",
	class="fas2_g36c",
	cost=5
})

RP:AddWeapon({
	name="G3A3",
	class="fas2_g3",
	cost=5
})

RP:AddWeapon({
	name="Glock-20",
	class="fas2_glock20",
	cost=5
})

RP:AddWeapon({
	name="IMI Desert Eagle",
	class="fas2_deagle",
	cost=5
})

RP:AddWeapon({
	name="IMI Uzi",
	class="fas2_uzi",
	cost=5
})

RP:AddWeapon({
	name="KS-23",
	class="fas2_ks23",
	cost=5
})

RP:AddWeapon({
	name="M11A1",
	class="fas2_mac11",
	cost=5
})

RP:AddWeapon({
	name="M14",
	class="fas2_m14",
	cost=5
})

RP:AddWeapon({
	name="M1911",
	class="fas2_m1911",
	cost=5
})

RP:AddWeapon({
	name="M21",
	class="fas2_m21",
	cost=5
})

RP:AddWeapon({
	name="M24",
	class="fas2_m24",
	cost=5
})

RP:AddWeapon({
	name="M3 Super 90",
	class="fas2_m3s90",
	cost=5
})

RP:AddWeapon({
	name="M4A1",
	class="fas2_m4a1",
	cost=5
})

RP:AddWeapon({
	name="Machete",
	class="fas2_machete",
	cost=5
})

RP:AddWeapon({
	name="MP5A5",
	class="fas2_mp5a5",
	cost=5
})

RP:AddWeapon({
	name="MP5K",
	class="fas2_mp5k",
	cost=5
})

RP:AddWeapon({
	name="MP5SD6",
	class="fas2_mp5sd6",
	cost=5
})

RP:AddWeapon({
	name="P226",
	class="fas2_p226",
	cost=5
})

RP:AddWeapon({
	name="PP-19 Bizon",
	class="fas2_pp19",
	cost=5
})

RP:AddWeapon({
	name="Raging Bull",
	class="fas2_ragingbull",
	cost=5
})

RP:AddWeapon({
	name="Remington 870",
	class="fas2_rem870",
	cost=5
})

RP:AddWeapon({
	name="RPK-47",
	class="fas2_rpk",
	cost=5
})

RP:AddWeapon({
	name="Sako RK-95",
	class="fas2_rk95",
	cost=5
})

RP:AddWeapon({
	name="SG 550",
	class="fas2_sg550",
	cost=5
})

RP:AddWeapon({
	name="SG 552",
	class="fas2_sg552",
	cost=5
})

RP:AddWeapon({
	name="SKS",
	class="fas2_sks",
	cost=5
})

RP:AddWeapon({
	name="SR-25",
	class="fas2_sr25",
	cost=5
})