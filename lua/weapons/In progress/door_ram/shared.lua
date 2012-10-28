if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName = "Battering Ram"
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
SWEP.Base = "weapon_cs_base2"

SWEP.Author = "Rickster"
SWEP.Instructions = "Left click to break open doors/unfreeze props or get people out of their vehicles."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_rpg.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")
SWEP.AnimPrefix = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self.LastIron = CurTime()
	self:SetWeaponHoldType("normal")
	self.Ready = false
end

function SWEP:Deploy()
	self.Ready = false
end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if (CLIENT) then return end

	if not self.Ready then return end

	local trace = self.Owner:GetEyeTrace()

	self.Weapon:SetNextPrimaryFire(CurTime() + 2.5)
	if (not IsValid(trace.Entity) or (not trace.Entity:IsDoor() and not trace.Entity:IsVehicle() and trace.Entity:GetClass() ~= "prop_physics")) then
		return
	end

	if (trace.Entity:IsDoor() and self.Owner:EyePos():Distance(trace.HitPos) > 45) then
		return
	end

	if (trace.Entity:IsVehicle() and self.Owner:EyePos():Distance(trace.HitPos) > 100) then
		return
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Sound)
	
	
	local a = GetConVarNumber("copscanunfreeze") == 1
	local d = GetConVarNumber("copscanunweld") == 1
	local b = trace.Entity:GetClass() == "prop_physics"
	local c = true
	if trace.Entity.Owner then
		c = trace.Entity.Owner.warranted or (trace.Entity.Owner.DarkRPVars and trace.Entity.Owner.DarkRPVars.wanted)
	end
	if (trace.Entity:IsDoor()) then
		local allowed = false
		local team = self.Owner:Team()
		-- if we need a warrant to get in
		if GetConVarNumber("doorwarrants") == 1 and trace.Entity:IsOwned() and not trace.Entity:OwnedBy(self.Owner) then
			-- if anyone who owns this door has a warrant for their arrest
			-- allow the police to smash the door in
			for k, v in pairs(player.GetAll()) do
				if trace.Entity:OwnedBy(v) and v.warranted == true then
					allowed = true
					break
				end
			end
		else
			-- rp_doorwarrants 0, allow warrantless entry
			allowed = true
		end
		
		if GetConVarNumber("doorwarrants") == 1 and trace.Entity.DoorData.GroupOwn and RPExtraTeamDoors[trace.Entity.DoorData.GroupOwn] then -- Be able to open the door if anyone is warranted
			allowed = false
			for k,v in pairs(player.GetAll()) do
				if table.HasValue(RPExtraTeamDoors[trace.Entity.DoorData.GroupOwn], v:Team()) and v.warranted then
					allowed = true
					break
				end
			end
		end
		-- Do we have a warrant for this player?
		if allowed then
			trace.Entity:Fire("unlock", "", .5)
			trace.Entity:Fire("open", "", .6)
			trace.Entity:Fire("setanimation", "open", .6)
		else
			Notify(self.Owner, 1, 5, "You need a warrant in order to be able to unlock this door.")
		end
	elseif (trace.Entity:IsVehicle()) then
		trace.Entity:Fire("unlock", "", .5)
		local driver = trace.Entity:GetDriver()
		if driver and driver.ExitVehicle then
			driver:ExitVehicle()
		end
	elseif a and b and (not trace.Entity:GetPhysicsObject():IsMoveable() or trace.Entity.isFadingDoor) and self.Owner:EyePos():Distance(trace.HitPos) < 100 then
		if c then
			if trace.Entity.isFadingDoor and trace.Entity.fadeActivate then
				if not trace.Entity.fadeActive then
					trace.Entity:fadeActivate()
					timer.Simple(5, function() if trace.Entity.fadeActive then trace.Entity:fadeDeactivate() end end)
				end
			else
				trace.Entity:GetPhysicsObject( ):EnableMotion( true ) 
			end
		else
			local FadingProp = (trace.Entity.isFadingDoor and "open fading door.") or "unfreeze this prop"
			Notify(self.Owner, 1, 5,"You need a warrant in order to be able to "..FadingProp)
		end
	end
	if d and b and self.Owner:EyePos():Distance(trace.HitPos) < 100 then
		if c then
			constraint.RemoveConstraints( trace.Entity, "Weld" )
		else 
			Notify(self.Owner, 1, 5,"You need a warrant in order to be able to unweld this prop.")
		end
	end
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end

function SWEP:SecondaryAttack()
	self.LastIron = CurTime()
	self.Ready = not self.Ready
	if self.Ready then
		self:SetWeaponHoldType("rpg")
	else
		self:SetWeaponHoldType("normal")
	end
end

function SWEP:GetViewModelPosition(pos, ang)
	local Mul = 1
	if self.LastIron > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - self.LastIron) / 0.25, 0, 1)
	end

	if self.Ready then
		Mul = 1-Mul
	end

	ang:RotateAroundAxis(ang:Right(), - 15 * Mul)
	return pos,ang
end