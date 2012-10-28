ENT.Base = "base_gmodentity" 
ENT.Type = "anim"
ENT.PrintName		= "ATM Machine"
ENT.Author			= "Dr. Matt/Evolving Assassin"
ENT.Contact			= "N/A"
ENT.Purpose			= "Deposit/Withdraw money from the bank."
ENT.Instructions	= "Press E to open the bank menu."
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category 		= "AbyssRP"

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end