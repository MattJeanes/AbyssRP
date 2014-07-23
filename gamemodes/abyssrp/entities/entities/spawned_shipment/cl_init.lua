include("shared.lua")

local matBallGlow = Material("models/props_combine/tpballglow")

surface.CreateFont("HUDNumber5", {font="Trebuchet MS", size=45, weight=900})

function ENT:Draw()
	self.height = self.height or 0
	self.colr = self.colr or 1
	self.colg = self.colg or 0
	self.StartTime = self.StartTime or CurTime()
	
	if GetConVarNumber("shipmentspawntime") > 0 and self.height < self:OBBMaxs().z then
		render.MaterialOverride(matBallGlow)
		
		render.SetColorModulation(self.colr, self.colg, 0)
		
		self.Entity:DrawModel()
		
		self.colr = 1 / ((CurTime() - self.StartTime ) / GetConVarNumber( "shipmentspawntime"))
		self.colg = (CurTime() - self.StartTime ) / GetConVarNumber( "shipmentspawntime")
		
		render.SetColorModulation(1, 1, 1)
		
		render.MaterialOverride()
	
		local normal = - self:GetAngles():Up()
		local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z + self.height))
		local distance = normal:Dot(pos)
		self.height = self:OBBMaxs().z * ((CurTime() - self.StartTime) / GetConVarNumber("shipmentspawntime")) 
		render.EnableClipping(true)
		render.PushCustomClipPlane(normal, distance);
		
		self.Entity:DrawModel()
		
		render.PopCustomClipPlane()
	else
		self.Entity:DrawModel()
	end
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	local name = self.Entity:GetNWString("name")
	
	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Contents:")
	local TextWidth2 = surface.GetTextSize(name)
	
	cam.Start3D2D(Pos + Ang:Up() * 25, Ang, 0.2)
		draw.WordBox(2, -TextWidth*0.5 + 5, -30, "Contents:", "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(2, -TextWidth2*0.5 + 5, 18, name, "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	
	local count = self.Entity:GetNWInt("count")
	
	local TextWidth = surface.GetTextSize("Amount left:")
	local TextWidth2 = surface.GetTextSize(tostring(count))
	
	cam.Start3D2D(Pos + Ang:Up() * 17, Ang, 0.14)
		draw.WordBox(2, -TextWidth*0.5 + 5, -150, "Amount left:", "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(2, -TextWidth2*0.5 + 0, -102, count, "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
	Ang:RotateAroundAxis(Ang:Forward(), 180)
	
	Ang:RotateAroundAxis(Ang:Up(), 180)
	
	local cost = self.Entity:GetNWInt("cost")
	
	local TextWidth = surface.GetTextSize("Cost:")
	local TextWidth2 = surface.GetTextSize(tostring(cost))
	
	cam.Start3D2D(Pos + Ang:Up() * 17, Ang, 0.14)
		draw.WordBox(2, -TextWidth*0.5 + -17, -150, "Cost:", "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(2, -TextWidth2*0.5 + -26, -102, RP:CC(cost), "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
end