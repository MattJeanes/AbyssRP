
DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "player_playercol", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "player_weaponcol", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )

end

local PLAYER = {}

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	-- as needed.

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	local col = self.Player:GetInfo( "player_playercol" )
	self.Player:SetPlayerColor( Vector( col ) )

	local col = self.Player:GetInfo( "player_weaponcol" )
	self.Player:SetWeaponColor( Vector( col ) )

end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal() 

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

player_manager.RegisterClass( "player_abyssrp", PLAYER, "player_default" )