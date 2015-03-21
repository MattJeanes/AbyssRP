if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Arrest/Unarrest Baton"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Base = "weapon_base"

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
	self:SetHoldType("normal")
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
	
	local trace = self.Owner:GetEyeTraceNoCursor()
	local ent = trace.Entity
	
	if (ent:GetClass() == "prop_ragdoll") and
	(ent.taseredply.RP_Wanted) and
	(self.Owner:EyePos():Distance(ent:GetPos()) < 115) then
		taserevive(ent)
		ent:Remove()
	end
		
	if not IsValid(ent) or (self.Owner:EyePos():Distance(ent:GetPos()) > 115) or (not ent:IsPlayer() and not ent:IsNPC()) or (not ent:IsPlayer() and not ent.Tased) then
		return
	end
	
	if not tobool(GetConVarNumber("npcarrest")) and ent:IsNPC() then
		return
	end
	
	if ( ent.RP_Jailed ) then
		RP:Notify(ent, RP.colors.white, "You have been moved back to your cell.")
		RP:Notify(self.Owner, RP.colors.blue, ent:Nick(), RP.colors.white, " was moved back to their cell.")
		ent:SetPos(ent.JailPos)
		return
	end
	
	if not ( ent.RP_Wanted ) then
		RP:Error(self.Owner, RP.colors.blue, ent:Nick(), RP.colors.white, " is not wanted by police!")
		return
	end
	
	if (#RP.JailPoses==0) then
		RP:Error(self.Owner, RP.colors.white, "No jail positions set!")
	else
		-- Send NPCs to Jail
		if ent:IsNPC() then
			if RP.JailPoses > 0 then
				ent:SetPos(table.Random(RP.JailPoses))
			else
				ent:SetPos(RP.JailPos)
			end
		else
			local success=ent:Arrest()
			if success then
				local jailtime = RP:GetSetting("jailtime")	
				RP:Notify(RP.colors.blue, ent:Nick(), RP.colors.white, " has been arrested!")
				RP:Notify(ent, RP.colors.white, "You've been arrested by ", RP.colors.blue, self.Owner:Nick())
				RP:Notify(self.Owner, RP.colors.white, "You've arrested: ", RP.colors.blue, ent:Nick(), RP.colors.white, "!")
				RP:Notify(ent, RP.colors.white, "You will be released in: ", RP.colors.blue, tostring(jailtime), RP.colors.white, " seconds.")
				
				timer.Create("JailTimer-"..ent:SteamID(), jailtime, 1, function()
					if IsValid(ent) then
						ent:Unarrest()
					end
				end)
			else
				RP:Error(self.Owner, RP.colors.white, "Failed to arrest ", RP.colors.red, ent:Nick(), RP.colors.white, ".")
			end
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
	
	local trace = self.Owner:GetEyeTraceNoCursor()
	local ent = trace.Entity

	if not IsValid(ent) or not ent:IsPlayer() or (self.Owner:EyePos():Distance(ent:GetPos()) > 115) then
		return
	end
	
	if not ( ent.RP_Jailed ) then
		RP:Error(self.Owner, RP.colors.blue, ent:Nick(), RP.colors.white, " has not been arrested!")
		return
	end
	
	local success=ent:Unarrest()
	if success then
		RP:Notify(ent, RP.colors.white, "You have been released!")
		RP:Notify(RP.colors.blue, ent:Nick(), RP.colors.white, " has been released!")
	else
		RP:Error(self.Owner, RP.colors.white, "Failed to unarrest ", RP.colors.red, ent:Nick(), RP.colors.white, ".")
	end
end
