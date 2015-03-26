-- Vehicles

RP.Vehicles = {}

function RP:AddVehicle(t)
	table.insert(self.Vehicles,table.Copy(t))
end

-- Shop

RP:AddShop({
	uid="vehicle",
	name="Vehicles",
	column="Vehicle",
	tbl=RP.Vehicles,
	view=function(p)
		local mins,maxs = p.Entity:GetRenderBounds()
		p:SetCamPos(mins:Distance(maxs)*Vector(0.5,0.5,0.15))
		p:SetLookAt((maxs + mins)/2)
	end,
	noshipment=true,
	handler=function(ply,info,cost,pos,ang)
		local t=list.Get("Vehicles")[info.uid]
		if not t then return false end
		local ent = ents.Create(t.Class)
		table.Merge(ent,t)
		ent:SetModel(t.Model)     
		ent:SetPos(pos)
		--ent:SetAngles(Vector(0, 0, 0))
		for k,v in pairs(t.KeyValues) do
			ent:SetKeyValue(k,v)
		end
		ent:Activate()
		ent:Spawn()
		ent.VehicleName=info.uid
		ent.VehicleTable=t
		ent.ClassOverride=t.Class
		ent:SetPlayerOwner(ply)
		ent.cost = cost
		ent.Owner = ply
		ent.Ownable = false
		return ent
	end
})

-- Vehicles

-- HL2

RP:AddVehicle({
	name="Jeep",
	uid="Jeep",
	class="prop_vehicle_jeep",
	model="models/buggy.mdl",
	script="scripts/vehicles/jeep_test.txt",
	cost=2000
})

--[[
RP:AddVehicle({
	name="Airboat",
	uid="Airboat",
	model="models/airboat.mdl",
	cost=150
})
]]--

--[[
RP:AddVehicle({
	name="Jalopy",
	uid="Jalopy",
	model="models/vehicle.mdl",
	cost=150
})
]]--

-- TDM Ford

--[[ taxi job?
RP:AddVehicle({
	name="Ford Crown Victoria Taxi",
	uid="crownvic_taxitdm",
	model="models/tdmcars/crownvic_taxi.mdl",
	cost=150
})
]]--

RP:AddVehicle({
	name="Ford Deluxe Coupe 1940",
	uid="coupe40tdm",
	model="models/tdmcars/ford_coupe_40.mdl",
	cost=3000
})

RP:AddVehicle({
	name="Ford F100",
	uid="f100tdm",
	model="models/tdmcars/for_f100.mdl",
	cost=3200
})

RP:AddVehicle({
	name="Ford F350 SuperDuty",
	uid="f350tdm",
	model="models/tdmcars/for_f350.mdl",
	cost=3500
})

RP:AddVehicle({
	name="Ford Focus RS",
	uid="focusrstdm",
	model="models/tdmcars/focusrs.mdl",
	cost=4300
})

RP:AddVehicle({
	name="Ford Focus SVT",
	uid="focussvttdm",
	model="models/tdmcars/for_focussvt.mdl",
	cost=3700
})

RP:AddVehicle({
	name="Ford GT 05",
	uid="gt05tdm",
	model="models/tdmcars/gt05.mdl",
	cost=8500
})

RP:AddVehicle({
	name="Ford Mustang GT",
	uid="mustanggttdm",
	model="models/tdmcars/for_mustanggt.mdl",
	cost=7000
})

RP:AddVehicle({
	name="Ford Raptor SVT",
	uid="raptorsvttdm",
	model="models/tdmcars/for_raptor.mdl",
	cost=4000
})

RP:AddVehicle({
	name="Ford Transit",
	uid="transittdm",
	model="models/tdmcars/ford_transit.mdl",
	cost=3500
})

-- LW Cars

RP:AddVehicle({
	name="Ascari KZ1R",
	uid="asc_kz1r",
	model="models/LoneWolfie/asc_kz1r.mdl",
	cost=30000
})

RP:AddVehicle({
	name="Bentley Arnage T",
	uid="bentley_arnage",
	model="models/LoneWolfie/bentley_arnage_t.mdl",
	cost=15000
})

RP:AddVehicle({
	name="Bentley Platinum Motorsports Continental GT",
	uid="bently_pmcontinental",
	model="models/LoneWolfie/bently_pmcontinental.mdl",
	cost=25000
})

--[[
RP:AddVehicle({ --Admin only maybe
	name="Bugatti Veyron 16.4 Grand Sport",
	uid="bugatti_veyron_grandsport_lw",
	model="models/loneWolfie/bugatti_veyron_grandsport.mdl",
	cost=150
})
]]--

RP:AddVehicle({
	name="Cadillac Eldorado Biarritz Convertible",
	uid="cad_eldorado",
	model="models/LoneWolfie/cad_eldorado.mdl",
	cost=12000
})

RP:AddVehicle({
	name="Cadillac Eldorado Limo",
	uid="cad_eldorado_limo",
	model="models/LoneWolfie/cad_eldorado_limo.mdl",
	cost=13000
})

