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

function RP:NoDropWeapons()
	return NoDropWeapons
end

local function PlayerDropWeapon( ply, attacker, dmginfo )
	if GetConVarNumber("rp_dropweapon") == 1 and not ply.RP_Jailed then
		local wep=ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() then
			for k,v in pairs(NoDropWeapons) do
				if wep:GetClass() == v then
					return
				end
			end
		end
		
		if IsValid(wep) then
			if CPPI then
				wep:CPPISetOwner(ply)
			end
			wep.Owner = ply
			ply:DropWeapon(wep)
		end
	end
end
hook.Add("DoPlayerDeath", "DropWeapons", PlayerDropWeapon)