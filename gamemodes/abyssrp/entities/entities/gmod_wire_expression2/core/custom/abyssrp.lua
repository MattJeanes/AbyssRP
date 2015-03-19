/*
local function spawnShipment(self,name,pos,angles,count1,price)
	
	pos = E2Lib.clampPos( pos )
	
	if self.player:Team() != RP:GetTeamN("gun dealer") then
		RP:Error(ply, RP.colors.white, "You are not a gun dealer!")
		return
	end
	
	for i=1,#Shipments.Name do
		if string.lower(name) == string.lower(Shipments.Name[i]) then
			ShipmentFound = true
			ShipmentNum = i
		end
	end
	
	if ShipmentFound then
		local num = ShipmentNum
		local count = tonumber(count1) or 10
		local cash = self.player:GetCash()
		local cost = tonumber((Shipments.Cost[num] * count))
		if cost > cash then
			RP:Error(ply, RP.colors.white, "Not enough cash! You need: ", RP.colors.blue, RP:CC(cost), RP.colors.white, ".")
			ShipmentFound = false
			ShipmentNum = nil
			return
		end
		
		if price then
			if tonumber(price) > 1000 then
				RP:Error(ply, RP.colors.white, "That price is too large!")
				return
			end
		
			if tonumber(price) < tonumber(Shipments.Cost[num]) then
				RP:Error(ply, RP.colors.white, "That price is too small!")
				return
			end
			
		end
		
		local shipment = ents.Create("spawned_shipment")
		shipment.ShareGravgun = true
		shipment.Class = Shipments.Class[num]
		shipment.Count = count
		shipment.Name = Shipments.Name[num]
		shipment.Owner = self.player
		shipment.Model = Shipments.Model[num]
		shipment:SetPos(pos)
		shipment:SetAngles(angles)
		shipment.nodupe = true
		shipment.DefaultPrice = tonumber(Shipments.Cost[num])
		shipment:Spawn()
		if price then
			shipment.Price = tonumber(price)
			shipment:SetNWInt("price", tonumber(price))
		end
		self.player:TakeCash(cost)
		timer.Simple(0.1,function()
			if not (shipment:IsInWorld()) then
				self.player:AddCash(cost)
			end
		end)
		return prop
	end
end

e2function void spawnShipment(string name, vector pos, angle rot, number count, number price)
	return spawnShipment(self,name,Vector(pos[1],pos[2],pos[3]),Angle(rot[1],rot[2],rot[3]),count, price)
end

e2function void spawnShipment(string name, vector pos, angle rot, number count)
	return spawnShipment(self,name,Vector(pos[1],pos[2],pos[3]),Angle(rot[1],rot[2],rot[3]),count)
end

e2function void spawnShipment(string name, vector pos, angle rot)
	return spawnShipment(self,name,Vector(pos[1],pos[2],pos[3]),Angle(rot[1],rot[2],rot[3]))
end
*/