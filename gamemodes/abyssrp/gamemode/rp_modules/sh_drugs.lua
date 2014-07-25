RP.Drugs={}

function RP:AddDrug(t)
	local n = #RP.Drugs+1
	RP.Drugs[n]=table.Copy(t)
end

-- Drugs

RP:AddDrug({
	name="Alcohol",
	class="durgz_alcohol",
	model="models/drug_mod/alcohol_can.mdl",
	cost=25
})

RP:AddDrug({
	name="Aspirin",
	class="durgz_aspirin",
	model="models/jaanus/aspbtl.mdl",
	cost=110
})

RP:AddDrug({
	name="Cigarette",
	class="durgz_cigarette",
	model="models/boxopencigshib.mdl",
	cost=30
})

RP:AddDrug({
	name="Cocaine",
	class="durgz_cocaine",
	model="models/cocn.mdl",
	cost=225
})

RP:AddDrug({
	name="Heroine",
	class="durgz_heroine",
	model="models/katharsmodels/syringe_out/syringe_out.mdl",
	cost=45
})

RP:AddDrug({
	name="LSD",
	class="durgz_lsd",
	model="models/smile/smile.mdl",
	cost=45
})

RP:AddDrug({
	name="Mushroom",
	class="durgz_mushroom",
	model="models/ipha/mushroom_small.mdl",
	cost=45
})

RP:AddDrug({
	name="PCP",
	class="durgz_pcp",
	model="models/marioragdoll/Super Mario Galaxy/star/star.mdl",
	cost=35
})

RP:AddDrug({
	name="Water",
	class="durgz_water",
	model="models/drug_mod/the_bottle_of_water.mdl",
	cost=5
})

RP:AddDrug({
	name="Weed",
	class="durgz_weed",
	model="models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
	cost=175
})

local drug=RP:AddConstant("shop","drug")

if CLIENT then
	hook.Add("RP-Menu", "RP-Drugs", function(sheet,x,y)
		if not (LocalPlayer():Team()==RP:GetTeamN("drug dealer")) then return end
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
			Panel:SetCamPos(PrevMins:Distance(PrevMaxs)*Vector(1,1,1))
			Panel:SetLookAt((PrevMaxs + PrevMins)/2)
		end
		
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local selected,selectedn,update
		local quantity=1
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(200,panel:GetTall())
		listview:AddColumn("Drug")
		listview:AddColumn("Cost"):SetFixedWidth(50)
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Drugs) do
			listview:AddLine(v.name,RP:CC(v.cost))
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Drugs) do
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
			send(drug,selectedn,quantity,false)
		end
		
		local buy2 = vgui.Create("DButton",panel)
		buy2:SetSize(panel:GetWide()-buy:GetWide()-listview:GetWide()-10,50)
		buy2:SetPos(panel:GetWide()-buy2:GetWide()-1,panel:GetTall()-buy2:GetTall()-1)
		buy2:SetText("Buy shipment")
		buy2.DoClick = function(self)
			send(drug,selectedn,quantity,true)
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
		--icon.LayoutEntity = function() end -- TODO: On/Off?
		
		function update()
			cost:SetText(RP:CC(selected.cost*quantity))
			cost:SizeToContents()
			icon:SetModel(selected.model)
			GenerateView(icon)
		end
		
		listview:SelectFirstItem()
		
		sheet:AddSheet("Drugs",panel)
	end)
end