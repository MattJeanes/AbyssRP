include('shared.lua')

SWEP.PrintName			= "7.62MM AK-47"					// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_rp_ak47.vmt", "GAME")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_rp_ak47")
end