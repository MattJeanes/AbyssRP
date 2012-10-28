local function GetDoorData()

	local DoorRotating={}
	for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
		if v.TheOwner then
			table.insert(DoorRotating, {v:GetPos(), v.TheOwner})
		end
	end
	
	local Door={}
	for k, v in pairs(ents.FindByClass("func_door")) do
		if v.TheOwner then
			table.insert(Door, {v:GetPos(), v.TheOwner})
		end
	end
	
	local DoorRotate={}
	for k, v in pairs(ents.FindByClass("func_door_rotating")) do
		if v.TheOwner then
			table.insert(DoorRotate, {v:GetPos(), v.TheOwner})
		end
	end
	
	return {DoorRotating, Door, DoorRotate}
	
end

local function SetDoorData(data)

	for a,b in pairs(ents.FindByClass("prop_door_rotating")) do
		for c,d in pairs(data[1]) do
			if b:GetPos()==d[1] then
				b.TheOwner=d[2]
				b.Ownable=false
			end
		end
	end
	
	for a,b in pairs(ents.FindByClass("func_door")) do
		for c,d in pairs(data[2]) do
			if b:GetPos()==d[1] then
				b.TheOwner=d[2]
				b.Ownable=false
			end
		end
	end
	
	for a,b in pairs(ents.FindByClass("func_door_rotating")) do
		for c,d in pairs(data[3]) do
			if b:GetPos()==d[1] then
				b.TheOwner=d[2]
				b.Ownable=false
			end
		end
	end
end

local OldCleanup=game.CleanUpMap
function game.CleanUpMap()

	local D=GetDoorData()
	OldCleanup()
	timer.Simple(1, function()
		hook.Call("RP-EntStartup", GAMEMODE)
	end)
	timer.Simple(2, function()
		SetDoorData(D)
	end)
	
end