RP:AddVehicle({
	name="Chevrolet Camaro SS 68",
	uid="chev_camaro_68",
	model="models/LoneWolfie/chev_camaro_68.mdl",
	cost=8500
})

RP:AddVehicle({
	name="Chevrolet Impala LS",
	uid="chev_impala_09",
	model="models/LoneWolfie/chev_impala_09.mdl",
	cost=3500
})

--[[ taxi job?
RP:AddVehicle({
	name="Chevrolet Impala LS Taxi",
	uid="chev_impala_09_taxi",
	model="models/LoneWolfie/chev_impala_09_taxi.mdl",
	cost=150
})
]]--

RP:AddVehicle({
	name="Chevrolet Suburban GMT900",
	uid="chev_suburban",
	model="models/LoneWolfie/chev_suburban.mdl",
	cost=8700
})

RP:AddVehicle({
	name="Chevrolet Tahoe",
	uid="chev_tahoe_lw",
	model="models/LoneWolfie/chev_tahoe.mdl",
	cost=8000
})

RP:AddVehicle({
	name="De Tomaso Pantera",
	uid="detomaso_pantera_lw",
	model="models/LoneWolfie/detomaso_pantera.mdl",
	cost=6500
})

RP:AddVehicle({
	name="Dodge Charger Daytona HEMI",
	uid="dodge_daytona",
	model="models/LoneWolfie/dodge_daytona.mdl",
	cost=10000
})

RP:AddVehicle({
	name="Dodge Monaco",
	uid="dodge_monaco_lw",
	model="models/LoneWolfie/dodge_monaco.mdl",
	cost=4300
})

RP:AddVehicle({
	name="Dodge Viper GTS ACR",
	uid="dodge_viper",
	model="models/LoneWolfie/dodge_viper.mdl",
	cost=23000
})

RP:AddVehicle({
	name="Drift Subaru Impreza 22B-STi series",
	uid="22b2",
	model="models/LoneWolfie/subaru_22b.mdl",
	cost=18000
})

RP:AddVehicle({
	name="Ferrari 458 Italia",
	uid="ferrari_458_lw",
	model="models/LoneWolfie/ferrari_458.mdl",
	cost=35000
})

RP:AddVehicle({
	name="Ferrari F40",
	uid="ferrari_f40_lw",
	model="models/LoneWolfie/ferrari_f40.mdl",
	cost=25000
})

RP:AddVehicle({
	name="Ferrari LaFerrari",
	uid="ferrari_laferrari_lw",
	model="models/LoneWolfie/ferrari_laferrari.mdl",
	cost=40000
})

RP:AddVehicle({
	name="Fiat Abarth 595 SS",
	uid="fiat595",
	model="models/LoneWolfie/fiat_595.mdl",
	cost=1750
})

RP:AddVehicle({
	name="Ford Capri RS3100 MK1",
	uid="ford_capri_rs3100_lw",
	model="models/LoneWolfie/ford_capri_rs3100.mdl",
	cost=5400
})

RP:AddVehicle({
	name="Ford Cobra R 1993",
	uid="ford_foxbody_stock_lw",
	model="models/LoneWolfie/ford_foxbody_stock.mdl",
	cost=6000
})

RP:AddVehicle({
	name="Ford Country Squire",
	uid="fordcountry",
	model="models/LoneWolfie/for_country_squire.mdl",
	cost=2700
})

RP:AddVehicle({
	name="GMC Typhoon",
	uid="gmc_typhoon",
	model="models/LoneWolfie/gmc_typhoon.mdl",
	cost=4700
})

RP:AddVehicle({
	name="Jaguar XJ220",
	uid="jaguar_xj220",
	model="models/LoneWolfie/jaguar_xj220.mdl",
	cost=32000
})

RP:AddVehicle({
	name="Lamborghini Countach LP5000 QV",
	uid="lam_countach",
	model="models/LoneWolfie/lam_countach.mdl",
	cost=27000
})

RP:AddVehicle({
	name="Lamborghini Huracan LP 610-4",
	uid="lam_huracan_lw",
	model="models/LoneWolfie/lam_huracan.mdl",
	cost=39000
})

RP:AddVehicle({
	name="Lancia Delta Integrale",
	uid="delta",
	model="models/LoneWolfie/lan_delta_int.mdl",
	cost=3200
})

RP:AddVehicle({
	name="Lotus Esprit Turbo [Type 82]",
	uid="lotus_esprit_80_lw",
	model="models/LoneWolfie/lotus_esprit_80.mdl",
	cost=5900
})

RP:AddVehicle({
	name="Lotus Exige S Roadster",
	uid="lotus_exiges_roadster_lw",
	model="models/LoneWolfie/lotus_exiges_roadster.mdl",
	cost=27000
})

RP:AddVehicle({
	name="Mazda MX-5 Miata Series I",
	uid="miata94",
	model="models/LoneWolfie/maz_miata_94.mdl",
	cost=2400
})

