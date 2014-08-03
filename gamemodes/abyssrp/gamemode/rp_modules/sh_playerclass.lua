-- Player class

DEFINE_BASECLASS( "player_default" )

if SERVER then
	RP:AddSetting("admingivetools",true)
end

local PLAYER = {}

PLAYER.TeammateNoCollide 	= false		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players

PLAYER.TauntCam = TauntCamera()

function PLAYER:Spawn()
	if self.Player:Team()==0 then
		self.Player:SetTeam(1)
	end
	
	BaseClass.Spawn( self )
	
	self.Player:RemoveAllAmmo()
	self.Player:StripWeapons()
	
	local col = team.GetColor( self.Player:Team() )
	local colvec = Vector( col.r, col.g, col.b ) / 255
	self.Player:SetPlayerColor( colvec )
	self.Player:SetWeaponColor( colvec )
end

function PLAYER:Loadout()
	if self.Player.RP_Jailed then return end
	local t=self.Player:GetTeam()
	
	if not t.nohands then self.Player:Give( "hands" ) end
	
	if t.weps then
		for k,v in pairs(t.weps) do
			self.Player:Give(v)
		end
	end
	
	self.Player:Give( "weapon_physcannon" )
	self.Player:Give( "gmod_camera" )
	self.Player:Give( "weapon_keys" )
	
	-- This doesn't work on first spawn as all variables have not been initialised yet, which is why all players must respawn on first join. TODO: Look for a better fix.
	if RP:GetSetting("build") or (self.Player:RP_IsAdmin() and RP:GetSetting("adminbuild")) then
		self.Player:Give( "gmod_tool" )
		self.Player:Give( "weapon_physgun" )
	end
	
	if t.armor then
		self.Player:SetArmor(t.armor)
	end
	
	if t.walkspeed then
		self.Player:SetWalkSpeed(t.walkspeed)
	else
		self.Player:SetWalkSpeed(125)
	end
	
	if t.runspeed then
		self.Player:SetRunSpeed(t.runspeed)
	else
		self.Player:SetRunSpeed(250)
	end
end

function PLAYER:SetModel()
	local m = RP:GetTeamModel( self.Player:Team() )
	util.PrecacheModel( m )
	self.Player:SetModel( m )
end

function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName( RP:GetTeamModel( self.Player:Team() ) )
	return player_manager.TranslatePlayerHands( playermodel )
end

function PLAYER:ShouldDrawLocal() 
	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end
end

function PLAYER:CreateMove( cmd )
	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end
end

function PLAYER:CalcView( view )
	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end
end

player_manager.RegisterClass( "player_abyssrp", PLAYER, "player_default" )