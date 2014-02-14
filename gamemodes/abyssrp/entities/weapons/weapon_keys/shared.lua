if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Keys"
	SWEP.Slot = 5
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Dr. Matt and others"
SWEP.Instructions = "Left click to lock. Right click to unlock"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	local trace = self.Owner:GetEyeTraceNoCursor()
	
	if CLIENT then return end
	
	if not IsValid(trace.Entity) or (trace.Entity:IsDoor() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 65) or (trace.Entity:IsVehicle() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 100) then
		return
	end
	
	if tobool(trace.Entity.OwnedByTeam) then
		for i=1,#trace.Entity.OwnedByTeam do
			if (trace.Entity.OwnedByTeam[i] == tonumber(self.Owner:Team())) then
				trace.Entity:Fire( "lock", "", 0 );
				self.Owner:EmitSound( self.Sound );
				self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
			end
		end
	
	elseif (trace.Entity.TheOwner and trace.Entity.TheOwner == self.Owner) or (((self.Owner:Team() == RP:GetTeamN("officer")) or (self.Owner:Team() == RP:GetTeamN("mayor"))) and trace.Entity.TheOwner and trace.Entity.TheOwner.Warranted) then
		trace.Entity:Fire( "lock", "", 0 );
		self.Owner:EmitSound( self.Sound );
		self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
		
		
	else
		
		self.Owner:EmitSound("physics/wood/wood_crate_impact_hard2.wav", 100, math.random(90, 110))
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		
	end
		
end

function SWEP:SecondaryAttack()
	local trace = self.Owner:GetEyeTraceNoCursor()
	
	if CLIENT then return end
	
	if not IsValid(trace.Entity) or (trace.Entity:IsDoor() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 65) or (trace.Entity:IsVehicle() and self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 100) then
		return
	end
	
	if tobool(trace.Entity.OwnedByTeam) then
		for i=1,#trace.Entity.OwnedByTeam do
			if (trace.Entity.OwnedByTeam[i] == tonumber(self.Owner:Team())) then
				trace.Entity:Fire( "unlock", "", 0 );
				self.Owner:EmitSound( self.Sound );
				self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
			end
		end
	
	elseif (trace.Entity.TheOwner and trace.Entity.TheOwner == self.Owner) or (((self.Owner:Team() == RP:GetTeamN("officer")) or (self.Owner:Team() == RP:GetTeamN("mayor"))) and trace.Entity.TheOwner and trace.Entity.TheOwner.Warranted) then
		trace.Entity:Fire( "unlock", "", 0 );
		self.Owner:EmitSound( self.Sound );
		self.Weapon:SetNextSecondaryFire(CurTime() + 1.0)
	
	else
		
		self.Owner:EmitSound("physics/wood/wood_crate_impact_hard2.wav", 100, math.random(90, 110))
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
		
	end
		
end

SWEP.OnceReload = false
function SWEP:Reload()
	if not self.OnceReload then
		if SERVER then
			self.OnceReload = true
			timer.Simple(3, function() self.OnceReload = false end)
			
			local trace = self.Owner:GetEyeTraceNoCursor()
			local ent = trace.Entity
			local doorcost = GetConVarNumber("rp_doorcost")
			local sellpercent = GetConVarNumber("rp_sellpercent")
			local sellprice = (tonumber(doorcost) * tonumber(sellpercent))
			
			if not IsValid(ent) or (not string.find(ent:GetClass(), "door") and not string.find(ent:GetClass(), "vehicle")) or ent:GetPos():Distance(self.Owner:GetPos()) > 200 then
				RP:Error(self.Owner, RP.colors.white, "You need to be looking at a door/vehicle!")
				return
			end
			
			if ent:Owned() and ent.TheOwner == self.Owner and ent:IsDoor() then
				ent.TheOwner = nil
				RP:Notify(self.Owner, RP.colors.white, "You sold your door for: ", RP.colors.blue, "$" .. tostring(sellprice))
				ent:SetNWBool("Owned", false)
				ent.Ownable = true
				ent:Fire( "close", "", 0 )
				ent:Fire( "lock", "", 0 )
				self.Owner:AddCash(sellprice)
			
			elseif ent:Owned() and IsValid(ent.TheOwner) and ent.TheOwner != self.Owner and ent:IsDoor() then
				RP:Error(self.Owner, RP.colors.white, "This door is owned by: ", RP.colors.blue, ent.TheOwner:Nick(), RP.colors.white, "!")
			
			elseif not ent:Owned() and ent.Ownable and (tonumber(self.Owner:GetPData("cash")) - doorcost > -1) and ent:IsDoor() then
				RP:Notify(self.Owner, RP.colors.white, "You have bought this door for: ", RP.colors.blue, "$" .. tostring(doorcost))
				ent.Ownable = false
				ent:SetNWBool("Owned", true)
				ent:Fire( "unlock", "", 0 )
				ent:Fire( "open", "", 0 )
				ent.TheOwner = self.Owner
				self.Owner:TakeCash(doorcost)
				
			elseif ent:IsVehicle() and ent.TheOwner == self.Owner then
				local vehiclecost = ent.Cost
				local sellprice2 = (tonumber(vehiclecost) * tonumber(sellpercent))
				RP:Notify(self.Owner, RP.colors.white, "You sold your vehicle for: ", RP.colors.blue, "$" .. tostring(sellprice2))
				ent:Remove()
				self.Owner:AddCash(sellprice2)
			
			elseif ent:IsVehicle() and ent.TheOwner and ent.TheOwner != self.Owner then
			RP:Error(self.Owner, RP.colors.white, "Vehicle owned by: ", RP.colors.blue, ent.TheOwner:Nick(), RP.colors.white, ". Ask them to buy it!")
			
			elseif tobool(ent.OwnedByTeam) and ent:IsDoor() then
				RP:Error(self.Owner, RP.colors.white, "This door belongs to the ", RP.colors.blue, string.lower(team.GetName(ent.OwnedByTeam[1])) .. "s", RP.colors.white, "!")
			
			elseif (ent.Ownable == false and ent.TheOwner == nil) and ent:IsDoor() then
				RP:Error(self.Owner, RP.colors.white, "You cannot own this door!")
				
			elseif (ent.Ownable == false and ent.TheOwner == nil) and ent:IsVehicle() then
				RP:Error(self.Owner, RP.colors.white, "You cannot own this vehicle!")
			
			else
				RP:Error(self.Owner, RP.colors.white, "You don't have enough cash!")
			end
			
			hook.Add("ShowTeam", "Own a door", function()
				self:Reload()
			end)
		end
	end
end
