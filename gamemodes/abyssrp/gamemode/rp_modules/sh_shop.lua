-- Shop

RP.Shops={}

function RP:AddShop(t) -- This must be shared because of constants
	t.const=RP:AddConstant("shop",t.uid)
	table.insert(RP.Shops,t)
end

function RP:GetShop(uid)
	for k,v in pairs(RP.Shops) do
		if v.uid==uid then
			return v
		end
	end
end

if SERVER then
	RP:AddSetting("maxcostmul", 2)
	RP:AddSetting("maxquantity", 100)
	
	util.AddNetworkString("RP-Shop")
	
	net.Receive("RP-Shop", function(len, ply)
		local t=net.ReadFloat() -- Type of shipment
		local n=net.ReadFloat() -- Number in table
		local q=math.Clamp(net.ReadFloat(),1,RP:GetSetting("maxquantity",1)) -- Quantity
		local c=net.ReadFloat() -- Cost
		local s=tobool(net.ReadBit()) -- Is shipment
		
		local shop=RP:GetShop(RP:GetConstant("shop",t))
		if s then
			RP:BuyShipment(ply,shop.tbl[n],c,q)
		else
			RP:BuySingle(ply,shop.tbl[n],c)
		end
		return true
	end)

	function RP:SpawnItem(ply,info,cost,pos,ang)
		if not pos then return false end
		if not ang then ang=Angle(0,0,0) end
		
		local item=ents.Create("spawned_item")
		item:SetModel(info.model)
		item.ShareGravgun = true
		item.info = info
		item.cost = cost
		item.Owner = ply
		item:SetPos(pos)
		item:SetAngles(ang)
		item.nodupe = true
		item:Spawn()
		item:Activate()
		return item
	end

	function RP:SpawnShipment(ply,info,cost,quantity,pos,ang)
		if not pos then return false end
		if not ang then ang=Angle(0,0,0) end
		
		local shipment=ents.Create("spawned_shipment")
		shipment:SetPos(pos)
		shipment:SetAngles(ang)
		shipment.count = quantity
		shipment.info = info
		shipment.cost = cost
		shipment.Owner = ply
		shipment:Spawn()
		shipment:Activate()
		return shipment
	end

	function RP:BuyShipment(ply,t,c,q)
		if not (ply or t or q) then return end
		c=math.Clamp(c,0,t.cost*RP:GetSetting("maxcostmul",1))
		local cost=t.cost*q
		if ply:GetCash() < cost then
			RP:Error(ply, RP.colors.white, "You do not have enough cash to buy this shipment.")
			return false
		end
		local tr=ply:GetEyeTraceNoCursor()
		local item=RP:SpawnShipment(ply,t,c,q,tr.HitPos)
		if IsValid(item) then
			ply:TakeCash(cost)
			RP:Notify(ply, RP.colors.white, "Shipment bought.")
			return true
		end
		return false
	end

	function RP:BuySingle(ply,t,c)
		c=math.Clamp(c,0,t.cost*RP:GetSetting("maxcostmul",1))
		if ply:GetCash() < t.cost then
			RP:Error(ply, RP.colors.white, "You do not have enough cash to buy this item.")
			return false
		end
		local tr=ply:GetEyeTraceNoCursor()
		local item=RP:SpawnItem(ply,t,c,tr.HitPos)
		if IsValid(item) then
			ply:TakeCash(t.cost)
			RP:Notify(ply, RP.colors.white, "Item bought.")
			return true
		end
		return false
	end
elseif CLIENT then
	function RP:OpenShop(sheet,x,y,uid)
		local shop=RP:GetShop(uid)
		if not shop then return end
		
		local function send(n,q,c,s)
			if n and q and c then
				net.Start("RP-Shop")
					net.WriteFloat(shop.const)
					net.WriteFloat(n)
					net.WriteFloat(q)
					net.WriteFloat(c)
					net.WriteBit(s)
				net.SendToServer()
				return true
			else
				return false
			end
		end
		
		local items={}
		local entlist=scripted_ents.GetList()
		local weplist=weapons.GetList()
		local ammolist=game.BuildAmmoTypes()
		for k,v in pairs(shop.tbl) do
			if v.class=="rp_ammobox" then
				for a,b in pairs(ammolist) do
					if v.name==b.name then
						table.insert(items,v)
						break
					end
				end
			elseif entlist[v.class] then
				table.insert(items,v)
			end
			
			for a,b in pairs(weplist) do
				if v.class==b.ClassName then
					table.insert(items,v)
					break
				end
			end
		end
		entlist=nil
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		sheet:AddSheet(shop.name,panel)
		
		if table.Count(items) == 0 then -- Show warning message if no items found
			local label = vgui.Create("DLabel",panel)
			label:SetPos(0,0)
			label:SetText("Sorry, no valid items are installed on\nthe server.")
			label:SetFont("DermaLarge")
			label:SizeToContents()
			return
		end
		
		local selected,selectedn,update
		local quantity=1
		local cost=0

		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn(shop.column or shop.name)
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(items) do
			listview:AddLine(v.name,RP:CC(v.cost)).v=v
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			for k,v in pairs(items) do
				if line.v==v then
					selected=v
					selectedn=k
					update()
				end
			end
		end
			
		local label = vgui.Create("DLabel",panel)
		label:SetPos(listview:GetPos()+listview:GetWide()+5,2.5)
		label:SetText("Quantity:")
		label:SizeToContents()
		local numberwang = vgui.Create("DNumberWang",panel)
		numberwang:SetPos(listview:GetWide()+label:GetWide()+10,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,RP:GetSetting("maxquantity",1))
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Cost:")
		label:SizeToContents()
		local setcost = vgui.Create("DNumberWang",panel)
		setcost:SetPos(panel:GetWide()-setcost:GetWide()-1,0)
		label:SetPos(panel:GetWide()-setcost:GetWide()-label:GetWide()-5,2.5)
		setcost.OnValueChanged = function(self,value)
			cost=tonumber(value)
		end

		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(selectedn,quantity,cost,false)
		end

		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(selectedn,quantity,cost,true)
		end

		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)

		local total = vgui.Create("DLabel",panel)
		total:SetText(RP:CC(0))
		total:SetFont("DermaLarge")
		total:SizeToContents()
		total:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-total:GetTall()-5)

		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-total:GetTall()-10)
		if shop.nospin then
			icon.LayoutEntity = function() end
		end

		function update()
			setcost:SetMinMax(0,selected.cost*RP:GetSetting("maxcostmul",1))
			setcost:SetValue(selected.cost)
			cost=selected.cost
			total:SetText(RP:CC(selected.cost*quantity))
			total:SizeToContents()
			icon:SetModel(selected.displaymodel or selected.model)
			shop.view(icon)
		end

		listview:SelectFirstItem()
	end
end

RP:AddInclude("rp_modules/shop")