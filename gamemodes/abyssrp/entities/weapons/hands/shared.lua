SWEP.Author = "Dr. Matt"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.HoldType = "normal"
SWEP.Category = ""

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
end

function SWEP:Reload()
end

function SWEP:Deploy()	
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end 