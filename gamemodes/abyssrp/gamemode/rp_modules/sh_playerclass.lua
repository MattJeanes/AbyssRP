DEFINE_BASECLASS( "player_default" )

local PLAYER = {}


PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= nil
PLAYER.RunSpeed				= nil

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()
	BaseClass.Spawn( self )
	
	local oldhands = self.Player:GetHands();
	if ( IsValid( oldhands ) ) then
		oldhands:Remove()
	end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		hands:DoSetup( self.Player )
		hands:Spawn()
	end	

	local col = team.GetColor( self.Player:Team() )
	local colvec = Vector( col.r, col.g, col.b ) / 255
	self.Player:SetPlayerColor( colvec )
	self.Player:SetWeaponColor( colvec )
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

function PLAYER:GetHandsModel()

	-- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

	return player_manager.TranslatePlayerHands( player_manager.TranslateToPlayerModelName(self.Player:GetModel()) )

end

player_manager.RegisterClass( "player_abyssrp", PLAYER, "player_default" )
