SWEP.Author = "Meoowe/GParkour creators"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Mouse1 to climb walls, mouse2 to grab ledges."

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.HoldType = "normal"
SWEP.Category = "Movement"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HeartBeatDelay = CurTime()

function SWEP:DrawWorldModel()
	return false
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:DrawShadow(false)
	self.Owner.Delay = 0.25
	self.Owner.UsedTimes = 0
	self.Owner.Hanging = false
	self.Owner.NeckBreakDelay = 0
	self.Owner.InitialPower = 240
	self.Owner.VelocityMinus = 15
	self.Owner.HasWallJumped = false
	
	self.ClimbSoundElse = {
	Sound("physics/body/body_medium_impact_soft1.wav"),
	Sound("physics/body/body_medium_impact_soft2.wav"),
	Sound("physics/body/body_medium_impact_soft3.wav"),
	Sound("physics/body/body_medium_impact_soft4.wav") }
	
	self.ClimbSoundGlass = {
	Sound("physics/glass/glass_sheet_step1.wav"),
	Sound("physics/glass/glass_sheet_step1.wav"),
	Sound("physics/glass/glass_sheet_step1.wav"),
	Sound("physics/glass/glass_sheet_step1.wav") }
	
	self.ClimbSoundMetal = {
	Sound("physics/metal/metal_box_impact_soft1.wav"),
	Sound("physics/metal/metal_box_impact_soft2.wav"),
	Sound("physics/metal/metal_box_impact_soft3.wav") }
	
	self.ClimbSoundVent = {
	Sound("physics/metal/metal_box_footstep1.wav"),
	Sound("physics/metal/metal_box_footstep2.wav"),
	Sound("physics/metal/metal_box_footstep3.wav"),
	Sound("physics/metal/metal_box_footstep4.wav") }
	
	self.ClimbSoundGrate = {
	Sound("physics/metal/metal_chainlink_impact_soft1.wav"),
	Sound("physics/metal/metal_chainlink_impact_soft2.wav"),
	Sound("physics/metal/metal_chainlink_impact_soft3.wav") }
	
	self.ClimbSoundPlastic = {
	Sound("physics/plastic/plastic_box_impact_soft1.wav"),
	Sound("physics/plastic/plastic_box_impact_soft2.wav"),
	Sound("physics/plastic/plastic_box_impact_soft3.wav"),
	Sound("physics/plastic/plastic_box_impact_soft4.wav") }
	
	self.ClimbSoundWood = {
	Sound("physics/wood/wood_box_impact_soft1.wav"),
	Sound("physics/wood/wood_box_impact_soft2.wav"),
	Sound("physics/wood/wood_box_impact_soft3.wav") }
	
	self.ClimbSoundConcrete = {
	Sound("player/footsteps/concrete1.wav"),
	Sound("player/footsteps/concrete2.wav"),
	Sound("player/footsteps/concrete3.wav"),
	Sound("player/footsteps/concrete4.wav") }
	
	self.ClimbSoundTile = {
	Sound("physics/plaster/ceiling_tile_step1.wav"),
	Sound("physics/plaster/ceiling_tile_step2.wav"),
	Sound("physics/plaster/ceiling_tile_step3.wav"),
	Sound("physics/plaster/ceiling_tile_step4.wav") }
	
	self.GrabSound = {
	Sound("physics/flesh/flesh_impact_hard3.wav"),
	Sound("physics/flesh/flesh_impact_hard4.wav"),
	Sound("physics/flesh/flesh_impact_hard6.wav") }
	
	self.BreakNeck = {
	Sound("physics/body/body_medium_break3.wav"),
	Sound("physics/body/body_medium_break4.wav") }
	
	self.SwingSound = {
	Sound("npc/fast_zombie/claw_miss1.wav"),
	Sound("npc/fast_zombie/claw_miss2.wav") }
	
	self.HitMan = {
	Sound("npc/vort/foot_hit.wav"),
	Sound("npc/zombie/zombie_hit.wav") }
	
	self.PushProp = {
	Sound("physics/flesh/flesh_impact_hard1.wav"),
	Sound("physics/flesh/flesh_impact_hard2.wav"),
	Sound("physics/flesh/flesh_impact_hard3.wav"),
	Sound("physics/flesh/flesh_impact_hard4.wav"),
	Sound("physics/flesh/flesh_impact_hard5.wav"),
	Sound("physics/flesh/flesh_impact_hard6.wav") }
	
	self.AllowedSnaps = {
	"npc_metropolice",
	"npc_combine_s",
	"npc_sniper",
	"npc_stalker",
	"npc_mossman",
	"npc_citizen",
	"npc_alyx",
	"npc_eli",
	"npc_gman",
	"npc_barney",
	"npc_kleiner",
	"npc_breen",
	"npc_zombie",
	"npc_zombie_torso",
	"npc_fastzombie",
	"npc_fastzombie_torso",
	"npc_monk" }
	
