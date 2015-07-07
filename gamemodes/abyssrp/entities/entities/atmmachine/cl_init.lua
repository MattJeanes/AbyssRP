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
	local frame = vgui.Create('DFrame')
	frame:SetSize(228, 224)
	frame:Center()
	frame:SetTitle('Bank ATM')
	frame:SetSizable(false)
	frame:SetDeleteOnClose(false)
	frame:MakePopup()

	local label = vgui.Create("DTextEntry", frame)
	label:SetPos(13, 41)
	label:SetSize(200, 150)
	label:SetMultiline(true)
	label:SetWrap(true)
	label:SetTextColor(color_white)
	label:SetDrawBackground(false)
	label:SetDrawBorder(false)
	label:SetEditable(false)
	label.Update = function(self,value)
		self:SetText("Welcome to your bank account, Please enter the values below on how much you want to withdraw or deposit. You have "..RP:CC(value).." in your bank account.")
	end
	label:Update(LocalPlayer():GetBank())
	
	net.Receive("RP-ATMUpdate", function(len)
		label:Update(net.ReadFloat())
	end)
	
	local textentry = vgui.Create('DTextEntry')
	textentry:SetParent(frame)
	textentry:SetSize(185, 25)
	textentry:SetPos(19, 115)
	textentry.OnGetFocus = function(PanelVar) -- Passes a single argument, the text entry object.
		if textentry:GetValue() == "Enter a number here!" then
			textentry:SetText("")
		end
	end
	textentry.OnLoseFocus = function(PanelVar) -- Passes a single argument, the text entry object.
		if textentry:GetValue() == "" then
			textentry:SetText("Enter a number here!")
		end
	end
	
	local function deposit(n)
		net.Start("RP-ATM")
			net.WriteBit(false)
			net.WriteFloat(tonumber(n))
		net.SendToServer()
	end
	
	local function withdraw(n)
		net.Start("RP-ATM")
			net.WriteBit(true)
			net.WriteFloat(tonumber(n))
		net.SendToServer()
	end
	
	local button = vgui.Create('DButton')
	button:SetParent(frame)
	button:SetSize(90, 25)
	button:SetPos(19, 148)
	button:SetText('Deposit')
	button.DoClick = function()
		if not tonumber(textentry:GetValue()) then
			if textentry:GetValue() == "Enter a number here!" then
				RP:Error(LocalPlayer(), RP.colors.white, "Please enter an amount!")
			else
				RP:Error(LocalPlayer(), RP.colors.white, "Invalid input!")
			end
		else
			deposit(textentry:GetValue())
		end
	end
	
	local button = vgui.Create('DButton')
	button:SetParent(frame)
	button:SetSize(90, 25)
	button:SetPos(114, 148)
	button:SetText('Withdraw')
	button.DoClick = function() 
		if not tonumber(textentry:GetValue()) then
			if textentry:GetValue() == "Enter a number here!" then
				RP:Error(LocalPlayer(), RP.colors.white, "Please enter an amount!")
			else
				RP:Error(LocalPlayer(), RP.colors.white, "Invalid input!")
			end
		else
			withdraw(textentry:GetValue())
		end
	end

	local button = vgui.Create('DButton')
	button:SetParent(frame)
	button:SetPos(19, 178)
	button:SetSize(90, 25)
	button:SetText('Deposit All')
	button.DoClick = function() 
		deposit(LocalPlayer():GetCash())
	end
	
	local button = vgui.Create('DButton')
	button:SetParent(frame)
	button:SetPos(114, 178)
	button:SetSize(90, 25)
	button:SetText('Withdraw All')
	button.DoClick = function() 
		withdraw(LocalPlayer():GetBank())
	end
end)