
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

/*---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------*/
function ENT:Draw()
	self:DrawModel()
	
	local str=RP:CC(self:GetNWFloat("cash",0))
	
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
