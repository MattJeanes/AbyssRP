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

//Convinience functions!
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

// Team 0 info - Don't delete this one please! //

RP:AddTeam({
	num=0,
	nosetup=true,
	model={"models/player/group01/male_0",".mdl"},
	modelrand=true,
	modelrandn={1,9},
	name="No Class",
	salary="0\n\nYou're not even a person why would you earn money?",
	desc="You aren't any class! You need to select one to the left.",
	rules="This isn't even a team what are you doing.",
	extra="You are not a person."
})

// begin other teams - feel free to delete/modify any of these.

RP:AddTeam({
	name="Citizen",
	color=Color( 255, 255, 0 ),
	model={"models/player/group01/male_0",".mdl"},
	modelrand=true,
	modelrandn={1,9},
	salary=50,
	desc="The citizen has a basic role of life, you are a standard person, with no special benefits or abilities.",
	rules="No Rules! Your just a normal citizen!",
	extra="No extra information."
})

RP:AddTeam({
	name="Officer",
	color=Color( 0, 0, 205 ),
	model="models/player/police.mdl",
	salary=150,
	desc="You are a police officer, your role is to protect the fellow citizens of AbyssRP and treat your fellow officers well.",
	rules="You are of authority, do not abuse your power.",
	extra="Arrest/Unarrest Players with your special baton.\n!wanted <player> [1/0] - Allow's someone to be arrested.",
	votejoin=true,
	maxplayers=5,
	police=true,
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:SetArmor(100)
				ply:Give( "arrest_stick" )
				ply:Give( "weapon_taser" )
				ply:Give( "weapon_stunstick" )
				ply:Give( "weapon_rp_glock" )
				ply:GiveAmmo(100, "9MM")
				ply:Give( "weapon_rp_mp5" )
			end
		end)
	end
})

RP:AddTeam({
	name="Car Dealer",
	color=Color( 0, 255, 0 ),
	model="models/player/barney.mdl",
	salary=30,
	desc="You are a car dealer. Your job is to sell car's to other people who want them, and make yourself a living from it!",
	rules="Make sure to use !giveownership <ply> while looking at the vehicle, before letting the client drive off in it!",
	extra="Special Car Spawn-menu."
})

RP:AddTeam({
	name="Thief",
	color=Color( 255, 120, 0 ),
	model="models/player/arctic.mdl",
	salary=30,
	desc="You are a thief, it is your 'job' to try and steal peoples cash without them noticing, or break into someones house and take their possessions.",
	rules="If you do go round stealing peoples money or breaking into houses, you must be prepared for the consequences if you're caught.",
	extra="Try not to get seen by anybody while breaking into a house or pickpocketing someone.",
	maxplayers=4,
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:Give("weapon_pickpocket")
				ply:Give("weapon_lockpick")
			end
		end)
	end
})

RP:AddTeam({
	name="Assassin",
	color=Color( 0, 191, 255 ),
	model="models/player/combine_super_soldier.mdl",
	salary=65,
	desc="You are the assassin! Your job varies on what your client want's to do, remember police officers can still arrest you!",
	rules="Do not randomly kill people, you must be hired to do so!",
	extra="You're hired to kill.",
	maxplayers=2,
	votejoin=true,
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:Give( "weapon_rp_scout" )
				ply:GiveAmmo(20, "7.62MM")
			end
		end)
	end
})

RP:AddTeam({
	name="Pedophile",
	color=Color( 160, 82, 45 ),
	model="models/player/monk.mdl",
	salary=20,
	desc="You are the scum of the earth, the pedophiles! Your 'job' is to capture small childs and do things like [REDACTED]..",
	rules="No Rules! You make your own.. with the small childs.",
	extra="Abduct small childs.",
	maxplayers=3,
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:Give( "weapon_rape" )
			end
		end)
	end
})

RP:AddTeam({
	name="Freerunner",
	color=Color( 18, 181, 142 ),
	model={"models/player/group03/male_0",".mdl"},
	modelrand=true,
	modelrandn={1,9},
	salary=55,
	desc="You are a freerunner! You feel the flow of the city as it comes together, rooftops and obstacles become simple pathways as you explore the terrain.",
	rules="No Rules! You feel the breeze of the city, away from any trouble.",
	extra="Roam the city, hopefully free from trouble.",
	func=function(a,b,c)		
		hook.Add("SetupMove", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				GAMEMODE:SetPlayerSpeed(ply, 250, 500)
				return true
			end
		end)
	end
})

RP:AddTeam({
	name="Police Chief",
	color=Color( 130, 65, 107 ),
	model="models/player/combine_soldier_prisonguard.mdl",
	salary=200,
	desc="You are the police chief! Your job is to command your police force and use command's like !wanted and !warrant to allow your fellow officers to arrest people.",
	rules="Do not randomly make players wanted/warranted, you must have a reason.\nYou are of very high authority so do not abuse it!",
	extra="!wanted <player> [1/0] - Allow's someone to be arrested.\n!warrant <player> [1/0] - Allows your force to search a players house.",
	votejoin=true,
	maxplayers=1,
	police=true,
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:SetArmor(100)
				ply:Give( "arrest_stick" )
				ply:Give( "weapon_rp_deagle" )
				ply:Give( "weapon_stunstick" )
				ply:Give( "weapon_taser" )
				ply:GiveAmmo(56, ".50MM")
				ply:Give( "weapon_rp_m4" )
				ply:GiveAmmo(150, "5.56MM")
				ply:Give( "weapon_slam" )
			end
		end)
	end
})

RP:AddTeam({
	name="Gun Dealer",
	color=Color( 99, 99, 99 ),
	model="models/player/odessa.mdl",
	salary=30,
	desc="You're a gun dealer, You sell gun's to people to make your living. If the police catch you it's time to use your weapon cache!",
	rules="You have the right not to sell your guns, however don't hog the class just to get gun's to shoot people yourself!",
	extra="No extra information.",
	votejoin=true,
	maxplayers=2
})

RP:AddTeam({
	name="Mayor",
	color=Color( 255, 0, 0 ),
	model="models/player/breen.mdl",
	salary=500,
	desc="You are the wonderful mayor! You have much control over your people and can even allow the police force to search someones house!",
	rules="As for the Police Chief, you are of extremely high authority and you should not randomly warrant/arrest players so do not abuse.",
	extra="!wanted <player> [1/0] - Allow's someone to be arrested.\n!warrant <player> [1/0] - Allow police force to search a players house.",
	votejoin=true,
	maxplayers=1,
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:SetArmor(100)
				ply:Give( "arrest_stick" )
			end
		end)
	end
})

RP:AddTeam({
	name="Medic",
	color=Color( 255, 0, 170 ),
	model={"models/player/group03/female_0",".mdl"},
	modelrand=true,
	modelrandn={1,4},
	salary=150,
	desc="You are the helpful medic! Your job is to heal those who have injured themselves (probably the freerunners) or those who have been shot!",
	rules="Make sure to respond to 'medic' requests from your peers.",
	extra="People can call for you with !medic.",
	func=function(a,b,c)
		hook.Add("PlayerLoadout", b, function(ply)
			if ply:Team()==c and not ply.RP_Jailed then
				ply:Give( "med_kit" )
			end
		end)
	end
})