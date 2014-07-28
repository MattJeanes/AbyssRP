surface.CreateFont("AbyssRPHUD",
	{
		font="Verdana",
		size=ScreenScale(8)
	}
)

surface.CreateFont("AbyssRPHUD2",
	{
		font="Arial",
		size=ScreenScale(7)
	}
)
 
hook.Add("HUDPaint", "CreateAbyssHUD", function()
	draw.RoundedBox( 0, ScrW()*0.005, ScrH()*0.855, ScrW()*0.15, ScrH()*0.14, Color( 0, 0, 0, 150 ) )
	
	
	-- HP
	local hp=math.Clamp(LocalPlayer():Health(),0,100)
	surface.SetDrawColor( 231, 76, 60, 150 )
	surface.DrawRect( ScrW()*0.007, ScrH()*0.948, hp*(ScrW()*0.00147), ScrH()*0.019 )
	surface.DrawOutlinedRect( ScrW()*0.007, ScrH()*0.948, ScrW()*0.147, ScrH()*0.02)
	draw.SimpleText("HP: "..hp, "AbyssRPHUD", ScrW()*0.0775, ScrH()*0.946, Color(255,255,255,255),TEXT_ALIGN_CENTER)
	
	-- Armor
	local armor = "No Armor"
	if LocalPlayer():Armor() >= 1 then
		armor = "Armor: "..math.Clamp(LocalPlayer():Armor(), 0, 100)
	end
	local armorl = 100*(ScrW()*0.00148)
	if LocalPlayer():Armor() > 0 then
		armorl = math.Clamp(LocalPlayer():Armor(), 0, 100)*(ScrW()*0.00148)
	end
	
	surface.SetDrawColor( 52, 152, 219, 150 )
	surface.DrawRect( ScrW()*0.007, ScrH()*0.97, math.Clamp(LocalPlayer():Armor(), 0, 100)*(ScrW()*0.00147), ScrH()*0.019 )
	surface.DrawOutlinedRect( ScrW()*0.007, ScrH()*0.97, ScrW()*0.147, ScrH()*0.02)
	draw.SimpleText(armor, "AbyssRPHUD", ScrW()*0.0775, ScrH()*0.968, Color(255,255,255,255),TEXT_ALIGN_CENTER)

	-- Info
	local job = Material("icon16/user.png")
	surface.SetMaterial(job)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectRotated(ScrW()*0.017, ScrH()*0.875, 16, 16, 0)

	draw.SimpleText(team.GetName(LocalPlayer():Team()), "AbyssRPHUD2", ScrW()*0.025, ScrH()*0.865, Color(255,255,255,255))
	 

	local cash = Material("icon16/money.png")
	surface.SetMaterial(cash)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectRotated(ScrW()*0.017, ScrH()*0.9, 16, 16,0)
	
	draw.SimpleText(RP:CC(LocalPlayer():GetCash()), "AbyssRPHUD2", ScrW()*0.025, ScrH()*0.89, Color(255,255,255,255))
	
	local salary = Material("icon16/coins_add.png")
	surface.SetMaterial(salary)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectRotated(ScrW()*0.017, ScrH()*0.925, 16, 16,0)

	draw.SimpleText(RP:CC(LocalPlayer():GetTeamValue("salary")).." | "..RP:FormatTime(RP.SalaryTime), "AbyssRPHUD2", ScrW()*0.025, ScrH()*0.915, Color(255,255,255,255))

end)
 
local function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "Hide the normal HUD", hidehud)