AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/cocn.mdl"

ENT.MASS = 2; --the model is too heavy so we have to override it with THIS

ENT.LASTINGEFFECT = 45; --how long the high lasts in seconds

--get default walk/run speed
local DEFAULT_WALK_SPEED = 0
local DEFAULT_RUN_SPEED = 0

local hook_name = "durgzmod_getwalkrunspeed"
hook.Add("PlayerSpawn", hook_name, function(pl)
    DEFAULT_WALK_SPEED = pl:GetWalkSpeed()
    DEFAULT_RUN_SPEED = pl:GetRunSpeed()
    DURGZ_DEFAULT_WALK_SPEED = DEFAULT_WALK_SPEED
    DURGZ_DEFAULT_RUN_SPEED = DEFAULT_RUN_SPEED
    hook.Remove("PlayerSpawn", hook_name)
end)


function ENT:High(activator,caller)
	--cut health in half and double the speed
    if not self:Realistic() then
        activator:SetHealth(activator:Health()/2)
    end

	if( activator:Health() > 1 )then
		self:Say(activator, "MYNOSEISDRIBBLINGISANYONEELSESNOSEDRIBBLINGTHATSREALLYWEIRDIHOPEIDONTHAVEACOLD")
	end

	self.MakeHigh = false;

    if not self:Realistic() then
        if activator:GetNetworkedFloat("durgz_cocaine_high_end") < CurTime() then
            self.MakeHigh = true;
        end
    end


end

function ENT:AfterHigh(activator, caller)
	
	--kill them if they're weak
	if( activator:Health() <=1 )then
		activator.DURGZ_MOD_DEATH = "durgz_cocaine";
		activator.DURGZ_MOD_OVERRIDE = activator:Nick().." died of a heart attack (too much cocaine).";
		activator:Kill()
	return
	end
	
	if( self.MakeHigh )then
        activator.durgz_cocaine_fast = true
		activator:SetRunSpeed(DEFAULT_RUN_SPEED*6)
		activator:SetWalkSpeed(DEFAULT_WALK_SPEED*6)
	end
end

--set speed back to normal once your high is over 
hook.Add("Think", "durgz_cocaine_resetspeed", function()
    for id,pl in pairs(player.GetAll())do
        if  pl.durgz_cocaine_fast and pl:GetNetworkedFloat("durgz_cocaine_high_end") < CurTime() then
            pl:SetWalkSpeed(DEFAULT_WALK_SPEED)
            pl:SetRunSpeed(DEFAULT_RUN_SPEED)
            pl.durgz_cocaine_fast = false
        end
    end
end)

