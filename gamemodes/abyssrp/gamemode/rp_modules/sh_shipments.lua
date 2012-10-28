RP.Shipments = {}

function RP:AddShipment(t)
	local n = #RP.Shipments+1
	RP.Shipments[n]={}
	RP.Shipments[n].name = t.name
	RP.Shipments[n].model = t.model
	RP.Shipments[n].class = t.class
	RP.Shipments[n].cost = t.cost
	RP.Shipments[n].ammotype = t.ammotype
	RP.Shipments[n].ammocost = t.ammocost
end

RP:AddShipment({
	name="Galil",
	model="models/weapons/w_rif_galil.mdl",
	class="weapon_rp_galil",
	cost=300,
	ammotype="5.56MM",
	ammocost=3
})

RP:AddShipment({
	name="M3",
	model="models/weapons/w_shot_m3super90.mdl",
	class="weapon_rp_m3",
	cost=350,
	ammotype="Buckshot",
	ammocost=7
})

RP:AddShipment({
	name="Deagle",
	model="models/weapons/w_pist_deagle.mdl",
	class="weapon_rp_deagle",
	cost=100,
	ammotype=".50MM",
	ammocost=5
})

RP:AddShipment({
	name="M4A1",
	model="models/weapons/w_rif_m4a1.mdl",
	class="weapon_rp_m4",
	cost=200,
	ammotype="5.56MM",
	ammocost=2
})

RP:AddShipment({
	name="Glock",
	model="models/weapons/w_pist_glock18.mdl",
	class="weapon_rp_glock",
	cost=100,
	ammotype="9MM",
	ammocost=3
})

RP:AddShipment({
	name="AK47",
	model="models/weapons/w_rif_ak47.mdl",
	class="weapon_rp_ak47",
	cost=250,
	ammotype="7.62MM",
	ammocost=2
})

RP:AddShipment({
	name="Knife",
	model="models/weapons/w_knife_t.mdl",
	class="weapon_rp_knife",
	cost=20,
	ammotype="None",
	ammocost=0
})

RP:AddShipment({
	name="P90",
	model="models/weapons/w_smg_p90.mdl",
	class="weapon_rp_p90",
	cost=350,
	ammotype="5.7MM",
	ammocost=0.5
})

RP:AddShipment({
	name="Scout",
	model="models/weapons/w_snip_scout.mdl",
	class="weapon_rp_scout",
	cost=450,
	ammotype="7.62MM",
	ammocost=2
})