-- Sell stuff

RP:AddSetting("doorcost",100)
RP:AddSetting("sellpercent", 0.5)

local pl = FindMetaTable( "Player" )

function pl:SellDoors(left)
	if(self:CountDoors() == 0) then
		if not left then
			RP:Notify(self, RP.colors.white, "No doors to sell!")
		end
		return
	end
		
	local DoorCount = self:CountDoors()
	local DoorTable = self:OwnedDoors()
	
	for k,v in pairs(DoorTable) do
		v.Ownable = true
		v.Owner = nil
		v:Fire( "close", "", 0 );
		v:Fire( "lock", "", 0 );
	end
	
	local sellprice = (RP:GetSetting("doorcost") * RP:GetSetting("sellpercent")) * DoorCount
	
	if not left then
		if #DoorTable == 1 then
			RP:Notify(self, RP.colors.white, "You sold ", RP.colors.red, tostring(DoorCount), RP.colors.white, " door for: ", RP.colors.blue, RP:CC(sellprice))
		else
			RP:Notify(self, RP.colors.white, "You sold ", RP.colors.red, tostring(DoorCount), RP.colors.white, " doors for: ", RP.colors.blue, RP:CC(sellprice))
		end
	end
	
	self:AddCash(sellprice)
end

function pl:SellVehicles(left)
	if(self:CountVehicles() == 0) then
		if not left then
			RP:Notify(self, RP.colors.white, "No cars to sell!")
		end
		return
	end
	
	local VehicleCount = self:CountVehicles()
	local VehicleTable = self:OwnedVehicles()
	
	local cost = 0
	for k,v in ipairs(VehicleTable) do
		cost = cost + v.cost
		v:Remove()
	end
	
	local sellprice = cost * RP:GetSetting("sellpercent")
	
	if not left then
		if #VehicleTable == 1 then
			RP:Notify(self, RP.colors.white, "You sold ", RP.colors.red, tostring(VehicleCount), RP.colors.white, " vehicle for: ", RP.colors.blue, RP:CC(sellprice))
		else
			RP:Notify(self, RP.colors.white, "You sold ", RP.colors.red, tostring(VehicleCount), RP.colors.white, " vehicles for: ", RP.colors.blue, RP:CC(sellprice))
		end
	end
		
	self:AddCash(sellprice)
end

function pl:SellShipments(left)
	if(self:CountShipments() == 0) then
		if not left then
			RP:Notify(self, RP.colors.white, "No shipments to sell!")
		end
		return
	end
	
	local ShipmentCount = self:CountShipments()
	local ShipmentTable = self:OwnedShipments()
	local ShipmentPrice = {}
	
	for k,v in ipairs(ShipmentTable) do
		ShipmentPrice[k] = v.info.cost*v.count
		v:Remove()
	end
	
	local cost = 0
	for i=1,#ShipmentPrice do
		cost = cost + tonumber(ShipmentPrice[i])
	end
	
	local sellprice = cost * RP:GetSetting("sellpercent")
	
	if not left then
		if #ShipmentTable == 1 then
			RP:Notify(self, RP.colors.white, "You sold ", RP.colors.red, tostring(ShipmentCount), RP.colors.white, " shipment for: ", RP.colors.blue, RP:CC(sellprice))
		else
			RP:Notify(self, RP.colors.white, "You sold ", RP.colors.red, tostring(ShipmentCount), RP.colors.white, " shipments for: ", RP.colors.blue, RP:CC(sellprice))
		end
	end
		
	self:AddCash(sellprice)
end


function pl:CountDoors()
	local count = 0
	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v.Owner == self then
			count = count + 1
		end
	end
	return count
end

function pl:OwnedDoors()
	local doors = {}
	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v.Owner == self then
			table.insert(doors,v)
		end
	end
	return doors
end

function pl:OwnedVehicles()
	local vehicles2 = {}
	for k,v in pairs(ents.GetAll()) do
		if (v:IsVehicle()) and (v.Owner == self) then
			table.insert(vehicles2,v)
		end
	end
	return vehicles2
end

function pl:CountVehicles()
	local count = 0
	for k,v in pairs(ents.GetAll()) do
		if (v:IsVehicle()) and (v.Owner == self) then
			count = count + 1
		end
	end
	return count
end

function pl:CountShipments()
	local count = 0
	for k, v in pairs(ents.GetAll()) do
		if v.IsShipment and (v.Owner == self) then
			count = count + 1
		end
	end
	return count
end

function pl:OwnedShipments()
	local shipments2 = {}
	for k, v in pairs(ents.GetAll()) do
		if v.IsShipment and (v.Owner == self) then
			table.insert(shipments2,v)
		end
	end
	return shipments2
end

hook.Add( "PlayerDisconnected", "RP-SellStuff", function(ply)
	ply:SellDoors(true)
	ply:SellVehicles(true)
	ply:SellShipments(true)
end)