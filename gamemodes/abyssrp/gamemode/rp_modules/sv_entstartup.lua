-- Ent startup

RP.VendingMachines = {}
RP.ATMs = {}
RP.PoliceDoors = {}
RP.PoliceDoorsH = {}
RP.JailPoses = {}

function RP:AddVendingMachine(vec,ang)
	table.insert(self.VendingMachines,{
		pos=vec,
		ang=ang
	})
end

function RP:AddATM(vec,ang)
	table.insert(self.ATMs,{
		pos=vec,
		ang=ang
	})
end

function RP:AddPoliceDoor(pos,hacky)
	if hacky then
		table.insert(self.PoliceDoorsH,pos)
	else
		table.insert(self.PoliceDoors,pos)
	end
end

function RP:AddJailPos(pos)
	table.insert(self.JailPoses,pos)
end

local maps = file.Find( "abyssrp/gamemode/rp_maps/*.lua", "LUA" )
table.Add(maps, file.Find( "rp_maps/*.lua", "LUA" )) -- Others can add new maps
for _, map in ipairs( maps ) do
	local s=string.gsub(map, ".lua", "")
	if string.lower(s)==string.lower(game.GetMap()) then
		include( "abyssrp/gamemode/rp_maps/" .. map )
	end
end

function RP:EntStartup()
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
	
	if self.PoliceDoors then
		for a,b in ipairs(ents.GetAll()) do
			for c,d in pairs(self.PoliceDoors) do
				if b:GetPos() == d then
					b:Fire( "lock", "", 0 );
					b.PoliceOwned = true
					b:SetNWBool("Owned", true)
					b.Ownable = false
				end
			end
		end
		for c,d in pairs(self.PoliceDoorsH) do
			local e=ents.FindInSphere(d,1) -- why map why
			if IsValid(e[1]) then
				e[1]:Fire( "lock", "", 0 );
				e[1].PoliceOwned = true
				e[1]:SetNWBool("Owned", true)
				e[1].Ownable = false
			end
		end
	end
	if self.ATMs then
		for k,v in pairs(self.ATMs) do
			local ent = ents.Create("atmmachine")
			ent:SetPos(v.pos)
			ent:SetAngles(v.ang)
			ent:SetWorldOwner()
			ent:Spawn()
		end
	end
	if self.VendingMachines then
		for k,v in pairs(self.VendingMachines) do
			local ent = ents.Create("vendingmachine")
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