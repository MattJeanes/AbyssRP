include( 'shared.lua' )

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont("TabLarge", {font="Tahoma", size=72, weight=700, shadow=true})

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local right = ang:Right()
	local dir = ang:Forward():Angle()
	local fwd = ang:Forward()
	
	dir:RotateAroundAxis(dir:Right(), -90)
	dir:RotateAroundAxis(dir:Up(), 90)
	
	cam.Start3D2D(pos + Vector(0, 0, 100) + fwd, dir, 0.15 )
		draw.DrawText("ATM (Bank)", "TabLarge", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

net.Receive("RP-ATM", function(len)	
	local DFrame1 = vgui.Create('DFrame')
	DFrame1:SetSize(228, 194)
	DFrame1:Center()
	DFrame1:SetTitle('Bank ATM')
	DFrame1:SetSizable(false)
	DFrame1:SetDeleteOnClose(false)
	DFrame1:MakePopup()

	local DLabel1 = vgui.Create("DTextEntry", DFrame1)
	DLabel1:SetPos(13, 41)
	DLabel1:SetSize(200, 150)
	DLabel1:SetMultiline(true)
	DLabel1:SetWrap(true)
	DLabel1:SetTextColor(color_white)
	DLabel1:SetDrawBackground(false)
	DLabel1:SetDrawBorder(false)
	DLabel1:SetEditable(false)
	DLabel1.Update = function(self,value)
		self:SetText("Welcome to your bank account, Please enter the values below on how much you want to withdraw or deposit. You have "..RP:CC(value).." in your bank account.")
	end
	DLabel1:Update(LocalPlayer():GetBank())
	
	net.Receive("RP-ATMUpdate", function(len)
		DLabel1:Update(net.ReadFloat())
	end)
	
	local DTextEntry1 = vgui.Create('DTextEntry')
	DTextEntry1:SetParent(DFrame1)
	DTextEntry1:SetSize(185, 25)
	DTextEntry1:SetPos(19, 115)
	DTextEntry1.OnGetFocus = function(PanelVar) -- Passes a single argument, the text entry object.
		if DTextEntry1:GetValue() == "Enter a number here!" then
			DTextEntry1:SetText("")
		end
	end
	DTextEntry1.OnLoseFocus = function(PanelVar) -- Passes a single argument, the text entry object.
		if DTextEntry1:GetValue() == "" then
			DTextEntry1:SetText("Enter a number here!")
		end
	end
	
	local DButton1 = vgui.Create('DButton')
	DButton1:SetParent(DFrame1)
	DButton1:SetSize(70, 25)
	DButton1:SetPos(19, 148)
	DButton1:SetText('Deposit')
	DButton1.DoClick = function()
		if not tonumber(DTextEntry1:GetValue()) then
			if DTextEntry1:GetValue() == "Enter a number here!" then
				RP:Error(LocalPlayer(), RP.colors.white, "Please enter an amount!")
			else
				RP:Error(LocalPlayer(), RP.colors.white, "Invalid input!")
			end
		else
			net.Start("RP-ATM")
				net.WriteBit(false)
				net.WriteFloat(DTextEntry1:GetValue())
			net.SendToServer()
		end
	end
	
	local DButton2 = vgui.Create('DButton')
	DButton2:SetParent(DFrame1)
	DButton2:SetSize(70, 25)
	DButton2:SetPos(135, 148)
	DButton2:SetText('Withdraw')
	DButton2.DoClick = function() 
		if not tonumber(DTextEntry1:GetValue()) then
			if DTextEntry1:GetValue() == "Enter a number here!" then
				RP:Error(LocalPlayer(), RP.colors.white, "Please enter an amount!")
			else
				RP:Error(LocalPlayer(), RP.colors.white, "Invalid input!")
			end
		else
			net.Start("RP-ATM")
				net.WriteBit(true)
				net.WriteFloat(DTextEntry1:GetValue())
			net.SendToServer()
		end
	end
	
	local DButton2 = vgui.Create('DButton')
	DButton2:SetParent(DFrame1)
	DButton2:SetPos(92, 148)
	DButton2:SetSize(40, 25)
	DButton2:SetText('All')
	DButton2.DoClick = function() 
		DTextEntry1:SetValue(LocalPlayer():GetBank())
	end
end)