end

function SWEP:Reload()
end

function SWEP:Deploy()
	timer.Simple(1.0, function()
		if self.Owner == nil then return false end
		if SERVER then
			self.Owner:DrawViewModel(false)
		end
	end)
	
	-- Just in case
	self.Owner.Delay = 0.25
	self.Owner.UsedTimes = 0
	self.Owner.Hanging = false
	self.Owner.NeckBreakDelay = 0
	self.Owner.InitialPower = 240
	self.Owner.VelocityMinus = 15
	self.Owner.HasWallJumped = false
	self.Owner.HasReleased = false
	
	if SERVER then
		if self.Owner:HasWeapon("climb_swepz") then
			self.Owner:StripWeapon("climb_swepz")
		end
		
		if self.Owner:HasWeapon("climb_swepzgrip") then
			self.Owner:StripWeapon("climb_swepzgrip")
		end
	end
	
	return true
end

function SWEP:Holster()
	self.Owner:SetMoveType(MOVETYPE_WALK)
	self.Owner.Hanging = false
	timer.Destroy("HideMyModel")
	timer.Destroy("0.3SecTimer")
	timer.Destroy("HasDoneARollTimer")
	return true
end

function SWEP:Think()
	if CLIENT then return end
	

	if self.Owner.Hanging == true and not self.Owner:OnGround() and not self.Owner:KeyDown(IN_ATTACK) and not self.Owner:KeyDown(IN_ATTACK2) then -- Zoey's shimmy code, thanks again!
		if self.Owner:GetMoveType() == MOVETYPE_FLY or self.Owner:GetMoveType() == MOVETYPE_NONE then
			local tr = {}
			tr.start = self.Owner:GetShootPos()
			tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 40 )
			tr.filter = self.Owner
			tr.mask = MASK_SHOT
			local traceSHI = util.TraceLine( tr )
			if not traceSHI.Hit then
				if SERVER then
					self.Owner:SetLocalVelocity(Vector(0,0,0))
					self.Owner:SetMoveType(MOVETYPE_NONE)
				end
			end
			
			if not self.Owner:KeyDown(IN_MOVELEFT) and not self.Owner:KeyDown(IN_MOVERIGHT) then
				if SERVER then
					self.Owner:SetLocalVelocity(Vector(0,0,0))
					self.Owner:SetMoveType(MOVETYPE_NONE)
				end
			end
			
			if self.Owner:KeyDown(IN_MOVELEFT) and traceSHI.Hit then
				if self.Owner:KeyDown(IN_JUMP) or self.Owner:KeyDown(IN_BACK) then
					self.Owner:SetLocalVelocity(Vector(0,0,0))
					self.Owner:SetMoveType(MOVETYPE_NONE)
				else
					if SERVER then
						self.Owner:SetMoveType(MOVETYPE_FLY)
					end
					if self.Owner:KeyDown(IN_SPEED) then
						self.Owner:SetLocalVelocity(self.Owner:GetRight() * -40)
					else
						self.Owner:SetLocalVelocity(self.Owner:GetRight() * -20)
					end
				end
			end
			
			if self.Owner:KeyDown(IN_MOVERIGHT) and traceSHI.Hit then
				if self.Owner:KeyDown(IN_JUMP) or self.Owner:KeyDown(IN_BACK) then
					self.Owner:SetLocalVelocity(Vector(0,0,0))
					self.Owner:SetMoveType(MOVETYPE_NONE)
				else
					if SERVER then
						self.Owner:SetMoveType(MOVETYPE_FLY)
					end
					if self.Owner:KeyDown(IN_SPEED) then
						self.Owner:SetLocalVelocity(self.Owner:GetRight()*40)
					else
						self.Owner:SetLocalVelocity(self.Owner:GetRight()*20)
					end
				end
			end
			
			if self.Owner:KeyDown(IN_FORWARD) and traceSHI.Hit then
				if self.Owner:KeyDown(IN_JUMP) or self.Owner:KeyDown(IN_BACK) then
					self.Owner:SetLocalVelocity(Vector(0,0,0))
					self.Owner:SetMoveType(MOVETYPE_NONE)
				else
					if SERVER then
						self.Owner:SetMoveType(MOVETYPE_FLY)
					end
					if self.Owner:KeyDown(IN_SPEED) then
						self.Owner:SetLocalVelocity(self.Owner:GetForward()*40)
					else
						self.Owner:SetLocalVelocity(self.Owner:GetForward()*20)
					end
				end
			end
		end
	end

	if self.Owner:KeyPressed(IN_JUMP) then
		
		if not self.Owner:OnGround() then
			if self.Owner.Hanging == false and not self.Weapon:CanGrab() then
				if self.Owner.UsedTimes >= 2 then
					local trace = self.Owner:GetEyeTrace()
					if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 50 then -- Wall-jump using W/A/D
						if self.Owner.HasWallJumped == false then
							if self.Owner:KeyDown(IN_FORWARD) then
								if SERVER then
									self.Owner:SetEyeAngles(self.Owner:EyeAngles() - Vector(0, 180, 0))
									self.Owner:SetLocalVelocity(self.Owner:GetForward() * -375 + Vector(0, 0, 75))
								end
								self.Degree = 180
								self.CameraType = 1 
								self.Owner:ViewPunch(Angle(-10, 0, 0))
								
							elseif self.Owner:KeyDown(IN_MOVERIGHT) then
								if SERVER then
									self.Owner:SetEyeAngles(self.Owner:EyeAngles() - Vector(0, 90, 0))
									self.Owner:SetLocalVelocity(self.Owner:GetRight() * 375 + Vector(0, 0, 75))
								end
								self.Degree = 90
								self.CameraType = 2
								self.Owner:ViewPunch(Angle(-10, 0, 0))
								
							elseif self.Owner:KeyDown(IN_MOVELEFT) then
								if SERVER then
									self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Vector(0, 90, 0))
									self.Owner:SetLocalVelocity(self.Owner:GetRight() * -375 + Vector(0, 0, 75))
								end
								self.Degree = 90
								self.CameraType = 1
								self.Owner:ViewPunch(Angle(-10, 0, 0))
							end
							self.Owner.UsedTimes = 3
							self.Owner.HasWallJumped = true
						end
					end
				end
			elseif self.Owner.Hanging == true then
				if self.Owner:KeyDown(IN_FORWARD) then
				
					if SERVER then
						self.Owner:SetMoveType(MOVETYPE_WALK)
					end
					
					if SERVER then
						self.Owner:SetLocalVelocity(self.Owner:GetForward() * 375 + Vector(0, 0, 75))
					end
					self.Owner:ViewPunch(Angle(-5, 0, 0))
					self.Owner.Hanging = false
					self.Owner.UsedTimes = 3
				end
			end
		elseif self.Owner:OnGround() then -- Cat leap part
			-- Where the hell is the first Cat leap part?! It's in autorun/server/roll.lua
			
		end
	end
	
	if self.Owner.HasReleased == false and not self.Owner:KeyDown(IN_ATTACK2) then
		self.Owner.HasReleased = true
	end
	
