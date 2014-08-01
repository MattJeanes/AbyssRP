include('shared.lua')

surface.CreateFont("VendingMachine", {font="Tahoma", size=48, weight=700, shadow=true})

function ENT:Draw()
    self:DrawModel()
	local pos = self:LocalToWorld(Vector(20.6,-5,45))
	local ang = self:GetAngles()
	local right = ang:Right()
	local dir = ang:Forward():Angle()
	
	dir:RotateAroundAxis(dir:Right(), -90)
	dir:RotateAroundAxis(dir:Up(), 90)
	
	cam.Start3D2D(pos, dir, 0.1 )
		draw.DrawText("Vending Machine", "VendingMachine", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end