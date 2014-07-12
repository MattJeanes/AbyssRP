include( 'shared.lua' )

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont("TabLarge", {font="Tahoma", size=72, weight=700, shadow=true})

function ENT:Draw()
    self.Entity:DrawModel()
	local pos = self.Entity:GetPos()
	local ang = self.Entity:GetAngles()
	local right = ang:Right()
	local dir = ang:Forward():Angle()
	local fwd = ang:Forward()
	
	dir:RotateAroundAxis(dir:Right(), -90)
	dir:RotateAroundAxis(dir:Up(), 90)
	
	cam.Start3D2D(pos + Vector(0, 0, 100) + fwd, dir, 0.15 )
		draw.DrawText("ATM (Bank)", "TabLarge", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

function ENT:DrawEntityOutline()
     --DO NOTHING
end

surface.CreateFont("ATMText", {})

local function BankMenu()
	local DButton2
	local DButton1
	local DTextEntry1
	local DLabel1
	local DFrame1
	
	DFrame1 = vgui.Create('DFrame')
	DFrame1:SetSize(228, 194)
	DFrame1:Center()
	DFrame1:SetTitle('Bank ATM')
	DFrame1:SetSizable(false)
	DFrame1:SetDeleteOnClose(false)
	DFrame1:MakePopup()

	DLabel1 = vgui.Create("DTextEntry", DFrame1)
	DLabel1:SetPos(13, 41)
	DLabel1:SetSize(200, 150)
	DLabel1:SetMultiline(true)
	DLabel1:SetWrap(true)
	usermessage.Hook("ATMUpdate", function(data)
		local BankAmount=data:ReadFloat()
		DLabel1:SetText("Welcome to your bank account, Please enter the values below on how much you want to withdraw or deposit. You have $"..BankAmount.." in your bank account.")
	end)
	DLabel1:SetText("Welcome to your bank account, Please enter the values below on how much you want to withdraw or deposit. You have $"..LocalPlayer():GetBank().." in your bank account.")
	DLabel1:SetTextColor(color_white)
	DLabel1:SetFont("ATMText")
	DLabel1:SetDrawBackground(false)
	DLabel1:SetDrawBorder(false)
	DLabel1:SetEditable(false)
	
	DTextEntry1 = vgui.Create('DTextEntry')
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
	
	DButton1 = vgui.Create('DButton')
	DButton1:SetParent(DFrame1)
	DButton1:SetSize(70, 25)
	DButton1:SetPos(25, 148)
	DButton1:SetText('Deposit')
	DButton1.DoClick = function()
		if not tonumber(DTextEntry1:GetValue()) then
			if DTextEntry1:GetValue() == "Enter a number here!" then
				RP:Error(LocalPlayer(), RP.colors.white, "Please enter an amount!")
			else
				RP:Error(LocalPlayer(), RP.colors.white, "Only numbers please!")
			end
		else
			LocalPlayer():ConCommand("bank_deposit " .. tonumber(DTextEntry1:GetValue()))
		end
	end
	DButton2 = vgui.Create('DButton')
	DButton2:SetParent(DFrame1)
	DButton2:SetSize(70, 25)
	DButton2:SetPos(130, 148)
	DButton2:SetText('Withdraw')
	DButton2.DoClick = function() 
		if not tonumber(DTextEntry1:GetValue()) then
			if DTextEntry1:GetValue() == "Enter a number here!" then
				RP:Error(LocalPlayer(), RP.colors.white, "Please enter an amount!")
			else
				RP:Error(LocalPlayer(), RP.colors.white, "Only numbers please!")
			end
		else
			LocalPlayer():ConCommand("bank_withdraw " .. tonumber(DTextEntry1:GetValue()))
		end
	end
end
usermessage.Hook("ShowBank", BankMenu)