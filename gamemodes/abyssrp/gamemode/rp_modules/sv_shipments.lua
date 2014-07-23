-- Shipments

util.AddNetworkString("RP-Shipments")

net.Receive("RP-Shipments", function(len, ply)
	local t=net.ReadFloat() -- Type of shipment
	local n=net.ReadFloat() -- Number in table
	local q=math.Clamp(net.ReadFloat(),1,100) -- Quantity
	local s=tobool(net.ReadBit()) -- Is shipment
	
	local type=RP:GetConstant("shop",t)
	local tbl
	if type=="weapon" then
		tbl=RP.Weapons[n]
	elseif type=="ammotype" then
		tbl=RP.AmmoTypes[n]
	elseif type=="attachment" then
		tbl=RP.Attachments[n]
	elseif type=="drug" then
		tbl=RP.Drugs[n]
	else
		return
	end
	
	if s then
		RP:BuyShipment(ply,tbl,q)
	else
		RP:BuySingle(ply,tbl)
	end
end)

function RP:BuyShipment(ply,t,q)
	if not (ply or t or q) then return end
	local cost=t.cost*q
	if ply:GetCash() < cost then
		RP:Error(ply, RP.colors.white, "You do not have enough cash to buy this shipment.")
		return false
	end
	local shipment=ents.Create("spawned_shipment")
	local tr=ply:GetEyeTraceNoCursor()
	shipment:SetPos(tr.HitPos)
	shipment.Name = t.name
	shipment.Count = q
	shipment.DefaultCost = t.cost
	shipment.Class = t.class
	shipment.Model = t.model or "models/items/boxmrounds.mdl"
	shipment.TheOwner = ply
	shipment:Spawn()
	shipment:Activate()
	ply:TakeCash(cost)
	RP:Notify(ply, RP.colors.white, "Shipment bought.")
	return true
end

function RP:BuySingle(ply,t)
	local cost=t.cost
	if ply:GetCash() < cost then
		RP:Error(ply, RP.colors.white, "You do not have enough cash to buy this item.")
		return false
	end
	local weapon = ents.Create("spawned_weapon")
	local tr=ply:GetEyeTraceNoCursor()
	weapon:SetPos(tr.HitPos)
	weapon:SetModel(t.model)
	weapon.ShareGravgun = true
	weapon.Class = t.class
	weapon.TheOwner = ply
	weapon.Cost = cost
	weapon.nodupe = true
	weapon:Spawn()
	weapon:Activate()
	ply:TakeCash(cost)
	RP:Notify(ply, RP.colors.white, "Item bought.")
	return true
end