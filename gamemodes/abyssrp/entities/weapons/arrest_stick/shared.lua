if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Arrest/Unarrest Baton"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Base = "weapon_cs_base2"

SWEP.Author = "Dr. Matt, Rick Darkaliono, philxyz"
SWEP.Instructions = "Left click to arrest, right click to unarrest"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.NextStrike = 0

SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Holster()
	if CLIENT then return end
	return true
end

function SWEP:PrimaryAttack()
	if CurTime() < self.NextStrike then return end
	
	self:SetWeaponHoldType("melee")
	timer.Simple(0.3, function() self:SetWeaponHoldType("normal") end)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4
	
	if CLIENT then return end
	
	local trace = self.Owner:GetEyeTrace()
	local jpc = RP.jailPosCount
	
	if (trace.Entity:GetClass() == "prop_ragdoll") and
	(trace.Entity.taseredply.Wanted) and
	(self.Owner:EyePos():Distance(trace.Entity:GetPos()) < 115) then
		taserevive(trace.Entity)
		trace.Entity:Remove()
	end
	
	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and (trace.Entity:Team() == RP:GetTeamN("officer")) then
		RP:Error(self.Owner, RP.colors.white, "You can not arrest other CPs!")
		return
	end
		
	if not IsValid(trace.Entity) or (self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 115) or (not trace.Entity:IsPlayer() and not trace.Entity:IsNPC()) or (not trace.Entity:IsPlayer() and not trace.Entity.Tased) then
		return
	end
	
	if not tobool(GetConVarNumber("npcarrest")) and trace.Entity:IsNPC() then
		return
	end
	
	if ( trace.Entity.RP_Jailed ) then
		RP:Notify(trace.Entity, RP.colors.white, "You have been moved back to your cell!")
		RP:Notify(self.Owner, RP.colors.blue, trace.Entity:Nick(), RP.colors.white, " was moved back to their cell!")
		if JailSupport then
			trace.Entity:SetPos(trace.Entity.JailPos)
		else
			trace.Entity:SetPos(RP.jailPos)
		end
		
		return
	end
	
	if not ( trace.Entity.Wanted ) then
		RP:Error(self.Owner, RP.colors.blue, trace.Entity:Nick(), RP.colors.white, " is not wanted by police!")
		return
	end

	/*
	if GetConVarNumber("needwantedforarrest") == 1 and not trace.Entity:IsNPC() and not trace.Entity.DarkRPVars.wanted then
		Notify(self.Owner, 1, 5, "The player must be wanted in order to be able to arrest them.")
		return
	end
	*/
	
	local jpc = RP.jailPosCount
	local jailtime = GetConVarNumber("rp_jailtime")
	
	if (#RP.JailPoses==0 and not jpc) then
		RP:Error(self.Owner, RP.colors.white, "No jail positions set!")
	else
		-- Send NPCs to Jail
		if trace.Entity:IsNPC() then
			if RP.JailPoses > 0 then
				i = math.random(1,#RP.JailPoses)
				trace.Entity:SetPos(RP.JailPoses[i])
			else
				trace.Entity:SetPos(RP.jailPos)
			end
		else
			RP:ArrestPlayer(trace.Entity, self.Owner)
			timer.Create("JailTimer-"..trace.Entity:SteamID(), jailtime, 1, function()
				RP:UnarrestPlayer(trace.Entity)
			end)
		end
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self.NextStrike then return end
	
	
	self:SetWeaponHoldType("melee")
	timer.Simple(0.3, function() self:SetWeaponHoldType("normal") end)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	if CLIENT then return end
	
	local trace = self.Owner:GetEyeTrace()

	if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() or (self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 115) then
		return
	end
	
	if not ( trace.Entity.RP_Jailed ) then
		RP:Error(self.Owner, RP.colors.blue, trace.Entity:Nick(), RP.colors.white, " has not been arrested!")
		return
	end
	
	if timer.Exists("JailTimer-"..trace.Entity:SteamID()) then
		timer.Destroy("JailTimer-"..trace.Entity:SteamID())
	end
	
	RP:UnarrestPlayer(trace.Entity)
	
end
