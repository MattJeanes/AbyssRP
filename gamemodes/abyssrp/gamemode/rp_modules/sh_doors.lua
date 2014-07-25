local ent = FindMetaTable( "Entity" )

function ent:IsOwnable()
	if not IsValid(self) then return false end
	local class = self:GetClass()

	if ((class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating") or
			(tobool(GetConVarNumber("rp_allowvehicleowning")) and self:IsVehicle()) or self.Ownable) then
			return true
		end
	return false
end

function ent:IsDoor()
class = tostring(self:GetClass())
	if (class == "func_door") or
		(class == "func_door_rotating") or
		(class == "prop_door_rotating") or
		(class == "prop_dynamic") then
		return true
	else
		return false
	end
end

function ent:AllowedToOwn(ply)
	if ent.Ownable then
		return true
	end
	return false
end

function ent:GetDoorOwner()
	if not IsValid(self) then return end
	return self.Owner
end


function ent:OwnedBy(ply)
	if ply == self:GetDoorOwner() then
		return true
	else
		return false
	end
end

function ent:Owned()
	if self:GetNWBool("Owned") then
		return true
	else
		return false
	end
end