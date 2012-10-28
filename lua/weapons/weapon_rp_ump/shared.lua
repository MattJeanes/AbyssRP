// Variables that are used on both client and server

SWEP.Base 				= "weapon_rp_base"

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil		= 0.5
SWEP.Primary.Damage		= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.019
SWEP.Primary.Delay 		= 0.09

SWEP.Primary.ClipSize		= 25					// Size of a clip
SWEP.Primary.DefaultClip	= 25					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ".45MM"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_rp_shell_pistol"	// "effect_rp_shell_pistol" or "effect_rp_shell_rifle" or "effect_rp_shell_shotgun"

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector(7.31, -2, 3.285)
SWEP.IronSightsAng 		= Vector(-1.4, .245, 2)
SWEP.RunArmOffset 		= Vector (-2.6657, 0, 2.5)
SWEP.RunArmAngle 			= Vector (-20.0824, -20.5693, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/ump45/ump45-1.wav")
end