RP:AddVehicle({
	name="Mercedes 190E Evolution II",
	uid="mercedes_190e_evo_lw",
	model="models/LoneWolfie/mercedes_190e_evo.mdl",
	cost=5900
})

RP:AddVehicle({
	name="Mercedes Benz C63 AMG Black Series Aerodynamic Package",
	uid="mer_c63",
	model="models/LoneWolfie/mer_c63_amg.mdl",
	cost=25000
})

RP:AddVehicle({
	name="Mercedes G65 6x6 AMG",
	uid="mer_g65_6x6",
	model="models/LoneWolfie/mer_g65_6x6.mdl",
	cost=9600
})

RP:AddVehicle({
	name="Mercedes G65 AMG W463",
	uid="mer_g65",
	model="models/LoneWolfie/mer_g65.mdl",
	cost=8600
})

RP:AddVehicle({
	name="Mercedes Sprinter LWB",
	uid="merc_sprinter_lwb_lw",
	model="models/LoneWolfie/merc_sprinter_lwb.mdl",
	cost=11000
})

RP:AddVehicle({
	name="Mitsubishi Lancer GSR Evolution VI",
	uid="evo6",
	model="models/LoneWolfie/mitsu_evo_six.mdl",
	cost=22000
})

RP:AddVehicle({
	name="Morgan 3 Wheeler",
	uid="morgan_3wheeler_lw",
	model="models/LoneWolfie/morgan_3wheeler.mdl",
	cost=5600
})

RP:AddVehicle({
	name="NFS Ford Mustang GT",
	uid="nfsmustang",
	model="models/LoneWolfie/nfs_mustanggt.mdl",
	cost=19500
})

RP:AddVehicle({
	name="Nissan 200SX S14 Avant",
	uid="nissan_silvia_s14_lw",
	model="models/LoneWolfie/nissan_silvia_s14.mdl",
	cost=8500
})

RP:AddVehicle({
	name="Nissan 200SX S14 Widebody",
	uid="nissan_silvia_s14_wide_lw",
	model="models/LoneWolfie/nissan_silvia_s14_wide.mdl",
	cost=10000
})

RP:AddVehicle({
	name="Nissan 200SX S14 Works Kit",
	uid="nissan_silvia_s14_works_lw",
	model="models/LoneWolfie/nissan_silvia_s14_works.mdl",
	cost=13000
})

RP:AddVehicle({
	name="Nissan Sileighty",
	uid="nissan_sileighty_lw",
	model="models/LoneWolfie/nissan_sileighty.mdl",
	cost=7800
})

RP:AddVehicle({
	name="Nissan Silvia Club K's Mk.V [S13]",
	uid="nis_s13",
	model="models/LoneWolfie/nis_s13.mdl",
	cost=9200
})

RP:AddVehicle({
	name="Nissan Skyline 2000GT-R Mk.III",
	uid="2000gtrstock",
	model="models/LoneWolfie/2000gtr_stock.mdl",
	cost=5200
})

RP:AddVehicle({
	name="Nissan Skyline 2000GTR Speedhunters",
	uid="2000gtr_sh",
	model="models/LoneWolfie/2000gtr_speedhunters.mdl",
	cost=19000
})

RP:AddVehicle({
	name="Nissan Skyline GT-R R32",
	uid="nis_skyline_r32",
	model="models/LoneWolfie/nis_skyline_r32.mdl",
	cost=9500
})

RP:AddVehicle({
	name="Polaris Quad 4x4",
	uid="polaris_4x4_lw",
	model="models/LoneWolfie/polaris_4x4.mdl",
	cost=5500
})

RP:AddVehicle({
	name="Polaris Quad 6x6",
	uid="polaris_6x6_lw",
	model="models/LoneWolfie/polaris_6x6.mdl",
	cost=6000
})

RP:AddVehicle({
	name="Smart ForTwo",
	uid="smartfortwo",
	model="models/LoneWolfie/smart_fortwo.mdl",
	cost=5700
})

RP:AddVehicle({
	name="Spyker C8 Aileron",
	uid="spyker_aileron",
	model="models/LoneWolfie/Spyker_Aileron.mdl",
	cost=35000
})

RP:AddVehicle({
	name="Subaru BRZ",
	uid="subarubrz",
	model="models/LoneWolfie/subaru_brz.mdl",
	cost=17000
})

RP:AddVehicle({
	name="Subaru Impreza 22B-STi series",
	uid="22b",
	model="models/LoneWolfie/subaru_22b.mdl",
	cost=25000
})

RP:AddVehicle({
	name="Suzuki Kingquad",
	uid="suzuki_kingquad_lw",
	model="models/LoneWolfie/suzuki_kingquad.mdl",
	cost=5700
})

RP:AddVehicle({
	name="Volvo S60 R",
	uid="volvo_s60",
	model="models/LoneWolfie/volvo_s60.mdl",
	cost=11000
})

RP:AddVehicle({
	name="Y.A.R.E Buggy",
	uid="yare_buggy",
	model="models/LoneWolfie/yare_buggy.mdl",
	cost=17000
})