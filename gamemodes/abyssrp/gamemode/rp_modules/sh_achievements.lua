-- Achievements

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
			name="Que?",
			id="que",
			desc="Attempted to open the spawn menu",
			reward=300,
			func=function(a,b)
				hook.Add("SpawnMenuOpen", b, function(ply)
					ply:AddAchievement(a)
				end)
			end
		})

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
        name="Lucky Day",
        id="luckyday",
        maxcash=RP:GetSetting("maxdroppedcash",0),
        desc="Find and pick up the maximum amount of dropped money (£"..RP:GetSetting("maxdroppedcash",0)..")",
        reward=2500,
        func=function(a,b)
                hook.Add("RP-PickupCash", b, function(ply, amount, owner)
                      if ply:IsPlayer() && IsValid(ply) && ply~=owner  && amount==a.maxcash then
                                ply:AddAchievement(a)
                      end
                end)
        end
})  

    RP:AddAchievement({
            name="I regret nothiiiiinnnnng",
            id="regret",
            desc="Kill yourself",
            reward=500,
            func=function(a,b)
                    hook.Add("PlayerDeath", b, function(victim, _ , killer)
                          if killer:IsPlayer() and IsValid(killer) then
                                 if (victim:IsPlayer() || IsValid(victim)) && victim==killer  then
                                    victim:AddAchievement(a)
                                 end
                          end
                    end)
            end
    })

RP:AddAchievement({
        name="I'm Sorry",
        id="killadmin",
        desc="Kill an Admin",
        reward=500,
        func=function(a,b)
                hook.Add("PlayerDeath", b, function(victim, _ , killer)
                      if killer:IsPlayer() and IsValid(killer) then
                             if (victim:IsAdmin() || victim:IsSuperAdmin()) && victim~=killer  then
                                killer:AddAchievement(a)
                             end
                      end
                end)
        end
})

RP:AddAchievement({
        name="Getting bank",
        id="getbank",
        desc="Have £10,000 in your bank.",
        reward=750,
        func=function(a,b)
                hook.Add("RP-BankChanged", b, function(ply, amount)
                      if ply:IsPlayer() && IsValid(ply) && amount>=10000 then
                                ply:AddAchievement(a)
                      end
                end)
        end
})   
    
RP:AddAchievement({
        name="Saving for something?",
        id="sfs",
        desc="Have £20,000 in your bank.",   
        reward=1500,
        func=function(a,b)
                hook.Add("RP-BankChanged", b, function(ply, amount)
                      if ply:IsPlayer() && IsValid(ply) && amount>=20000 then
                                ply:AddAchievement(a)
                      end
                end)
        end
})  
    
RP:AddAchievement({
        name="Big Money",
        id="humbug",
        desc="Have £50,000 in your bank.",   
        reward=5000,
        func=function(a,b)
                hook.Add("RP-BankChanged", b, function(ply, amount)
                      if ply:IsPlayer() && IsValid(ply)  && amount>=50000 then
                                ply:AddAchievement(a)
                      end
                end)
        end
})  

RP:AddAchievement({
        name="Life savings",
        id="lifesavings",
        desc="Have £100,000 in your bank.",   
        reward=10000,
        func=function(a,b)
                hook.Add("RP-BankChanged", b, function(ply, amount)
                      if ply:IsPlayer() && IsValid(ply)  && amount>=100000 then
                                ply:AddAchievement(a)
                      end
                end)
        end
})  

RP:AddAchievement({
        name="Deep Pockets",
        id="dpockets",
        desc="Have Â£10,000 on you.",
        reward=1500,
        func=function(a,b)
                hook.Add("RP-CashChanged", b, function(ply, amount)
                      if ply:IsPlayer() && IsValid(ply) && amount>=10000 then
                                ply:AddAchievement(a)
                      end
                end)
        end
}) 

	RP:AddAchievement({
		name="Sir, I think you dropped something.",
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
	name="Rest In Peace",
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

if CLIENT then
	hook.Add("RP-Menu", "Achievements", function(sheet,x,y)
		local panel = vgui.Create("Panel")	
		panel:SetSize(x,y)
		
		local selected,update
		
		local listview = vgui.Create("DListView",panel)
		listview:SetSize(100,panel:GetTall())
		listview:SetPos(0,0)
		listview:AddColumn("Achievement")
		listview:SetMultiSelect(false)
		for k,v in pairs(RP.Achievements) do
			listview:AddLine(v.name).v=k
		end
		listview:SortByColumn(1)
		listview.OnRowSelected = function(self,id,line)
			local name=line:GetValue(1)
			for k,v in pairs(RP.Achievements) do
				if line.v==k then
					selected=v
					update()
				end
			end
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Description:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetWide()+5,0)
		
		local desc = vgui.Create("DLabel",panel)
		desc:SetPos(listview:GetPos()+listview:GetWide()+5,label:GetTall())
		desc:SetText("")
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Reward:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetWide()+5,50)
		
		local reward = vgui.Create("DLabel",panel)
		reward:SetPos(listview:GetPos()+listview:GetWide()+5,50+label:GetTall())
		reward:SetText("")
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Achieved:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetWide()+5,100)
		
		local ach = vgui.Create("DLabel",panel)
		ach:SetPos(listview:GetPos()+listview:GetWide()+5,100+label:GetTall())
		ach:SetText("")
		
		local totallabel = vgui.Create("DLabel",panel)
		totallabel:SetText("Progress:")
		totallabel:SetFont("DermaLarge")
		totallabel:SizeToContents()
		totallabel:SetPos(listview:GetWide()+5,150)
		totallabel:SetVisible(false)
		
		local total = vgui.Create("DLabel",panel)
		total:SetPos(listviw:GetPos()+listview:GetWide()+5,150+label:GetTall())
		total:SetText("")
		
		function update()
			if not selected then return end
			totallabel:SetVisible(false)
			total:SetVisible(false)
			
			desc:SetText(selected.desc)
			desc:SizeToContents()
			
			reward:SetText(RP:CC(selected.reward))
			reward:SizeToContents()
			
			ach:SetText(LocalPlayer():Achieved(selected) and "Yes" or "No")
			ach:SizeToContents()
			
			if selected.total then
				total:SetText(tostring(LocalPlayer():GetAchievementValue(selected,"c",0)).."/"..tostring(selected.total))
				totallabel:SetVisible(true)
				total:SetVisible(true)
			end
		end
		
		sheet:AddSheet("Achievements", panel)
	end)
end