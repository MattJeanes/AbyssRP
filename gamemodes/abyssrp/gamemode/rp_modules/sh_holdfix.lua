if SERVER then
	local WeaponMeta = FindMetaTable("Weapon")
	local WeaponMeta = FindMetaTable("Entity")
	oldsetholdtype = oldsetholdtype or WeaponMeta.SetWeaponHoldType
	function WeaponMeta:SetWeaponHoldType(type)
		if !type then return end
		if type == self.oldholdtype then
			self.sametype = self.sametype or 0
			self.sametype = self.sametype + 1
		else
			self.sametype = 0
		end
		if self.sametype >= 3 then return end
		oldsetholdtype = oldsetholdtype or WeaponMeta.SetWeaponHoldType
		umsg.Start"WeaponHoldTypeFix"
		umsg.Short(EntityMeta.EntIndex(self))
		umsg.String(type)
		umsg.End()
		oldsetholdtype(type)
		self.oldholdtype = type
	end
else
	usermessage.Hook("WeaponHoldTypeFix", function(umsg)
		local ent = Entity(umsg:ReadShort())
		if ent.SetWeaponHoldType then
		ent:SetWeaponHoldType(umsg:ReadString())
		end
	end)
end
