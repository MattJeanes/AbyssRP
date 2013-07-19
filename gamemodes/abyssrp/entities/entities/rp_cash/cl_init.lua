
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

/*---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------*/
function ENT:Draw()
	self.Entity:DrawModel()
	local pos = self.Entity:GetPos()
	local ang = self.Entity:GetAngles()
	local right = ang:Right()
	local dir = ang:Forward():Angle()
	local dir2 = ang:Forward():Angle()
	local fwd = ang:Forward()
	
	dir:RotateAroundAxis(dir:Right(), -90)
	dir:RotateAroundAxis(dir:Up(), 90)
	
	dir2:RotateAroundAxis(dir2:Right(), 90)
	dir2:RotateAroundAxis(dir2:Up(), -90)
	
	cam.Start3D2D(pos + Vector(0, 0, 10) + fwd, dir, 0.7 )
		draw.DrawText("$".. tostring(self.Entity:GetNWInt("cash")), "TabLarge", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
	
	cam.Start3D2D(pos + Vector(0, 0, 10) + fwd, dir2, 0.7 )
		draw.DrawText("$".. tostring(self.Entity:GetNWInt("cash")), "TabLarge", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
	
end

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()

	// This is here just to make it backwards compatible.
	// You shouldn't really be drawing your model here unless it's translucent

	self:Draw()
	
end

/*---------------------------------------------------------
   Name: BuildBonePositions
   Desc: 
---------------------------------------------------------*/
function ENT:BuildBonePositions( NumBones, NumPhysBones )

	// You can use this section to position the bones of
	// any animated model using self:SetBonePosition( BoneNum, Pos, Angle )
	
	// This will override any animation data and isn't meant as a 
	// replacement for animations. We're using this to position the limbs
	// of ragdolls.
	
end



/*---------------------------------------------------------
   Name: SetRagdollBones
   Desc: 
---------------------------------------------------------*/
function ENT:SetRagdollBones( bIn )

	// If this is set to true then the engine will call 
	// DoRagdollBone (below) for each ragdoll bone.
	// It will then automatically fill in the rest of the bones

	self.m_bRagdollSetup = bIn

end


/*---------------------------------------------------------
   Name: DoRagdollBone
   Desc: 
---------------------------------------------------------*/
function ENT:DoRagdollBone( PhysBoneNum, BoneNum )

	// self:SetBonePosition( BoneNum, Pos, Angle )
	
end
