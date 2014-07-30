if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Pickpocket"
	SWEP.Slot = 1
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server

SWEP.Author = "Dr. Matt/Rickster"
SWEP.Instructions = "Go behind a player and press Mouse1 to begin."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = -1     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false        -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""
SWEP.PickPocketTime=10

function SWEP:DrawWorldModel()
	return false
end

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	self.Weapon:DrawShadow(false)
end

if CLIENT then
	usermessage.Hook("PickPocket_time", function(um)
		local wep = um:ReadEntity()
		local time = um:ReadLong()

		wep.PickPocketTime = time
		wep.EndPick = CurTime() + time
	end)
end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	if self.IsPickPocketing then return end

	local trace = self.Owner:GetEyeTrace()
	local e = trace.Entity
	if IsValid(e) and trace.HitPos:Distance(self.Owner:GetShootPos()) <= 100 and e:IsPlayer() and (e:GetAimVector():DotProduct(self.Owner:GetAimVector()) > 0.8) and e:Team() != 0 then
		self.IsPickPocketing = true
		self.StartPick = CurTime()
		if SERVER then
			self.PickPocketTime = math.Rand(5, 10)
			umsg.Start("PickPocket_time", self.Owner)
				umsg.Entity(self)
				umsg.Long(self.PickPocketTime)
			umsg.End()
		end

		self.EndPick = CurTime() + self.PickPocketTime

		self:SetWeaponHoldType("pistol")
		if SERVER then
			self.snd=CreateSound(self, "physics/body/body_medium_scrape_smooth_loop1.wav")
			self.snd:Play()
		
		elseif CLIENT then
			self.Dots = self.Dots or ""
			timer.Create("PickPocketDots", 0.5, 0, function()
				if not self:IsValid() then timer.Destroy("PickPocketDots") return end
				local len = string.len(self.Dots)
				local dots = {[0]=".", [1]="..", [2]="...", [3]=""}
				self.Dots = dots[len]
			end)
		end
	end
end

function SWEP:Holster()
	self.IsPickPocketing = false
	//if SERVER then timer.Destroy("PickPocketSounds") end
	if SERVER and self.snd then
		self.snd:Stop()
		self.snd=nil
	end
	if CLIENT then timer.Destroy("PickPocketDots") end
	return true
end

function SWEP:Succeed()
	self.IsPickPocketing = false
	self:SetWeaponHoldType("normal")
	local trace = self.Owner:GetEyeTrace()
	if SERVER and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
		if not RP:GetSetting("admindropcash") and trace.Entity:RP_IsAdmin() then
			RP:Error(self.Owner, RP.colors.white, "You cannot steal an admins cash, sorry!")
		else
			local P=math.floor(math.random(10,30))/100
			local A=math.Clamp(math.floor((trace.Entity:GetCash()*P)*0.1)*10,0,RP:GetSetting("maxdroppedcash"))
			self.Owner:AddCash(A)
			trace.Entity:TakeCash(A)
			RP:Notify(self.Owner, RP.colors.white, "You have stolen ", RP.colors.blue, RP:CC(A), RP.colors.white, " from ", RP.colors.red, trace.Entity:Nick(), RP.colors.white, ".")
			RP:Notify(trace.Entity, RP.colors.red, RP:CC(A), RP.colors.white, " has been stolen from you.")
		end
	end
	if SERVER and self.snd then
		self.snd:Stop()
		self.snd=nil
	end
	//if SERVER then timer.Destroy("PickPocketSounds") end
	if CLIENT then timer.Destroy("PickPocketDots") end
end

function SWEP:Fail()
	self.IsPickPocketing = false
	self:SetWeaponHoldType("normal")
	if SERVER and self.snd then
		self.snd:Stop()
		self.snd=nil
	end
	//if SERVER then timer.Destroy("PickPocketSounds") end
	if CLIENT then timer.Destroy("PickPocketDots") end
end

function SWEP:Think()
	if self.IsPickPocketing then
		local trace = self.Owner:GetEyeTrace()
		if not IsValid(trace.Entity) then
			self:Fail()
		end
		if trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or not (trace.Entity:IsPlayer() and trace.Entity:GetAimVector():DotProduct(self.Owner:GetAimVector()) > 0.8) then
			self:Fail()
		end
		if self.EndPick <= CurTime() then
			self:Succeed()
		end
	end
end

function SWEP:DrawHUD()
	if self.IsPickPocketing then
		self.Dots = self.Dots or ""
		local w = ScrW()
		local h = ScrH()
		local x,y,width,height = w/2-w/10, h/ 2, w/5, h/15
		draw.RoundedBox(8, x, y, width, height, Color(10,10,10,120))

		local time = self.EndPick - self.StartPick
		local curtime = CurTime() - self.StartPick
		local status = curtime/time
		local BarWidth = status * (width - 16) + 8
		draw.RoundedBox(8, x+8, y+8, BarWidth, height - 16, Color(255-(status*255), 0+(status*255), 0, 255))

		draw.SimpleText("Pick-pocketing"..self.Dots, "Trebuchet24", w/2, h/2 + height/2, Color(255,255,255,255), 1, 1)
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end