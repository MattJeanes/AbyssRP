
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

/*---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------*/
function ENT:Draw()
	self:DrawModel()
	
	local str=RP:CC(self:GetNWInt("cash",0))
	
	surface.SetFont("TabLarge")
	local w,h=surface.GetTextSize(str)
	
	local pos = self:LocalToWorld(Vector(0,0,1))
	local pos2 = self:GetPos()
	
	local ang = self:GetAngles()
	local ang2 = self:GetAngles()
	
	ang2:RotateAroundAxis(self:GetRight(),180)

	cam.Start3D2D(pos, ang, 7.5/w)
		draw.DrawText(str, "TabLarge", 0, (-h)+31, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
	
	cam.Start3D2D(pos2, ang2, 7.5/w)
		draw.DrawText(str, "TabLarge", 0, (-h)+31, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
	
end

concommand.Add("guitest", function(ply,cmd,args)
	local frame = vgui.Create("DFrame")
	frame:SetSize(560,300)
	frame:SetPos((ScrW()/2)-(frame:GetWide()/2), (ScrH()/2)-(frame:GetTall()/2))
	frame:SetTitle("Shop")
	frame:ShowCloseButton(true)
	frame:MakePopup()
	
	local sheet = vgui.Create("DPropertySheet",frame)
	sheet:SetSize(frame:GetWide()-10,frame:GetTall()-35)
	sheet:SetPos(5,30)
	
	local panel = vgui.Create("Panel")	
	panel:SetSize(sheet:GetWide()-15,sheet:GetTall()-35)
	
	local selected,updatecost
	local quantity=1
	
	local listview = vgui.Create("DListView",panel)
	--listview:SetPos(0,0)
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
				updatecost()
			end
		end
	end
	
	
	local label = vgui.Create("DLabel",panel)
	label:SetText("Total cost:")
	label:SetFont("DermaLarge")
	label:SizeToContents()
	label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-label:GetTall()-5)
	
	local cost = vgui.Create("DLabel",panel)
	cost:SetText(RP:CC(0))
	cost:SetFont("DermaLarge")
	cost:SizeToContents()
	cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-cost:GetTall()-5)
	
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
		updatecost()
	end
	
	local buy = vgui.Create("DButton",panel)
	buy:SetSize(100,50)
	buy:SetPos(panel:GetWide()-buy:GetWide()-1,panel:GetTall()-buy:GetTall()-1)
	buy:SetText("Buy")
	buy.DoClick = function(self)
		PrintTable(selected)
	end
	
	function updatecost()
		cost:SetText(RP:CC(selected.cost*quantity))
		cost:SizeToContents()
	end
	
	listview:SelectFirstItem()
	
	sheet:AddSheet("Weapons",panel)
	
	local panel = vgui.Create("Panel")	
	panel:SetSize(sheet:GetWide()-15,sheet:GetTall()-35)
	
	local selected,updatecost
	local quantity=1
	
	local listview = vgui.Create("DListView",panel)
	--listview:SetPos(0,0)
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
				updatecost()
			end
		end
	end
	
	
	local label = vgui.Create("DLabel",panel)
	label:SetText("Total cost:")
	label:SetFont("DermaLarge")
	label:SizeToContents()
	label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-label:GetTall()-5)
	
	local cost = vgui.Create("DLabel",panel)
	cost:SetText(RP:CC(0))
	cost:SetFont("DermaLarge")
	cost:SizeToContents()
	cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-cost:GetTall()-5)
	
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
		updatecost()
	end
	
	local buy = vgui.Create("DButton",panel)
	buy:SetSize(100,50)
	buy:SetPos(panel:GetWide()-buy:GetWide()-1,panel:GetTall()-buy:GetTall()-1)
	buy:SetText("Buy")
	buy.DoClick = function(self)
		PrintTable(selected)
	end
	
	function updatecost()
		cost:SetText(RP:CC(selected.cost*quantity))
		cost:SizeToContents()
	end
	
	listview:SelectFirstItem()
	
	sheet:AddSheet("Ammo",panel)
	
	local panel = vgui.Create("Panel")	
	panel:SetSize(sheet:GetWide()-15,sheet:GetTall()-35)
	
	local selected,updatecost
	local quantity=1
	
	local listview = vgui.Create("DListView",panel)
	--listview:SetPos(0,0)
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
				updatecost()
			end
		end
	end
	
	
	local label = vgui.Create("DLabel",panel)
	label:SetText("Total cost:")
	label:SetFont("DermaLarge")
	label:SizeToContents()
	label:SetPos(listview:GetPos()+listview:GetWide()+5,panel:GetTall()-label:GetTall()-5)
	
	local cost = vgui.Create("DLabel",panel)
	cost:SetText(RP:CC(0))
	cost:SetFont("DermaLarge")
	cost:SizeToContents()
	cost:SetPos(label:GetPos()+label:GetWide()+5,panel:GetTall()-cost:GetTall()-5)
	
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
		updatecost()
	end
	
	local buy = vgui.Create("DButton",panel)
	buy:SetSize(100,50)
	buy:SetPos(panel:GetWide()-buy:GetWide()-1,panel:GetTall()-buy:GetTall()-1)
	buy:SetText("Buy")
	buy.DoClick = function(self)
		PrintTable(selected)
	end
	
	function updatecost()
		cost:SetText(RP:CC(selected.cost*quantity))
		cost:SizeToContents()
	end
	
	listview:SelectFirstItem()
	
	sheet:AddSheet("Attachments",panel)
	
end)
