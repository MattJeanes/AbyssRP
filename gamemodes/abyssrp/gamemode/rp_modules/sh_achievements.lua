RP.Achievements = {}

local meta = FindMetaTable("Player")

function meta:AddAchievement(t)
	local n=t.name
	if not self:GetPData("RPAch-"..t.name, false) then
		RP:Notify(team.GetColor(self:Team()), self:Nick(), RP.colors.white, " has earned the achievement: '", RP.colors.blue, t.name, RP.colors.white, "'.")
		RP:Notify(self, RP.colors.white, "You have recieved ", RP.colors.blue, RP:CC(t.reward), RP.colors.white, " for earning that achievement!")
		self:AddCash(t.reward)
		self:SetPData("RPAch-"..t.name, true)
	end
end

function meta:Achieved(t)
	if self:GetPData("RPAch-"..t.name, false) then
		return true
	else
		return false
	end
end

function meta:ResetAchievements()
	for k,v in ipairs(RP.Achievements) do
		self:SetPData("RPAch-"..v.name, false)
	end
end

function RP:AddAchievement(t)
	local n=#RP.Achievements+1
	RP.Achievements[n]={}
	RP.Achievements[n].name = t.name
	RP.Achievements[n].desc = t.desc
	RP.Achievements[n].reward = t.reward
	RP.Achievements[n].func = t.func
	RP.Achievements[n].func(RP.Achievements[n], "RPAch-"..t.name, "RPAch-"..t.name.."-Progress")

	if t.total then RP.Achievements[n].total = t.total end
end

RP:AddAchievement({
	name="Play AbyssRP",
	desc="Begin your hopefully enjoyable experience on AbyssRP!",
	reward=500,
	func=function(a,b)
		hook.Add("PlayerInitialSpawn", b, function(ply)
			ply:AddAchievement(a)
		end)
	end
})

RP:AddAchievement({
	name="Ownage",
	desc="Kill someone with their own dropped weapon!",
	reward=1000,
	func=function(a,b)
		hook.Add("PlayerDeath", b, function(victim, weapon, killer)
			if killer:IsPlayer() and IsValid(killer:GetActiveWeapon()) then
				if killer:GetActiveWeapon().TheOwner == victim then
					killer:AddAchievement(a)
				end
			end
		end)
	end
})

RP:AddAchievement({
	name="Suicidal",
	desc="Die a total of 200 times!",
	reward=1500,
	total=200,
	func=function(a,b,c)
		hook.Add("PlayerDeath", b, function(victim, weapon, killer)
			if not victim:Achieved(a) then
				victim:SetPData(c, victim:GetPData(c,0)+1)
				if tonumber(victim:GetPData(c,0))>=a.total then
					victim:AddAchievement(a)
				end
			end
		end)
	end
})

RP:AddAchievement({
	name="Homicidal",
	desc="Kill a total of 200 people!",
	reward=2000,
	total=200,
	func=function(a,b,c)
		hook.Add("PlayerDeath", b, function(victim, weapon, killer)
			if victim != killer and killer:IsPlayer() and not killer:Achieved(a) then
				killer:SetPData(c, killer:GetPData(c,0)+1)
				if tonumber(killer:GetPData(c,0))>=a.total then
					killer:AddAchievement(a)
				end
			end
		end)
	end
})