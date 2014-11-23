AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function SWEP:Lock(e,nomsg)
	e:Fire( "lock", "", 0 );
	self.Owner:EmitSound( self.Sound );
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1.0)
	if not nomsg then
		self.Owner:ChatPrint("Locked.")
	end
end

function SWEP:Unlock(e,nomsg)
	e:Fire( "unlock", "", 0 );
	self.Owner:EmitSound( self.Sound );
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1.0)
	if not nomsg then
		self.Owner:ChatPrint("Unlocked.")
	end
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
end

function SWEP:PrimaryAttack()
	local trace = self.Owner:GetEyeTraceNoCursor()
	
	if not IsValid(trace.Entity) or (trace.Entity:IsDoor() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 65) or (trace.Entity:IsVehicle() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 100) then
		return
	end
	
	if trace.Entity.PoliceOwned then
		if self.Owner:GetTeamValue("police") then
			self:Lock(trace.Entity)
		end
	elseif (trace.Entity.Owner and trace.Entity.Owner == self.Owner) or (((self.Owner:Team() == RP:GetTeamN("officer")) or (self.Owner:Team() == RP:GetTeamN("mayor"))) and trace.Entity.Owner and trace.Entity.Owner.Warranted) then
		self:Lock(trace.Entity)
	else
		self.Owner:EmitSound("physics/wood/wood_crate_impact_hard2.wav", 100, math.random(90, 110))
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	end
end

function SWEP:SecondaryAttack()
	local trace = self.Owner:GetEyeTraceNoCursor()
	
	if not IsValid(trace.Entity) or (trace.Entity:IsDoor() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 65) or (trace.Entity:IsVehicle() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 100) then
		return
	end
	
	if trace.Entity.PoliceOwned then
		if self.Owner:GetTeamValue("police") then
			self:Unlock(trace.Entity)
		end
	elseif (trace.Entity.Owner and trace.Entity.Owner == self.Owner) or (((self.Owner:Team() == RP:GetTeamN("officer")) or (self.Owner:Team() == RP:GetTeamN("mayor"))) and trace.Entity.Owner and trace.Entity.Owner.Warranted) then
		self:Unlock(trace.Entity)
	else
		self.Owner:EmitSound("physics/wood/wood_crate_impact_hard2.wav", 100, math.random(90, 110))
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
	end	
end

SWEP.OnceReload = false
function SWEP:Reload()
	if self.OnceReload then
		return
	end
	self.OnceReload = true
	timer.Simple(1, function()
		if IsValid(self) then
			self.OnceReload = false
		end
	end)
	
	local trace = self.Owner:GetEyeTraceNoCursor()
	local ent = trace.Entity
	local doorcost = RP:GetSetting("doorcost")
	local sellpercent = RP:GetSetting("sellpercent")
	local sellprice = (tonumber(doorcost) * tonumber(sellpercent))
	
	if not IsValid(ent) or (not string.find(ent:GetClass(), "door") and not string.find(ent:GetClass(), "vehicle")) or ent:GetPos():Distance(self.Owner:GetPos()) > 200 then
		RP:Error(self.Owner, RP.colors.white, "You need to be looking at a door/vehicle!")
		return
	end
	
	print(ent.Owner)
	
	if ent:Owned() and ent.Owner == self.Owner and ent:IsDoor() then
		ent.Owner = nil
		RP:Notify(self.Owner, RP.colors.white, "You sold your door for: ", RP.colors.blue, RP:CC(sellprice))
		ent:SetNWBool("Owned", false)
		ent.Ownable = true
		ent:Fire( "close", "", 0 )
		self:Lock(ent,true)
		self.Owner:AddCash(sellprice)
	elseif ent:Owned() and IsValid(ent.Owner) and ent.Owner != self.Owner and ent:IsDoor() then
		RP:Error(self.Owner, RP.colors.white, "This door is owned by: ", RP.colors.blue, ent.Owner:Nick(), RP.colors.white, "!")
	elseif not ent:Owned() and ent.Ownable and ent:IsDoor() then
		if (self.Owner:GetCash() - doorcost) > -1 then
			RP:Notify(self.Owner, RP.colors.white, "You have bought this door for: ", RP.colors.blue, RP:CC(doorcost))
			ent.Ownable = false
			ent:SetNWBool("Owned", true)
			self:Unlock(ent,true)
			ent:Fire( "open", "", 0 )
			ent.Owner = self.Owner
			self.Owner:TakeCash(doorcost)
		else
			RP:Error(self.Owner, RP.colors.white, "You don't have enough cash!")
		end
	elseif ent:IsVehicle() and ent.Owner == self.Owner then
		local vehiclecost = ent.Cost
		local sellprice2 = (tonumber(vehiclecost) * tonumber(sellpercent))
		RP:Notify(self.Owner, RP.colors.white, "You sold your vehicle for: ", RP.colors.blue, RP:CC(sellprice2))
		ent:Remove()
		self.Owner:AddCash(sellprice2)
	elseif ent:IsVehicle() and IsValid(ent.Owner) and ent.Owner != self.Owner then
		RP:Error(self.Owner, RP.colors.white, "Vehicle owned by: ", RP.colors.blue, ent.Owner:Nick(), RP.colors.white, ". Ask them to buy it!")
	elseif ent.PoliceOwned and ent:IsDoor() then
		RP:Error(self.Owner, RP.colors.white, "This door belongs to the ", RP.colors.blue, "police", RP.colors.white, "!")
	elseif (ent.Ownable == false and not IsValid(ent.Owner)) and ent:IsDoor() then
		RP:Error(self.Owner, RP.colors.white, "You cannot own this door!")
	elseif not ent.Ownable and not IsValid(ent.Owner) and ent:IsVehicle() then
		RP:Error(self.Owner, RP.colors.white, "You cannot own this vehicle!")
	end
end