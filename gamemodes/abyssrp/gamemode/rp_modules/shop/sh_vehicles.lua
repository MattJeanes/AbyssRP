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
	cost=100
})

RP:AddVehicle({
	name="Airboat",
	uid="Airboat",
	model="models/airboat.mdl",
	cost=150
})

RP:AddVehicle({
	name="Jalopy",
	uid="Jalopy",
	model="models/vehicle.mdl",
	cost=150
})

-- TDM Ford

RP:AddVehicle({
	name="Ford Crown Victoria Taxi",
	uid="crownvic_taxitdm",
	model="models/tdmcars/crownvic_taxi.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford Deluxe Coupe 1940",
	uid="coupe40tdm",
	model="models/tdmcars/ford_coupe_40.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford F100",
	uid="f100tdm",
	model="models/tdmcars/for_f100.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford F350 SuperDuty",
	uid="f350tdm",
	model="models/tdmcars/for_f350.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford Focus RS",
	uid="focusrstdm",
	model="models/tdmcars/focusrs.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford Focus SVT",
	uid="focussvttdm",
	model="models/tdmcars/for_focussvt.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford GT 05",
	uid="gt05tdm",
	model="models/tdmcars/gt05.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford Mustang GT",
	uid="mustanggttdm",
	model="models/tdmcars/for_mustanggt.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford Raptor SVT",
	uid="raptorsvttdm",
	model="models/tdmcars/for_raptor.mdl",
	cost=150
})

RP:AddVehicle({
	name="Ford Transit",
	uid="transittdm",
	model="models/tdmcars/ford_transit.mdl",
	cost=150
})