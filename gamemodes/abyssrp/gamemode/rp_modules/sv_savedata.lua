local function GetDoorData()

	local DoorRotating={}
	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v.Owner then
			table.insert(DoorRotating, {v:GetPos(), v.Owner})
		end
	end
	
	local Door={}
	for k, v in pairs(ents.FindByClass("func_door")) do
		if v.Owner then
			table.insert(Door, {v:GetPos(), v.Owner})
		end
	end
	
	local DoorRotate={}
	for k, v in pairs(ents.FindByClass("func_door_rotating")) do
		if v.Owner then
			table.insert(DoorRotate, {v:GetPos(), v.Owner})
		end
	end
	
	return {DoorRotating, Door, DoorRotate}
	
end

local function SetDoorData(data)

	for a,b in pairs(ents.FindByClass("prop_door_rotating")) do
		for c,d in pairs(data[1]) do
			if b:GetPos()==d[1] then
				b.Owner=d[2]
				b.Ownable=false
			end
		end
	end
	
	for a,b in pairs(ents.FindByClass("func_door")) do
		for c,d in pairs(data[2]) do
			if b:GetPos()==d[1] then
				b.Owner=d[2]
				b.Ownable=false
			end
		end
	end
	
	for a,b in pairs(ents.FindByClass("func_door_rotating")) do
		for c,d in pairs(data[3]) do
			if b:GetPos()==d[1] then
				b.Owner=d[2]
				b.Ownable=false
			end
		end
	end
end

if not OldCleanup then
	OldCleanup=game.CleanUpMap
end
function game.CleanUpMap()
	local data=GetDoorData()
	OldCleanup()
	RP:EntStartup()
	SetDoorData(data)
end