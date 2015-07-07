-- Medic shop

RP.MedicShop = {}

function RP:AddMedicItem(t)
	table.insert(self.MedicShop,table.Copy(t))
end

-- Shop

RP:AddShop({
	uid="medic",
	name="Medic",
	column="Medical supply",
	tbl=RP.MedicShop,
	view=function(p)
		local mins,maxs = p.Entity:GetRenderBounds()
		p:SetCamPos(mins:Distance(maxs)*Vector(1,1,1))
		p:SetLookAt((maxs + mins)/2)
	end
})

-- Medical items

RP:AddMedicItem({
	name="Health Kit",
	class="item_healthkit",
	model="models/items/healthkit.mdl",
	cost=50
})

RP:AddMedicItem({
	name="Health Vial",
	class="item_healthvial",
	model="models/healthvial.mdl",
	cost=20
})

RP:AddMedicItem({
	name="Suit Battery",
	class="item_battery",
	model="models/items/battery.mdl",
	cost=75
})

RP:AddMedicItem({
	name="Medical Supplies",
	class="fas2_ammo_medical",
	model="models/items/boxmrounds.mdl",
	cost=100
})

RP:AddMedicItem({
	name="Bandages",
	class="fas2_ammo_bandages",
	model="models/items/boxmrounds.mdl",
	cost=50
})

RP:AddMedicItem({
	name="Hemostats",
	class="fas2_ammo_hemostats",
	model="models/items/boxmrounds.mdl",
	cost=50
})

RP:AddMedicItem({
	name="Quikclots",
	class="fas2_ammo_quikclots",
	model="models/items/boxmrounds.mdl",
	cost=50
})

RP:AddMedicItem({
	name="Infantry First Aid Kit",
	class="fas2_ifak",
	model="models/items/healthkit.mdl",
	cost=500
})

