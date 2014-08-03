-- Drop weapon

RP:AddSetting("dropweapon",true)

RP:AddSetting("dropweaponblacklist",{
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
	"weapon_climb",
	"weapon_stunstick"
})

function RP:PlayerDropWeapon( ply )
	if RP:GetSetting("dropweapon") and not ply.RP_Jailed then
		local wep=ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() then
			for k,v in pairs(RP:GetSetting("dropweaponblacklist")) do
				if wep:GetClass() == v then
					return false
				end
			end
		end
		
		if IsValid(wep) then
			if CPPI then
				wep:CPPISetOwner(ply)
			end
			wep.OldOwner = ply
			ply:DropWeapon(wep)
			return true
		end
		return false
	end
	return false
end
hook.Add("DoPlayerDeath", "DropWeapons", function(ply)
	RP:PlayerDropWeapon(ply)
end)