end


function SWEP:PrimaryAttack()
	if CLIENT then return end
	local ActualSound
	
	if not self.Owner:OnGround() then
		if self.Owner:GetVelocity().z >= -750 then
			local pos = self.Owner:GetShootPos()
			local ang = self.Owner:GetAimVector()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+(ang*45)
			tracedata.filter = self.Owner
			local trace = util.TraceLine(tracedata)
			
			if trace.MatType == MAT_CONCRETE then
				ActualSound = self.ClimbSoundConcrete
			elseif trace.MatType == MAT_METAL then
				ActualSound = self.ClimbSoundMetal
			elseif trace.MatType == MAT_VENT then
				ActualSound = self.ClimbSoundVent
			elseif trace.MatType == MAT_GRATE then
				ActualSound = self.ClimbSoundGrate
			elseif trace.MatType == MAT_WOOD then
				ActualSound = self.ClimbSoundWood
			elseif trace.MatType == MAT_TILE then
				ActualSound = self.ClimbSoundTile
			elseif trace.MatType == MAT_PLASTIC or trace.MatType == MAT_COMPUTER then
				ActualSound = self.ClimbSoundPlastic
			elseif trace.MatType == MAT_GLASS then
				ActualSound = self.ClimbSoundGlass
			else
				ActualSound = self.ClimbSoundElse
			end
			if self.Owner.Hanging == false or not self.Owner:GetMoveType() == MOVETYPE_NONE then
				if self.Owner.UsedTimes < 3 then
					if ( trace.HitWorld or trace.Entity:IsValid() and not trace.Entity:IsPlayer() and not trace.Entity:IsNPC() ) then
						local Vel = self.Owner:GetVelocity()
						if SERVER then
							self.Owner:SetVelocity(Vector(0, 0, self.Owner.InitialPower - (self.Owner.UsedTimes * self.Owner.VelocityMinus) - Vel.z))
						end
						self.Owner:EmitSound(table.Random(ActualSound), 75, math.random(95, 105))
						self.Weapon:SetNextPrimaryFire( CurTime() + self.Owner.Delay )
						self.Owner.NeckBreakDelay = CurTime() + 1.5
						self.Owner.UsedTimes = self.Owner.UsedTimes + 1
						self.Weapon:ShakeEffect()
					end
				end
			else
			local Vel = self.Owner:GetVelocity()
				if SERVER then
					self.Owner:SetMoveType(MOVETYPE_WALK)
					self.Owner:SetLocalVelocity(Vector(0, 0, 250))
				end
				self.Owner:EmitSound(table.Random(ActualSound), 75, math.random(95, 105))
				self.Owner:EmitSound("player/suit_sprint.wav", 85, math.random(95, 105))
				timer.Simple(0.3, function() 
					if self.Owner == nil then return false end
					self.Owner.Hanging = false
				end)
				self.Weapon:SetNextPrimaryFire( CurTime() + (self.Owner.Delay + 0.15) )
				self.Owner.NeckBreakDelay = CurTime() + 1.5
				self.Owner:ViewPunch(Angle(-7, 0, 0))
			end	
		end	
	end
