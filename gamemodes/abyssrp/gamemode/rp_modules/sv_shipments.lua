-- Shipments

util.AddNetworkString("RP-Shipments")

net.Receive("RP-Shipments", function(len, ply)
	local t=net.ReadFloat() -- Type of shipment
	local n=net.ReadFloat() -- Number in table
	local q=math.Clamp(net.ReadFloat(),1,100) -- Quantity
	local s=tobool(net.ReadBit()) -- Is shipment
	
	local shop=RP:GetShop(RP:GetConstant("shop",t))
	if s then
		RP:BuyShipment(ply,shop.tbl[n],q)
	else
		RP:BuySingle(ply,shop.tbl[n])
	end
	return true
end)

function RP:SpawnItem(ply,info,pos,ang)
	if not pos then return false end
	if not ang then ang=Angle(0,0,0) end

	local item=ents.Create("spawned_item")
	item:SetModel(info.model)
	item.ShareGravgun = true
	item.info = info
	item.Owner = ply
	item:SetPos(pos)
	item:SetAngles(ang)
	item.nodupe = true
	item:Spawn()
	item:Activate()
	return item
end

function RP:SpawnShipment(ply,info,quantity,pos,ang)
	if not pos then return false end
	if not ang then ang=Angle(0,0,0) end

	local shipment=ents.Create("spawned_shipment")
	shipment:SetPos(pos)
	shipment:SetAngles(ang)
	shipment.count = quantity
	shipment.info = info
	shipment.Owner = ply
	shipment:Spawn()
	shipment:Activate()
	return shipment
end

function RP:BuyShipment(ply,t,q)
	if not (ply or t or q) then return end
	local cost=t.cost*q
	if ply:GetCash() < cost then
		RP:Error(ply, RP.colors.white, "You do not have enough cash to buy this shipment.")
		return false
	end
	local tr=ply:GetEyeTraceNoCursor()
	local item=RP:SpawnShipment(ply,t,q,tr.HitPos)
	if IsValid(item) then
		ply:TakeCash(cost)
		RP:Notify(ply, RP.colors.white, "Shipment bought.")
		return true
	end
	return false
end

function RP:BuySingle(ply,t)
	local cost=t.cost
	if ply:GetCash() < cost then
		RP:Error(ply, RP.colors.white, "You do not have enough cash to buy this item.")
		return false
	end
	local tr=ply:GetEyeTraceNoCursor()
	local item=RP:SpawnItem(ply,t,tr.HitPos)
	if IsValid(item) then
		ply:TakeCash(cost)
		RP:Notify(ply, RP.colors.white, "Item bought.")
		return true
	end
	return false
end