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
	if (not amount) or (amount <= 0) then return end
	if not (ply:GetCash() >= amount) then
		amount=ply:GetCash()
	end
	if amount==0 then
		RP:Error( ply, RP.colors.white, "You don't have any cash on you.")
		return
	end
	ply:TakeCash(amount)
	ply:AddBank(amount)
	RP:Notify( ply, RP.colors.white, "You deposited ", RP.colors.blue, RP:CC(amount), RP.colors.white, " to your bank account.")
	umsg.Start("ATMUpdate", ply)
		umsg.Float(ply:GetBank())
	umsg.End()
end )

concommand.Add( "bank_withdraw", function( ply, cmd, args )
	local amount = tonumber(args[1])
	if (not amount) or (amount <= 0) then return end
	if not (ply:GetBank() >= amount)then
		amount = ply:GetBank()
	end
	if amount==0 then
		RP:Error( ply, RP.colors.white, "You don't have any cash in your bank.")
		return
	end
	ply:AddCash(amount)
	ply:TakeBank(amount)
	RP:Notify( ply, RP.colors.white, "You withdrew ", RP.colors.blue, RP:CC(amount), RP.colors.white, " from your bank account.")
	umsg.Start("ATMUpdate", ply)
		umsg.Float(ply:GetBank())
	umsg.End()
end )