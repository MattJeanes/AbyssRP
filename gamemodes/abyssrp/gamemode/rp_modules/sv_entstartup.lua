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

function RP:EntStartup()
	local maps = file.Find( "abyssrp/gamemode/rp_maps/*.lua", "LUA" )
	local found=false
	for _, map in ipairs( maps ) do
		local s=string.gsub(map, ".lua", "")
		if string.lower(s)==string.lower(game.GetMap()) then
			include( "abyssrp/gamemode/rp_maps/" .. map )
		end
	end

	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		v.Ownable = tobool(v:GetSaveTable().m_bLocked)
		v.Owner = nil
		v:SetWorldOwner()
	end
	
	for k, v in pairs(ents.FindByClass("func_door")) do
		v.Ownable = tobool(v:GetSaveTable().m_bLocked)
		v.Owner = nil
		v:SetWorldOwner()
	end
	
	for k, v in pairs(ents.FindByClass("func_door_rotating")) do
		v.Ownable = tobool(v:GetSaveTable().m_bLocked)
		v.Owner = nil
		v:SetWorldOwner()
	end
	
	if RP.PoliceDoors then
		for a,b in ipairs(ents.GetAll()) do
			for c,d in pairs(RP.PoliceDoors) do
				if b:GetPos() == d then
					b.PoliceOwned = true
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
			ent:SetWorldOwner()
			ent:Spawn()
		end
	end
end

hook.Add( "InitPostEntity", "RP-EntStartup", function()
	RP:EntStartup()
end)