AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
DeriveGamemode("sandbox")

CreateConVar( "rp_doorcost", "100", FCVAR_NOTIFY )
CreateConVar( "rp_allowvehicleowning", "1", FCVAR_NOTIFY )
CreateConVar( "rp_shipmentspawntime", "2", FCVAR_NOTIFY )
CreateConVar( "rp_allowplugins", "0", FCVAR_NOTIFY ) // not sure what does
CreateConVar( "rp_dropweapon", "1", FCVAR_NOTIFY )
CreateConVar( "rp_shownames", "0", FCVAR_NOTIFY ) // not sure what this actually does?
CreateConVar( "rp_debug", "0", FCVAR_NOTIFY ) // not sure if used
CreateConVar( "rp_admincandoall", "1", FCVAR_NOTIFY )
CreateConVar( "rp_admindropmoney", "0", FCVAR_NOTIFY )
CreateConVar( "rp_admingivetools", "1", FCVAR_NOTIFY )