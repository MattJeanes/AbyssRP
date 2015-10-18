-- Achievements

RP.Achievements = {}

local meta = FindMetaTable("Player")

if SERVER then
	function meta:AddAchievement(t)
		if not self:Achieved(t) then
			RP:Notify(team.GetColor(self:Team()), self:Nick(), RP.colors.white, " has earned the achievement: '", RP.colors.blue, t.name, RP.colors.white, "'.")
			RP:Notify(self, RP.colors.white, "You have recieved ", RP.colors.blue, RP:CC(t.reward), RP.colors.white, " for earning that achievement!")
			self:UpdateAchievement(t,"ach",true)
			self:AddCash(t.reward)
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
	
	function meta:ResetAchievements()
		self:SetValue("ach",{})
		RP:SavePlayerInfo()
	end
	
	util.AddNetworkString("RP-Achievement")
	
	net.Receive("RP-Achievement", function(len,ply)
		local id=net.ReadString()
		local update=net.ReadBool()
		local t=RP.Achievements[id]
		if t and t.client then
			if update then
				local i=net.ReadType()
				local v=net.ReadType()
				ply:UpdateAchievement(t,i,v)
			else
				ply:AddAchievement(t)
			end
		end
	end)
else
	function meta:AddAchievement(t)
		if t.id then
			net.Start("RP-Achievement")
				net.WriteString(t.id)
				net.WriteBool(false)
			net.SendToServer()
		end
	end

	function meta:UpdateAchievement(t,i,v)
		if t.id then
			net.Start("RP-Achievement")
				net.WriteString(t.id)
				net.WriteBool(true)
				net.WriteType(i)
				net.WriteType(v)
			net.SendToServer()
		end
	end
end

