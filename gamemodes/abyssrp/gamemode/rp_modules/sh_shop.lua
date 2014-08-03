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

if CLIENT then
	function RP:OpenShop(sheet,x,y,uid)
		local shop=RP:GetShop(uid)
		if not shop then return end
		
		local function send(n,q,s)
			if n and q then
				net.Start("RP-Shipments")
					net.WriteFloat(shop.const)
					net.WriteFloat(n)
					net.WriteFloat(q)
					net.WriteBit(tobool(s))
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

		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn(shop.column or shop.name)
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(items) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(items) do
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
			send(selectedn,quantity,false)
		end

		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(selectedn,quantity,true)
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
		if shop.nospin then
			icon.LayoutEntity = function() end
		end

		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
			icon:SetModel(selected.displaymodel or selected.model)
			shop.view(icon)
		end

		listview:SelectFirstItem()
	end
end

RP:AddInclude("rp_modules/shop")