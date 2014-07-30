RP.Achievements = {}

local meta = FindMetaTable("Player")

function meta:AddAchievement(t)
	if not self:Achieved(t) then
		RP:Notify(team.GetColor(self:Team()), self:Nick(), RP.colors.white, " has earned the achievement: '", RP.colors.blue, t.name, RP.colors.white, "'.")
		RP:Notify(self, RP.colors.white, "You have recieved ", RP.colors.blue, RP:CC(t.reward), RP.colors.white, " for earning that achievement!")
		self:AddCash(t.reward)
		self:UpdateAchievement(t,"ach",true)
	end
end

function meta:UpdateAchievement(t,i,v)
	if not self:GetValue("ach") then self:SetValue("ach",{}) end
	local ach=self:GetValue("ach")
	if not ach[t.id] then ach[t.id]={} end
	
	ach[t.id][i] = v
	self:SetValue("ach", ach)
	RP:SavePlayerInfo()
end

function meta:GetAchievement(t,d)
	if not self:GetValue("ach") then return d end
	local ach=self:GetValue("ach")
	if not ach[t.id] then return d end
	
	return ach[t.id]
end

function meta:GetAchievementValue(t,i,d)
	if not self:GetValue("ach") then return d end
	local ach=self:GetValue("ach")
	if not ach[t.id] then return d end
	if not ach[t.id][i] then return d end
	
	return ach[t.id][i]
end

function meta:Achieved(t)
	if self:GetAchievementValue(t,"ach") then
		return true
	end
	return false
end

function meta:ResetAchievements()
	self:SetValue("ach",{})
	RP:SavePlayerInfo()
end

function RP:AddAchievement(t)
	local n=#RP.Achievements+1
	RP.Achievements[n]=table.Copy(t)
	if RP.Achievements[n].func then
		RP.Achievements[n].func(RP.Achievements[n], "Ach-"..t.name)
	end
end

RP:AddAchievement({
	name="Play AbyssRP",
	id="play",
	desc="Begin your hopefully enjoyable experience on AbyssRP!",
	reward=500,
	func=function(a,b)
		hook.Add("PlayerSpawn", b, function(ply)
			ply:AddAchievement(a)
		end)
	end
})

RP:AddAchievement({
	name="Ownage",
	id="killownwep",
	desc="Kill someone with their own dropped weapon!",
	reward=1000,
	func=function(a,b)
		hook.Add("PlayerDeath", b, function(victim, weapon, killer)
			if killer:IsPlayer() and IsValid(killer:GetActiveWeapon()) then
				if killer:GetActiveWeapon().OldOwner == victim then
					killer:AddAchievement(a)
				end
			end
		end)
	end
})

RP:AddAchievement({
	name="Suicidal",
	id="die",
	desc="Die a total of 200 times!",
	reward=1500,
	total=200,
	func=function(a,b,c)
		hook.Add("PlayerDeath", b, function(victim, weapon, killer)
			if not victim:Achieved(a) then
				victim:UpdateAchievement(a,"c",math.Clamp(victim:GetAchievementValue(a,"c",0)+1,0,a.total))
				if victim:GetAchievementValue(a,"c") >= a.total then
					victim:AddAchievement(a)
				end
			end
		end)
	end
})

RP:AddAchievement({
	name="Homicidal",
	id="kill",
	desc="Kill a total of 200 people!",
	reward=2000,
	total=200,
	func=function(a,b,c)
		hook.Add("PlayerDeath", b, function(victim, weapon, killer)
			if victim != killer and killer:IsPlayer() and not killer:Achieved(a) then
				killer:UpdateAchievement(a,"c",math.Clamp(killer:GetAchievementValue(a,"c",0)+1,0,a.total))
				if killer:GetAchievementValue(a,"c") >= a.total then
					killer:AddAchievement(a)
				end
			end
		end)
	end
})