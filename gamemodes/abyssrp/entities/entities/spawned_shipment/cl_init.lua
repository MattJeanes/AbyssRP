include("shared.lua")

local matBallGlow = Material("models/props_combine/tpballglow")

surface.CreateFont("HUDNumber5", {font="Trebuchet MS", size=45, weight=900})

function ENT:Draw()	
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	local name = self:GetNWString("name")
	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Contents:")
	local TextWidth2 = surface.GetTextSize(name)
	
	cam.Start3D2D(Pos + Ang:Up() * 24.5, Ang, 0.2)
		draw.WordBox(2, -TextWidth*0.5 + 5, -30, "Contents:", "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(2, -TextWidth2*0.5 + 5, 18, name, "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	
	local count = self:GetNWInt("count")
	
	local TextWidth = surface.GetTextSize("Amount left:")
	local TextWidth2 = surface.GetTextSize(tostring(count))
	
	cam.Start3D2D(Pos + Ang:Up() * 17, Ang, 0.14)
		draw.WordBox(2, -TextWidth*0.5 + 5, -150, "Amount left:", "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(2, -TextWidth2*0.5 + 0, -102, count, "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
	Ang:RotateAroundAxis(Ang:Forward(), 180)
	
	Ang:RotateAroundAxis(Ang:Up(), 180)
	
	local cost = self:GetNWFloat("cost")
	
	local TextWidth = surface.GetTextSize("Cost:")
	local TextWidth2 = surface.GetTextSize(RP:CC(cost))
	
	cam.Start3D2D(Pos + Ang:Up() * 14.5, Ang, 0.14)
		draw.WordBox(2, -TextWidth*0.5 + -17, -150, "Cost:", "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(2, -TextWidth2*0.5 + -26, -102, RP:CC(cost), "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
end