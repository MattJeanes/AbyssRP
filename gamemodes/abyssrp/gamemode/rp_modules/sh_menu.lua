local meta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString("RP-ShowMenu")
	function meta:ShowMenu()
		if self:GetTeamValue("menu") then
			net.Start("RP-ShowMenu") net.Send(self)
			return true
		else
			return false
		end
	end
elseif CLIENT then
	function meta:ShowMenu()
		if self:GetTeamValue("menu") then
			self:GetTeamValue("menu")()
			return true
		else
			return false
		end
	end
	net.Receive("RP-ShowMenu", function(len)
		LocalPlayer():ShowMenu()
	end)
end