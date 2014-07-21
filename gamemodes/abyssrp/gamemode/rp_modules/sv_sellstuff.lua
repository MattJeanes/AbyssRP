local pl = FindMetaTable( "Player" )

function pl:SellDoors(left)
	local ply = self
	if(ply:CountDoors() == 0) then
		if not left then
			RP:Notify(ply, RP.colors.white, "No doors to sell!")
		end
		return
	end
		
	local DoorCount = ply:CountDoors()
	local DoorTable = ply:OwnedDoors()
	
	for k,v in pairs(DoorTable) do
		v.Ownable = true
		v.TheOwner = nil
		v:Fire( "close", "", 0 );
		v:Fire( "lock", "", 0 );
	end
	
	local SellPrice = (GetConVarNumber("rp_doorcost") * GetConVarNumber("rp_sellpercent")) * DoorCount
	
	if not left then
		if #DoorTable == 1 then
			RP:Notify(ply, RP.colors.white, "You sold ", RP.colors.red, tostring(DoorCount), RP.colors.white, " door for: ", RP.colors.blue, RP:CC(SellPrice))
		else
			RP:Notify(ply, RP.colors.white, "You sold ", RP.colors.red, tostring(DoorCount), RP.colors.white, " doors for: ", RP.colors.blue, RP:CC(SellPrice))
		end
	end
	
	ply:AddCash(SellPrice)
end

function pl:SellVehicles(left)
	local ply = self
	if(ply:CountVehicles() == 0) then
		if not left then
			RP:Notify(ply, RP.colors.white, "No cars to sell!")
		end
		return
	end
	
	local VehicleCount = ply:CountVehicles()
	local VehicleTable = ply:OwnedVehicles()
	local CarPrice = {}
	
	for k,v in ipairs(VehicleTable) do
		CarPrice[k] = v.Cost
		v:Remove()
	end
	
	local Cost = 0
	
	for i=1,#CarPrice do
		Cost = Cost + tonumber(CarPrice[i])
	end
	
	local SellPrice = (Cost * GetConVarNumber("rp_sellpercent"))
	
	if not left then
		if #VehicleTable == 1 then
			RP:Notify(ply, RP.colors.white, "You sold ", RP.colors.red, tostring(VehicleCount), RP.colors.white, " vehicle for: ", RP.colors.blue, RP:CC(SellPrice))
		else
			RP:Notify(ply, RP.colors.white, "You sold ", RP.colors.red, tostring(VehicleCount), RP.colors.white, " vehicles for: ", RP.colors.blue, RP:CC(SellPrice))
		end
	end
		
	ply:AddCash(SellPrice)
end

function pl:SellShipments(left)
	local ply = self
	if(ply:CountShipments() == 0) then
		if not left then
			RP:Notify(ply, RP.colors.white, "No shipments to sell!")
		end
		return
	end
	
	local ShipmentCount = ply:CountShipments()
	local ShipmentTable = ply:OwnedShipments()
	local ShipmentPrice = {}
	
	for k,v in ipairs(ShipmentTable) do
		ShipmentPrice[k] = (tonumber(v.Price) or tonumber(v.DefaultPrice))*v.Count
		v:Remove()
	end
	
	local Cost = 0
	
	for i=1,#ShipmentPrice do
		Cost = Cost + tonumber(ShipmentPrice[i])
	end
	
	local SellPrice = (Cost * GetConVarNumber("rp_sellpercent"))
	
	if not left then
		if #ShipmentTable == 1 then
			RP:Notify(ply, RP.colors.white, "You sold ", RP.colors.red, tostring(ShipmentCount), RP.colors.white, " shipment for: ", RP.colors.blue, RP:CC(SellPrice))
		else
			RP:Notify(ply, RP.colors.white, "You sold ", RP.colors.red, tostring(ShipmentCount), RP.colors.white, " shipments for: ", RP.colors.blue, RP:CC(SellPrice))
		end
	end
		
	ply:AddCash(SellPrice)
end


function pl:CountDoors()
	local Count = 0
	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v.TheOwner == self then
			Count = Count + 1
		end
	end
	return Count
end

function pl:OwnedDoors()
	local doors = {}
	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v.TheOwner == self then
			table.insert(doors,v)
		end
	end
	return doors
end

function pl:OwnedVehicles()
	local vehicles2 = {}
	for k,v in pairs(ents.GetAll()) do
		if (v:IsVehicle()) and (v.TheOwner == self) then
			table.insert(vehicles2,v)
		end
	end
	return vehicles2
end

function pl:CountVehicles()
	local Count = 0
	for k,v in pairs(ents.GetAll()) do
		if (v:IsVehicle()) and (v.TheOwner == self) then
			Count = Count + 1
		end
	end
	return Count
end

function pl:CountShipments()
	local Count = 0
	for k, v in pairs(ents.GetAll()) do
		if v.IsShipment and (v.TheOwner == self) then
			Count = Count + 1
		end
	end
	return Count
end

function pl:OwnedShipments()
	local shipments2 = {}
	for k, v in pairs(ents.GetAll()) do
		if v.IsShipment and (v.TheOwner == self) then
			table.insert(shipments2,v)
		end
	end
	return shipments2
end

function PlayerDisconnect( ply )

	ply:SellDoors(true)
	ply:SellVehicles(true)
	ply:SellShipments(true)
	
end

hook.Add( "PlayerDisconnected", "playerdisconnected", PlayerDisconnect )

CreateConVar( "rp_sellpercent", "0.5", FCVAR_NOTIFY )