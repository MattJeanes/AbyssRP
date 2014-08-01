AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.AddNetworkString("RP-ATM")
util.AddNetworkString("RP-ATMUpdate")

function ENT:Initialize()
	self:SetModel( "models/env/misc/bank_atm/bank_atm.mdl" )
	self:SetSolid( SOLID_BBOX ) 
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:OnTakeDamage( dmg ) 
	return false
end

function ENT:Use( activator, caller )
	if activator:IsPlayer() then
		net.Start("RP-ATM") net.Send(activator)
	end
end

net.Receive("RP-ATM", function(len,ply)
	local t=tobool(net.ReadBit())
	local amount = net.ReadFloat()
	if (not amount) or (amount <= 0) then return end
	if not ((t and ply:GetBank() or ply:GetCash()) >= amount) then
		amount=(t and ply:GetBank() or ply:GetCash())
	end
	if amount==0 then
		RP:Error( ply, RP.colors.white, "You don't have any cash "..(t and "in your bank" or "on you").."." )
		return
	end
	if t then
		ply:AddCash(amount)
		ply:TakeBank(amount)
	else
		ply:TakeCash(amount)
		ply:AddBank(amount)
	end
	RP:Notify( ply, RP.colors.white, "You "..(t and "withdrew" or "deposited").." ", RP.colors.blue, RP:CC(amount), RP.colors.white, " "..(t and "from" or "into").." your bank account.")
	net.Start("RP-ATMUpdate")
		net.WriteFloat(ply:GetBank())
	net.Send(ply)
end)