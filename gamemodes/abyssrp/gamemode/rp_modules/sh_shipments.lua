-- Shipments

if SERVER then
	util.AddNetworkString("RP-Shipments")
	
	net.Receive("RP-Shipments", function(len, ply)
		local t=net.ReadFloat() -- Type of shipment
		local n=net.ReadFloat() -- Number in table
		local q=math.Clamp(net.ReadFloat(),1,100) -- Quantity
		local s=tobool(net.ReadBit()) -- Is shipment
		
		local tbl
		if t==1 then
			tbl=RP.Weapons[n]
		elseif t==2 then
			tbl=RP.AmmoTypes[n]
		elseif t==3 then
			tbl=RP.Attachments[n]
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
		shipment.DefaultPrice = t.cost
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
		weapon.Price = cost
		weapon.nodupe = true
		weapon:Spawn()
		weapon:Activate()
		ply:TakeCash(cost)
		RP:Notify(ply, RP.colors.white, "Item bought.")
		return true
	end
elseif CLIENT then
	function RP:GunShop()
		local function send(t,n,q,s)
			if t and n and q then
				net.Start("RP-Shipments")
					net.WriteFloat(t)
					net.WriteFloat(n)
					net.WriteFloat(q)
					net.WriteBit(tobool(s))
				net.SendToServer()
				return true
			else
				return false
			end
		end

		local function GenerateView(Panel)
			local PrevMins, PrevMaxs = Panel.Entity:GetRenderBounds()
			Panel:SetCamPos(PrevMins:Distance(PrevMaxs)*Vector(0,1,0))
			Panel:SetLookAt((PrevMaxs + PrevMins)/2)
		end

		local frame = vgui.Create("DFrame")
		frame:SetSize(480,300)
		frame:SetPos((ScrW()/2)-(frame:GetWide()/2), (ScrH()/2)-(frame:GetTall()/2))
		frame:SetTitle("Shop")
		frame:ShowCloseButton(true)
		frame:MakePopup()
		
		local sheet = vgui.Create("DPropertySheet",frame)
		sheet:SetSize(frame:GetWide()-10,frame:GetTall()-35)
		sheet:SetPos(5,30)
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(sheet:GetWide()-15,sheet:GetTall()-35)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Weapon")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Weapons) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Weapons) do
				if v.name==name then
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
		numberwang:SetPos(label:GetPos()+label:GetWide()+5,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,100)
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(1,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(1,selectedn,quantity,true)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)
		
		local cost = vgui.Create("DLabel",panel)
		cost:SetText(RP:CC(0))
		cost:SetFont("DermaLarge")
		cost:SizeToContents()
		cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-cost:GetTall()-5)
		
		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-cost:GetTall()-10)
		icon.LayoutEntity = function() end -- TODO: On/Off?
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
			icon:SetModel(selected.displaymodel)
			GenerateView(icon)
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Weapons",panel)
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(sheet:GetWide()-15,sheet:GetTall()-35)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Ammo type")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.AmmoTypes) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.AmmoTypes) do
				if v.name==name then
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
		numberwang:SetPos(label:GetPos()+label:GetWide()+5,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,100)
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(2,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(2,selectedn,quantity,true)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)
		
		local cost = vgui.Create("DLabel",panel)
		cost:SetText(RP:CC(0))
		cost:SetFont("DermaLarge")
		cost:SizeToContents()
		cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-cost:GetTall()-5)
		
		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-cost:GetTall()-10)
		icon:SetModel("models/items/boxmrounds.mdl")
		icon:SetCamPos(Vector(40,0,20))
		icon:SetLookAt(Vector(0,0,5))
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Ammo",panel)
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(sheet:GetWide()-15,sheet:GetTall()-35)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Attachment")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Attachments) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Attachments) do
				if v.name==name then
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
		numberwang:SetPos(label:GetPos()+label:GetWide()+5,0)
		numberwang:SetValue(quantity)
		numberwang:SetMinMax(1,100)
		numberwang.OnValueChanged = function(self,value)
			value=tonumber(value)
			quantity=math.Clamp(value,self:GetMin(),self:GetMax())
			update()
		end
		
		local buy = vgui.Create("DButton",panel)
		buy:SetSize(panel:GetWide()-listview:GetWide()-150,50)
		buy:SetPos(listview:GetWide()+5,panel:GetTall()-buy:GetTall()-1)
		buy:SetText("Buy single")
		buy.DoClick = function(self)
			send(3,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(3,selectedn,quantity,true)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Total cost:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-buy:GetTall()-label:GetTall()-5)
		
		local cost = vgui.Create("DLabel",panel)
		cost:SetText(RP:CC(0))
		cost:SetFont("DermaLarge")
		cost:SizeToContents()
		cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-buy:GetTall()-cost:GetTall()-5)
		
		local icon = vgui.Create("DModelPanel",panel)
		icon:SetPos(listview:GetWide()+5,numberwang:GetTall()+5)
		icon:SetSize(panel:GetWide()-icon:GetPos(),panel:GetTall()-numberwang:GetTall()-buy:GetTall()-cost:GetTall()-10)
		icon:SetModel("models/items/boxmrounds.mdl")
		icon:SetCamPos(Vector(40,0,20))
		icon:SetLookAt(Vector(0,0,5))
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Attachments",panel)
		
	end
end