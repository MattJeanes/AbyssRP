-- Parkour Skill Pre 1.0.2 By SpY and Allusona - adapted by Dr. Matt
CreateConVar( "Parkour_SpeedDivider", 5, { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
CreateConVar( "Parkour_ForceMul", 15, { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
CreateConVar( "Parkour_MinForceAdd", 10, { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
CreateConVar( "Parkour_MaxForceAdd", 20, { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
--CreateConVar( "Parkour_MaxWallCombo", 5, { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

if CLIENT then
	function ParkourRoll( um )
		local ply = LocalPlayer()
		ply.IsRolling = true
		ply.RollTimer = CurTime() + 0.6
	end
	usermessage.Hook( "ParkourRoll", ParkourRoll )
	
	local function SendSlideToClient( um )
		local ply = LocalPlayer()
		if IsValid(ply) and ply:Health() > 0 then 
			local Bool = um:ReadBool()
			ply.Sliding = Bool
		end
	end
	usermessage.Hook( "SendSlideToClient", SendSlideToClient )
	
	local AddRoll = 0
	local RollValue = 0
	function ParkourCalcView(ply, pos, angles, fov)
	 
		if !ply:Alive() then return end
		
		local Dist = 0
		
		if ply:GetNWBool("WallRunning") and ply:GetNWBool("ParkourLeanView") == true and ply:GetNWBool("ParkourLeftLeanView") == true and AddRoll >= -20 or ply.IsRolling then
			Dist = AddRoll - 20
			AddRoll = math.Approach(AddRoll, 20, FrameTime() * ( Dist * 7))
			ply:SetNWBool("ParkourLeanView", true)
		elseif ply:GetNWBool("WallRunning") and ply:GetNWBool("ParkourLeanView") == true and ply:GetNWBool("ParkourRightLeanView") == true and AddRoll <= 20 then
			Dist = AddRoll - -20
			AddRoll = math.Approach(AddRoll, -20, FrameTime() * ( Dist * 7))
			ply:SetNWBool("ParkourLeanView", true)
		elseif ply:GetNWBool("ParkourLeanView") == false or ply:GetNWBool("WallRunning") == false or !ply.IsRolling or ply:Health() <= 0 then 
			AddRoll = math.Approach(AddRoll, 0, FrameTime() * 80)
		end
		
		if ply.RollTimer and ply.RollTimer < CurTime() and RollValue != 0 then 
			ply.IsRolling = false
			RollValue = 0
		elseif ply.RollTimer and ply.RollTimer > CurTime() and ply.IsRolling == true then
			RollValue = RollValue + FrameTime() * 600
		end	
		
		if AddRoll != 0 then
			angles.roll = angles.roll + AddRoll
		end
		
		local DistIn
		local DistOut
		
		if ply.Sliding == nil or ply.SlideLeanAngle == nil then
			ply.Sliding = false
			ply.SlideLeanAngle = 0
		end
		
		if ply.Sliding and ply.SlideLeanAngle < 20 then
			DistIn = ply.SlideLeanAngle - 20
			ply.SlideLeanAngle = math.Approach(ply.SlideLeanAngle, 20, FrameTime() * (DistIn * 6))
		elseif !ply.Sliding and ply.SlideLeanAngle > 0 then 
			DistOut = ply.SlideLeanAngle - 0
			ply.SlideLeanAngle = math.Approach(ply.SlideLeanAngle, 0, FrameTime() * (DistOut * 6))
		end
	
		if ply.SlideLeanAngle != 0 then
			angles.roll = angles.roll + ply.SlideLeanAngle
		end
		
		angles.p = angles.p + RollValue
		
	end
	hook.Add("CalcView", "ParkourCalcView", ParkourCalcView)

elseif SERVER then
	RP:AddSetting("maxwalljumps", 5)

    local CanLastVel2 = false
    local NextExp = CurTime()
	local function DoWallJump(ply, key)
		if not ply:GetTeamValue("freerun") then return end
		if (ply:Alive() and key == IN_JUMP and ply:WaterLevel() <= 1 and !ply:InVehicle() ) then
		
		local pos = ply:GetShootPos();
		local up = ply:GetUp();
	    local left = (ply:GetRight() * -1);
		local right = ply:GetRight();
		local forward = ply:GetForward();
		local back = (ply:GetForward() * -1);
		local MinForcevalue = GetConVarNumber("Parkour_MinForceAdd") * GetConVarNumber("Parkour_ForceMul")
		local MaxForcevalue = GetConVarNumber("Parkour_MaxForceAdd") * GetConVarNumber("Parkour_ForceMul")
		--local WallJumpComboMax = GetConVarNumber("Parkour_MaxWallCombo")
		local WallJumpComboMax = RP:GetSetting("maxwalljumps",0)
		local upforce = (up * (math.random(MinForcevalue * 2, MaxForcevalue * 2) + (ply:GetVelocity():Length() / 2) / GetConVarNumber("Parkour_SpeedDivider")))
		
		ply.PushForce = (math.random(MinForcevalue, MaxForcevalue) + ((ply:GetVelocity():Length() * 2) / GetConVarNumber("Parkour_SpeedDivider")))
		
		if ply.WalljumpCombo >= WallJumpComboMax then return end
		
		if (ply:KeyDown(IN_FORWARD)) then
			local tr = util.QuickTrace(pos, (back * 60), ply);
			if (tr.Hit) then
				if ply.Hanging then
					ply.Hanging = false
					ply:SetMoveType(MOVETYPE_WALK)
				end	
			    ply:ViewPunch(Angle(10, 0, 0));
				local WallFireFix = tr.Entity
				ply.Hanging = false
				WallJumpSound(ply)
				if tr.Entity == WallFireFix and WallFireFix:IsOnFire() then
					tr.Entity:Extinguish()		
				end
				ply:SetLocalVelocity((forward * ply.PushForce) + upforce);
			end
		end
		
		if (ply:KeyDown(IN_BACK)) then
			local tr = util.QuickTrace(pos, (forward * 60), ply);
			if (tr.Hit) then
				if ply.Hanging then
					ply.Hanging = false
					ply:SetMoveType(MOVETYPE_WALK)
				end	
				ply:ViewPunch(Angle(10, 0, 0));
			    local WallFireFix = tr.Entity
				ply.Hanging = false
				WallJumpSound(ply)
				if tr.Entity == WallFireFix and WallFireFix:IsOnFire() then
					tr.Entity:Extinguish()		
				end
				ply:SetLocalVelocity((back * ply.PushForce) + upforce);
			end
		end
		
		if (ply:KeyDown(IN_MOVELEFT)) then
			local tr = util.QuickTrace(pos, (right * 60), ply);
			if (tr.Hit) then
				if ply.Hanging then
					ply.Hanging = false
					ply:SetMoveType(MOVETYPE_WALK)
				end	
				local WallFireFix = tr.Entity
				ply.Hanging = false
				WallJumpSound(ply)
				if tr.Entity == WallFireFix and WallFireFix:IsOnFire() then
					tr.Entity:Extinguish()		
				end
			    if ply:KeyDown(IN_FORWARD) then
					ply:SetLocalVelocity(((left * ply.PushForce) + upforce) + (forward * ply.PushForce));
					ply:ViewPunch(Angle(10, -10, 0));
				elseif !ply:KeyDown(IN_FORWARD) then
					ply:SetLocalVelocity(((left * ply.PushForce) + upforce));
					ply:ViewPunch(Angle(0, -10, 0));
				end
			end
		end
		
		if (ply:KeyDown(IN_MOVERIGHT)) then
			local tr = util.QuickTrace(pos, (left * 60), ply);
			if (tr.Hit) then
				if ply.Hanging then
					ply.Hanging = false
					ply:SetMoveType(MOVETYPE_WALK)
				end	
			    local WallFireFix = tr.Entity
				WallJumpSound(ply)
				if tr.Entity == WallFireFix and WallFireFix:IsOnFire() then
					tr.Entity:Extinguish()		
				end
				if ply:KeyDown(IN_FORWARD) then
					ply:SetLocalVelocity(((right * ply.PushForce) + upforce) + (forward * ply.PushForce));
					ply:ViewPunch(Angle(10, 10, 0));
				elseif !ply:KeyDown(IN_FORWARD) then
					ply:SetLocalVelocity(((right * ply.PushForce) + upforce));
					ply:ViewPunch(Angle(0, 10, 0));
				end
			end
		end
	end
	end
	hook.Add("KeyPress", "DoWallJump", DoWallJump);
	
	function DoRoll( ply, vel )
		if not ply:GetTeamValue("freerun") then return end
		local weapon  = ply:GetActiveWeapon()
		ply.lookangle = ply:GetUp() - ply:GetAimVector()
		ply.lookingdown = false
		if (ply.lookangle.z > 1.7) then 
			ply.lookingdown = true 
		end
		if ply.lookingdown == true and ply:KeyDown(IN_DUCK) then
			if weapon:IsValid() then
				if weapon.Primary == nil then
					weapon:SendWeaponAnim(ACT_VM_HOLSTER)
					local AnimDuration = weapon:SequenceDuration()
					local totime = 0
					if AnimDuration != nil or AnimDuration > 0.1 then
						totime = AnimDuration
					end
					timer.Simple(totime, function()
						ply:DrawViewModel(false)
					end, ply)
				else
					ply:DrawViewModel(false)
				end
			end
			
			ply.Rolling = true
			umsg.Start("ParkourRoll", ply) 
			umsg.End()      
			
			timer.Simple(0.6, function()
				if ply:Alive() then
					if weapon:IsValid() then
						if weapon.Primary == nil then
							weapon:SendWeaponAnim(ACT_VM_DRAW)
							AnimDuration = weapon:SequenceDuration()
							if weapon:IsValid() then
								weapon:SetNextPrimaryFire(CurTime() + 0.3)
							end	
							ply:DrawViewModel(true)
						else
							ply:DrawViewModel(true)
							weapon:Deploy()
						end
					end	
					ply.Rolling = false	
				end
			end, ply)
			if vel > 1000 then
				return vel / 20
			else
				return 0
			end
				
		end	
	end
	hook.Add( "GetFallDamage", "DoRoll", DoRoll )
	
	local function SlowPlayerAnimation(ply, anim)
		ply:SetPlaybackRate(0.1)
	end
	hook.Add("SetPlayerAnimation", "SlowPlayerAnimation", SlowPlayerAnimation)

	local CanLastVel = true
	local CanClimbTime = CurTime()
	local deployed = true
	local holstered = false
	local NextLevel = CurTime()
	local NextClimbSound = CurTime()
	local NextWallRunSound = CurTime()
	local NextSlideEffect = CurTime()
	local NextRollSound = CurTime()
	local PunchCyle = 0
		
	function ParkourThink()
		for k, v in pairs(player.GetAll()) do
			if not v:GetTeamValue("freerun") then continue end
			local pos = v:GetShootPos();
			local up = v:GetUp();
			local down = v:GetUp() * -1;
			local left = (v:GetRight() * -1);
			local right = v:GetRight();
			local forward = v:GetForward();
			local back = (v:GetForward() * -1);
			local weapon = v:GetActiveWeapon()
			local vel = v:GetVelocity()
			local vellen = vel:Length()
			
			if !v:OnGround() and v:KeyDown(IN_USE) and CanClimb(v) then
				if CanLastVel == true then
					CanLastVel = false
					v.LastVel = v:GetVelocity()
					v.CanClimbTime = 1
					CanClimbTime = CurTime() + v.CanClimbTime
				end
				if CanClimbTime >= CurTime() then
					v.Climbing = true
					if weapon:IsValid() then
						weapon:SetNextPrimaryFire(CurTime() + 0.1)
					end	
				elseif v.Climbing and CanClimbTime < CurTime() then
					v.Climbing = false
				end
				if !v:KeyDown(IN_JUMP) then
					v:SetLocalVelocity(down * 150);
				elseif !v.Hanging and v:KeyDown(IN_JUMP) and v.Climbing then
					v:SetLocalVelocity(up * v.LastVel);
					if NextClimbSound <= CurTime() then
						v:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
						NextClimbSound = CurTime() + 0.2
						if PunchCyle == 0 then
							v:ViewPunch(Angle(5, math.random(3,7), 0));
							PunchCyle = 1
						else
							v:ViewPunch(Angle(5, -(math.random(3,7)), 0));
							PunchCyle = 0
						end
					end
				end
			elseif !v:OnGround() and !v:KeyDown(IN_USE) and v.Climbing then
				v.Climbing = false
			end
			
			if v:OnGround() or v:WaterLevel() > 0 or v:GetMoveType() == MOVETYPE_NOCLIP then
				v.Climbing = false
				v.Hanging = false
				CanLastVel = true
				v.ImOnGround = true
				v.WalljumpCombo = 0
				v.WRunning = false
				v.WallRunStep = 0
				v:SetNWBool("ParkourLeanView", false)
				v:SetNWBool("ParkourRightLeanView", false)
				v:SetNWBool("ParkourLeftLeanView", false)
				v:SetNWBool("WallRunning", false)
			else
				v.ImOnGround = false	
			end
			
			if v.WallRunStep == nil then
				v.WallRunStep = 0
			end
			
			if v:KeyDown(IN_FORWARD) and v:KeyDown(IN_JUMP) and v:KeyDown(IN_SPEED) and !v:KeyDown(IN_MOVELEFT) and !v:KeyDown(IN_MOVERIGHT) and CanWallRun(v) and !v.Hanging and !v.Climbing and v.WallRunStep != 4 then
				v.WRunning = true
				v.Climbing = false
				v.Hanging = false
				v.LastVel = vellen
				v:SetMoveType(MOVETYPE_WALK)
				v:SetGravity(0)
				v:SetLocalVelocity(forward * v.LastVel + up * 5)
				v:SetNWBool("WallRunning", true)
				if NextWallRunSound <= CurTime() and vel:Length() > 100 then
					v:EmitSound("physics/cardboard/cardboard_box_impact_hard" .. math.random(1, 7) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
					v.WallRunStep = v.WallRunStep + 1
					NextWallRunSound = CurTime() + 0.2
				end
			elseif v.WRunning and !v:KeyDown(IN_SPEED) or !v:KeyDown(IN_FORWARD) or vellen < 100 or !CanWallRun(v) or v.WallRunStep >= 4 then
				v.WRunning = false
				v:SetGravity(1)
				v:SetNWBool("WallRunning", false)
				v:SetNWBool("ParkourLeanView", false)
				v:SetNWBool("ParkourRightLeanView", false)
				v:SetNWBool("ParkourLeftLeanView", false)
			end
			
			if !v.Hanging and v:KeyDown(IN_USE) and GrabLedge(v) then
				v.Hanging = true
				v:SetMoveType(MOVETYPE_NONE)
				v.HangForward = v:GetForward()
				v.HangLeft = left
				v.HangRight = right
				v:ViewPunch(Angle(-10, 0, 0));
				v:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
			elseif v.Hanging and !v:KeyDown(IN_USE) and v:KeyDown(IN_JUMP) then
				v.Hanging = false
				v:SetMoveType(MOVETYPE_WALK)
				v:SetLocalVelocity(up * 325)
				v:ViewPunch(Angle(10, 0, 0));
				v:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
			end
			
			if v.Hanging and v:KeyDown(IN_MOVELEFT) and !v:KeyDown(IN_MOVERIGHT) and v.HangLeft and LedgeLeft(v, v.HangLeft, v.HangForward) then
				v:SetMoveType(MOVETYPE_WALK)
				v:SetGravity(0)
				v:SetLocalVelocity(v.HangLeft * 100 + up * 5)
				if NextClimbSound <= CurTime() then
					v:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
					NextClimbSound = CurTime() + 0.55
					if PunchCyle == 0 then
						v:ViewPunch(Angle(2, 2, 0));
						PunchCyle = 1
					else
						v:ViewPunch(Angle(2, -2, 0));
						PunchCyle = 0
					end
				end
			elseif v.Hanging and v:KeyReleased(IN_MOVELEFT) then
				v:SetMoveType(MOVETYPE_NONE)
			elseif v.Hanging and v:KeyDown(IN_MOVERIGHT) and !v:KeyDown(IN_MOVELEFT) and v.HangRight and LedgeRight(v, v.HangRight, v.HangForward) then
				v:SetMoveType(MOVETYPE_WALK)
				v:SetGravity(0)
				v:SetLocalVelocity(v.HangRight * 100 + up * 5)
				if NextClimbSound <= CurTime() then
					v:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
					NextClimbSound = CurTime() + 0.55
					if PunchCyle == 0 then
						v:ViewPunch(Angle(2, 2, 0));
						PunchCyle = 1
					else
						v:ViewPunch(Angle(2, -2	, 0));
						PunchCyle = 0
					end
				end
			elseif v.Hanging and v:KeyReleased(IN_MOVERIGHT) then
				v:SetMoveType(MOVETYPE_NONE)
			end
		
			local trF = util.QuickTrace(v:GetPos() + Vector(0,0,15) , (v:GetForward() * 50), v);
			
			if v.Rolling and v:OnGround() then
				v:SetLocalVelocity(forward * 450 )
				if weapon:IsValid() then
					weapon:SetNextPrimaryFire(CurTime() + 0.3)
				end
				if NextRollSound and NextRollSound <= CurTime() and vellen > 0 then
					NextRollSound = CurTime() + 0.2
					if SERVER then
						v:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav", math.Rand(80, 100), math.Rand(90, 120))
					end		
				end	
			end	
			if v.Rolling and trF and trF.Hit then
				v.Rolling = false
				v:SetVelocity(v:GetAimVector(), 0)
				if SERVER then
					v:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav", math.Rand(80, 100), math.Rand(90, 120))
				end
				local shake = ents.Create( "env_shake" )
				shake:SetOwner(v)
				shake:SetPos( trF.HitPos )
				shake:SetKeyValue( "amplitude", "2500" )
				shake:SetKeyValue( "radius", "100" )
				shake:SetKeyValue( "duration", "0.5" )
				shake:SetKeyValue( "frequency", "255" )
				shake:SetKeyValue( "spawnflags", "4" )	
				shake:Spawn()
				shake:Activate()
				shake:Fire( "StartShake", "", 0 )
			end
			
			if v.SlideCond == nil then
				v.SlideCond = false
				v.SlideTime = nil
				v.Sliding = false
				v.SlideLastDir = v:GetForward()
				v.NextSlideEffect = CurTime()
				umsg.Start("SendSlideToClient",v)
					umsg.Bool(false)
				umsg.End()
			end
			
			local trD = util.QuickTrace(v:GetPos(), (v:GetUp() * -1) * 20, v);
			
			if trD.Hit then
				v.CanSlide = true
			else
				v.CanSlide = false
			end
			
			if !v.SlideCond and v:KeyDown(IN_SPEED) and v:KeyDown(IN_DUCK) and v.CanSlide and vellen >= v:GetRunSpeed() then
				if !v.SlideCond then
					if SERVER then
						v:EmitSound("player/slide/slide_start_1.wav", math.Rand(80, 100), math.Rand(90, 120))
					end
				end
				v.SlideCond = true
				v.SlideLastVel = vellen
				v.SlideLastDir = vel:GetNormalized()
				v.SlideTime = CurTime() + math.Clamp(v.SlideLastVel / 800, 0, 2)
			elseif v.SlideCond and v.Sliding and !v:KeyDown(IN_SPEED) or !v:KeyDown(IN_DUCK) or v.Rolling or !v.CanSlide then
				v.SlideCond = false
				v.SlideTime = nil
				v.Sliding = false
			end
			
			if v.SlideCond and v.SlideLastVel > 0 then
				v.Sliding = true
				v.SlideCond = true
				
				if v.SlideTime and v.SlideTime < CurTime() then
					v.SlideLastVel = v.SlideLastVel - FrameTime() * 600
				end	
				
				v:SetLocalVelocity(v.SlideLastDir * v.SlideLastVel)
				
				if v.NextSlideEffect <= CurTime() then
					v.NextSlideEffect = CurTime() + 0.01
					local fx 	= EffectData()
					fx:SetStart(trD.HitPos)
					fx:SetOrigin(trD.HitPos)
					fx:SetNormal(trD.HitNormal)
					util.Effect("slide_effect",fx)
				end	
			elseif v.Sliding and v.SlideLastVel <= 0 or v.Sliding and !v.CanSlide then
				v.SlideTime = nil
				v.Sliding = false
				v.SlideCond1 = false
			end
			
			local trF = util.QuickTrace(v:GetPos() + Vector(0,0,50) , (v.SlideLastDir * 50), v);
			
			if trF and trF.Hit and v.Sliding and v.SlideCond then
				v.SlideTime = nil
				v.Sliding = false
				v.SlideCond = false
		
				v:SetVelocity(v:GetAimVector(), 0)
				if SERVER then
					v:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav", math.Rand(80, 100), math.Rand(90, 120))
				end
				local shake = ents.Create( "env_shake" )
				shake:SetOwner(v)
				shake:SetPos( trF.HitPos )
				shake:SetKeyValue( "amplitude", "2500" )
				shake:SetKeyValue( "radius", "100" )
				shake:SetKeyValue( "duration", "0.5" )
				shake:SetKeyValue( "frequency", "255" )
				shake:SetKeyValue( "spawnflags", "4" )	
				shake:Spawn()
				shake:Activate()
				shake:Fire( "StartShake", "", 0 )
			end	
			
			if v.LastSlide == nil then
				v.LastSlide = false
			end
			
			if v.LastSlide != v.Sliding then
				v.LastSlide = v.Sliding
				umsg.Start("SendSlideToClient",v)
					umsg.Bool(v.Sliding)
				umsg.End()
			end
			
		end
	end
	hook.Add( "Think", "ParkourThink", ParkourThink )
	
end	

function Parkour_Spawn(ply)
    ply.Hanging = false
	ply.WRunning = false
	ply.Climbing = false
    ply.MaxClimbCombo = ply.MaxClimbCombo
	ply.WalljumpCombo = 0
	ply.CanClimbTime = 0
	ply.Rolling = false	
	ply.Sliding = false
	ply:SetNWBool("ParkourRightLeanView", false)
	ply:SetNWBool("ParkourLeftLeanView", false)
	ply:SetNWBool("ParkourLeanView", false)
	ply:SetNWBool("WallRunning", false)
	if SERVER then
		umsg.Start("SendSlideToClient",v)
			umsg.Bool(false)
		umsg.End()
	end
	
end
hook.Add("PlayerSpawn","Parkour_Spawn",Parkour_Spawn)

function Parkour_Remove(ply)
    ply.Hanging = false
	ply.Climbing = false
	ply.WRunning = false
	ply.Rolling = false	
	ply:SetNWBool("ParkourRightLeanView", false)
	ply:SetNWBool("ParkourLeftLeanView", false)
	ply:SetNWBool("ParkourLeanView", false)
	ply:SetNWBool("WallRunning", false)
end
hook.Add("DoPlayerDeath","Parkour_Remove",Parkour_Remove)

function WallJumpSound(ply)
	if SERVER then
		ply:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 6) .. ".wav", math.Rand(90, 110), math.Rand(90, 120))
	end
	WallJumpCombo(ply)
	ply.Hanging = false
end

function WallJumpCombo(ply)
	ply.WalljumpCombo = ply.WalljumpCombo + 1
end

function GrabLedge(ply)
	local trace = {}
	trace.start = ply:GetShootPos() + Vector( 0, 0, 20 )
	trace.endpos = trace.start + (ply:GetAimVector():Angle():Forward( ) * 20)
	trace.filter = ply

	local trHi = util.TraceLine(trace)
	
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + (ply:GetAimVector():Angle():Forward( ) * 20)
	trace.filter = ply

	local trLo = util.TraceLine(trace)
	
	if trLo and trLo.Hit and !trHi.Hit and  ply.ImOnGround == false then
		return true
	else 
		return false
	end
	
	return false
end

function LedgeLeft(ply, hangleft, hangforward)
	local Start = ply:GetShootPos() - Vector(0,0,10)
	local trace = {}
	trace.start = Start
	trace.endpos = trace.start + (ply:GetAimVector():Angle():Forward( ) * 20)
	trace.filter = ply

	local trLo = util.TraceLine(trace)
	
	local trace = {}
	trace.start = Start
	trace.endpos = trace.start + (hangleft * 30 + hangforward * 20)
	trace.filter = ply

	local trLe = util.TraceLine(trace)
	
	if trLo and trLe and trLe.Hit and trLo.Hit and  ply.ImOnGround == false then
		return true
	else 
		return false
	end
	
	return false
end

function LedgeRight(ply, hangright, hangforward)
	local Start = ply:GetShootPos() - Vector(0,0,10)
	local trace = {}
	trace.start = Start
	trace.endpos = trace.start + (ply:GetAimVector():Angle():Forward( ) * 20)
	trace.filter = ply

	local trLo = util.TraceLine(trace)
	
	local trace = {}
	trace.start = Start
	trace.endpos = trace.start + (hangright * 30 + hangforward * 20 )
	trace.filter = ply

	local trRi = util.TraceLine(trace)
	
	if trLo and trRi and trRi.Hit and trLo.Hit and  ply.ImOnGround == false then
		return true
	else 
		return false
	end
	
	return false
end

function CanClimb(ply)

	local trF = util.QuickTrace(ply:GetPos() + Vector( 0, 0, 50 ), (ply:GetAimVector() * 30), ply);
	
	if trF and trF.Hit and !ply:OnGround() then
		return true
	else 
		return false
	end
	
	return false
end

function CanSlide(ply) -- test
	
	local Down = ply:GetUp() * -1
	
	local tr1 = util.QuickTrace(ply:GetPos(), (Down * 10), ply);
	local tr2 = util.QuickTrace(ply:GetPos() + Vector( 50, 0, 0 ), (Down * 10), ply);
	
	if tr1 and tr2 and tr1.Hit and !tr2.Hit then
		return true
	else 
		return false
	end
	
	return false
end

function SlideDire(ply) -- test
	
	local Down = ply:GetUp() * -1
	
	local tr1 = util.QuickTrace(ply:GetPos(), (Down * 50), ply);
	local tr2 = util.QuickTrace(ply:GetPos() + ply:GetForward(), (Down * 100), ply);
	
	if tr1 and tr2 and tr1.Hit and tr2.Hit then
		local dir = tr1.HitPos - tr2.HitPos
		return dir
	else
		return ply:GetForward()
	end
end

function NearWall(ply)

	local trF = util.QuickTrace(ply:GetPos() + Vector( 0, 0, 50 ), (ply:GetAimVector() * 25), ply);
	local trR = util.QuickTrace(ply:GetPos() + Vector( 0, 0, 50 ), (ply:GetAimVector():Angle():Right( ) * 50), ply);
	local trL = util.QuickTrace(ply:GetPos() + Vector( 0, 0, 50 ), (ply:GetAimVector():Angle():Right() * -1) * 50, ply);
	
	if trF and trR and trL and (trF.Hit or trR.Hit or trL.Hit) then
		return true, trF.Hit, trR.Hit, trL.Hit
	else 
		return false
	end
	
	return false
end

function CanWallRun(ply)
	
	local trace = {}
	trace.start = ply:GetPos()
	trace.endpos = trace.start + Vector(0,0,-9999999)
	trace.filter = ply
	local trD = util.TraceLine( trace )
	local dist = trD.HitPos:Distance(ply:GetPos())
	
	local trR = util.QuickTrace(ply:GetPos() + Vector( 0, 0, 50 ), (ply:GetAimVector():Angle():Right( ) * 50), ply);
	local trF = util.QuickTrace(ply:GetPos(), (ply:GetAimVector() * 50), ply);
	local trL = util.QuickTrace(ply:GetPos() + Vector( 0, 0, 50 ), (ply:GetAimVector():Angle():Right() * -1) * 50, ply);
	
	if trR and trL and trD and trF and ( !trF.Hit and trR.Hit or trL.Hit) and ply:GetMoveType() != MOVETYPE_NOCLIP and dist > 150 then
		
		
		if ply.WRunning and ( trR.Hit and !trL.Hit ) then
			ply:SetNWBool("ParkourLeanView", true)
			ply:SetNWBool("ParkourRightLeanView", true)
			ply:SetNWBool("ParkourLeftLeanView", false)
		elseif ply.WRunning and ( !trR.Hit and trL.Hit ) then
			ply:SetNWBool("ParkourLeanView", true)
			ply:SetNWBool("ParkourRightLeanView", false)
			ply:SetNWBool("ParkourLeftLeanView", true)
		end	
		
		return true
		
	else 
		return false
	end
	return false
end