function RP:AddAchievement(t)
	RP.Achievements[t.id]=table.Copy(t)
	if RP.Achievements[t.id].func and (CLIENT and t.client or SERVER) then
		RP.Achievements[t.id].func(RP.Achievements[t.id], "Ach-"..t.id)
	end
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
	name="Lucky day",
	id="luckyday",
	desc="Find and pick up the maximum amount of dropped money ("..RP:CC(RP:GetSetting("maxdroppedcash",0))..")",
	reward=2500,
	func=function(a,b)
		hook.Add("RP-PickupCash", b, function(ply, amount, owner)
			if IsValid(ply) and ply:IsPlayer() and ply~=owner and amount==RP:GetSetting("maxdroppedcash",0) then
				ply:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="I regret nothing",
	id="regret",
	desc="Kill yourself",
	reward=500,
	func=function(a,b)
		hook.Add("PlayerDeath", b, function(victim, _ , killer)
			if IsValid(killer) and killer:IsPlayer() and IsValid(victim) and victim:IsPlayer() and victim==killer then
				victim:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="I'm sorry",
	id="killadmin",
	desc="Kill an Admin",
	reward=500,
	func=function(a,b)
		hook.Add("PlayerDeath", b, function(victim, _, killer)
			if IsValid(killer) and killer:IsPlayer() and IsValid(victim) and victim:IsPlayer() and (victim:IsAdmin() or victim:IsSuperAdmin()) and victim~=killer then
				killer:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="Getting bank",
	id="getbank",
	desc="Have "..RP:CC(10000).." in your bank.",
	reward=750,
	func=function(a,b)
		hook.Add("RP-BankChanged", b, function(ply, amount)
			if IsValid(ply) and ply:IsPlayer() and amount>=10000 then
				ply:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="Saving for something?",
	id="sfs",
	desc="Have "..RP:CC(20000).." in your bank.",   
	reward=1500,
	func=function(a,b)
		hook.Add("RP-BankChanged", b, function(ply, amount)
			if IsValid(ply) and ply:IsPlayer() and amount>=20000 then
				ply:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="Big money",
	id="humbug",
	desc="Have "..RP:CC(50000).." in your bank.",   
	reward=5000,
	func=function(a,b)
		hook.Add("RP-BankChanged", b, function(ply, amount)
			if IsValid(ply) and ply:IsPlayer() and amount>=50000 then
				ply:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="Life savings",
	id="lifesavings",
	desc="Have "..RP:CC(100000).." in your bank.",   
	reward=10000,
	func=function(a,b)
		hook.Add("RP-BankChanged", b, function(ply, amount)
			if IsValid(ply) and ply:IsPlayer() and amount>=100000 then
				ply:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="Deep pockets",
	id="dpockets",
	desc="Have "..RP:CC(10000).." on you.",
	reward=1500,
	func=function(a,b)
		hook.Add("RP-CashChanged", b, function(ply, amount)
			if IsValid(ply) and ply:IsPlayer() and amount>=10000 then
				ply:AddAchievement(a)
			end
		end)
	end
})

RP:AddAchievement({
	name="Embarrassing",
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
	name="Payday!",
	id="payday",
	desc="Receive your first payday",   
	reward=250,
	func=function(a,b)
		hook.Add("RP-Payday", b, function(ply, amount)
			ply:AddAchievement(a)
		end)
	end
})

RP:AddAchievement({
	name="Developers Developers Developers",
	id="ddd",
	desc="Be on the server with a member of the dev team for AbyssRP",   
	reward=500,
	func=function(a,b)
		hook.Add("PlayerInitialSpawn", b, function(ply)
			if ply:SteamID()=="STEAM_0:0:24831103" or "STEAM_0:1:31884971" or "STEAM_0:0:33037550" then 
				for k, v in pairs( player.GetAll() ) do
					v:AddAchievement(a)
				end
			else
				for k,v in pairs(player.GetAll()) do 
					if v:SteamID()=="STEAM_0:0:24831103" or "STEAM_0:1:31884971" or "STEAM_0:0:33037550" then
						ply:AddAchievement(a)
					end
				end	
			end
		end)
	end
})

RP:AddAchievement({
	name="One Small Step",
	id="oss",
	desc="Take 1 Step",
	reward=150,
	total=1,
	func=function(a,b,c)
		if SERVER then
			hook.Add("PlayerFootstep", b, function(ply)
				if not ply:Achieved(a) then
					ply:UpdateAchievement(a,"c",math.Clamp(ply:GetAchievementValue(a,"c",0)+1,0,a.total))
					if ply:GetAchievementValue(a,"c") >= a.total then
						ply:AddAchievement(a)
					end
				end
			end)
		end
	end
})

RP:AddAchievement({
	name="A Few Small Steps",
	id="afss",
	desc="Take 5000 Steps",
	reward=200,
	total=5000,
	func=function(a,b,c)
		if SERVER then
			hook.Add("PlayerFootstep", b, function(ply)
				if not ply:Achieved(a) then
					ply:UpdateAchievement(a,"c",math.Clamp(ply:GetAchievementValue(a,"c",0)+1,0,a.total))
					if ply:GetAchievementValue(a,"c") >= a.total then
						ply:AddAchievement(a)
					end
				end
			end)
		end
	end
})

RP:AddAchievement({
	name="Many Small Steps",
	id="mss",
	desc="Take 20000 Steps",
	reward=500,
	total=20000,
	func=function(a,b,c)
		if SERVER then
			hook.Add("PlayerFootstep", b, function(ply)
				if not ply:Achieved(a) then
					ply:UpdateAchievement(a,"c",math.Clamp(ply:GetAchievementValue(a,"c",0)+1,0,a.total))
					if ply:GetAchievementValue(a,"c") >= a.total then
						ply:AddAchievement(a)
					end
				end
			end)
		end
	end
})

RP:AddAchievement({
	name="A Lot Of Small Steps",
	id="aloss",
	desc="Take 50000 Steps",
	reward=1000,
	total=50000,
	func=function(a,b,c)
		if SERVER then
			hook.Add("PlayerFootstep", b, function(ply)
				if not ply:Achieved(a) then
					ply:UpdateAchievement(a,"c",math.Clamp(ply:GetAchievementValue(a,"c",0)+1,0,a.total))
					if ply:GetAchievementValue(a,"c") >= a.total then
						ply:AddAchievement(a)
					end
				end
			end)
		end
	end
})

RP:AddAchievement({
	name="A Giant Leap",
	id="agl",
	desc="Take 100000 Steps",
	reward=2000,
	total=100000,
	func=function(a,b,c)
		if SERVER then
			hook.Add("PlayerFootstep", b, function(ply)
				if not ply:Achieved(a) then
					ply:UpdateAchievement(a,"c",math.Clamp(ply:GetAchievementValue(a,"c",0)+1,0,a.total))
					if ply:GetAchievementValue(a,"c") >= a.total then
						ply:AddAchievement(a)
					end
				end
			end)
		end
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
		listview:SetSize(150,panel:GetTall())
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
		desc:SetWrap(true)
		desc:SetAutoStretchVertical(true)
		desc:SetText("")
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Reward:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetWide()+5,60)
		
		local reward = vgui.Create("DLabel",panel)
		reward:SetPos(listview:GetPos()+listview:GetWide()+5,60+label:GetTall())
		reward:SetText("")
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("Achieved:")
		label:SetFont("DermaLarge")
		label:SizeToContents()
		label:SetPos(listview:GetWide()+5,120)
		
		local ach = vgui.Create("DLabel",panel)
		ach:SetPos(listview:GetPos()+listview:GetWide()+5,120+label:GetTall())
		ach:SetText("")
		
		local totallabel = vgui.Create("DLabel",panel)
		totallabel:SetText("Progress:")
		totallabel:SetFont("DermaLarge")
		totallabel:SizeToContents()
		totallabel:SetPos(listview:GetWide()+5,180)
		totallabel:SetVisible(false)
		
		local total = vgui.Create("DLabel",panel)
		total:SetPos(listview:GetPos()+listview:GetWide()+5,180+label:GetTall())
		total:SetText("")
		
		function update()
			if not selected then return end
			totallabel:SetVisible(false)
			total:SetVisible(false)
			
			desc:SetText(selected.desc)
			local x,y=desc:GetPos()
			desc:SetSize(panel:GetWide()-x, 30)
			
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
