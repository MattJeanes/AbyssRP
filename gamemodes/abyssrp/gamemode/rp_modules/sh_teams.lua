-- Teams

RP.Team={}
function RP:AddTeam(t)
	if not (t.name or t.color) and not t.nosetup then
		print("ERROR: Invalid usage of RP:AddTeam!")
		return
	end
	local n = t.num or #RP.Team+1
	RP.Team[n]=table.Copy(t)
	if RP.Team[n].func then
		RP.Team[n].func(RP.Team[n], "RP.Team-"..n, n)
	end
	
	if not t.nosetup then
		team.SetUp( n, t.name, t.color )
	end
end

-- Convinience functions!
function RP:GetTeamModel(n)
	local t=RP.Team[n]
	if t.modelrand then
		local i=math.random(t.modelrandn[1], t.modelrandn[2])
		return t.model[1]..i..t.model[2]
	else
	 	return t.model
	end
end

function RP:GetTeamN(str)
	for k,v in ipairs(RP.Team) do
		if string.lower(v.name)==string.lower(str) then
			return k
		end
	end
	return false
end

local meta = FindMetaTable("Player")

function meta:GetTeam()
	return RP.Team[self:Team()]
end

function meta:IsTeam(str)
	return self:Team()==RP:GetTeamN(str)
end

function meta:GetTeamValue(value)
	return RP.Team[self:Team()][value]
end

RP:AddTeam({
	num=0,
	nosetup=true,
	model="models/player/group01/male_01",
	name="No Job",
	salary=0,
	desc="",
	rules="",
	extra=""
})

RP:AddTeam({
	name="Citizen",
	color=Color( 255, 255, 0 ),
	model={"models/player/group01/male_0",".mdl"},
	modelrand=true,
	modelrandn={1,9},
	salary=50,
	desc="You are a citizen. You have no special benefits or abilities but are free to roam the world.",
	rules="No specific rules, just follow the law.",
	extra="You earn a fair salary, higher than the lawbreakers but lower than authority figures."
})

RP:AddTeam({
	name="Officer",
	color=Color( 0, 0, 205 ),
	model="models/player/police.mdl",
	salary=150,
	desc="You are a police officer. Your role is to protect the citizens and lock up any troublemakers.",
	rules="You have high authority, so don't abuse your power.",
	extra="Arrest/Unarrest Players with your special baton.\n!wanted <player> <reason> - Allows someone to be arrested.",
	votejoin=true,
	maxplayers=5,
	police=true,
	armor=100,
	weps={
		"arrest_stick",
		"weapon_taser",
		"weapon_stunstick",
		"fas2_glock20",
		"fas2_mp5a5",
		"fas2_dv2"
	}
})

RP:AddTeam({
	name="Car Dealer",
	color=Color( 0, 255, 0 ),
	model="models/player/barney.mdl",
	salary=30,
	desc="You are a car dealer. You sell cars for a living, and that is your main source of income.",
	rules="Make sure to transfer ownership of the vehicle with !giveownership <ply> before handing it over.",
	extra="Use !shop to access the car shop.",
	func=function(a,b,c)
		hook.Add("SpawnMenuOpen", b, function()
			if LocalPlayer():Team()==c then
				SpawnVehicle_Menu( LocalPlayer() )
				return false
			end
		end)
	end
})

RP:AddTeam({
	name="Thief",
	color=Color( 255, 120, 0 ),
	model="models/player/arctic.mdl",
	salary=30,
	desc="You are a thief. It is your 'job' to try and steal people's cash without them noticing, or break into someone's house and take their possessions.",
	rules="You don't have any rules, but be prepared to deal with the police if you get caught.",
	extra="You can also use your knife to mug citizens, but this is not recommended.",
	maxplayers=4,
	weps={
		"weapon_pickpocket",
		"weapon_lockpick",
		"fas2_dv2"
	}
})

RP:AddTeam({
	name="Assassin",
	color=Color( 0, 191, 255 ),
	model="models/player/combine_super_soldier.mdl",
	salary=65,
	desc="You are an assassin. Strike from the shadows and slip away undetected.",
	rules="You must be hired to kill, so don't randomly kill people.",
	extra="People can request a hit using !hit <player> <offer>, which you can accept or reject.",
	maxplayers=2,
	votejoin=true,
	weps={
		"fas2_m1911"
	}
})

RP:AddTeam({
	name="Black Market Dealer",
	color=Color( 160, 82, 45 ),
	model="models/player/monk.mdl",
	salary=20,
	desc="You are a black market dealer. You illegally sell stuff to those who want them, and avoid detection.",
	rules="You must actually deal stuff; you're not allowed to use this job just to buy yourself stuff.",
	extra="You can access the black market with !menu.",
	maxplayers=2
})

RP:AddTeam({
	name="Freerunner",
	color=Color( 18, 181, 142 ),
	model={"models/player/group03/male_0",".mdl"},
	modelrand=true,
	modelrandn={1,9},
	salary=40,
	desc="You are a freerunner. Most of your time is spent on the rooftops, away from authority.",
	rules="You don't have any rules. You may choose to follow the law but you don't have to.",
	extra="You are like a citizen, but you can move faster and use obstacles to your aid.",
	nohands=true,
	freerun=true,
	walkspeed=250,
	runspeed=500,
	weps={
		"weapon_climb"
	}
})

RP:AddTeam({
	name="Police Chief",
	color=Color( 130, 65, 107 ),
	model="models/player/combine_soldier_prisonguard.mdl",
	salary=200,
	desc="You are the police chief. Your job is to command your fellow officers and help them to hold the law.",
	rules="You must have a valid reason to issue a warrant or make someone wanted.\nYou are of very high authority so don't abuse it.",
	extra="!wanted <player> <reason> - Allows someone to be arrested.\n!warrant <player> [1/0] - Allows you and your fellow officers to search a player's house.",
	votejoin=true,
	maxplayers=1,
	police=true,
	armor=100,
	weps={
		"arrest_stick",
		"weapon_stunstick",
		"weapon_taser",
		"fas2_deagle",
		"fas2_rk95",
		"fas2_dv2"
	}
})

RP:AddTeam({
	name="Gun Dealer",
	color=Color( 99, 99, 99 ),
	model="models/player/odessa.mdl",
	salary=30,
	desc="You are a gun dealer. You sell guns to people to make your living.",
	rules="You must actually deal guns; you're not allowed to use this job just to buy yourself weapons.",
	extra="You can access the gun shop with !menu.",
	votejoin=true,
	maxplayers=2
})

RP:AddTeam({
	name="Mayor",
	color=Color( 255, 0, 0 ),
	model="models/player/breen.mdl",
	salary=500,
	desc="You are the mayor. Your job is to oversee the town and keep things running smoothly.",
	rules="You are of extremely high authority and you must never warrant/arrest players with no reason.",
	extra="!wanted <player> <reason> - Allows someone to be arrested.\n!warrant <player> [1/0] - Allows police force to search a player's house.",
	votejoin=true,
	police=true,
	maxplayers=1,
	armor=100
})

RP:AddTeam({
	name="Medic",
	color=Color( 255, 0, 170 ),
	model={"models/player/group03m/male_0",".mdl"},
	modelrand=true,
	modelrandn={1,9},
	salary=150,
	desc="You are the medic. Your job is to heal those who have been injured.",
	rules="Make sure to respond to 'medic' requests wherever possible.",
	extra="People can call for you with !medic.",
	weps={
		"med_kit"
	}
})