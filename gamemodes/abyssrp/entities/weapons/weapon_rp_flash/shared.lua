// Variables that are used on both client and server

SWEP.Base 				= "weapon_rp_grenade"

SWEP.ViewModelFlip		= true
SWEP.ViewModel 			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel 			= "models/weapons/w_eq_flashbang.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 1.5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_rp_shell_pistol" or "effect_rp_shell_rifle" or "effect_rp_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.Primed 			= 0
SWEP.Throw 				= CurTime()

SWEP.GrenadeType			= "ent_rp_flash"
SWEP.GrenadeName			= "weapon_rp_flash"
SWEP.GrenadeTime			= "3"
SWEP.CookGrenade			= false