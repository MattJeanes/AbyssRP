AddCSLuaFile()

local NoDropWeapons = {
	"weapon_physcannon",
	"weapon_physgun",
	"weapon_keys",
	"gmod_tool",
	"gmod_camera",
	"arrest_stick",
	"weapon_taser",
	"med_kit",
	"weapon_archercrossbow",
	"climb_swepnogrip",
	"weapon_lockpick",
	"weapon_pickpocket",
	"hands",
	"weapon_rape"
}

local function PlayerDropWeapon( ply, attacker, dmginfo )
	if GetConVarNumber("rp_dropweapon") == 1 and not ply.RP_Jailed then
		if NoDropWeapons and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() then
			for k,v in pairs(NoDropWeapons) do
				if ply:GetActiveWeapon():GetClass() == v then
					return
				end
			end
		end
		if ply:GetActiveWeapon() then
			ply:GetActiveWeapon().TheOwner = ply
			ply:DropWeapon(ply:GetActiveWeapon())
		end
	end
end

hook.Add("DoPlayerDeath", "DropWeapons", PlayerDropWeapon)

function RP:GetNoDropWeapons()
	return NoDropWeapons
end