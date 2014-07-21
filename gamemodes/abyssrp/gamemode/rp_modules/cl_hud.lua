surface.CreateFont("AbyssRPHUD",
	{
		font="Verdana",
		size=ScreenScale(9),
		weight="1200",
	}
)

surface.CreateFont("AbyssRPHUD2",
	{
		font="Courier New",
		size=ScreenScale(6),
		weight="700",
		outline=true
	}
)
 
hook.Add("HUDPaint", "CreateAbyssHUD", function()
	draw.RoundedBox( 0, ScrW()*0.005, ScrH()*0.875, ScrW()*0.15, ScrH()*0.12, Color( 0, 0, 0, 150 ) )
	draw.RoundedBox( 0, ScrW()*0.006, ScrH()*0.948, math.Clamp(LocalPlayer():Health(), 0, 100)* (ScrW()*0.00148), ScrH()*0.02, Color( 255, 0, 0, 255 ) )
	draw.RoundedBox( 0, ScrW()*0.006, ScrH()*0.948, math.Clamp(LocalPlayer():Health(), 0, 100)* (ScrW()*0.00148), ScrH()*0.01, Color( 255, 255, 255, 90 ) ) 
	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.DrawOutlinedRect( ScrW()*0.006, ScrH()*0.948, ScrW()*0.148, ScrH()*0.02)
	draw.SimpleText("HP: "..LocalPlayer():Health(), "AbyssRPHUD", ScrW()*0.05, ScrH()*0.945, Color(0,0,255,255))
	//   draw.SimpleText("HP: "..LocalPlayer():Health(), "AbyssHUD", ScrW()*0.04, ScrH()*0.967, Color(0,0,255,255))
	// Armor
	local armor1 = "Armor: "..LocalPlayer():Armor()
	if LocalPlayer():Armor() < 1 then
		armor1 = "No Armor"
	end
	local armor2 = 100*(ScrW()*0.00148)
	if LocalPlayer():Armor() > 0 then
		armor2 = math.Clamp(LocalPlayer():Armor(), 0, 100)*(ScrW()*0.00148)
	end
	draw.RoundedBox( 0, ScrW()*0.006, ScrH()*0.97, armor2, ScrH()*0.02, Color( 0, 0, 255, 255 ) )
	draw.RoundedBox( 0, ScrW()*0.006, ScrH()*0.97, armor2, ScrH()*0.01, Color( 255, 255, 255, 90 ) )
	surface.SetDrawColor( 0, 0, 255, 255 )
	surface.DrawOutlinedRect( ScrW()*0.006, ScrH()*0.97, ScrW()*0.148, ScrH()*0.02)
	draw.SimpleText(armor1, "AbyssRPHUD", ScrW()*0.05, ScrH()*0.967, Color(255,255,255,255))

	local name = Material("icon16/user.png")
	surface.SetMaterial(name)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectRotated(ScrW()*0.017, ScrH()*0.895, 16, 16, 0)

	draw.SimpleText("  "..team.GetName(LocalPlayer():Team()), "AbyssRPHUD2", ScrW()*0.015, ScrH()*0.885, Color(255,255,255,255))
	 

	local Cash = Material("icon16/money.png")
	surface.SetMaterial(Cash)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectRotated(ScrW()*0.017, ScrH()*0.927, 16, 16,0)

	draw.SimpleText("  "..RP:CC(LocalPlayer():GetCash()), "AbyssRPHUD2", ScrW()*0.015, ScrH()*0.915, Color(255,255,255,255))

end)
 
local function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "Hide the normal HUD", hidehud)