end

function SWEP:ShakeEffect()
	if self.Owner.UsedTimes == 1 then
		self.Owner:ViewPunch(Angle(0, 5, 0))
	elseif self.Owner.UsedTimes == 2 then
		self.Owner:ViewPunch(Angle(0, -5, 0))
	elseif self.Owner.UsedTimes == 3 then
		self.Owner:ViewPunch(Angle(-5, 0, 0))
	end
end

// SecondaryAttack

function SWEP:CanGrab() -- this part is not by me, it's by guys who made GParkour
	
	local trace = {}
	trace.start = self.Owner:GetShootPos() + Vector( 0, 0, 15 )
	trace.endpos = trace.start + (self.Owner:GetAimVector():Angle():Forward( ) * 30)
	trace.filter = self.Owner

	local trHi = util.TraceLine(trace)
	
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector():Angle():Forward( ) * 30)
	trace.filter = self.Owner

	local trLo = util.TraceLine(trace)
	
	if trLo and trHi and trLo.Hit and not trHi.Hit then
		return true
	else 
		return false
	end
end -- And everything below is by me

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner.HasReleased == false then 
		return -- We don't want to let go of the ledge if we were accidently holding the secondary attack button while we were hanging on it, right?
	end
	
	local trace = self.Owner:GetEyeTrace()
	if not self.Owner:OnGround() then
		if self.Owner:GetVelocity():Length() <= 900 then
			if self.Owner.Hanging == false and self.Weapon:CanGrab() and not trace.Entity:IsNPC() and trace.Entity:GetPhysicsObject():IsMoveable() == false then
				if self.Owner:GetVelocity().z < 0 then
					self.Owner:ViewPunch(Angle(10, 0, 0))
				else
					self.Owner:ViewPunch(Angle(-5, 0, 0))
				end
				self.Owner.Hanging = true
				self.Owner.HasWallJumped = true
				self.Owner.HasReleased = false -- We don't want to let go of the ledge if we were accidently holding the secondary attack button while we were hanging on it, right?
				self.Owner:EmitSound(table.Random(self.GrabSound), 75, math.random(95, 105))
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.35)
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
				if SERVER then
					self.Owner:SetMoveType(MOVETYPE_NONE)
					self.Owner:SetLocalVelocity(Vector(0, 0, 0))
				end
			elseif self.Owner.Hanging == true then
				local Vel = self.Owner:GetVelocity()
				if SERVER then
					self.Owner:SetMoveType(MOVETYPE_WALK)
					self.Owner:SetLocalVelocity(Vector(0, 0, 0))
				end
				self.Owner.Hanging = false
				self.Owner.UsedTimes = 3
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.35)
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			end	
		end
	end
end 