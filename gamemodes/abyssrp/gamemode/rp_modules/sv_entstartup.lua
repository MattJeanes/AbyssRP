RP.ATMs = {}
RP.PoliceDoors = {}
RP.JailPoses = {}

function RP:AddATM(vec,ang)
	local n=#RP.ATMs+1
	RP.ATMs[n]={}
	RP.ATMs[n].pos=vec
	RP.ATMs[n].ang=ang
end

function RP:AddPoliceDoor(pos)
	local n=#RP.PoliceDoors+1
	RP.PoliceDoors[n]=pos
end

function RP:AddJailPos(pos)
	local n=#RP.JailPoses+1
	RP.JailPoses[n]=pos
end

hook.Add("RP-EntStartup", "RP-DefaultStartup", function()

	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v:GetSaveTable().m_bLocked then
			v.TheOwner = nil
			v.Ownable = true
			v:SetNetworkedString("Owner", "World")
			v:SetNetworkedEntity("OwnerObj", game.GetWorld())
		else
			v.TheOwner = nil
			v.Ownable = false
			v:SetNetworkedString("Owner", "World")
			v:SetNetworkedEntity("OwnerObj", game.GetWorld())
		end
	end
	
	for k, v in pairs(ents.FindByClass("func_door")) do
		if v:GetSaveTable().m_bLocked then
			v.TheOwner = nil
			v.Ownable = true
			v:SetNetworkedString("Owner", "World")
			v:SetNetworkedEntity("OwnerObj", game.GetWorld())
		else
			v.TheOwner = nil
			v.Ownable = false
			v:SetNetworkedString("Owner", "World")
			v:SetNetworkedEntity("OwnerObj", game.GetWorld())
		end
	end
	
	for k, v in pairs(ents.FindByClass("func_door_rotating")) do
		if v:GetSaveTable().m_bLocked then
			v.TheOwner = nil
			v.Ownable = true
			v:SetNetworkedString("Owner", "World")
			v:SetNetworkedEntity("OwnerObj", game.GetWorld())
		else
			v.TheOwner = nil
			v.Ownable = false
			v:SetNetworkedString("Owner", "World")
			v:SetNetworkedEntity("OwnerObj", game.GetWorld())
		end
	end
	
	if RP.PoliceDoors then
		for a,b in ipairs(ents.GetAll()) do
			for c,d in pairs(RP.PoliceDoors) do
				if b:GetPos() == d then
					b.OwnedByTeam = {2, 8}
					b:SetNWBool("Owned", true)
					b.Ownable = false
				end
			end
		end
	end
	if RP.ATMs then
		for k,v in pairs(RP.ATMs) do
			local ent = ents.Create("atmmachine")
			ent:SetPos(v.pos)
			ent:SetAngles(v.ang)
			ent:SetNetworkedString("Owner", "World")
			ent:SetNetworkedEntity("OwnerObj", game.GetWorld())
			ent:Spawn()
		end
	end
	game.ConsoleCommand("sbox_godmode 0\n")
	game.ConsoleCommand("sbox_playershurtplayers 1\n")
	game.ConsoleCommand("sbox_noclip 0\n")
end)

hook.Add( "InitPostEntity", "MapStartTrigger", function()
	local maps = file.Find( "abyssrp/gamemode/rp_maps/*.lua", "LUA" )
	local found=false
	for _, map in ipairs( maps ) do
		local s=string.gsub(map, ".lua", "")
		if string.lower(s)==string.lower(game.GetMap()) then
			include( "abyssrp/gamemode/rp_maps/" .. map )
		end
	end
	timer.Simple(2, function()
		hook.Call("RP-EntStartup", GAMEMODE)
	end)
end)