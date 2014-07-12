AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
self:SetModel( "models/env/misc/bank_atm/bank_atm.mdl" )
self:SetSolid(  SOLID_BBOX ) 
self:SetUseType( SIMPLE_USE )
self:DropToFloor()
end

function ENT:OnTakeDamage( dmg ) 
	return false
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("ShowBank", Caller)
		umsg.End()
	end
end

concommand.Add( "bank_deposit", function( ply, cmd, args )
	local amount = tonumber(args[1])
	if (not amount) or (amount < 1) then return end
	if ply:GetCash() >= amount then
		ply:TakeCash(amount)
		ply:AddBank(amount)
		RP:Notify( ply, RP.colors.white, "You deposited ", RP.colors.blue, "$"..args[1], RP.colors.white, " to your bank account.")
		umsg.Start("ATMUpdate", ply)
			umsg.Float(ply:GetBank())
		umsg.End()
	else
		RP:Error( ply, RP.colors.white, "You don't have enough cash!" )
	end
end )

concommand.Add( "bank_withdraw", function( ply, cmd, args )
	local amount = tonumber(args[1])
	if (not amount) or (amount < 1) then return end
		if ply:GetBank() >= amount then
			ply:AddCash(amount)
			ply:TakeBank(amount)
			RP:Notify( ply, RP.colors.white, "You withdrew ", RP.colors.blue, "$"..args[1], RP.colors.white, " from your bank account.")
			umsg.Start("ATMUpdate", ply)
				umsg.Float(ply:GetPData("bank"))
			umsg.End()
		else
			RP:Error( ply, RP.colors.white, "Too little cash in bank." )
		end
end )