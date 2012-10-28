RP.Vehicles = {}

function RP:AddVehicle(t)
	local n = #RP.Vehicles+1
	RP.Vehicles[n]={}
	RP.Vehicles[n].name = t.name
	RP.Vehicles[n].icon = t.icon
	RP.Vehicles[n].cost = t.cost
	RP.Vehicles[n].class = t.class
	RP.Vehicles[n].model = t.model
	RP.Vehicles[n].script = t.script
end

RP:AddVehicle({
	name="Jeep",
	icon="vgui/vehicles/jeep",
	class="prop_vehicle_jeep",
	model="models/buggy.mdl",
	script="scripts/vehicles/jeep_test.txt",
	cost=100
})

RP:AddVehicle({
	name="Airboat",
	icon="vgui/vehicles/airboat",
	class="prop_vehicle_airboat",
	model="models/airboat.mdl",
	script="scripts/vehicles/airboat.txt",
	cost=150
})